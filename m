Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2JGX00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:26:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38702 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690Ab2JGXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:28 -0400
Message-Id: <20121007225838.175286411@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <linux@roeck-us.net>,
        Paul Thomas <pthomas8589@gmail.com>, Jean Delvare <khali@linux-fr.org>
Subject: [ 025/108] hwmon: (ads7871) Add name sysfs attribute
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 4e21f4eaa49f78d3e977e316514c941053871c76 upstream.

The 'name' sysfs attribute is mandatory for hwmon devices, but was missing
in this driver.

Cc: Paul Thomas <pthomas8589@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Paul Thomas <pthomas8589@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/ads7871.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
index e65c6e4..7bf4ce3 100644
--- a/drivers/hwmon/ads7871.c
+++ b/drivers/hwmon/ads7871.c
@@ -139,6 +139,12 @@ static ssize_t show_voltage(struct device *dev,
 	}
 }
 
+static ssize_t ads7871_show_name(struct device *dev,
+				 struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "%s\n", to_spi_device(dev)->modalias);
+}
+
 static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, show_voltage, NULL, 0);
 static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, show_voltage, NULL, 1);
 static SENSOR_DEVICE_ATTR(in2_input, S_IRUGO, show_voltage, NULL, 2);
@@ -148,6 +154,8 @@ static SENSOR_DEVICE_ATTR(in5_input, S_IRUGO, show_voltage, NULL, 5);
 static SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, show_voltage, NULL, 6);
 static SENSOR_DEVICE_ATTR(in7_input, S_IRUGO, show_voltage, NULL, 7);
 
+static DEVICE_ATTR(name, S_IRUGO, ads7871_show_name, NULL);
+
 static struct attribute *ads7871_attributes[] = {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
 	&sensor_dev_attr_in1_input.dev_attr.attr,
@@ -157,6 +165,7 @@ static struct attribute *ads7871_attributes[] = {
 	&sensor_dev_attr_in5_input.dev_attr.attr,
 	&sensor_dev_attr_in6_input.dev_attr.attr,
 	&sensor_dev_attr_in7_input.dev_attr.attr,
+	&dev_attr_name.attr,
 	NULL
 };
 


