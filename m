Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1JZU6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:58:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40206 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1JZU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:58:14 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: swarren@nvidia.com, linus.walleij@linaro.org
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/2] pinmux: Unify pin type from signed to unsigned.
Date: Wed, 26 Oct 2011 22:57:21 +0200
Message-Id: <1319662641-28416-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
References: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/pinctrl/core.c          |    7 ++-----
 drivers/pinctrl/core.h          |    2 +-
 drivers/pinctrl/pinmux.c        |    4 ++--
 include/linux/pinctrl/pinctrl.h |    4 ++--
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 423522d..11e2ec5 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -87,7 +87,7 @@ struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
 	return found ? pctldev : NULL;
 }
 
-struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin)
+struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin)
 {
 	struct pin_desc *pindesc;
 	unsigned long flags;
@@ -107,13 +107,10 @@ struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin)
  * This tells us whether a certain pin exist on a certain pin controller or
  * not. Pin lists may be sparse, so some pins may not exist.
  */
-bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
+bool pin_is_valid(struct pinctrl_dev *pctldev, unsigned int pin)
 {
 	struct pin_desc *pindesc;
 
-	if (pin < 0)
-		return false;
-
 	pindesc = pin_desc_get(pctldev, pin);
 	if (pindesc == NULL)
 		return false;
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 472fa13..759dc1f 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -65,7 +65,7 @@ struct pin_desc {
 
 struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
 					     const char *dev_name);
-struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, int pin);
+struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin);
 int pinctrl_get_device_gpio_range(unsigned gpio,
 				  struct pinctrl_dev **outdev,
 				  struct pinctrl_gpio_range **outrange);
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index b6d964f..a53d36a 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -103,7 +103,7 @@ struct pinmux_hog {
  *	single GPIO pin
  */
 static int pin_request(struct pinctrl_dev *pctldev,
-		       int pin, const char *function, bool gpio,
+		       unsigned int pin, const char *function, bool gpio,
 		       struct pinctrl_gpio_range *gpio_range)
 {
 	struct pin_desc *desc;
@@ -213,7 +213,7 @@ int pinmux_request_gpio(unsigned gpio)
 	struct pinctrl_dev *pctldev;
 	struct pinctrl_gpio_range *range;
 	int ret;
-	int pin;
+	unsigned int pin;
 
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret)
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 3605e94..34c33c7 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -112,7 +112,7 @@ struct pinctrl_desc {
 extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 				struct device *dev, void *driver_data);
 extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
-extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
+extern bool pin_is_valid(struct pinctrl_dev *pctldev, unsigned int pin);
 extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 				struct pinctrl_gpio_range *range);
 extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
@@ -123,7 +123,7 @@ extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
 
 
 /* Sufficiently stupid default function when pinctrl is not in use */
-static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
+static inline bool pin_is_valid(struct pinctrl_dev *pctldev, unsigned int pin)
 {
 	return pin >= 0;
 }
-- 
1.7.5.4

