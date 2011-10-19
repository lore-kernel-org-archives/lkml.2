Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1JSCzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 22:55:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56456 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1JSCzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 22:55:09 -0400
Message-ID: <1318992896.7128.1.camel@phoenix>
Subject: [PATCH 1/2] ASoC: sgtl5000: Fix define for SGTL5000_BIAS_R_MASK
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Wed, 19 Oct 2011 10:54:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet:
CHIP_MIC_CTRL 0x002A

BITS[9:8] BIAS_RESISTOR
        0x0 = Powerd off
        0x1 = 2.0 kohm
        0x2 = 4.0 kohm
        0x3 = 8.0 kohm

Thus SGTL5000_BIAS_R_MASK should be defined as 0x0300 instead of 0x0200.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sgtl5000.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index eec3ab3..8a9f435 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -280,7 +280,7 @@
 /*
  * SGTL5000_CHIP_MIC_CTRL
  */
-#define SGTL5000_BIAS_R_MASK			0x0200
+#define SGTL5000_BIAS_R_MASK			0x0300
 #define SGTL5000_BIAS_R_SHIFT			8
 #define SGTL5000_BIAS_R_WIDTH			2
 #define SGTL5000_BIAS_R_off			0x0
-- 
1.7.5.4



