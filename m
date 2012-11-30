Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030219Ab2K3L6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:58:21 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39579 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2K3L6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:58:10 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/12] ab8500_bm: Make the battery Device Tree node reference less cryptic
Date: Fri, 30 Nov 2012 11:57:34 +0000
Message-Id: <1354276654-590-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's rename the Device Tree node which contains information about
an attached battery to something more easily readable.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_bmdata.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index 6b772e5..0bf5236 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -457,18 +457,18 @@ int __devinit ab8500_bm_of_probe(struct device *dev,
 				 struct abx500_bm_data *bm)
 {
 	struct batres_vs_temp *tmp_batres_tbl;
-	struct device_node *np_bat_supply;
+	struct device_node *battery_node;
 	const char *btech;
 	int i;
 
 	/* get phandle to 'battery-info' node */
-	np_bat_supply = of_parse_phandle(np, "battery", 0);
-	if (!np_bat_supply) {
+	battery_node = of_parse_phandle(np, "battery", 0);
+	if (!battery_node) {
 		dev_err(dev, "battery node or reference missing\n");
 		return -EINVAL;
 	}
 
-	btech = of_get_property(np_bat_supply, "stericsson,battery-type", NULL);
+	btech = of_get_property(battery_node, "stericsson,battery-type", NULL);
 	if (!btech) {
 		dev_warn(dev, "missing property battery-name/type\n");
 		return -EINVAL;
@@ -484,7 +484,7 @@ int __devinit ab8500_bm_of_probe(struct device *dev,
 		bm->bat_type[BATTERY_UNKNOWN].normal_vol_lvl     = 4200;
 	}
 
-	if (of_property_read_bool(np_bat_supply, "thermistor-on-batctrl")) {
+	if (of_property_read_bool(battery_node, "thermistor-on-batctrl")) {
 		if (strncmp(btech, "LION", 4) == 0)
 			tmp_batres_tbl = temp_to_batres_tbl_9100;
 		else
@@ -500,7 +500,7 @@ int __devinit ab8500_bm_of_probe(struct device *dev,
 	for (i = 0; i < bm->n_btypes; ++i)
 		bm->bat_type[i].batres_tbl = tmp_batres_tbl;
 
-	of_node_put(np_bat_supply);
+	of_node_put(battery_node);
 
 	return 0;
 }
-- 
1.7.9.5

