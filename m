Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab0KCKWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:22:17 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:30228
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960Ab0KCKWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:22:15 -0400
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Nov 2010 06:22:15 EDT
X-SpamScore: -3
X-BigFish: VS-3(zzbb2cKzz1202hzz8275bhz2dh2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
From: Shaohui Xie <b21989@freescale.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Li Yang <leoli@freescale.com>, Shaohui Xie <b21989@freescale.com>,
        Kumar Gala <kumar.gala@freescale.com>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH 1/4][v2] powerpc: add e500 HID1 bit definition
Date: Wed, 3 Nov 2010 17:35:31 +0800
Message-ID: <1288776931-20689-1-git-send-email-b21989@freescale.com>
X-Mailer: git-send-email 1.6.4
X-OriginalArrivalTime: 03 Nov 2010 10:07:30.0275 (UTC) FILETIME=[ECE41330:01CB7B3E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Yang <leoli@freescale.com>

Also make 74xx HID1 definition conditional.

Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Shaohui Xie <b21989@freescale.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <kumar.gala@freescale.com>
Cc: Roy Zang <tie-fei.zang@freescale.com>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
---
These patches have been send for almost one week, and has no feedback.

 arch/powerpc/include/asm/reg.h       |    2 ++
 arch/powerpc/include/asm/reg_booke.h |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index ff0005e..125fc1a 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -283,6 +283,7 @@
 #define HID0_NOPTI	(1<<0)		/* No-op dcbt and dcbst instr. */
 
 #define SPRN_HID1	0x3F1		/* Hardware Implementation Register 1 */
+#ifdef CONFIG_6xx
 #define HID1_EMCP	(1<<31)		/* 7450 Machine Check Pin Enable */
 #define HID1_DFS	(1<<22)		/* 7447A Dynamic Frequency Scaling */
 #define HID1_PC0	(1<<16)		/* 7450 PLL_CFG[0] */
@@ -292,6 +293,7 @@
 #define HID1_SYNCBE	(1<<11)		/* 7450 ABE for sync, eieio */
 #define HID1_ABE	(1<<10)		/* 7450 Address Broadcast Enable */
 #define HID1_PS		(1<<16)		/* 750FX PLL selection */
+#endif
 #define SPRN_HID2	0x3F8		/* Hardware Implementation Register 2 */
 #define SPRN_HID2_GEKKO	0x398		/* Gekko HID2 Register */
 #define SPRN_IABR	0x3F2	/* Instruction Address Breakpoint Register */
diff --git a/arch/powerpc/include/asm/reg_booke.h b/arch/powerpc/include/asm/reg_booke.h
index 667a498..dc6adff 100644
--- a/arch/powerpc/include/asm/reg_booke.h
+++ b/arch/powerpc/include/asm/reg_booke.h
@@ -246,6 +246,20 @@
 					store or cache line push */
 #endif
 
+/* Bit definitions for the HID1 */
+#ifdef CONFIG_E500
+/* e500v1/v2 */
+#define HID1_PLL_CFG_MASK 0xfc000000	/* PLL_CFG input pins */
+#define HID1_RFXE	0x00020000	/* Read fault exception enable */
+#define HID1_R1DPE	0x00008000	/* R1 data bus parity enable */
+#define HID1_R2DPE	0x00004000	/* R2 data bus parity enable */
+#define HID1_ASTME	0x00002000	/* Address bus streaming mode enable */
+#define HID1_ABE	0x00001000	/* Address broadcast enable */
+#define HID1_MPXTT	0x00000400	/* MPX re-map transfer type */
+#define HID1_ATS	0x00000080	/* Atomic status */
+#define HID1_MID_MASK	0x0000000f	/* MID input pins */
+#endif
+
 /* Bit definitions for the DBSR. */
 /*
  * DBSR bits which have conflicting definitions on true Book E versus IBM 40x.
-- 
1.6.4


