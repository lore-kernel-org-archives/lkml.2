Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2ASVnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 16:43:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38657 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2ASVm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 16:42:58 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: unbreak error messages
Date: Thu, 19 Jan 2012 22:42:48 +0100
Message-Id: <1327009368-23624-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better to not line break error messages to allow easier grepping
for them even when the line gets >80 chars. Additionally some minor
reformating is done.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/pinctrl/pinmux.c |   46 +++++++++++++++++++---------------------------
 1 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index a76a348..0b22037 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -152,8 +152,7 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		status = 0;
 
 	if (status)
-		dev_err(pctldev->dev, "->request on device %s failed "
-		       "for pin %d\n",
+		dev_err(pctldev->dev, "->request on device %s failed for pin %d\n",
 		       pctldev->desc->name, pin);
 out_free_pin:
 	if (status) {
@@ -355,21 +354,20 @@ int __init pinmux_register_mappings(struct pinmux_map const *maps,
 	/* First sanity check the new mapping */
 	for (i = 0; i < num_maps; i++) {
 		if (!maps[i].name) {
-			pr_err("failed to register map %d: "
-			       "no map name given\n", i);
+			pr_err("failed to register map %d: no map name given\n",
+					i);
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
+					maps[i].name, i);
 			return -EINVAL;
 		}
 
@@ -442,8 +440,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 		ret = pin_request(pctldev, pins[i], func, NULL);
 		if (ret) {
 			dev_err(pctldev->dev,
-				"could not get pin %d for function %s "
-				"on device %s - conflicting mux mappings?\n",
+				"could not get pin %d for function %s on device %s - conflicting mux mappings?\n",
 				pins[i], func ? : "(undefined)",
 				pinctrl_dev_get_name(pctldev));
 			/* On error release all taken pins */
@@ -473,8 +470,7 @@ static void release_pins(struct pinctrl_dev *pctldev,
 	ret = pctlops->get_group_pins(pctldev, group_selector,
 				      &pins, &num_pins);
 	if (ret) {
-		dev_err(pctldev->dev, "could not get pins to release for "
-			"group selector %d\n",
+		dev_err(pctldev->dev, "could not get pins to release for group selector %d\n",
 			group_selector);
 		return;
 	}
@@ -526,8 +522,7 @@ static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
 		ret = pinctrl_get_group_selector(pctldev, groups[0]);
 		if (ret < 0) {
 			dev_err(pctldev->dev,
-				"function %s wants group %s but the pin "
-				"controller does not seem to have that group\n",
+				"function %s wants group %s but the pin controller does not seem to have that group\n",
 				pmxops->get_function_name(pctldev, func_selector),
 				groups[0]);
 			return ret;
@@ -535,8 +530,7 @@ static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
 
 		if (num_groups > 1)
 			dev_dbg(pctldev->dev,
-				"function %s support more than one group, "
-				"default-selecting first group %s (%d)\n",
+				"function %s support more than one group, default-selecting first group %s (%d)\n",
 				pmxops->get_function_name(pctldev, func_selector),
 				groups[0],
 				ret);
@@ -628,10 +622,8 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 
 	if (pmx->pctldev && pmx->pctldev != pctldev) {
 		dev_err(pctldev->dev,
-			"different pin control devices given for device %s, "
-			"function %s\n",
-			devname,
-			map->function);
+			"different pin control devices given for device %s, function %s\n",
+			devname, map->function);
 		return -EINVAL;
 	}
 	pmx->dev = dev;
@@ -695,7 +687,6 @@ static void pinmux_free_groups(struct pinmux *pmx)
  */
 struct pinmux *pinmux_get(struct device *dev, const char *name)
 {
-
 	struct pinmux_map const *map = NULL;
 	struct pinctrl_dev *pctldev = NULL;
 	const char *devname = NULL;
@@ -745,8 +736,7 @@ struct pinmux *pinmux_get(struct device *dev, const char *name)
 			else if (map->ctrl_dev_name)
 				devname = map->ctrl_dev_name;
 
-			pr_warning("could not find a pinctrl device for pinmux "
-				   "function %s, fishy, they shall all have one\n",
+			pr_warning("could not find a pinctrl device for pinmux function %s, fishy, they shall all have one\n",
 				   map->function);
 			pr_warning("given pinctrl device name: %s",
 				   devname ? devname : "UNDEFINED");
@@ -932,8 +922,8 @@ static int pinmux_hog_map(struct pinctrl_dev *pctldev,
 		 * without any problems, so then we can hog pinmuxes for
 		 * all devices that just want a static pin mux at this point.
 		 */
-		dev_err(pctldev->dev, "map %s wants to hog a non-system "
-			"pinmux, this is not going to work\n", map->name);
+		dev_err(pctldev->dev, "map %s wants to hog a non-system pinmux, this is not going to work\n",
+				map->name);
 		return -EINVAL;
 	}
 
@@ -1122,13 +1112,15 @@ static int pinmux_show(struct seq_file *s, void *what)
 
 		seq_printf(s, "device: %s function: %s (%u),",
 			   pinctrl_dev_get_name(pmx->pctldev),
-			   pmxops->get_function_name(pctldev, pmx->func_selector),
+			   pmxops->get_function_name(pctldev,
+				   pmx->func_selector),
 			   pmx->func_selector);
 
 		seq_printf(s, " groups: [");
 		list_for_each_entry(grp, &pmx->groups, node) {
 			seq_printf(s, " %s (%u)",
-				   pctlops->get_group_name(pctldev, grp->group_selector),
+				   pctlops->get_group_name(pctldev,
+					   grp->group_selector),
 				   grp->group_selector);
 		}
 		seq_printf(s, " ]");
-- 
1.7.8.3

