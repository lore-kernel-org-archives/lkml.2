Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2LKMKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:10:09 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38406 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2LKMKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:10:08 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Mack <zonque@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <syrjala@sci.fi>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] w1:masters/w1-gpio.c: fix error using "__devinit" and "__devexit"
Date: Tue, 11 Dec 2012 12:08:54 +0000
Message-Id: <1355227740-4377-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

w1:masters/w1-gpio.c: fix error using "__devinit" and "__devexit"

we should use "__devinit" to mark the probe function, "__devexit" to
mark the remove function, and "__devexit_p" to mark the pointer to the
remove function.

the error was found by the following compilation warning:
WARNING: drivers/w1/masters/w1-gpio.o(.data+0x0): Section mismatch in
reference from the variable w1_gpio_driver to the function
.init.text:w1_gpio_probe()
The variable w1_gpio_driver references
the function __init w1_gpio_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/w1/masters/w1-gpio.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 85b363a..33edc3b 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -72,7 +72,7 @@ static int w1_gpio_probe_dt(struct platform_device *pdev)
 	return 0;
 }
 
-static int __init w1_gpio_probe(struct platform_device *pdev)
+static int __devinit w1_gpio_probe(struct platform_device *pdev)
 {
 	struct w1_bus_master *master;
 	struct w1_gpio_platform_data *pdata;
@@ -158,7 +158,7 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int __exit w1_gpio_remove(struct platform_device *pdev)
+static int __devexit w1_gpio_remove(struct platform_device *pdev)
 {
 	struct w1_bus_master *master = platform_get_drvdata(pdev);
 	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
@@ -210,7 +210,7 @@ static struct platform_driver w1_gpio_driver = {
 		.of_match_table = of_match_ptr(w1_gpio_dt_ids),
 	},
 	.probe = w1_gpio_probe,
-	.remove	= __exit_p(w1_gpio_remove),
+	.remove	= __devexit_p(w1_gpio_remove),
 	.suspend = w1_gpio_suspend,
 	.resume = w1_gpio_resume,
 };
-- 
1.7.4.5

