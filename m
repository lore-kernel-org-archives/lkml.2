Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2JGX07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:26:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38685 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754678Ab2JGXX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:27 -0400
Message-Id: <20121007225838.719240918@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <linux@roeck-us.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 029/108] hwmon: (ad7314) Add name sysfs attribute
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

commit 3ceefe4319636d89d4bdf40dca9471970f942e4f upstream.

The 'name' sysfs attribute is mandatory for hwmon devices, but was missing
in this driver.

Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/ad7314.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/ad7314.c b/drivers/hwmon/ad7314.c
index cfec802..f915eb1 100644
--- a/drivers/hwmon/ad7314.c
+++ b/drivers/hwmon/ad7314.c
@@ -87,10 +87,18 @@ static ssize_t ad7314_show_temperature(struct device *dev,
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


