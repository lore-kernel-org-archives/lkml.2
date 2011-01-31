Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1AaP0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:26:01 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:41487 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab1AaPZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:25:59 -0500
From: Thomas Chou <thomas@wytron.com.tw>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH 2/3] of: of_gpiochip_add is needed only for gpiolib
Date: Mon, 31 Jan 2011 23:25:50 +0800
Message-Id: <1296487551-30938-2-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
References: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
X-SA-Exim-Connect-IP: 192.168.1.250
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some gpio drivers may not use gpiolib. In this case, struct gpio_chip
is not defined and of_gpiochip_add/remove are not needed.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 include/linux/of_gpio.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 6598c04..fc96af0 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -71,9 +71,13 @@ static inline unsigned int of_gpio_count(struct device_node *np)
 	return 0;
 }
 
+#ifdef CONFIG_GPIOLIB
+
 static inline void of_gpiochip_add(struct gpio_chip *gc) { }
 static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 
+#endif /* CONFIG_GPIOLIB */
+
 #endif /* CONFIG_OF_GPIO */
 
 /**
-- 
1.7.3.5

