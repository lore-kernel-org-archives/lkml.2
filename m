Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2KKCbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 21:31:37 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63886 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2KKCbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 21:31:36 -0500
Message-ID: <1352601091.23129.7.camel@phoenix>
Subject: [PATCH] pinctrl: tegra: Staticize non-exported symbols
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Date: Sun, 11 Nov 2012 10:31:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are not referenced outside of this file, make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-tegra.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index 7da0b37..4dfa902 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -178,8 +178,9 @@ static int add_config(struct device *dev, unsigned long **configs,
 	return 0;
 }
 
-void tegra_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
-			       struct pinctrl_map *map, unsigned num_maps)
+static void tegra_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
+				      struct pinctrl_map *map,
+				      unsigned num_maps)
 {
 	int i;
 
@@ -209,11 +210,11 @@ static const struct cfg_param {
 	{"nvidia,slew-rate-rising",	TEGRA_PINCONF_PARAM_SLEW_RATE_RISING},
 };
 
-int tegra_pinctrl_dt_subnode_to_map(struct device *dev,
-				    struct device_node *np,
-				    struct pinctrl_map **map,
-				    unsigned *reserved_maps,
-				    unsigned *num_maps)
+static int tegra_pinctrl_dt_subnode_to_map(struct device *dev,
+					   struct device_node *np,
+					   struct pinctrl_map **map,
+					   unsigned *reserved_maps,
+					   unsigned *num_maps)
 {
 	int ret, i;
 	const char *function;
@@ -288,9 +289,10 @@ exit:
 	return ret;
 }
 
-int tegra_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
-				 struct device_node *np_config,
-				 struct pinctrl_map **map, unsigned *num_maps)
+static int tegra_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+					struct device_node *np_config,
+					struct pinctrl_map **map,
+					unsigned *num_maps)
 {
 	unsigned reserved_maps;
 	struct device_node *np;
-- 
1.7.9.5



