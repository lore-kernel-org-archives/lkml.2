Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2BVV0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:26:22 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6084 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2BVV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:26:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 22 Feb 2012 13:26:08 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 3/4] pinctrl: Allocate sizeof(*p) instead of sizeof(struct foo)
Date: Wed, 22 Feb 2012 14:26:00 -0700
Message-Id: <1329945961-29547-4-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329945961-29547-1-git-send-email-swarren@nvidia.com>
References: <1329945961-29547-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This hopefully makes it harder to take the sizeof the wrong type.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
---
v2: Rebased

 drivers/pinctrl/core.c   |    6 +++---
 drivers/pinctrl/pinmux.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 1d59430..2cc8f72 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -502,7 +502,7 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 	 * mapping, this is what consumers will get when requesting
 	 * a pin control handle with pinctrl_get()
 	 */
-	p = kzalloc(sizeof(struct pinctrl), GFP_KERNEL);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (p == NULL) {
 		dev_err(dev, "failed to alloc struct pinctrl\n");
 		return ERR_PTR(-ENOMEM);
@@ -726,7 +726,7 @@ static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
 	struct pinctrl *p;
 	int ret;
 
-	hog = kzalloc(sizeof(struct pinctrl_hog), GFP_KERNEL);
+	hog = kzalloc(sizeof(*hog), GFP_KERNEL);
 	if (!hog) {
 		dev_err(pctldev->dev, "failed to alloc struct pinctrl_hog\n");
 		return -ENOMEM;
@@ -1160,7 +1160,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	if (pctldesc->name == NULL)
 		return NULL;
 
-	pctldev = kzalloc(sizeof(struct pinctrl_dev), GFP_KERNEL);
+	pctldev = kzalloc(sizeof(*pctldev), GFP_KERNEL);
 	if (pctldev == NULL) {
 		dev_err(dev, "failed to alloc struct pinctrl_dev\n");
 		return NULL;
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 2887897..98b89d6 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -491,7 +491,7 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 	p->func_selector = func_selector;
 
 	/* Now add this group selector, we may have many of them */
-	grp = kmalloc(sizeof(struct pinmux_group), GFP_KERNEL);
+	grp = kmalloc(sizeof(*grp), GFP_KERNEL);
 	if (!grp)
 		return -ENOMEM;
 	grp->group_selector = group_selector;
-- 
1.7.0.4

