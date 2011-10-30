Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986Ab1J3Lvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 07:51:44 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:55963 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab1J3Lvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 07:51:43 -0400
Subject: [PATCH] [RESEND] [TRIVIAL] Kconfig: remove a few puzzling comments
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Oct 2011 12:51:41 +0100
Message-ID: <1319975501.14409.8.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These comments mention CONFIG options that do not exist: not as a symbol
in a Kconfig file (without the CONFIG_ prefix) and neither as a symbol
(with that prefix) in the code.

There's one reference to XSCALE_PMU_TIMER as a negative dependency.
But XSCALE_PMU_TIMER is never defined (CONFIG_XSCALE_PMU_TIMER is
also unused in the code). It shows up with type "unknown" if you search
for it in menuconfig. Apparently a negative dependency on an unknown
symbol is always true. That negative dependency can be removed too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/arm/Kconfig              |    3 +--
 arch/cris/Kconfig.debug       |    1 -
 drivers/video/console/Kconfig |    2 --
 net/ipv4/Kconfig              |    2 --
 4 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3146ed3..aac26d5 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1078,10 +1078,9 @@ config IWMMXT
 	  Enable support for iWMMXt context switching at run time if
 	  running on a CPU that supports it.
 
-#  bool 'Use XScale PMU as timer source' CONFIG_XSCALE_PMU_TIMER
 config XSCALE_PMU
 	bool
-	depends on CPU_XSCALE && !XSCALE_PMU_TIMER
+	depends on CPU_XSCALE
 	default y
 
 config CPU_HAS_PMU
diff --git a/arch/cris/Kconfig.debug b/arch/cris/Kconfig.debug
index 0b9a630..14881e8 100644
--- a/arch/cris/Kconfig.debug
+++ b/arch/cris/Kconfig.debug
@@ -1,6 +1,5 @@
 menu "Kernel hacking"
 
-#bool 'Debug kmalloc/kfree' CONFIG_DEBUG_MALLOC
 config PROFILING
 	bool "Kernel profiling support"
 
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 2209e35..c2d11fef 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -66,8 +66,6 @@ config SGI_NEWPORT_CONSOLE
           Say Y here if you want the console on the Newport aka XL graphics
           card of your Indy.  Most people say Y here.
 
-#  bool 'IODC console' CONFIG_IODC_CONSOLE
-
 config DUMMY_CONSOLE
 	bool
 	depends on VGA_CONSOLE!=y || SGI_NEWPORT_CONSOLE!=y 
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index cbb505b..251f662 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -163,8 +163,6 @@ config IP_PNP_RARP
 	  operating on your network. Read
 	  <file:Documentation/filesystems/nfs/nfsroot.txt> for details.
 
-# not yet ready..
-#   bool '    IP: ARP support' CONFIG_IP_PNP_ARP
 config NET_IPIP
 	tristate "IP: tunneling"
 	select INET_TUNNEL
-- 
1.7.4.4



