Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2GXB1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:27:09 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56086 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab2GXB1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:27:07 -0400
Message-ID: <1343093217.7556.1.camel@phoenix>
Subject: [PATCH] extcon: extcon_gpio: Replace gpio_request_one by
 devm_gpio_request_one
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Lockwood <lockwood@android.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 24 Jul 2012 09:26:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 01eaf24 "extcon: Convert extcon_gpio to devm_gpio_request_one"
missed the replacement for devm_gpio_request_one. fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/extcon/extcon_gpio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon_gpio.c b/drivers/extcon/extcon_gpio.c
index fe3db45..3cc152e 100644
--- a/drivers/extcon/extcon_gpio.c
+++ b/drivers/extcon/extcon_gpio.c
@@ -107,7 +107,8 @@ static int __devinit gpio_extcon_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	ret = gpio_request_one(extcon_data->gpio, GPIOF_DIR_IN, pdev->name);
+	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
+				    pdev->name);
 	if (ret < 0)
 		goto err;
 
-- 
1.7.9.5



