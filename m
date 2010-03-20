Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0CTOOL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:14:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59043 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab0CTOOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:14:06 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>, Jean Delvare <khali@linux-fr.org>,
       Corentin Labbe <corentin.labbe@geomatys.fr>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Juerg Haefliger <juergh@gmail.com>, Riku Voipio <riku.voipio@iki.fi>,
       "Hans J. Koch" <hjk@linutronix.de>, Marc Hulsman <m.hulsman@tudelft.nl>,
       Rudolf Marek <r.marek@assembler.cz>, lm-sensors@lm-sensors.org
Date: Sat, 20 Mar 2010 15:12:46 +0100
Message-Id: <1269094385-16114-6-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 05/24] hwmon: fix dangling pointers
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix I2C-drivers which missed setting clientdata to NULL before freeing the
structure it points to. Also fix drivers which do this _after_ the structure
was freed already.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Corentin Labbe <corentin.labbe@geomatys.fr>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Juerg Haefliger <juergh@gmail.com>
Cc: Riku Voipio <riku.voipio@iki.fi>
Cc: "Hans J. Koch" <hjk@linutronix.de>
Cc: Marc Hulsman <m.hulsman@tudelft.nl>
Cc: Rudolf Marek <r.marek@assembler.cz>
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/hwmon/ad7414.c     |    2 ++
 drivers/hwmon/ad7418.c     |    2 ++
 drivers/hwmon/adm1021.c    |    2 ++
 drivers/hwmon/adm1025.c    |    2 ++
 drivers/hwmon/adm1026.c    |    2 ++
 drivers/hwmon/adm1029.c    |    2 ++
 drivers/hwmon/adm1031.c    |    2 ++
 drivers/hwmon/adm9240.c    |    2 ++
 drivers/hwmon/ads7828.c    |    5 ++++-
 drivers/hwmon/adt7462.c    |    2 ++
 drivers/hwmon/adt7470.c    |    2 ++
 drivers/hwmon/adt7475.c    |    2 ++
 drivers/hwmon/amc6821.c    |    2 ++
 drivers/hwmon/asb100.c     |    2 ++
 drivers/hwmon/atxp1.c      |    2 ++
 drivers/hwmon/dme1737.c    |    2 ++
 drivers/hwmon/ds1621.c     |    2 ++
 drivers/hwmon/f75375s.c    |    4 ++--
 drivers/hwmon/g760a.c      |    4 ++--
 drivers/hwmon/gl518sm.c    |    2 ++
 drivers/hwmon/gl520sm.c    |    2 ++
 drivers/hwmon/lm63.c       |    2 ++
 drivers/hwmon/lm77.c       |    2 ++
 drivers/hwmon/lm78.c       |    2 ++
 drivers/hwmon/lm80.c       |    2 ++
 drivers/hwmon/lm83.c       |    2 ++
 drivers/hwmon/lm85.c       |    2 ++
 drivers/hwmon/lm87.c       |    2 ++
 drivers/hwmon/lm90.c       |    2 ++
 drivers/hwmon/lm92.c       |    2 ++
 drivers/hwmon/lm93.c       |    2 ++
 drivers/hwmon/lm95241.c    |    1 +
 drivers/hwmon/ltc4215.c    |    2 ++
 drivers/hwmon/ltc4245.c    |    2 ++
 drivers/hwmon/max1619.c    |    2 ++
 drivers/hwmon/max6650.c    |    2 ++
 drivers/hwmon/pcf8591.c    |    6 +++++-
 drivers/hwmon/smsc47m192.c |    2 ++
 drivers/hwmon/thmc50.c     |    2 ++
 drivers/hwmon/tmp401.c     |    1 +
 drivers/hwmon/w83791d.c    |    2 ++
 drivers/hwmon/w83792d.c    |    2 ++
 drivers/hwmon/w83793.c     |    1 +
 drivers/hwmon/w83l785ts.c  |    2 ++
 drivers/hwmon/w83l786ng.c  |    2 ++
 45 files changed, 92 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
