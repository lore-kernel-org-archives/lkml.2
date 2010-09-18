Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab0IRTUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:20:52 -0400
Received: from kroah.org ([198.145.64.141]:43848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab0IRTQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:16 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:06 2010
Message-Id: <20100918191306.413249366@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yong Wang <yong.y.wang@intel.com>, Jean Delvare <khali@linux-fr.org>
Subject: [106/129] hwmon: (emc1403) Remove unnecessary hwmon_device_unregister
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yong Wang <yong.y.wang@linux.intel.com>

commit f17c811d1433aa1966f9c5a744841427e9a97ecf upstream.

It is unnecessary and wrong to call hwmon_device_unregister in error
handling before hwmon_device_register is called.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Reviewed-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/emc1403.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -275,7 +275,6 @@ static int emc1403_probe(struct i2c_clie
 	res = sysfs_create_group(&client->dev.kobj, &m_thermal_gr);
 	if (res) {
 		dev_warn(&client->dev, "create group failed\n");
-		hwmon_device_unregister(data->hwmon_dev);
 		goto thermal_error1;
 	}
 	data->hwmon_dev = hwmon_device_register(&client->dev);


