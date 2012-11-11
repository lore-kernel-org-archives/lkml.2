Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2KKC3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 21:29:47 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63770 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2KKC3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 21:29:45 -0500
Message-ID: <1352600980.23129.5.camel@phoenix>
Subject: [PATCH] pinctrl: spear: Staticize non-exported symbols
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 11 Nov 2012 10:29:40 +0800
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
 drivers/pinctrl/spear/pinctrl-spear.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/spear/pinctrl-spear.c b/drivers/pinctrl/spear/pinctrl-spear.c
index b1fd6ee..9a4dd4e 100644
--- a/drivers/pinctrl/spear/pinctrl-spear.c
+++ b/drivers/pinctrl/spear/pinctrl-spear.c
@@ -121,9 +121,10 @@ static void spear_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
 	seq_printf(s, " " DRIVER_NAME);
 }
 
-int spear_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
-				 struct device_node *np_config,
-				 struct pinctrl_map **map, unsigned *num_maps)
+static int spear_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+					struct device_node *np_config,
+					struct pinctrl_map **map,
+					unsigned *num_maps)
 {
 	struct spear_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
 	struct device_node *np;
@@ -168,8 +169,9 @@ int spear_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-void spear_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
-		struct pinctrl_map *map, unsigned num_maps)
+static void spear_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
+				      struct pinctrl_map *map,
+				      unsigned num_maps)
 {
 	kfree(map);
 }
-- 
1.7.9.5



