Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab0CWKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:25:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60844 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0CWKZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:25:00 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Wells <kevin.wells@nxp.com>
Subject: [PATCH 1/3] gpiolib: make names array and its values const
Date: Tue, 23 Mar 2010 11:24:53 +0100
Message-Id: <1269339895-12600-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100322204706.GA10157@pengutronix.de>
References: <20100322204706.GA10157@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpiolib doesn't need to modify the names and I assume most initializers
use string constants that shouldn't be modified anyhow.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Kevin Wells <kevin.wells@nxp.com>
---
 drivers/gpio/gpiolib.c      |    2 +-
 drivers/gpio/pca953x.c      |    2 +-
 include/asm-generic/gpio.h  |    2 +-
 include/linux/i2c/pca953x.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 6d1b866..03e82d5 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -720,7 +720,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 	unsigned long		flags;
 	struct gpio_desc	*desc;
 	int			status = -EINVAL;
-	char			*ioname = NULL;
+	const char		*ioname = NULL;
 
 	/* can't export until sysfs is available ... */
 	if (!gpio_class.p) {
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index ab5daab..60553d0 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -72,7 +72,7 @@ struct pca953x_chip {
 	struct i2c_client *client;
 	struct pca953x_platform_data *dyn_pdata;
 	struct gpio_chip gpio_chip;
-	char **names;
+	const char *const *names;
 };
 
 static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 979c6a5..bc0c14d 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -98,7 +98,7 @@ struct gpio_chip {
 						struct gpio_chip *chip);
 	int			base;
 	u16			ngpio;
-	char			**names;
+	const char		*const *names;
 	unsigned		can_sleep:1;
 	unsigned		exported:1;
 };
diff --git a/include/linux/i2c/pca953x.h b/include/linux/i2c/pca953x.h
index d5c5a60..139ba52 100644
--- a/include/linux/i2c/pca953x.h
+++ b/include/linux/i2c/pca953x.h
@@ -24,7 +24,7 @@ struct pca953x_platform_data {
 	int		(*teardown)(struct i2c_client *client,
 				unsigned gpio, unsigned ngpio,
 				void *context);
-	char		**names;
+	const char	*const *names;
 };
 
 #endif /* _LINUX_PCA953X_H */
-- 
1.7.0

