Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab1JTKti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:49:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38954 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab1JTKth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:49:37 -0400
Message-ID: <1319107769.8866.3.camel@phoenix>
Subject: [PATCH] ASoC: Use SGTL5000_LINREG_VDDD_MASK instead of hardcoded
 mask value
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Thu, 20 Oct 2011 18:49:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have defined SGTL5000_LINREG_VDDD_MASK in sgtl5000.h,
use it instead of hardcoded (0x1 << 4) - 1 for the mask.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sgtl5000.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 8395002..32b5bbd 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -754,7 +754,7 @@ static int ldo_regulator_enable(struct regulator_dev *dev)
 
 	/* set voltage to register */
 	snd_soc_update_bits(codec, SGTL5000_CHIP_LINREG_CTRL,
-				(0x1 << 4) - 1, reg);
+				SGTL5000_LINREG_VDDD_MASK, reg);
 
 	snd_soc_update_bits(codec, SGTL5000_CHIP_ANA_POWER,
 				SGTL5000_LINEREG_D_POWERUP,
@@ -780,7 +780,7 @@ static int ldo_regulator_disable(struct regulator_dev *dev)
 
 	/* clear voltage info */
 	snd_soc_update_bits(codec, SGTL5000_CHIP_LINREG_CTRL,
-				(0x1 << 4) - 1, 0);
+				SGTL5000_LINREG_VDDD_MASK, 0);
 
 	ldo->enabled = 0;
 
@@ -1115,7 +1115,7 @@ static int sgtl5000_set_power_regs(struct snd_soc_codec *codec)
 
 	/* set voltage to register */
 	snd_soc_update_bits(codec, SGTL5000_CHIP_LINREG_CTRL,
-				(0x1 << 4) - 1, 0x8);
+				SGTL5000_LINREG_VDDD_MASK, 0x8);
 
 	/*
 	 * if vddd linear reg has been enabled,
-- 
1.7.5.4



