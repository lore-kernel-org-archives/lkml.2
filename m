Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab0KHMMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:12:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54495 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0KHMMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:12:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lyEH7Z7TQv7AU25gxfllqy+Gv9PYi+/YyNeBvlGWfKUuBaEUHIXvYZmbiYjTGe4Apn
         or+nSnvxmO4EugcRqWfyCJTo9NMw4EtcG7BKBhPcORGCSGXUcWmbNH8kcrGYc7tGuevo
         0YRAHiE14xIvZ2VtgrDH2Q7w4vmnqFmF5wCXQ=
From: Marek Belisko <marek.belisko@gmail.com>
To: Jassi Brar <jassi.brar@samsung.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] ASoC: s3c24xx: Fix compilation problem.
Date: Mon,  8 Nov 2010 13:14:51 +0100
Message-Id: <1289218491-17700-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When make mini2440_defconfig compilation end with undefined
references to DMA functions. There was missing selection
for S3C2410_DMA when compile ASoC audio for S3C24xx CPU.
Tested on mini2440 board.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 sound/soc/s3c24xx/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/s3c24xx/Kconfig b/sound/soc/s3c24xx/Kconfig
index 8a6b53c..d85bf8a 100644
--- a/sound/soc/s3c24xx/Kconfig
+++ b/sound/soc/s3c24xx/Kconfig
@@ -2,6 +2,7 @@ config SND_S3C24XX_SOC
 	tristate "SoC Audio for the Samsung S3CXXXX chips"
 	depends on ARCH_S3C2410 || ARCH_S3C64XX || ARCH_S5PC100 || ARCH_S5PV210
 	select S3C64XX_DMA if ARCH_S3C64XX
+	select S3C2410_DMA if ARCH_S3C2410
 	help
 	  Say Y or M if you want to add support for codecs attached to
 	  the S3C24XX AC97 or I2S interfaces. You will also need to
-- 
1.7.1

