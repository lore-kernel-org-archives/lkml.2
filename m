Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab1ANPPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:15:19 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47698 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab1ANPPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:15:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=N6+MbH0k4MQgk/DxRoZGlctyoODgf8l6YZPxuik4Rr9HkGrY7vR7ga2KwO7XD56vLU
         QzQVC6RsuIJ/lPMkd6ehynLl/XXi1i4Bl+qChI6G809+cfSVP7SnjN1NAN/Y+6EAv0aC
         Csex0h0wS5S08Qq1xUjp3HBXoiewPo7Pzi64g=
Date: Fri, 14 Jan 2011 18:15:07 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grazvydas Ignotas <notasas@gmail.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH] Add MAX17042 Fuel Gauge Driver - Initial Release
Message-ID: <20110114151507.GA30831@oksana.dev.rtsoft.ru>
References: <1294983971-17140-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1294983971-17140-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 02:46:11PM +0900, MyungJoo Ham wrote:
> The MAX17042 is a fuel gauge with an I2C interface for lithium-ion
> betteries. Unlike its predecessor MAX17040, MAX17042 uses 16bit
> registers. Besides, MAX17042 has much more features than MAX17040; e.g.,
> a thermistor, current and current accumulation measurement, battery
> internal resistance estimate, average values of measurement, and others.
> 
> This patch implements a driver for MAX17042.
> In this initial release, we have implemented the most basic features of
> a fuel gauge: measure the battery capacity and voltage.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Thanks for the patch!

Applied to battery-2.6.git, with some changes.

[...]
> +static const struct i2c_device_id max17042_id[] = {
> +	{ "max17042", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, max17040_id);

Should be max17042_id, otherwise build breaks when enabled as a module:

drivers/power/max17042_battery.c:214: error: ‘__mod_i2c_device_table’ aliased to undefined symbol ‘max17040_id’

Also a few small cosmetic changes were made. Here is the whole
diff:

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 6e6eeab..c5c8805 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -1,5 +1,5 @@
 /*
- * max17042_battery.c - Fuel gauge driver for Maxim 17042 / 8966 / 8997
+ * Fuel gauge driver for Maxim 17042 / 8966 / 8997
  *  Note that Maxim 8966 and 8997 are mfd and this is its subdevice.
  *
  * Copyright (C) 2011 Samsung Electronics
@@ -22,8 +22,10 @@
  * This driver is based on max17040_battery.c
  */
 
+#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/mod_devicetable.h>
 #include <linux/power_supply.h>
 #include <linux/power/max17042_battery.h>
 
@@ -209,8 +211,7 @@ static const struct i2c_device_id max17042_id[] = {
 	{ "max17042", 0 },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, max17040_id);
-
+MODULE_DEVICE_TABLE(i2c, max17042_id);
 
 static struct i2c_driver max17042_i2c_driver = {
 	.driver	= {
diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
index 4cc533f..7995deb 100644
--- a/include/linux/power/max17042_battery.h
+++ b/include/linux/power/max17042_battery.h
@@ -1,5 +1,5 @@
 /*
- * max17042_battery.h - Fuel gauge driver for Maxim 17042 / 8966 / 8997
+ * Fuel gauge driver for Maxim 17042 / 8966 / 8997
  *  Note that Maxim 8966 and 8997 are mfd and this is its subdevice.
  *
  * Copyright (C) 2011 Samsung Electronics
