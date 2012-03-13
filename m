Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965350Ab2CMAkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:40:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:48586 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab2CMAYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Edgar Hucek <gimli@dark-green.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 132/196] hwmon: (applesmc) Add MacBookAir3,1(3,2) support
Date: Mon, 12 Mar 2012 20:20:45 -0400
Message-Id: <1331598109-31424-87-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edgar Hucek <gimli@dark-green.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 132af03233b493101a53010383b5abb5b9ff1e51 upstream.

This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
applesmc driver.

[rydberg@euromail.se: minor cleanup]
Signed-off-by: Edgar Hucek <gimli@dark-green.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 57c0331..7765a6b 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -162,6 +162,10 @@ static const char *temperature_sensors_sets[][41] = {
 /* Set 22: MacBook Pro 7,1 */
 	{ "TB0T", "TB1T", "TB2T", "TC0D", "TC0P", "TN0D", "TN0P", "TN0S",
 	  "TN1D", "TN1F", "TN1G", "TN1S", "Th1H", "Ts0P", "Ts0S", NULL },
+/* Set 23: MacBook Air 3,1 */
+	{ "TB0T", "TB1T", "TB2T", "TC0D", "TC0E", "TC0P", "TC1E", "TCZ3",
+	  "TCZ4", "TCZ5", "TG0E", "TG1E", "TG2E", "TGZ3", "TGZ4", "TGZ5",
+	  "TH0F", "TH0O", "TM0P" },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1385,11 +1389,17 @@ static __initdata struct dmi_match_data applesmc_dmi_data[] = {
 	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
 /* MacBook Pro 7,1: accelerometer, backlight and temperature set 22 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 22 },
+/* MacBook Air 3,1: accelerometer, backlight and temperature set 23 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 23 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
  * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
 static __initdata struct dmi_system_id applesmc_whitelist[] = {
+	{ applesmc_dmi_match, "Apple MacBook Air 3", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3") },
+		&applesmc_dmi_data[23]},
 	{ applesmc_dmi_match, "Apple MacBook Air 2", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir2") },
-- 
1.7.9.3

