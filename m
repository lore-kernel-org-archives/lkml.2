Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab2BTGrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:47:07 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5240 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2BTGq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:46:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 19 Feb 2012 22:46:14 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 10/20] pinctrl: Assume map table entries can't have a NULL ctrl_dev_name field
Date: Sun, 19 Feb 2012 23:45:50 -0700
Message-Id: <1329720360-23227-11-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are already disallowed. Clean up some code that doesn't assume this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 331ffb6..37dfac7 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -770,8 +770,7 @@ static int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
 
 	mutex_lock(&pinctrl_maps_mutex);
 	for_each_maps(maps_node, i, map) {
-		if (map->ctrl_dev_name &&
-		    !strcmp(map->ctrl_dev_name, devname) &&
+		if (!strcmp(map->ctrl_dev_name, devname) &&
 		    !strcmp(map->dev_name, devname)) {
 			/* OK time to hog! */
 			ret = pinctrl_hog_map(pctldev, map);
-- 
1.7.5.4

