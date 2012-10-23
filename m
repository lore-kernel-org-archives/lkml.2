Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2JWFYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 01:24:11 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47531 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab2JWFYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 01:24:09 -0400
MIME-Version: 1.0
Date: Tue, 23 Oct 2012 13:24:09 +0800
Message-ID: <CAPgLHd9u=7j9Bf2CP4_GcwjafmRCd7hwkvaH3ioMpWJ5w5r54A@mail.gmail.com>
Subject: [PATCH] pc8736x_gpio: use platform_device_unregister in pc8736x_gpio_cleanup()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: jim.cromie@gmail.com, arnd@arndb.de, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

platform_device_unregister() only calls platform_device_del() and
platform_device_put(), thus use platform_device_unregister() to
simplify the code.

Also the documents in platform.c shows that platform_device_del
and platform_device_put must _only_ be externally called in error
cases.  All other usage is a bug.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/char/pc8736x_gpio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/pc8736x_gpio.c b/drivers/char/pc8736x_gpio.c
index b304ec0..3f79a9f 100644
--- a/drivers/char/pc8736x_gpio.c
+++ b/drivers/char/pc8736x_gpio.c
@@ -345,8 +345,7 @@ static void __exit pc8736x_gpio_cleanup(void)
 	unregister_chrdev_region(MKDEV(major,0), PC8736X_GPIO_CT);
 	release_region(pc8736x_gpio_base, PC8736X_GPIO_RANGE);
 
-	platform_device_del(pdev);
-	platform_device_put(pdev);
+	platform_device_unregister(pdev);
 }
 
 module_init(pc8736x_gpio_init);