index bfda8c8..0cfae01 100644
--- a/drivers/hwmon/ad7414.c
+++ b/drivers/hwmon/ad7414.c
@@ -220,6 +220,7 @@ static int ad7414_probe(struct i2c_client *client,
 exit_remove:
 	sysfs_remove_group(&client->dev.kobj, &ad7414_group);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -231,6 +232,7 @@ static int __devexit ad7414_remove(struct i2c_client *client)
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &ad7414_group);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/ad7418.c b/drivers/hwmon/ad7418.c
index f97b5b3..bc2b16f 100644
--- a/drivers/hwmon/ad7418.c
+++ b/drivers/hwmon/ad7418.c
@@ -283,6 +283,7 @@ static int ad7418_probe(struct i2c_client *client,
 exit_remove:
 	sysfs_remove_group(&client->dev.kobj, &data->attrs);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -293,6 +294,7 @@ static int ad7418_remove(struct i2c_client *client)
 	struct ad7418_data *data = i2c_get_clientdata(client);
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &data->attrs);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index 1ad0a88..af04bef 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -375,6 +375,7 @@ static int adm1021_probe(struct i2c_client *client,
 error3:
 	sysfs_remove_group(&client->dev.kobj, &adm1021_group);
 error1:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 error0:
 	return err;
@@ -396,6 +397,7 @@ static int adm1021_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm1021_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/adm1025.c b/drivers/hwmon/adm1025.c
index 251b631..778067a 100644
--- a/drivers/hwmon/adm1025.c
+++ b/drivers/hwmon/adm1025.c
@@ -485,6 +485,7 @@ exit_remove:
 	sysfs_remove_group(&client->dev.kobj, &adm1025_group);
 	sysfs_remove_group(&client->dev.kobj, &adm1025_group_in4);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -540,6 +541,7 @@ static int adm1025_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &adm1025_group);
 	sysfs_remove_group(&client->dev.kobj, &adm1025_group_in4);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
index 65335b2..6a45c72 100644
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -1743,6 +1743,7 @@ exitremove:
 	else
 		sysfs_remove_group(&client->dev.kobj, &adm1026_group_temp3);
 exitfree:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -1757,6 +1758,7 @@ static int adm1026_remove(struct i2c_client *client)
 		sysfs_remove_group(&client->dev.kobj, &adm1026_group_in8_9);
 	else
 		sysfs_remove_group(&client->dev.kobj, &adm1026_group_temp3);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/adm1029.c b/drivers/hwmon/adm1029.c
index 0b8a3b1..54dec88 100644
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -369,6 +369,7 @@ static int adm1029_probe(struct i2c_client *client,
  exit_remove_files:
 	sysfs_remove_group(&client->dev.kobj, &adm1029_group);
  exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
  exit:
 	return err;
@@ -398,6 +399,7 @@ static int adm1029_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm1029_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 1644b92..dad192f 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -880,6 +880,7 @@ exit_remove:
 	sysfs_remove_group(&client->dev.kobj, &adm1031_group);
 	sysfs_remove_group(&client->dev.kobj, &adm1031_group_opt);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -892,6 +893,7 @@ static int adm1031_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm1031_group);
 	sysfs_remove_group(&client->dev.kobj, &adm1031_group_opt);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/adm9240.c b/drivers/hwmon/adm9240.c
index 0727ad2..bf409ee 100644
--- a/drivers/hwmon/adm9240.c
+++ b/drivers/hwmon/adm9240.c
@@ -620,6 +620,7 @@ static int adm9240_probe(struct i2c_client *new_client,
 exit_remove:
 	sysfs_remove_group(&new_client->dev.kobj, &adm9240_group);
 exit_free:
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -632,6 +633,7 @@ static int adm9240_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm9240_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index aac85f3..5b84256 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -158,9 +158,11 @@ static const struct attribute_group ads7828_group = {
 static int ads7828_remove(struct i2c_client *client)
 {
 	struct ads7828_data *data = i2c_get_clientdata(client);
+
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &ads7828_group);
-	kfree(i2c_get_clientdata(client));
+	i2c_set_clientdata(client, NULL);
+	kfree(data);
 	return 0;
 }
 
@@ -247,6 +249,7 @@ static int ads7828_probe(struct i2c_client *client,
 exit_remove:
 	sysfs_remove_group(&client->dev.kobj, &ads7828_group);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index b8156b4..6b44d7e 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -1959,6 +1959,7 @@ static int adt7462_probe(struct i2c_client *client,
 exit_remove:
 	sysfs_remove_group(&client->dev.kobj, &data->attrs);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -1970,6 +1971,7 @@ static int adt7462_remove(struct i2c_client *client)
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &data->attrs);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 3445ce1..d106d0d 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -1295,6 +1295,7 @@ exit_unregister:
 exit_remove:
 	sysfs_remove_group(&client->dev.kobj, &data->attrs);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -1308,6 +1309,7 @@ static int adt7470_remove(struct i2c_client *client)
 	wait_for_completion(&data->auto_update_stop);
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &data->attrs);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index a0c3851..e2bfbf9 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -1388,6 +1388,7 @@ static int adt7475_probe(struct i2c_client *client,
 eremove:
 	adt7475_remove_files(client, data);
 efree:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return ret;
 }
@@ -1398,6 +1399,7 @@ static int adt7475_remove(struct i2c_client *client)
 
 	hwmon_device_unregister(data->hwmon_dev);
 	adt7475_remove_files(client, data);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index fa9708c..3403613 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -889,6 +889,7 @@ static int amc6821_probe(
 	dev_err(&client->dev, "error registering hwmon device.\n");
 	sysfs_remove_group(&client->dev.kobj, &amc6821_attr_grp);
 err_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return err;
 }
@@ -900,6 +901,7 @@ static int amc6821_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &amc6821_attr_grp);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/asb100.c b/drivers/hwmon/asb100.c
index 7dada55..18d879a 100644
--- a/drivers/hwmon/asb100.c
+++ b/drivers/hwmon/asb100.c
@@ -784,6 +784,7 @@ ERROR3:
 	i2c_unregister_device(data->lm75[1]);
 	i2c_unregister_device(data->lm75[0]);
 ERROR1:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 ERROR0:
 	return err;
