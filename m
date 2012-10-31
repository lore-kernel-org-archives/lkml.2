Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168Ab2J3SPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:15:42 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59053 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934115Ab2J3SMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:46 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH] w1-gpio: Pinctrl-fy
Date: Wed, 31 Oct 2012 17:57:38 +0200
Message-Id: <1351699058-4576-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pinctrl for w1-gpio.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/w1/masters/w1-gpio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 6012c4e..aec35bd 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -16,6 +16,8 @@
 #include <linux/gpio.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/err.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
@@ -85,8 +87,13 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
 {
 	struct w1_bus_master *master;
 	struct w1_gpio_platform_data *pdata;
+	struct pinctrl *pinctrl;
 	int err;
 
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(&pdev->dev, "unable to select pin group\n");
+
 	err = w1_gpio_probe_dt(pdev);
 	if (err < 0)
 		return err;
-- 
1.7.12

