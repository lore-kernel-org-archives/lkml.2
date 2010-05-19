Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab0ESP3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:29:06 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:40209 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0ESP3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:29:04 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
       Denis Turischev <denis@compulab.co.il>
Subject: [PATCH] drivers/gpio/it8761e_gpio: check return value of gpiochip_remove()
Date: Wed, 19 May 2010 17:28:33 +0200
Message-Id: <1274282913-21696-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates the following build warning:

drivers/gpio/it8761e_gpio.c: In function ‘it8761e_gpio_exit’:
drivers/gpio/it8761e_gpio.c:220: warning: ignoring return value of ‘gpiochip_remove’, declared with attribute warn_unused_result

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Turischev <denis@compulab.co.il>
---
 drivers/gpio/it8761e_gpio.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/it8761e_gpio.c b/drivers/gpio/it8761e_gpio.c
index 753219c..a524bd8 100644
--- a/drivers/gpio/it8761e_gpio.c
+++ b/drivers/gpio/it8761e_gpio.c
@@ -217,7 +217,10 @@ gpiochip_add_err:
 static void __exit it8761e_gpio_exit(void)
 {
 	if (gpio_ba) {
-		gpiochip_remove(&it8761e_gpio_chip);
+		int ret = gpiochip_remove(&it8761e_gpio_chip);
+
+		WARN(ret, "%s(): gpiochip_remove() failed, ret=%d\n",
+				__func__, ret);
 
 		release_region(gpio_ba, GPIO_IOSIZE);
 		gpio_ba = 0;
-- 
1.7.1

