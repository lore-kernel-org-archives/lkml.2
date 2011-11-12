Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1KLVrm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 16:47:42 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:37141 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1KLVrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 16:47:41 -0500
Subject: [PATCH] [TRIVIAL] drop "select GCD" from three Kconfig files
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Nov 2011 22:47:36 +0100
Message-ID: <1321134456.20271.10.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no Kconfig symbol named GCD. The three select statements for
that symbol are nops. Drop these.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested. All my recent config files have CONFIG_IP_VS_WRR but not
CONFIG_GCD. That already proves these selects are nops.

1) These selects got added by commits 7ca5dc145b ("MIPS: Add support for
Texas Instruments AR7 System-on-a-Chip"), ae24e578de ("ipvs:
ip_vs_wrr.c: use lib/gcd.c"), and a9605391cfab ("ALSA:
sound/core/pcm_timer.c: use lib/gcd.c"). But lib/gcd.o is builtin, so
all that's needed to use gcd() is to include linux/gcd.h, which these
three commits also did.

 arch/mips/Kconfig          |    1 -
 net/netfilter/ipvs/Kconfig |    1 -
 sound/core/Kconfig         |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index d46f1da..7b91132 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -65,7 +65,6 @@ config AR7
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_ZBOOT_UART16550
 	select ARCH_REQUIRE_GPIOLIB
-	select GCD
 	select VLYNQ
 	help
 	  Support for the Texas Instruments AR7 System-on-a-Chip
diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index 70bd1d0..ca80de5 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -122,7 +122,6 @@ config	IP_VS_RR
  
 config	IP_VS_WRR
 	tristate "weighted round-robin scheduling"
-	select GCD
 	---help---
 	  The weighted robin-robin scheduling algorithm directs network
 	  connections to different real servers based on server weights
diff --git a/sound/core/Kconfig b/sound/core/Kconfig
index 475455c..c15682a 100644
--- a/sound/core/Kconfig
+++ b/sound/core/Kconfig
@@ -5,7 +5,6 @@ config SND_TIMER
 config SND_PCM
 	tristate
 	select SND_TIMER
-	select GCD
 
 config SND_HWDEP
 	tristate
-- 
1.7.4.4



