Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0HWPG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:06:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40669 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab0HWPG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:06:58 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Mack <daniel@caiaq.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Hemanth V <hemanthv@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Paul Gortmaker <p_gortmaker@yahoo.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Jingchang Lu <b22599@freescale.com>,
        Mingkai Hu <Mingkai.hu@freescale.com>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: [PATCH] i2c: remove obsolete cleanup for clientdata
Date: Mon, 23 Aug 2010 17:05:08 +0200
Message-Id: <1282575908-16555-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit. This is obsolete meanwhile, so fix it and hope the word will spread.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---

Jean, I dunno if it fits for 2.6.36. It is not precisely a regression.
Though, if it enters with the next merge window, the next set of "faulty"
drivers may come in at the same time...

 drivers/misc/bh1780gli.c               |    1 -
 drivers/regulator/ad5398.c             |    1 -
 drivers/regulator/isl6271a-regulator.c |    2 --
 drivers/rtc/rtc-ds3232.c               |    2 --
 4 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index 714c6b4..d5f3a3f 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -190,7 +190,6 @@ static int __devexit bh1780_remove(struct i2c_client *client)
 
 	ddata = i2c_get_clientdata(client);
 	sysfs_remove_group(&client->dev.kobj, &bh1780_attr_group);
-	i2c_set_clientdata(client, NULL);
 	kfree(ddata);
 
 	return 0;
diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index d59d2f2..15ff61d 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -256,7 +256,6 @@ static int __devexit ad5398_remove(struct i2c_client *client)
 
 	regulator_unregister(&chip->rdev);
 	kfree(chip);
-	i2c_set_clientdata(client, NULL);
 
 	return 0;
 }
diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index e49d2bd..65ecd82 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -191,8 +191,6 @@ static int __devexit isl6271a_remove(struct i2c_client *i2c)
 	struct isl_pmic *pmic = i2c_get_clientdata(i2c);
 	int i;
 
-	i2c_set_clientdata(i2c, NULL);
-
 	for (i = 0; i < 3; i++)
 		regulator_unregister(pmic->rdev[i]);
 
diff --git a/drivers/rtc/rtc-ds3232.c b/drivers/rtc/rtc-ds3232.c
index 9daed8d..9de8516 100644
--- a/drivers/rtc/rtc-ds3232.c
+++ b/drivers/rtc/rtc-ds3232.c
@@ -268,7 +268,6 @@ out_irq:
 		free_irq(client->irq, client);
 
 out_free:
-	i2c_set_clientdata(client, NULL);
 	kfree(ds3232);
 	return ret;
 }
@@ -287,7 +286,6 @@ static int __devexit ds3232_remove(struct i2c_client *client)
 	}
 
 	rtc_device_unregister(ds3232->rtc);
-	i2c_set_clientdata(client, NULL);
 	kfree(ds3232);
 	return 0;
 }
-- 
1.7.1

