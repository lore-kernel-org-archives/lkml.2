Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965330Ab2J3SSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:18:10 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59048 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965219Ab2J3SMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:42 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2012 14:12:41 EDT
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH] gpio-keys: Pinctrl-fy
Date: Wed, 31 Oct 2012 17:56:59 +0200
Message-Id: <1351699019-4313-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pinctrl support for gpio-keys.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/input/keyboard/gpio_keys.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 6a68041..e421082 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -29,6 +29,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
 #include <linux/spinlock.h>
+#include <linux/pinctrl/consumer.h>
 
 struct gpio_button_data {
 	const struct gpio_keys_button *button;
@@ -666,6 +667,7 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 	struct input_dev *input;
 	int i, error;
 	int wakeup = 0;
+	struct pinctrl *pinctrl;
 
 	if (!pdata) {
 		pdata = gpio_keys_get_devtree_pdata(dev);
@@ -731,6 +733,10 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 		goto fail3;
 	}
 
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(&pdev->dev, "unable to select pin group\n");
+
 	/* get current state of buttons that are connected to GPIOs */
 	for (i = 0; i < pdata->nbuttons; i++) {
 		struct gpio_button_data *bdata = &ddata->data[i];
-- 
1.7.12

