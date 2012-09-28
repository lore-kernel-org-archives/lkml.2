Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032567Ab2I1VBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:01:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59167 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033004Ab2I1Urq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:47:46 -0400
X-Sasl-enc: YbpDkiUwszp6w5boU944Bd0WmjTn/MSYKw8cIdGq2XI/ 1348865265
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paul Thomas <pthomas8589@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Subject: [ 052/127] hwmon: (ads7871) Add name sysfs attribute
Date: Fri, 28 Sep 2012 13:33:45 -0700
Message-Id: <20120928203051.894511720@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 4e21f4eaa49f78d3e977e316514c941053871c76 upstream.

The 'name' sysfs attribute is mandatory for hwmon devices, but was missing
in this driver.

Cc: Paul Thomas <pthomas8589@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Paul Thomas <pthomas8589@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/ads7871.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/hwmon/ads7871.c
+++ b/drivers/hwmon/ads7871.c
@@ -133,6 +133,12 @@ static ssize_t show_voltage(struct devic
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
@@ -142,6 +148,8 @@ static SENSOR_DEVICE_ATTR(in5_input, S_I
 static SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, show_voltage, NULL, 6);
 static SENSOR_DEVICE_ATTR(in7_input, S_IRUGO, show_voltage, NULL, 7);
 
+static DEVICE_ATTR(name, S_IRUGO, ads7871_show_name, NULL);
+
 static struct attribute *ads7871_attributes[] = {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
 	&sensor_dev_attr_in1_input.dev_attr.attr,
@@ -151,6 +159,7 @@ static struct attribute *ads7871_attribu
 	&sensor_dev_attr_in5_input.dev_attr.attr,
 	&sensor_dev_attr_in6_input.dev_attr.attr,
 	&sensor_dev_attr_in7_input.dev_attr.attr,
+	&dev_attr_name.attr,
 	NULL
 };
 


