Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033009Ab2I1VmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:42:22 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48962 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032405Ab2I1U0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Keerthy <j-keerthy@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 078/218] hwmon: (twl4030-madc-hwmon) Initialize uninitialized structure elements
Date: Fri, 28 Sep 2012 13:14:55 -0700
Message-Id: <20120928201510.507458802@linuxfoundation.org>
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

commit 73d7c119255615a26070f9d6cdb722a166a29015 upstream.

twl4030_madc_conversion uses do_avg and type structure elements of
twl4030_madc_request. Initialize structure to avoid random operation.

Fix for: Coverity CID 200794 Uninitialized scalar variable.

Cc: Keerthy <j-keerthy@ti.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/twl4030-madc-hwmon.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/twl4030-madc-hwmon.c
+++ b/drivers/hwmon/twl4030-madc-hwmon.c
@@ -44,12 +44,13 @@ static ssize_t madc_read(struct device *
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


