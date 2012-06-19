Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2FSSWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:22:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52682 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2FSSWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:22:49 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jiri Kosina <trivial@kernel.org>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] leds: [trivial]Remove unnecesary return
Date: Tue, 19 Jun 2012 23:52:39 +0530
Message-Id: <1340130159-10408-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the ret is got the status returned by the
led_classdev_register, returning ret if the
led_classdev_register fails and returning 0
if the led_classdev_register success, can be done
by doing just "return ret" at the end.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---

Tested by build with the gcc linaro (arm-linux-gnueabihf) (4.7.1).

 drivers/leds/leds-s3c24xx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index bd0a5ed..e6ee105 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -106,10 +106,9 @@ static int s3c24xx_led_probe(struct platform_device *dev)
	if (ret < 0) {
		dev_err(&dev->dev, "led_classdev_register failed\n");
		kfree(led);
-		return ret;
	}

-	return 0;
+	return ret;
 }

 static struct platform_driver s3c24xx_led_driver = {
--
1.7.9.5
