Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab1K2UFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:05:21 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34200 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754334Ab1K2UFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:05:20 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] pinmux: Message logging neatening
Date: Tue, 29 Nov 2011 12:05:16 -0800
Message-Id: <1d60ae08aa337a80604cf605565f74bc34bb3b32.1322596881.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce formats.  Argument aligning.
Rename pr_warning to pr_warn.
Add a couple missing newlines to format strings.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/pinctrl/pinmux.c |   60 +++++++++++++++++++--------------------------
 1 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 15ae972..8e3fb08 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -9,6 +9,7 @@
  *
  * License terms: GNU General Public License (GPL) version 2
  */
+
 #define pr_fmt(fmt) "pinmux core: " fmt
 
 #include <linux/kernel.h>
@@ -155,9 +156,8 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		status = 0;
 
 	if (status)
-		dev_err(&pctldev->dev, "->request on device %s failed "
-		       "for pin %d\n",
-		       pctldev->desc->name, pin);
+		dev_err(&pctldev->dev, "->request on device %s failed for pin %d\n",
+			pctldev->desc->name, pin);
 out_free_pin:
 	if (status) {
 		spin_lock(&desc->lock);
@@ -351,8 +351,7 @@ int __init pinmux_register_mappings(struct pinmux_map const *maps,
 	int i;
 
 	if (pinmux_maps != NULL) {
-		pr_err("pinmux mappings already registered, you can only "
-		       "register one set of maps\n");
+		pr_err("pinmux mappings already registered, you can only register one set of maps\n");
 		return -EINVAL;
 	}
 
@@ -360,30 +359,27 @@ int __init pinmux_register_mappings(struct pinmux_map const *maps,
 	for (i = 0; i < num_maps; i++) {
 		/* Sanity check the mapping */
 		if (!maps[i].name) {
-			pr_err("failed to register map %d: "
-			       "no map name given\n", i);
+			pr_err("failed to register map %d: no map name given\n",
+			       i);
 			return -EINVAL;
 		}
 		if (!maps[i].ctrl_dev && !maps[i].ctrl_dev_name) {
-			pr_err("failed to register map %s (%d): "
-			       "no pin control device given\n",
+			pr_err("failed to register map %s (%d): no pin control device given\n",
 			       maps[i].name, i);
 			return -EINVAL;
 		}
 		if (!maps[i].function) {
-			pr_err("failed to register map %s (%d): "
-			       "no function ID given\n", maps[i].name, i);
+			pr_err("failed to register map %s (%d): no function ID given\n",
+			       maps[i].name, i);
 			return -EINVAL;
 		}
 
 		if (!maps[i].dev && !maps[i].dev_name)
 			pr_debug("add system map %s function %s with no device\n",
-				 maps[i].name,
-				 maps[i].function);
+				 maps[i].name, maps[i].function);
 		else
 			pr_debug("register map %s, function %s\n",
-				 maps[i].name,
-				 maps[i].function);
+				 maps[i].name, maps[i].function);
 	}
 
 	pinmux_maps = maps;
@@ -424,8 +420,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 		ret = pin_request(pctldev, pins[i], func, NULL);
 		if (ret) {
 			dev_err(&pctldev->dev,
-				"could not get pin %d for function %s "
-				"on device %s - conflicting mux mappings?\n",
+				"could not get pin %d for function %s on device %s - conflicting mux mappings?\n",
 				pins[i], func ? : "(undefined)",
 				pinctrl_dev_get_name(pctldev));
 			/* On error release all taken pins */
@@ -455,8 +450,7 @@ static void release_pins(struct pinctrl_dev *pctldev,
 	ret = pctlops->get_group_pins(pctldev, group_selector,
 				      &pins, &num_pins);
 	if (ret) {
-		dev_err(&pctldev->dev, "could not get pins to release for "
-			"group selector %d\n",
+		dev_err(&pctldev->dev, "could not get pins to release for group selector %d\n",
 			group_selector);
 		return;
 	}
@@ -508,8 +502,7 @@ static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
 		ret = pinctrl_get_group_selector(pctldev, groups[0]);
 		if (ret < 0) {
 			dev_err(&pctldev->dev,
-				"function %s wants group %s but the pin "
-				"controller does not seem to have that group\n",
+				"function %s wants group %s but the pin controller does not seem to have that group\n",
 				pmxops->get_function_name(pctldev, func_selector),
 				groups[0]);
 			return ret;
@@ -517,8 +510,7 @@ static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
 
 		if (num_groups > 1)
 			dev_dbg(&pctldev->dev,
-				"function %s support more than one group, "
-				"default-selecting first group %s (%d)\n",
+				"function %s support more than one group, default-selecting first group %s (%d)\n",
 				pmxops->get_function_name(pctldev, func_selector),
 				groups[0],
 				ret);
@@ -610,8 +602,7 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 
 	if (pmx->pctldev && pmx->pctldev != pctldev) {
 		dev_err(&pctldev->dev,
-			"different pin control devices given for device %s, "
-			"function %s\n",
+			"different pin control devices given for device %s, function %s\n",
 			devname,
 			map->function);
 		return -EINVAL;
@@ -694,8 +685,8 @@ struct pinmux *pinmux_get(struct device *dev, const char *name)
 	if (dev)
 		devname = dev_name(dev);
 
-	pr_debug("get mux %s for device %s\n", name,
-		 devname ? devname : "(none)");
+	pr_debug("get mux %s for device %s\n",
+		 name, devname ? devname : "(none)");
 
 	/*
 	 * create the state cookie holder struct pinmux for each
@@ -727,17 +718,16 @@ struct pinmux *pinmux_get(struct device *dev, const char *name)
 			else if (map->ctrl_dev_name)
 				devname = map->ctrl_dev_name;
 
-			pr_warning("could not find a pinctrl device for pinmux "
-				   "function %s, fishy, they shall all have one\n",
-				   map->function);
-			pr_warning("given pinctrl device name: %s",
-				   devname ? devname : "UNDEFINED");
+			pr_warn("could not find a pinctrl device for pinmux function %s, fishy, they shall all have one\n",
+				map->function);
+			pr_warn("given pinctrl device name: %s\n",
+				devname ? devname : "UNDEFINED");
 
 			/* Continue to check the other mappings anyway... */
 			continue;
 		}
 
-		pr_debug("in map, found pctldev %s to handle function %s",
+		pr_debug("in map, found pctldev %s to handle function %s\n",
 			 dev_name(&pctldev->dev), map->function);
 
 
@@ -914,8 +904,8 @@ static int pinmux_hog_map(struct pinctrl_dev *pctldev,
 		 * without any problems, so then we can hog pinmuxes for
 		 * all devices that just want a static pin mux at this point.
 		 */
-		dev_err(&pctldev->dev, "map %s wants to hog a non-system "
-			"pinmux, this is not going to work\n", map->name);
+		dev_err(&pctldev->dev, "map %s wants to hog a non-system pinmux, this is not going to work\n",
+			map->name);
 		return -EINVAL;
 	}
 
-- 
1.7.6.405.gc1be0

