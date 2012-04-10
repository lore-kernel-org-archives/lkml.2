Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2DJIDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:03:23 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52522 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2DJIDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:03:15 -0400
Date: Tue, 10 Apr 2012 01:03:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: matrix-keypad - fix 'duplicate const' sparse warning
Message-ID: <20120410080311.GA19164@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SIMPLE_DEV_PM_OPS already defines constant dev_pm_ops.

Also guard PM methods with CONFIG_PM_SLEEP and get rid of some
unneeded #ifdefs.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/matrix_keypad.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 9b223d7..8714d68 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -224,7 +224,7 @@ static void matrix_keypad_stop(struct input_dev *dev)
 	disable_row_irqs(keypad);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static void matrix_keypad_enable_wakeup(struct matrix_keypad *keypad)
 {
 	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
@@ -293,11 +293,11 @@ static int matrix_keypad_resume(struct device *dev)
 
 	return 0;
 }
-
-static const SIMPLE_DEV_PM_OPS(matrix_keypad_pm_ops,
-				matrix_keypad_suspend, matrix_keypad_resume);
 #endif
 
+static SIMPLE_DEV_PM_OPS(matrix_keypad_pm_ops,
+			 matrix_keypad_suspend, matrix_keypad_resume);
+
 static int __devinit init_matrix_gpio(struct platform_device *pdev,
 					struct matrix_keypad *keypad)
 {
@@ -491,9 +491,7 @@ static struct platform_driver matrix_keypad_driver = {
 	.driver		= {
 		.name	= "matrix-keypad",
 		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
 		.pm	= &matrix_keypad_pm_ops,
-#endif
 	},
 };
 module_platform_driver(matrix_keypad_driver);
-- 
1.7.7.6


-- 
Dmitry
