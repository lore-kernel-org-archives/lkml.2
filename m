Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab2IQBWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:22:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33565 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab2IQAuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:01 -0400
Message-Id: <20120917003643.489170104@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <linux@roeck-us.net>,
        Keerthy <j-keerthy@ti.com>, Jean Delvare <khali@linux-fr.org>
Subject: [ 125/135] hwmon: (twl4030-madc-hwmon) Initialize uninitialized structure
 elements
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 73d7c119255615a26070f9d6cdb722a166a29015 upstream.

twl4030_madc_conversion uses do_avg and type structure elements of
twl4030_madc_request. Initialize structure to avoid random operation.

Fix for: Coverity CID 200794 Uninitialized scalar variable.

Cc: Keerthy <j-keerthy@ti.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/twl4030-madc-hwmon.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/twl4030-madc-hwmon.c b/drivers/hwmon/twl4030-madc-hwmon.c
index 0018c7d..1a174f0 100644
--- a/drivers/hwmon/twl4030-madc-hwmon.c
+++ b/drivers/hwmon/twl4030-madc-hwmon.c
@@ -44,12 +44,13 @@ static ssize_t madc_read(struct device *dev,
 			 struct device_attribute *devattr, char *buf)
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	struct twl4030_madc_request req;
+	struct twl4030_madc_request req = {
+		.channels = 1 << attr->index,
+		.method = TWL4030_MADC_SW2,
+		.type = TWL4030_MADC_WAIT,
+	};
 	long val;
 
-	req.channels = (1 << attr->index);
-	req.method = TWL4030_MADC_SW2;
-	req.func_cb = NULL;
 	val = twl4030_madc_conversion(&req);
 	if (val < 0)
 		return val;


