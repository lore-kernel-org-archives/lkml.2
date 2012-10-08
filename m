Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2JHNAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:00:07 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63691 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2JHNAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:00:04 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 21:00:04 +0800
Message-ID: <CAPgLHd9GT2LPyujNJyHAxJf_94cJJKsLcqCRuuHn2h9yVGBK_A@mail.gmail.com>
Subject: [PATCH] powerpc/windfarm: use module_i2c_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: benh@kernel.crashing.org
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use the module_i2c_driver() macro to make the code smaller
and a bit simpler.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/macintosh/windfarm_smu_sat.c        | 13 +------------
 drivers/macintosh/windfarm_max6690_sensor.c | 13 +------------
 drivers/macintosh/windfarm_lm75_sensor.c    | 14 +-------------
 drivers/macintosh/windfarm_fcu_controls.c   | 14 +-------------
 4 files changed, 4 insertions(+), 50 deletions(-)

diff --git a/drivers/macintosh/windfarm_smu_sat.c b/drivers/macintosh/windfarm_smu_sat.c
index 426e810..d87f5ee 100644
--- a/drivers/macintosh/windfarm_smu_sat.c
+++ b/drivers/macintosh/windfarm_smu_sat.c
@@ -364,18 +364,7 @@ static struct i2c_driver wf_sat_driver = {
 	.id_table	= wf_sat_id,
 };
 
-static int __init sat_sensors_init(void)
-{
-	return i2c_add_driver(&wf_sat_driver);
-}
-
-static void __exit sat_sensors_exit(void)
-{
-	i2c_del_driver(&wf_sat_driver);
-}
-
-module_init(sat_sensors_init);
-module_exit(sat_sensors_exit);
+module_i2c_driver(wf_sat_driver);
 
 MODULE_AUTHOR("Paul Mackerras <paulus@samba.org>");
 MODULE_DESCRIPTION("SMU satellite sensors for PowerMac thermal control");

diff --git a/drivers/macintosh/windfarm_max6690_sensor.c b/drivers/macintosh/windfarm_max6690_sensor.c
index 371b058..945a25b 100644
--- a/drivers/macintosh/windfarm_max6690_sensor.c
+++ b/drivers/macintosh/windfarm_max6690_sensor.c
@@ -130,18 +130,7 @@ static struct i2c_driver wf_max6690_driver = {
 	.id_table	= wf_max6690_id,
 };
 
-static int __init wf_max6690_sensor_init(void)
-{
-	return i2c_add_driver(&wf_max6690_driver);
-}
-
-static void __exit wf_max6690_sensor_exit(void)
-{
-	i2c_del_driver(&wf_max6690_driver);
-}
-
-module_init(wf_max6690_sensor_init);
-module_exit(wf_max6690_sensor_exit);
+module_i2c_driver(wf_max6690_driver);
 
 MODULE_AUTHOR("Paul Mackerras <paulus@samba.org>");
 MODULE_DESCRIPTION("MAX6690 sensor objects for PowerMac thermal control");

diff --git a/drivers/macintosh/windfarm_lm75_sensor.c b/drivers/macintosh/windfarm_lm75_sensor.c
index b0c2d36..9ef32b3 100644
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -174,19 +174,7 @@ static struct i2c_driver wf_lm75_driver = {
 	.id_table	= wf_lm75_id,
 };
 
-static int __init wf_lm75_sensor_init(void)
-{
-	return i2c_add_driver(&wf_lm75_driver);
-}
-
-static void __exit wf_lm75_sensor_exit(void)
-{
-	i2c_del_driver(&wf_lm75_driver);
-}
-
-
-module_init(wf_lm75_sensor_init);
-module_exit(wf_lm75_sensor_exit);
+module_i2c_driver(wf_lm75_driver);
 
 MODULE_AUTHOR("Benjamin Herrenschmidt <benh@kernel.crashing.org>");
 MODULE_DESCRIPTION("LM75 sensor objects for PowerMacs thermal control");

diff --git a/drivers/macintosh/windfarm_fcu_controls.c b/drivers/macintosh/windfarm_fcu_controls.c
index b3411ed..fd6ed15 100644
--- a/drivers/macintosh/windfarm_fcu_controls.c
+++ b/drivers/macintosh/windfarm_fcu_controls.c
@@ -593,19 +593,7 @@ static struct i2c_driver wf_fcu_driver = {
 	.id_table	= wf_fcu_id,
 };
 
-static int __init wf_fcu_init(void)
-{
-	return i2c_add_driver(&wf_fcu_driver);
-}
-
-static void __exit wf_fcu_exit(void)
-{
-	i2c_del_driver(&wf_fcu_driver);
-}
-
-
-module_init(wf_fcu_init);
-module_exit(wf_fcu_exit);
+module_i2c_driver(wf_fcu_driver);
 
 MODULE_AUTHOR("Benjamin Herrenschmidt <benh@kernel.crashing.org>");
 MODULE_DESCRIPTION("FCU control objects for PowerMacs thermal control");

