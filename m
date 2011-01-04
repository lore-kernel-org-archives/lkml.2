Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1ADQve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:51:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54442 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1ADQvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:51:31 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/2] gpiolib: add missing functions to generic fallback
Date: Tue,  4 Jan 2011 17:51:08 +0100
Message-Id: <1294159868-4989-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
References: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <gregkh@suse.de>
---
 include/linux/gpio.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 1d5214a..f79d67f 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 
 struct device;
+struct gpio;
 struct gpio_chip;
 
 /*
@@ -34,6 +35,17 @@ static inline int __must_check gpio_request(unsigned gpio, const char *label)
 	return -ENOSYS;
 }
 
+static inline int __must_check gpio_request_one(unsigned gpio,
+					unsigned long flags, const char *label)
+{
+	return -ENOSYS;
+}
+
+static inline int __must_check gpio_request_array(struct gpio *array, size_t num)
+{
+	return -ENOSYS;
+}
+
 static inline void gpio_free(unsigned gpio)
 {
 	might_sleep();
@@ -42,6 +54,14 @@ static inline void gpio_free(unsigned gpio)
 	WARN_ON(1);
 }
 
+static inline void gpio_free_array(struct gpio *array, size_t num)
+{
+	might_sleep();
+
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
 static inline int __must_check gpio_direction_input(unsigned gpio)
 {
 	return -ENOSYS;
-- 
1.7.2.3

