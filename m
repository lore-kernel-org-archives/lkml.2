Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2HIGit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:38:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab2HIGir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:38:47 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: Fix debug message in of_get_named_gpio_flags()
Date: Thu,  9 Aug 2012 08:38:43 +0200
Message-Id: <1344494323-4992-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.11.4
X-Provags-ID: V02:K0:31UVKSl9T1BU1aNEg0DtreIriNVr3sZkSMFTGNxtmw+
 q/5G9PbuZ/ZvcZbW7JlOS/oMRVXoSS3ga3cDvFcyxqFdLw/Zlj
 k4ym3qyx1r8BqXZY431CQgTiiZ+aBj5DSaYKaotqr0YZ79+seY
 OIKh3nrT7lzQzrV6IpB82d3IwWhKgRfalsm1+4/YF96ZWBfJmG
 D3F1iVFl1fOdOG7eJPAGQDM8EUwz8lsD7l/9jKfmnMtNZedRzY
 +MAWoWJ6eWNhb7d4hF6R0+Hfv06FSQ/YbFsgcBDjNGMCSSsihF
 drndAU2zDtaKsSJagWN5TE1pUtYoT3kobpCzH10datlLOcsoLM
 YE0xtLkz0uy5G5hKkrdvUXMRU3TDxtBIwIr0B6PKn9sK7qFJhF
 z/SzCV9rU/9N0HrtQNKgXVM0+8vX1ooI6CuWdhkG6nC5X8Xz1X
 TFxC+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was probably missed in the conversion done in commit 3d0f7cf
("gpio: Adjust of_xlate API to support multiple GPIO chips").

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/gpio/gpiolib-of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index a18c4aa..f1a4599 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -82,7 +82,7 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
 	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
 
 	of_node_put(gg_data.gpiospec.np);
-	pr_debug("%s exited with status %d\n", __func__, ret);
+	pr_debug("%s exited with status %d\n", __func__, gg_data.out_gpio);
 	return gg_data.out_gpio;
 }
 EXPORT_SYMBOL(of_get_named_gpio_flags);
-- 
1.7.11.4

