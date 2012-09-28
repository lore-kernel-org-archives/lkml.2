Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031165Ab2I1TpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:45:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965204Ab2I1S7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jonathan Cameron <jic23@cam.ac.uk>, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 111/262] hwmon: (ad7314) Add name sysfs attribute
Date: Fri, 28 Sep 2012 11:50:40 -0700
Message-Id: <20120928183011.271454580@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -87,10 +87,18 @@ static ssize_t ad7314_show_temperature(s
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


