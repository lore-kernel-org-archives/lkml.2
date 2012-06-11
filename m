Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2FKP0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:26:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46887 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab2FKPZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:44 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 11/14] usb: otg: Enable probing of the ab8500 during a Device Tree boot
Date: Mon, 11 Jun 2012 16:25:04 +0100
Message-Id: <1339428307-3850-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, if Device Tree is enabled the AB8500 USB OTG driver
wouldn't get probed at all, as there is no reference to it from platform
code. This patch ensures the driver is probed during normal DT start-up.

Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/usb/otg/ab8500-usb.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/otg/ab8500-usb.c b/drivers/usb/otg/ab8500-usb.c
index a84af67..9799ac6 100644
--- a/drivers/usb/otg/ab8500-usb.c
+++ b/drivers/usb/otg/ab8500-usb.c
@@ -569,12 +569,18 @@ static int __devexit ab8500_usb_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id ab8500_usb_match[] = {
+	{ .compatible = "stericsson,ab8500-usb", },
+	{},
+};
+
 static struct platform_driver ab8500_usb_driver = {
 	.probe		= ab8500_usb_probe,
 	.remove		= __devexit_p(ab8500_usb_remove),
 	.driver		= {
 		.name	= "ab8500-usb",
 		.owner	= THIS_MODULE,
+		.of_match_table = ab8500_usb_match,
 	},
 };
 
-- 
1.7.9.5

