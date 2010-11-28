Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0K1ROA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 12:14:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59416 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0K1RN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 12:13:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Rfc4KxEIzHn391jroF6mMtUCz20RtBbPHwlrAFBCAuDGowhdjfOohmKjeNKXMtyxDp
         04djCN4uHN5v2B/06y4jRlAeynoVNx5sW5PxPU+4SMpvZilDbZ11XhziA6RuE3F99m28
         pQNwqqaeAynUDVYs1chSo1XW+J8X7GQMIv4+o=
Subject: [PATCH] backlight: l4f00242t03: Fix reset sequence
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, Marek Vasut <marek.vasut@gmail.com>,
        Tejun Heo <tj@kernel.org>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Nov 2010 18:13:53 +0100
Message-ID: <1290964433.3016.2.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset command is part of the init sequence and it take effect
only if the lcd is powered.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---

This patch is built on top of:
http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch

 drivers/video/backlight/l4f00242t03.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index 5d25743..c04aa90 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -62,6 +62,8 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
 		regulator_enable(priv->core_reg);
 	}
 
+	l4f00242t03_reset(pdata->reset_gpio);
+
 	gpio_set_value(pdata->data_enable_gpio, 1);
 	msleep(60);
 	spi_write(spi, (const u8 *)cmd, ARRAY_SIZE(cmd) * sizeof(u16));
@@ -225,7 +227,6 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
 	}
 
 	/* Init the LCD */
-	l4f00242t03_reset(pdata->reset_gpio);
 	l4f00242t03_lcd_init(spi);
 	priv->lcd_state = FB_BLANK_VSYNC_SUSPEND;
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_UNBLANK);
-- 
1.6.3.3


