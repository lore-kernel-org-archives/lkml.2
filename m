Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2BTGrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:47:05 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19384 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2BTGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:46:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 19 Feb 2012 22:46:11 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 07/20] pinctrl: core.c/h cleanups
Date: Sun, 19 Feb 2012 23:45:47 -0700
Message-Id: <1329720360-23227-8-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make all functions internal to core.c static. Remove any of these from
  core.h.
* Add any missing EXPORT_SYMBOL_GPL().

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c |   12 +++++++-----
 drivers/pinctrl/core.h |    3 ---
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 50bcc51..b6e3c35 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -293,9 +293,9 @@ pinctrl_match_gpio_range(struct pinctrl_dev *pctldev, unsigned gpio)
  * the GPIO subsystem, return the device and the matching GPIO range. Returns
  * negative if the GPIO range could not be found in any device.
  */
-int pinctrl_get_device_gpio_range(unsigned gpio,
-				struct pinctrl_dev **outdev,
-				struct pinctrl_gpio_range **outrange)
+static int pinctrl_get_device_gpio_range(unsigned gpio,
+					 struct pinctrl_dev **outdev,
+					 struct pinctrl_gpio_range **outrange)
 {
 	struct pinctrl_dev *pctldev = NULL;
 
@@ -332,6 +332,7 @@ void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 	list_add_tail(&range->node, &pctldev->gpio_ranges);
 	mutex_unlock(&pctldev->gpio_ranges_lock);
 }
+EXPORT_SYMBOL_GPL(pinctrl_add_gpio_range);
 
 /**
  * pinctrl_remove_gpio_range() - remove a range of GPIOs fro a pin controller
@@ -345,6 +346,7 @@ void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 	list_del(&range->node);
 	mutex_unlock(&pctldev->gpio_ranges_lock);
 }
+EXPORT_SYMBOL_GPL(pinctrl_remove_gpio_range);
 
 /**
  * pinctrl_get_group_selector() - returns the group selector for a group
@@ -785,7 +787,7 @@ static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
  * map entries that need to be hogged, i.e. get+enabled until the system shuts
  * down.
  */
-int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
+static int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
 {
 	struct device *dev = pctldev->dev;
 	const char *devname = dev_name(dev);
@@ -819,7 +821,7 @@ int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
  * pinctrl_unhog_maps() - unhog specific map entries on controller device
  * @pctldev: the pin control device to unhog entries on
  */
-void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
+static void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
 {
 	struct list_head *node, *tmp;
 
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index de4c3ed..061c57d 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -101,8 +101,5 @@ struct pin_desc {
 struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *dev_name);
 struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin);
 int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name);
-int pinctrl_get_device_gpio_range(unsigned gpio,
-				  struct pinctrl_dev **outdev,
-				  struct pinctrl_gpio_range **outrange);
 int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 			       const char *pin_group);
-- 
1.7.5.4

