Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2KWFrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 00:47:14 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56741 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2KWFqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 00:46:13 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: <alsa-devel@alsa-project.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [BUGFIX PATCH] ASoC: fsl: fix miscompilation of snd-soc-imx-pcm
Date: Thu, 22 Nov 2012 13:31:06 +0100
Message-Id: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a broken make rule, imx-pcm-dma.c or imx-pcm-fiq.c (whatever is
selected via Kconfig) will not be compiled when building as module,
resulting in a non-functional sound driver.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 sound/soc/fsl/Makefile |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
index 515ba66..7bb5c38 100644
--- a/sound/soc/fsl/Makefile
+++ b/sound/soc/fsl/Makefile
@@ -36,8 +36,12 @@ obj-$(CONFIG_SND_SOC_IMX_AUDMUX) += snd-soc-imx-audmux.o
 
 obj-$(CONFIG_SND_SOC_IMX_PCM) += snd-soc-imx-pcm.o
 snd-soc-imx-pcm-y := imx-pcm.o
-snd-soc-imx-pcm-$(CONFIG_SND_SOC_IMX_PCM_FIQ) += imx-pcm-fiq.o
-snd-soc-imx-pcm-$(CONFIG_SND_SOC_IMX_PCM_DMA) += imx-pcm-dma.o
+ifneq ($(CONFIG_SND_SOC_IMX_PCM_FIQ),)
+	snd-soc-imx-pcm-objs += imx-pcm-fiq.o
+endif
+ifneq ($(CONFIG_SND_SOC_IMX_PCM_DMA),)
+	snd-soc-imx-pcm-objs += imx-pcm-dma.o
+endif
 
 # i.MX Machine Support
 snd-soc-eukrea-tlv320-objs := eukrea-tlv320.o
-- 
1.7.2.5

