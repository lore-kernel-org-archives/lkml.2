Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1JUBiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 21:38:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41735 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab1JUBiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 21:38:54 -0400
MIME-Version: 1.0
From: Hamo <hamo.by@gmail.com>
Date: Fri, 21 Oct 2011 09:38:32 +0800
Message-ID: <CAO_0yfOa7B4tB1nJg8c_5a612KjNmPh_aMvS=wHhfU_maAvZAg@mail.gmail.com>
Subject: [PATCH] gpio: fix build error in include/asm-generic/gpio.h
To: arnd@arndb.de
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should call the platform-specific __gpio_{get,set}_value
instead of generic gpio_{get,set}_value

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 include/asm-generic/gpio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d494001..6acff5d 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -220,13 +220,13 @@ static inline int gpio_cansleep(unsigned gpio)
 static inline int gpio_get_value_cansleep(unsigned gpio)
 {
 	might_sleep();
-	return gpio_get_value(gpio);
+	return __gpio_get_value(gpio);
 }

 static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 {
 	might_sleep();
-	gpio_set_value(gpio, value);
+	__gpio_set_value(gpio, value);
 }

 #endif /* !CONFIG_GPIOLIB */
-- 
1.7.1
