Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1GRLPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 07:15:52 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:46793 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab1GRLPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 07:15:51 -0400
X-ASG-Debug-ID: 1310987751-082bd9280001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
From: Leo Yan <leoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        haojian.zhuang@marvell.com, nicolas.pitre@linaro.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Leo Yan <leoy@marvell.com>
X-ASG-Orig-Subj: [PATCH 1/2] ARM: mmp: register audio sram device
Subject: [PATCH 1/2] ARM: mmp: register audio sram device
Date: Mon, 18 Jul 2011 19:18:07 +0800
X-ASG-Orig-Subj: [PATCH 1/2] ARM: mmp: register audio sram device
Message-Id: <1310987888-541-2-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310987888-541-1-git-send-email-leoy@marvell.com>
References: <1310987888-541-1-git-send-email-leoy@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1310987751
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mmp2/3 platform, there have the audio island.
So register the audio sram device at init phase.

Signed-off-by: Leo Yan <leoy@marvell.com>
---
 arch/arm/mach-mmp/brownstone.c        |    1 +
 arch/arm/mach-mmp/include/mach/mmp2.h |    6 ++++++
 arch/arm/mach-mmp/mmp2.c              |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/brownstone.c b/arch/arm/mach-mmp/brownstone.c
index 7bb78fd..c172910 100644
--- a/arch/arm/mach-mmp/brownstone.c
+++ b/arch/arm/mach-mmp/brownstone.c
@@ -189,6 +189,7 @@ static void __init brownstone_init(void)
 	mmp2_add_uart(3);
 	mmp2_add_twsi(1, NULL, ARRAY_AND_SIZE(brownstone_twsi1_info));
 	mmp2_add_sdhost(0, &mmp2_sdh_platdata_mmc0); /* SD/MMC */
+	mmp2_add_audio_sram();
 
 	/* enable 5v regulator */
 	platform_device_register(&brownstone_v_5vp_device);
diff --git a/arch/arm/mach-mmp/include/mach/mmp2.h b/arch/arm/mach-mmp/include/mach/mmp2.h
index 2cbf6df..bd1bbb4 100644
--- a/arch/arm/mach-mmp/include/mach/mmp2.h
+++ b/arch/arm/mach-mmp/include/mach/mmp2.h
@@ -28,6 +28,7 @@ extern struct pxa_device_desc mmp2_device_sdh0;
 extern struct pxa_device_desc mmp2_device_sdh1;
 extern struct pxa_device_desc mmp2_device_sdh2;
 extern struct pxa_device_desc mmp2_device_sdh3;
+extern struct pxa_device_desc mmp2_device_audio_sram;
 
 static inline int mmp2_add_uart(int id)
 {
@@ -85,5 +86,10 @@ static inline int mmp2_add_sdhost(int id, struct sdhci_pxa_platdata *data)
 	return pxa_register_device(d, data, sizeof(*data));
 }
 
+static inline int mmp2_add_audio_sram(void)
+{
+	return pxa_register_device(&mmp2_device_audio_sram, NULL, 0);
+}
+
 #endif /* __ASM_MACH_MMP2_H */
 
diff --git a/arch/arm/mach-mmp/mmp2.c b/arch/arm/mach-mmp/mmp2.c
index 8e6c3ac..4a888ae 100644
--- a/arch/arm/mach-mmp/mmp2.c
+++ b/arch/arm/mach-mmp/mmp2.c
@@ -226,4 +226,5 @@ MMP2_DEVICE(sdh0, "sdhci-pxa", 0, MMC, 0xd4280000, 0x120);
 MMP2_DEVICE(sdh1, "sdhci-pxa", 1, MMC2, 0xd4280800, 0x120);
 MMP2_DEVICE(sdh2, "sdhci-pxa", 2, MMC3, 0xd4281000, 0x120);
 MMP2_DEVICE(sdh3, "sdhci-pxa", 3, MMC4, 0xd4281800, 0x120);
+MMP2_DEVICE(audio_sram, "audio_sram", -1, NONE, 0xe0000000, 0x4000);
 
-- 
1.7.4.1

