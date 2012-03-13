Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab2CMAYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:48707 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965083Ab2CMAYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:32 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Bernhard Froemel <froemel@vmars.tuwien.ac.at>,
        Henrik Rydberg <rydberg@euromail.se>,
        Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 130/196] hwmon: (applesmc) Add generic support for MacBook Pro 6
Date: Mon, 12 Mar 2012 20:20:43 -0400
Message-Id: <1331598109-31424-85-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernhard Froemel <froemel@vmars.tuwien.ac.at>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 872bad55e2d3fcc13e1e8770a3b200f0c6ca5126 upstream.

This patch adds generic support for the MacBook Pro 6 family
based on the 6,2 model.

[rydberg@euromail.se: patch cleanup]
Signed-off-by: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jean Delvare <khali@linux-fr.org>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index be33094..ce41a43 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -155,6 +155,10 @@ static const char *temperature_sensors_sets[][41] = {
 /* Set 20: MacBook Pro 5,4 */
 	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TN0D",
 	  "TN0P", "TTF0", "Th2H", "Ts0P", "Ts0S", NULL },
+/* Set 21: MacBook Pro 6,2 */
+	{ "TB0T", "TB1T", "TB2T", "TC0C", "TC0D", "TC0P", "TC1C", "TG0D",
+	  "TG0P", "TG0T", "TMCD", "TP0P", "TPCD", "Th1H", "Th2H", "Tm0P",
+	  "Ts0P", "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1374,6 +1378,8 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 19 },
 /* MacBook Pro 5,4: accelerometer, backlight and temperature set 20 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 20 },
+/* MacBook Pro 6,2: accelerometer, backlight and temperature set 21 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1395,6 +1401,10 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,3") },
 		&applesmc_dmi_data[19]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 6", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro6") },
+		&applesmc_dmi_data[21]},
 	{ applesmc_dmi_match, "Apple MacBook Pro 5", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5") },
-- 
1.7.9.3

