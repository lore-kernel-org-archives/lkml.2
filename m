Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145Ab2CMAdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:33:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:48753 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122Ab2CMAYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 129/196] hwmon: (applesmc) Add support for MacBook Pro 5,3 and 5,4
Date: Mon, 12 Mar 2012 20:20:42 -0400
Message-Id: <1331598109-31424-84-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Rydberg <rydberg@euromail.se>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4e4a99d32721800c061191027f18f780dcbd9e0b upstream.

The MacBookPro 5,3 model has two fans, whereas the 5,4 model has
only one. This patch adds explicit support for the 5,3 and 5,4 models.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/applesmc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index f085c18..be33094 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -148,6 +148,13 @@ static const char *temperature_sensors_sets[][41] = {
 /* Set 18: MacBook Pro 2,2 */
 	{ "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "TM0P", "TTF0",
 	  "Th0H", "Th1H", "Tm0P", "Ts0P", NULL },
+/* Set 19: Macbook Pro 5,3 */
+	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TG0D",
+	  "TG0F", "TG0H", "TG0P", "TG0T", "TN0D", "TN0P", "TTF0", "Th2H",
+	  "Tm0P", "Ts0P", "Ts0S", NULL },
+/* Set 20: MacBook Pro 5,4 */
+	{ "TB0T", "TB1T", "TB2T", "TB3T", "TC0D", "TC0F", "TC0P", "TN0D",
+	  "TN0P", "TTF0", "Th2H", "Ts0P", "Ts0S", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1363,6 +1370,10 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 0, .light = 0, .temperature_set = 17 },
 /* MacBook Pro 2,2: accelerometer, backlight and temperature set 18 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 18 },
+/* MacBook Pro 5,3: accelerometer, backlight and temperature set 19 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 19 },
+/* MacBook Pro 5,4: accelerometer, backlight and temperature set 20 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 20 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1376,6 +1387,14 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
 		&applesmc_dmi_data[7]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 5,4", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,4") },
+		&applesmc_dmi_data[20]},
+	{ applesmc_dmi_match, "Apple MacBook Pro 5,3", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,3") },
+		&applesmc_dmi_data[19]},
 	{ applesmc_dmi_match, "Apple MacBook Pro 5", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5") },
-- 
1.7.9.3

