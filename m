Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab0F2CAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 22:00:54 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:59788 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab0F2CAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:00:51 -0400
Date: Mon, 28 Jun 2010 22:00:48 -0400
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
       Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       grant.likely@secretlab.ca
Subject: [PATCH 3/4] proc: unify PROC_DEVICETREE config
Message-ID: <20100628220048.6a07c5ee@debian>
In-Reply-To: <20100628215407.2017bf2f@debian>
References: <20100628215407.2017bf2f@debian>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Microblaze and PPC both use PROC_DEVICETREE, and OLPC will as well.. put
the Kconfig option into fs/ rather than in arch/*/Kconfig.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/microblaze/Kconfig |    8 --------
 arch/powerpc/Kconfig    |    8 --------
 fs/proc/Kconfig         |    8 ++++++++
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 76818f9..b66c962 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -128,14 +128,6 @@ config OF
 	def_bool y
 	select OF_FLATTREE
 
-config PROC_DEVICETREE
-	bool "Support for device tree in /proc"
-	depends on PROC_FS
-	help
-	  This option adds a device-tree directory under /proc which contains
-	  an image of the device tree that the kernel copies from Open
-	  Firmware or other boot firmware. If unsure, say Y here.
-
 endmenu
 
 menu "Advanced setup"
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 328774b..8a56e8b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -578,14 +578,6 @@ config SCHED_SMT
 	  when dealing with POWER5 cpus at a cost of slightly increased
 	  overhead in some places. If unsure say N here.
 
-config PROC_DEVICETREE
-	bool "Support for device tree in /proc"
-	depends on PROC_FS
-	help
-	  This option adds a device-tree directory under /proc which contains
-	  an image of the device tree that the kernel copies from Open
-	  Firmware or other boot firmware. If unsure, say Y here.
-
 config CMDLINE_BOOL
 	bool "Default bootloader kernel arguments"
 
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 50f8f06..858a859 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -39,6 +39,14 @@ config PROC_VMCORE
         help
         Exports the dump image of crashed kernel in ELF format.
 
+config PROC_DEVICETREE
+	bool "Support for device tree in /proc"
+	depends on PROC_FS && (PPC || MICROBLAZE)
+	help
+	  This option adds a device-tree directory under /proc which contains
+	  an image of the device tree that the kernel copies from Open
+	  Firmware or other boot firmware. If unsure, say Y here.
+
 config PROC_SYSCTL
 	bool "Sysctl support (/proc/sys)" if EMBEDDED
 	depends on PROC_FS
-- 
1.5.6.5