@@ -799,6 +800,7 @@ static int asb100_remove(struct i2c_client *client)
 	i2c_unregister_device(data->lm75[1]);
 	i2c_unregister_device(data->lm75[0]);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/atxp1.c b/drivers/hwmon/atxp1.c
index 94cadc1..9672280 100644
--- a/drivers/hwmon/atxp1.c
+++ b/drivers/hwmon/atxp1.c
@@ -349,6 +349,7 @@ static int atxp1_probe(struct i2c_client *new_client,
 exit_remove_files:
 	sysfs_remove_group(&new_client->dev.kobj, &atxp1_group);
 exit_free:
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -361,6 +362,7 @@ static int atxp1_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &atxp1_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/dme1737.c b/drivers/hwmon/dme1737.c
index 823dd28..070ccf8 100644
--- a/drivers/hwmon/dme1737.c
+++ b/drivers/hwmon/dme1737.c
@@ -2282,6 +2282,7 @@ static int dme1737_i2c_probe(struct i2c_client *client,
 exit_remove:
 	dme1737_remove_files(dev);
 exit_kfree:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -2294,6 +2295,7 @@ static int dme1737_i2c_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	dme1737_remove_files(&client->dev);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/ds1621.c b/drivers/hwmon/ds1621.c
index e113634..e88e50f 100644
--- a/drivers/hwmon/ds1621.c
+++ b/drivers/hwmon/ds1621.c
@@ -286,6 +286,7 @@ static int ds1621_probe(struct i2c_client *client,
       exit_remove_files:
 	sysfs_remove_group(&client->dev.kobj, &ds1621_group);
       exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
       exit:
 	return err;
@@ -298,6 +299,7 @@ static int ds1621_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &ds1621_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 277398f..9a720a3 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -660,8 +660,8 @@ static int f75375_probe(struct i2c_client *client,
 exit_remove:
 	sysfs_remove_group(&client->dev.kobj, &f75375_group);
 exit_free:
-	kfree(data);
 	i2c_set_clientdata(client, NULL);
+	kfree(data);
 	return err;
 }
 
@@ -670,8 +670,8 @@ static int f75375_remove(struct i2c_client *client)
 	struct f75375_data *data = i2c_get_clientdata(client);
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &f75375_group);
-	kfree(data);
 	i2c_set_clientdata(client, NULL);
+	kfree(data);
 	return 0;
 }
 
diff --git a/drivers/hwmon/g760a.c b/drivers/hwmon/g760a.c
index 09ea12e..5adfdf8 100644
--- a/drivers/hwmon/g760a.c
+++ b/drivers/hwmon/g760a.c
@@ -235,8 +235,8 @@ static int g760a_probe(struct i2c_client *client,
 error_hwmon_device_register:
 	sysfs_remove_group(&client->dev.kobj, &g760a_group);
 error_sysfs_create_group:
-	kfree(data);
 	i2c_set_clientdata(client, NULL);
+	kfree(data);
 
 	return err;
 }
@@ -246,8 +246,8 @@ static int g760a_remove(struct i2c_client *client)
 	struct g760a_data *data = i2c_get_clientdata(client);
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &g760a_group);
-	kfree(data);
 	i2c_set_clientdata(client, NULL);
