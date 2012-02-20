Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2BTGrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:47:00 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19379 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2BTGqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:46:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 19 Feb 2012 22:46:07 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 02/20] pinctrl: use list_add_tail instead of list_add
Date: Sun, 19 Feb 2012 23:45:42 -0700
Message-Id: <1329720360-23227-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mostly makes debugfs files print things in the order that they
were added or acquired, which just feels a little more consistent.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c   |    8 ++++----
 drivers/pinctrl/pinmux.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 84a24a6..feadf1c 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -309,7 +309,7 @@ void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 			    struct pinctrl_gpio_range *range)
 {
 	mutex_lock(&pctldev->gpio_ranges_lock);
-	list_add(&range->node, &pctldev->gpio_ranges);
+	list_add_tail(&range->node, &pctldev->gpio_ranges);
 	mutex_unlock(&pctldev->gpio_ranges_lock);
 }
 
@@ -569,7 +569,7 @@ struct pinctrl *pinctrl_get(struct device *dev, const char *name)
 
 	/* Add the pinmux to the global list */
 	mutex_lock(&pinctrl_list_mutex);
-	list_add(&p->node, &pinctrl_list);
+	list_add_tail(&p->node, &pinctrl_list);
 	mutex_unlock(&pinctrl_list_mutex);
 
 	return p;
@@ -749,7 +749,7 @@ static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
 	dev_info(pctldev->dev, "hogged map %s, function %s\n", map->name,
 		 map->function);
 	mutex_lock(&pctldev->pinctrl_hogs_lock);
-	list_add(&hog->node, &pctldev->pinctrl_hogs);
+	list_add_tail(&hog->node, &pctldev->pinctrl_hogs);
 	mutex_unlock(&pctldev->pinctrl_hogs_lock);
 
 	return 0;
@@ -1197,7 +1197,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 
 	pinctrl_init_device_debugfs(pctldev);
 	mutex_lock(&pinctrldev_list_mutex);
-	list_add(&pctldev->node, &pinctrldev_list);
+	list_add_tail(&pctldev->node, &pinctrldev_list);
 	mutex_unlock(&pinctrldev_list_mutex);
 	pinctrl_hog_maps(pctldev);
 	return pctldev;
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index fe4a007..5a09cd2 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -480,7 +480,7 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 		kfree(grp);
 		return ret;
 	}
-	list_add(&grp->node, &p->groups);
+	list_add_tail(&grp->node, &p->groups);
 
 	return 0;
 }
-- 
1.7.5.4

