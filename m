Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0DZUvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:51:16 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64717 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab0DZUvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ZvqY1v5AaTMlSyRes9a8mSCb04+JTm0VoS//npEL8I8wcvn2VxDyEJATYTag1kMUFk
         sWY5NcgfdKP4uIB1hRNFF3WiSH5uGEgU7F7b9h/ffR8+SlwZuTzseHfo2qZJfiUTGV3U
         I3nq9d/4RAbnPB6tPUabOqxn5uuCGPsiadnCA=
Subject: [PATCH] backlight: l4f00242t03: Fix regulators handling code in
 remove function
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-next <linux-next@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 22:51:08 +0200
Message-ID: <1272315068.3037.99.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple swap of regulator free

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/video/backlight/l4f00242t03.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index 74abd69..9e64afa 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -221,9 +221,9 @@ static int __devexit l4f00242t03_remove(struct spi_device *spi)
 	gpio_free(pdata->reset_gpio);
 
 	if (priv->io_reg)
-		regulator_put(priv->core_reg);
-	if (priv->core_reg)
 		regulator_put(priv->io_reg);
+	if (priv->core_reg)
+		regulator_put(priv->core_reg);
 
 	kfree(priv);
 
-- 
1.6.3.3