+	kfree(data);
 
 	return 0;
 }
diff --git a/drivers/hwmon/gl518sm.c b/drivers/hwmon/gl518sm.c
index e7ae574..e76aac2 100644
--- a/drivers/hwmon/gl518sm.c
+++ b/drivers/hwmon/gl518sm.c
@@ -548,6 +548,7 @@ exit_remove_files:
 	if (data->type == gl518sm_r80)
 		sysfs_remove_group(&client->dev.kobj, &gl518_group_r80);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -581,6 +582,7 @@ static int gl518_remove(struct i2c_client *client)
 	if (data->type == gl518sm_r80)
 		sysfs_remove_group(&client->dev.kobj, &gl518_group_r80);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/gl520sm.c b/drivers/hwmon/gl520sm.c
index ec58802..efaa0d5 100644
--- a/drivers/hwmon/gl520sm.c
+++ b/drivers/hwmon/gl520sm.c
@@ -759,6 +759,7 @@ exit_remove_files:
 	sysfs_remove_group(&client->dev.kobj, &gl520_group);
 	sysfs_remove_group(&client->dev.kobj, &gl520_group_opt);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -811,6 +812,7 @@ static int gl520_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &gl520_group);
 	sysfs_remove_group(&client->dev.kobj, &gl520_group_opt);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
index bf81aff..ea6ffe4 100644
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -496,6 +496,7 @@ exit_remove_files:
 	sysfs_remove_group(&new_client->dev.kobj, &lm63_group);
 	sysfs_remove_group(&new_client->dev.kobj, &lm63_group_fan1);
 exit_free:
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -544,6 +545,7 @@ static int lm63_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &lm63_group);
 	sysfs_remove_group(&client->dev.kobj, &lm63_group_fan1);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/lm77.c b/drivers/hwmon/lm77.c
index b28a297..3eae81f 100644
--- a/drivers/hwmon/lm77.c
+++ b/drivers/hwmon/lm77.c
@@ -344,6 +344,7 @@ static int lm77_probe(struct i2c_client *new_client,
 exit_remove:
 	sysfs_remove_group(&new_client->dev.kobj, &lm77_group);
 exit_free:
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -354,6 +355,7 @@ static int lm77_remove(struct i2c_client *client)
 	struct lm77_data *data = i2c_get_clientdata(client);
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm77_group);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index 72ff2c4..9e37d03 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -646,6 +646,7 @@ static int lm78_i2c_probe(struct i2c_client *client,
 ERROR4:
 	sysfs_remove_group(&client->dev.kobj, &lm78_group);
 ERROR3:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return err;
 }
@@ -656,6 +657,7 @@ static int lm78_i2c_remove(struct i2c_client *client)
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm78_group);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c
index 18a0e6c..5e2fa4f 100644
--- a/drivers/hwmon/lm80.c
+++ b/drivers/hwmon/lm80.c
@@ -504,6 +504,7 @@ static int lm80_probe(struct i2c_client *client,
 error_remove:
 	sysfs_remove_group(&client->dev.kobj, &lm80_group);
 error_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -516,6 +517,7 @@ static int lm80_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm80_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/lm83.c b/drivers/hwmon/lm83.c
index 8290476..918e558 100644
--- a/drivers/hwmon/lm83.c
+++ b/drivers/hwmon/lm83.c
@@ -376,6 +376,7 @@ exit_remove_files:
 	sysfs_remove_group(&new_client->dev.kobj, &lm83_group);
 	sysfs_remove_group(&new_client->dev.kobj, &lm83_group_opt);
 exit_free:
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -389,6 +390,7 @@ static int lm83_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &lm83_group);
 	sysfs_remove_group(&client->dev.kobj, &lm83_group_opt);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index b3841a6..e5b90c4 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -1308,6 +1308,7 @@ static int lm85_probe(struct i2c_client *client,
 	if (data->type == emc6d100)
 		sysfs_remove_group(&client->dev.kobj, &lm85_group_in567);
  err_kfree:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return err;
 }
@@ -1320,6 +1321,7 @@ static int lm85_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &lm85_group_in4);
 	if (data->type == emc6d100)
 		sysfs_remove_group(&client->dev.kobj, &lm85_group_in567);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/lm87.c b/drivers/hwmon/lm87.c
