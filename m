Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1DCVAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 17:00:37 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:16175
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419Ab1DCVAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 17:00:35 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>
CC: John Linn <john.linn@xilinx.com>
Subject: [PATCH 3/3] ARM: Xilinx: update of infrastructure for SMP
Date: Sun, 3 Apr 2011 15:00:18 -0600
X-Mailer: git-send-email 1.5.4.7
In-Reply-To: <1301864418-12425-3-git-send-email-john.linn@xilinx.com>
References: <1301864418-12425-1-git-send-email-john.linn@xilinx.com>
 <1301864418-12425-2-git-send-email-john.linn@xilinx.com>
 <1301864418-12425-3-git-send-email-john.linn@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <c6063ede-75c8-4dba-9a63-ce6d5b6bfd64@VA3EHSMHS021.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only minor updates of Kconfig and Makefile to support
the local timer and SMP.

Signed-off-by: John Linn <john.linn@xilinx.com>
---
 arch/arm/Kconfig              |    2 +-
 arch/arm/mach-xilinx/Makefile |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index aa7ac3b..50283ae 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1338,7 +1338,7 @@ config SMP
 	depends on REALVIEW_EB_ARM11MP || REALVIEW_EB_A9MP || \
 		 MACH_REALVIEW_PB11MP || MACH_REALVIEW_PBX || ARCH_OMAP4 || \
 		 ARCH_EXYNOS4 || ARCH_TEGRA || ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || \
-		 ARCH_MSM_SCORPIONMP || ARCH_SHMOBILE
+		 ARCH_MSM_SCORPIONMP || ARCH_SHMOBILE || ARCH_XILINX
 	select USE_GENERIC_SMP_HELPERS
 	select HAVE_ARM_SCU if !ARCH_MSM_SCORPIONMP
 	help
diff --git a/arch/arm/mach-xilinx/Makefile b/arch/arm/mach-xilinx/Makefile
index 62787ff..2f34007 100644
--- a/arch/arm/mach-xilinx/Makefile
+++ b/arch/arm/mach-xilinx/Makefile
@@ -5,3 +5,5 @@
 # Common support
 obj-y 				:= common.o timer.o
 obj-$(CONFIG_MACH_XILINX_EP107)	+= board_ep107.o
+obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
+obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
-- 
1.5.4.7



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


