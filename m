Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032432Ab2I1U0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:26:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032416Ab2I1U0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jonathan Cameron <jic23@cam.ac.uk>, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 087/218] hwmon: (ad7314) Add name sysfs attribute
Date: Fri, 28 Sep 2012 13:15:04 -0700
Message-Id: <20120928201511.573419358@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 3ceefe4319636d89d4bdf40dca9471970f942e4f upstream.

The 'name' sysfs attribute is mandatory for hwmon devices, but was missing
in this driver.

Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/ad7314.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/hwmon/ad7314.c
+++ b/drivers/hwmon/ad7314.c
@@ -94,10 +94,18 @@ static ssize_t ad7314_show_temperature(s
 	}
 }
 
+static ssize_t ad7314_show_name(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "%s\n", to_spi_device(dev)->modalias);
+}
+
+static DEVICE_ATTR(name, S_IRUGO, ad7314_show_name, NULL);
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
 			  ad7314_show_temperature, NULL, 0);
 
 static struct attribute *ad7314_attributes[] = {
+	&dev_attr_name.attr,
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
 	NULL,
 };


