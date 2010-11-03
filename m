Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0KCKXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:23:01 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:21846
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822Ab0KCKW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:22:58 -0400
X-SpamScore: -3
X-BigFish: VS-3(zzbb2cKzz1202hzz8275bhz2dh2a8h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
From: Shaohui Xie <b21989@freescale.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Shaohui Xie <b21989@freescale.com>, Li Yang <leoli@freescale.com>,
        Kumar Gala <kumar.gala@freescale.com>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH 2/4][v2] fsl_rio: fix non-standard HID1 register access
Date: Wed, 3 Nov 2010 17:36:37 +0800
Message-ID: <1288776997-23562-1-git-send-email-b21989@freescale.com>
X-Mailer: git-send-email 1.6.4
X-OriginalArrivalTime: 03 Nov 2010 10:08:20.0915 (UTC) FILETIME=[0B132030:01CB7B3F]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shaohui Xie <b21989@freescale.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <kumar.gala@freescale.com>
Cc: Roy Zang <tie-fei.zang@freescale.com>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
---
 arch/powerpc/kernel/cpu_setup_fsl_booke.S |    6 ++++++
 arch/powerpc/sysdev/fsl_rio.c             |    2 --
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/cpu_setup_fsl_booke.S b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
index 0adb50a..8fd5bc6 100644
--- a/arch/powerpc/kernel/cpu_setup_fsl_booke.S
+++ b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
@@ -63,6 +63,12 @@ _GLOBAL(__setup_cpu_e500v2)
 	bl	__e500_icache_setup
 	bl	__e500_dcache_setup
 	bl	__setup_e500_ivors
+#ifdef CONFIG_RAPIDIO
+	/* Ensure that RFXE is set */
+	mfspr	r3,SPRN_HID1
+	oris	r3,r3,HID1_RFXE@h
+	mtspr	SPRN_HID1,r3
+#endif
 	mtlr	r4
 	blr
 _GLOBAL(__setup_cpu_e500mc)
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 4127636..1143c93 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1538,8 +1538,6 @@ int fsl_rio_setup(struct platform_device *dev)
 	saved_mcheck_exception = ppc_md.machine_check_exception;
 	ppc_md.machine_check_exception = fsl_rio_mcheck_exception;
 #endif
-	/* Ensure that RFXE is set */
-	mtspr(SPRN_HID1, (mfspr(SPRN_HID1) | 0x20000));
 
 	return 0;
 err:
-- 
1.6.4


