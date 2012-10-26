Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab2JZPPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:15:08 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36417 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:15:06 -0400
MIME-Version: 1.0
Date: Fri, 26 Oct 2012 23:15:05 +0800
Message-ID: <CAPgLHd8BxYammidxX_-fmQSujf2LHL44qYMEBVDLrfV2ziBKBA@mail.gmail.com>
Subject: [PATCH -next] GPIO: clps711x: use platform_device_unregister in gpio_clps711x_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
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
 drivers/gpio/gpio-clps711x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-clps711x.c b/drivers/gpio/gpio-clps711x.c
index 0753b3a..def66ae 100644
--- a/drivers/gpio/gpio-clps711x.c
+++ b/drivers/gpio/gpio-clps711x.c
@@ -130,8 +130,7 @@ static int __init gpio_clps711x_init(void)
 			    GFP_KERNEL);
 	if (!gpio) {
 		dev_err(&pdev->dev, "GPIO allocating memory error\n");
-		platform_device_del(pdev);
-		platform_device_put(pdev);
+		platform_device_unregister(pdev);
 		return -ENOMEM;
 	}
 