index f1e6e75..e699b28 100644
--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -824,6 +824,7 @@ exit_remove:
 	sysfs_remove_group(&new_client->dev.kobj, &lm87_group_opt);
 exit_free:
 	lm87_write_value(new_client, LM87_REG_CONFIG, data->config);
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -880,6 +881,7 @@ static int lm87_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &lm87_group_opt);
 
 	lm87_write_value(client, LM87_REG_CONFIG, data->config);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 7cc2708..d5db33b 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -851,6 +851,7 @@ exit_remove_files:
 	sysfs_remove_group(&new_client->dev.kobj, &lm90_group);
 	device_remove_file(&new_client->dev, &dev_attr_pec);
 exit_free:
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -907,6 +908,7 @@ static int lm90_remove(struct i2c_client *client)
 	i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
 				  data->config_orig);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/lm92.c b/drivers/hwmon/lm92.c
index 7c31e62..b5cbc15 100644
--- a/drivers/hwmon/lm92.c
+++ b/drivers/hwmon/lm92.c
@@ -376,6 +376,7 @@ static int lm92_probe(struct i2c_client *new_client,
 exit_remove:
 	sysfs_remove_group(&new_client->dev.kobj, &lm92_group);
 exit_free:
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -388,6 +389,7 @@ static int lm92_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm92_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
index 6669255..e3b06b6 100644
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -2584,6 +2584,7 @@ static int lm93_probe(struct i2c_client *client,
 	dev_err(&client->dev, "error registering hwmon device.\n");
 	sysfs_remove_group(&client->dev.kobj, &lm93_attr_grp);
 err_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 err_out:
 	return err;
@@ -2596,6 +2597,7 @@ static int lm93_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm93_attr_grp);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/lm95241.c b/drivers/hwmon/lm95241.c
index 8fc8eb8..f83fa36 100644
--- a/drivers/hwmon/lm95241.c
+++ b/drivers/hwmon/lm95241.c
@@ -367,6 +367,7 @@ static int lm95241_probe(struct i2c_client *new_client,
 exit_remove_files:
 	sysfs_remove_group(&new_client->dev.kobj, &lm95241_group);
 exit_free:
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
diff --git a/drivers/hwmon/ltc4215.c b/drivers/hwmon/ltc4215.c
index 00d975e..c9bcf0c 100644
--- a/drivers/hwmon/ltc4215.c
+++ b/drivers/hwmon/ltc4215.c
@@ -276,6 +276,7 @@ static int ltc4215_probe(struct i2c_client *client,
 out_hwmon_device_register:
 	sysfs_remove_group(&client->dev.kobj, &ltc4215_group);
 out_sysfs_create_group:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 out_kzalloc:
 	return ret;
@@ -288,6 +289,7 @@ static int ltc4215_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &ltc4215_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/ltc4245.c b/drivers/hwmon/ltc4245.c
index 65c232a..24cb172 100644
--- a/drivers/hwmon/ltc4245.c
+++ b/drivers/hwmon/ltc4245.c
@@ -396,6 +396,7 @@ static int ltc4245_probe(struct i2c_client *client,
 out_hwmon_device_register:
 	sysfs_remove_group(&client->dev.kobj, &ltc4245_group);
 out_sysfs_create_group:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 out_kzalloc:
 	return ret;
@@ -408,6 +409,7 @@ static int ltc4245_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &ltc4245_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/max1619.c b/drivers/hwmon/max1619.c
index 022ded0..08cc0e8 100644
--- a/drivers/hwmon/max1619.c
+++ b/drivers/hwmon/max1619.c
@@ -289,6 +289,7 @@ static int max1619_probe(struct i2c_client *new_client,
 exit_remove_files:
 	sysfs_remove_group(&new_client->dev.kobj, &max1619_group);
 exit_free:
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -316,6 +317,7 @@ static int max1619_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &max1619_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index a0160ee..e341ad4 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -590,6 +590,7 @@ static int max6650_probe(struct i2c_client *client,
 	dev_err(&client->dev, "error registering hwmon device.\n");
 	sysfs_remove_group(&client->dev.kobj, &max6650_attr_grp);
 err_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return err;
 }
@@ -600,6 +601,7 @@ static int max6650_remove(struct i2c_client *client)
 
 	sysfs_remove_group(&client->dev.kobj, &max6650_attr_grp);
 	hwmon_device_unregister(data->hwmon_dev);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/pcf8591.c b/drivers/hwmon/pcf8591.c
index d447879..ceec56b 100644
--- a/drivers/hwmon/pcf8591.c
+++ b/drivers/hwmon/pcf8591.c
@@ -227,6 +227,7 @@ exit_sysfs_remove:
 	sysfs_remove_group(&client->dev.kobj, &pcf8591_attr_group_opt);
 	sysfs_remove_group(&client->dev.kobj, &pcf8591_attr_group);
 exit_kfree:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -234,9 +235,12 @@ exit:
 
 static int pcf8591_remove(struct i2c_client *client)
 {
+	struct pcf8591_data *data = i2c_get_clientdata(client);
+
 	sysfs_remove_group(&client->dev.kobj, &pcf8591_attr_group_opt);
 	sysfs_remove_group(&client->dev.kobj, &pcf8591_attr_group);
-	kfree(i2c_get_clientdata(client));
+	i2c_set_clientdata(client, NULL);
+	kfree(data);
 	return 0;
 }
 
diff --git a/drivers/hwmon/smsc47m192.c b/drivers/hwmon/smsc47m192.c
index 40b2667..565b68d 100644
--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -555,6 +555,7 @@ exit_remove_files:
 	sysfs_remove_group(&client->dev.kobj, &smsc47m192_group);
 	sysfs_remove_group(&client->dev.kobj, &smsc47m192_group_in4);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -568,6 +569,7 @@ static int smsc47m192_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &smsc47m192_group);
 	sysfs_remove_group(&client->dev.kobj, &smsc47m192_group_in4);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/thmc50.c b/drivers/hwmon/thmc50.c
index 7dfb4de..240a393 100644
--- a/drivers/hwmon/thmc50.c
+++ b/drivers/hwmon/thmc50.c
@@ -384,6 +384,7 @@ exit_remove_sysfs:
 exit_remove_sysfs_thmc50:
 	sysfs_remove_group(&client->dev.kobj, &thmc50_group);
 exit_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -398,6 +399,7 @@ static int thmc50_remove(struct i2c_client *client)
 	if (data->has_temp3)
 		sysfs_remove_group(&client->dev.kobj, &temp3_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index d14a1af..8df3a1c 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -598,6 +598,7 @@ static int tmp401_remove(struct i2c_client *client)
 					   &tmp411_attr[i].dev_attr);
 	}
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index 400a88b..3cf5980 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -1371,6 +1371,7 @@ error3:
 	if (data->lm75[1] != NULL)
 		i2c_unregister_device(data->lm75[1]);
 error1:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 error0:
 	return err;
@@ -1388,6 +1389,7 @@ static int w83791d_remove(struct i2c_client *client)
 	if (data->lm75[1] != NULL)
 		i2c_unregister_device(data->lm75[1]);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/w83792d.c b/drivers/hwmon/w83792d.c
index 679718e..bbf0a00 100644
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -1382,6 +1382,7 @@ ERROR3:
 	if (data->lm75[1] != NULL)
 		i2c_unregister_device(data->lm75[1]);
 ERROR1:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 ERROR0:
 	return err;
@@ -1404,6 +1405,7 @@ w83792d_remove(struct i2c_client *client)
 	if (data->lm75[1] != NULL)
 		i2c_unregister_device(data->lm75[1]);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index 9de81a4..94ef5ab 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -1884,6 +1884,7 @@ exit_remove:
 	if (data->lm75[1] != NULL)
 		i2c_unregister_device(data->lm75[1]);
 free_mem:
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
diff --git a/drivers/hwmon/w83l785ts.c b/drivers/hwmon/w83l785ts.c
index 20781de..fa73868 100644
--- a/drivers/hwmon/w83l785ts.c
+++ b/drivers/hwmon/w83l785ts.c
@@ -225,6 +225,7 @@ exit_remove:
 			   &sensor_dev_attr_temp1_input.dev_attr);
 	device_remove_file(&new_client->dev,
 			   &sensor_dev_attr_temp1_max.dev_attr);
+	i2c_set_clientdata(new_client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -240,6 +241,7 @@ static int w83l785ts_remove(struct i2c_client *client)
 	device_remove_file(&client->dev,
 			   &sensor_dev_attr_temp1_max.dev_attr);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/hwmon/w83l786ng.c b/drivers/hwmon/w83l786ng.c
index 0254e18..217ed0c 100644
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -667,6 +667,7 @@ w83l786ng_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 exit_remove:
 	sysfs_remove_group(&client->dev.kobj, &w83l786ng_group);
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 exit:
 	return err;
@@ -680,6 +681,7 @@ w83l786ng_remove(struct i2c_client *client)
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &w83l786ng_group);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
-- 
1.7.0

