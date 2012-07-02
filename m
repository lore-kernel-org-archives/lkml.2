Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2GBIWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:22:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47167 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2GBIW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:22:26 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] leds-88pm860x: use the goto label at data->port
Date: Mon,  2 Jul 2012 13:52:12 +0530
Message-Id: <1341217332-21153-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at the goto lable out: we are doing free of the led data, and returning ret.
the same we are doing at the data->port < 0 case, so use the goto end and
assign ret to -EINVAL. this will make the common err path for the
data->port and led_classdev_register functions.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/leds/leds-88pm860x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index 5b61aaf..538aaa3 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -220,8 +220,8 @@ static int pm860x_led_probe(struct platform_device *pdev)
 	data->port = pdata->flags;
 	if (data->port < 0) {
 		dev_err(&pdev->dev, "check device failed\n");
-		kfree(data);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	data->current_brightness = 0;
-- 
1.7.9.5

