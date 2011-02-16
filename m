Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab1BPBXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:23:52 -0500
Received: from kroah.org ([198.145.64.141]:45154 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721Ab1BPAr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:47:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:00 2011
Message-Id: <20110216002059.941297107@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Edgar Hucek <gimli@dark-green.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [patch 009/176] hwmon: (applesmc) Add MacBookAir3,1(3,2) support
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Edgar Hucek <gimli@dark-green.com>

commit 132af03233b493101a53010383b5abb5b9ff1e51 upstream.

This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
applesmc driver.

[rydberg@euromail.se: minor cleanup]
Cc: stable@kernel.org
Signed-off-by: Edgar Hucek <gimli@dark-green.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -162,6 +162,10 @@ static const char *temperature_sensors_s
 /* Set 22: MacBook Pro 7,1 */
 	{ "TB0T", "TB1T", "TB2T", "TC0D", "TC0P", "TN0D", "TN0P", "TN0S",
 	  "TN1D", "TN1F", "TN1G", "TN1S", "Th1H", "Ts0P", "Ts0S", NULL },
+/* Set 23: MacBook Air 3,1 */
+	{ "TB0T", "TB1T", "TB2T", "TC0D", "TC0E", "TC0P", "TC1E", "TCZ3",
+	  "TCZ4", "TCZ5", "TG0E", "TG1E", "TG2E", "TGZ3", "TGZ4", "TGZ5",
+	  "TH0F", "TH0O", "TM0P" },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1524,11 +1528,17 @@ static __initdata struct dmi_match_data
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


