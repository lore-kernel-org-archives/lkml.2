Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0IQNfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:35:37 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:33080 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751124Ab0IQNff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:35:35 -0400
Message-ID: <4C936EA5.2040506@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:35:33 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: i2c: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------030607040207030202050801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030607040207030202050801
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...
+ 1 attach for "next" branch.

I unsure in requrement of i2c modaliases, may be this bus undetectable, but I
not play with special tools with vendors exclude VIA.




--------------030607040207030202050801
Content-Type: text/plain;
 name="mods-i2c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-i2c.patch"

Fix lost I2C modaliases

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/drivers/staging/msm/hdmi_sii9022.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/msm/hdmi_sii9022.c	2010-09-17 12:39:01.682682707 +0300
@@ -239,6 +239,11 @@ static void __exit hdmi_sii_exit(void)
 	i2c_del_driver(&hdmi_sii_i2c_driver);
 }
 
+
+#ifdef CONFIG_I2C
+MODULE_DEVICE_TABLE(i2c, hmdi_sii_id);
+#endif
+
 module_init(hdmi_sii_init);
 module_exit(hdmi_sii_exit);
 MODULE_LICENSE("GPL v2");
--- linux-2.6.36-rc4-git3/drivers/hwmon/ad7414.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/hwmon/ad7414.c	2010-09-17 12:38:46.132572718 +0300
@@ -254,6 +254,9 @@ static int __init ad7414_init(void)
 {
 	return i2c_add_driver(&ad7414_driver);
 }
+
+MODULE_DEVICE_TABLE(i2c, ad7414_id);
+
 module_init(ad7414_init);
 
 static void __exit ad7414_exit(void)
--- linux-2.6.36-rc4-git3/drivers/hwmon/adt7411.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/hwmon/adt7411.c	2010-09-17 12:38:46.242609622 +0300
@@ -351,6 +351,9 @@ static int __init sensors_adt7411_init(v
 {
 	return i2c_add_driver(&adt7411_driver);
 }
+
+MODULE_DEVICE_TABLE(i2c, adt7411_id);
+
 module_init(sensors_adt7411_init)
 
 static void __exit sensors_adt7411_exit(void)
--- linux-2.6.36-rc4-git3/drivers/macintosh/windfarm_lm75_sensor.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/macintosh/windfarm_lm75_sensor.c	2010-09-17 12:38:50.385819714 +0300
@@ -249,6 +249,9 @@ static void __exit wf_lm75_sensor_exit(v
 }
 
 
+
+MODULE_DEVICE_TABLE(i2c, wf_lm75_id);
+
 module_init(wf_lm75_sensor_init);
 module_exit(wf_lm75_sensor_exit);
 
--- linux-2.6.36-rc4-git3/drivers/macintosh/windfarm_max6690_sensor.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/macintosh/windfarm_max6690_sensor.c	2010-09-17 12:38:50.449725150 +0300
@@ -199,6 +199,9 @@ static void __exit wf_max6690_sensor_exi
 	i2c_del_driver(&wf_max6690_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, wf_max6690_id);
+
 module_init(wf_max6690_sensor_init);
 module_exit(wf_max6690_sensor_exit);
 
--- linux-2.6.36-rc4-git3/drivers/macintosh/windfarm_smu_sat.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/macintosh/windfarm_smu_sat.c	2010-09-17 12:38:50.572504781 +0300
@@ -406,6 +406,9 @@ static void __exit sat_sensors_exit(void
 }
 #endif
 
+
+MODULE_DEVICE_TABLE(i2c, wf_sat_id);
+
 module_init(sat_sensors_init);
 /*module_exit(sat_sensors_exit); Uncomment when cleanup is implemented */
 
--- linux-2.6.36-rc4-git3/drivers/macintosh/therm_adt746x.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/macintosh/therm_adt746x.c	2010-09-17 12:38:50.762708501 +0300
@@ -692,5 +692,8 @@ thermostat_exit(void)
 	of_device_unregister(of_dev);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, therm_adt746x_id);
+
 module_init(thermostat_init);
 module_exit(thermostat_exit);
--- linux-2.6.36-rc4-git3/drivers/macintosh/therm_pm72.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/macintosh/therm_pm72.c	2010-09-17 12:38:50.922631361 +0300
@@ -2291,6 +2291,9 @@ static void __exit therm_pm72_exit(void)
 		of_device_unregister(of_dev);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, therm_pm72_id);
+
 module_init(therm_pm72_init);
 module_exit(therm_pm72_exit);
 
--- linux-2.6.36-rc4-git3/drivers/macintosh/therm_windtunnel.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/macintosh/therm_windtunnel.c	2010-09-17 12:38:51.079860513 +0300
@@ -522,6 +522,9 @@ g4fan_exit( void )
 		of_device_unregister( x.of_dev );
 }
 
+
+MODULE_DEVICE_TABLE(i2c, therm_windtunnel_id);
+
 module_init(g4fan_init);
 module_exit(g4fan_exit);
 
--- linux-2.6.36-rc4-git3/drivers/media/video/ir-kbd-i2c.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/media/video/ir-kbd-i2c.c	2010-09-17 12:38:51.782863117 +0300
@@ -507,6 +507,9 @@ static void __exit ir_fini(void)
 	i2c_del_driver(&driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, ir_kbd_id);
+
 module_init(ir_init);
 module_exit(ir_fini);
 
--- linux-2.6.36-rc4-git3/drivers/misc/eeprom/eeprom.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/misc/eeprom/eeprom.c	2010-09-17 12:38:52.622641652 +0300
@@ -246,5 +246,8 @@ MODULE_AUTHOR("Frodo Looijaard <frodol@d
 MODULE_DESCRIPTION("I2C EEPROM driver");
 MODULE_LICENSE("GPL");
 
+
+MODULE_DEVICE_TABLE(i2c, eeprom_id);
+
 module_init(eeprom_init);
 module_exit(eeprom_exit);
--- linux-2.6.36-rc4-git3/drivers/misc/eeprom/max6875.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/misc/eeprom/max6875.c	2010-09-17 12:38:52.812752203 +0300
@@ -223,5 +223,8 @@ MODULE_AUTHOR("Ben Gardner <bgardner@wab
 MODULE_DESCRIPTION("MAX6875 driver");
 MODULE_LICENSE("GPL");
 
+
+MODULE_DEVICE_TABLE(i2c, max6875_id);
+
 module_init(max6875_init);
 module_exit(max6875_exit);
--- linux-2.6.36-rc4-git3/drivers/misc/bh1780gli.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/misc/bh1780gli.c	2010-09-17 12:38:52.947320406 +0300
@@ -265,6 +265,9 @@ static void __exit bh1780_exit(void)
 	i2c_del_driver(&bh1780_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, bh1780_id);
+
 module_init(bh1780_init)
 module_exit(bh1780_exit)
 
--- linux-2.6.36-rc4-git3/drivers/misc/bmp085.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/misc/bmp085.c	2010-09-17 12:38:53.032585847 +0300
@@ -478,5 +478,8 @@ MODULE_AUTHOR("Christoph Mair <christoph
 MODULE_DESCRIPTION("BMP085 driver");
 MODULE_LICENSE("GPL");
 
+
+MODULE_DEVICE_TABLE(i2c, bmp085_id);
+
 module_init(bmp085_init);
 module_exit(bmp085_exit);
--- linux-2.6.36-rc4-git3/drivers/power/bq27x00_battery.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/power/bq27x00_battery.c	2010-09-17 12:38:56.472573087 +0300
@@ -458,6 +458,9 @@ static int __init bq27x00_battery_init(v
 
 	return ret;
 }
+
+MODULE_DEVICE_TABLE(i2c, bq27x00_id);
+
 module_init(bq27x00_battery_init);
 
 static void __exit bq27x00_battery_exit(void)
--- linux-2.6.36-rc4-git3/drivers/power/ds2782_battery.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/power/ds2782_battery.c	2010-09-17 12:38:56.559961282 +0300
@@ -407,6 +407,9 @@ static int __init ds278x_init(void)
 {
 	return i2c_add_driver(&ds278x_battery_driver);
 }
+
+MODULE_DEVICE_TABLE(i2c, ds278x_id);
+
 module_init(ds278x_init);
 
 static void __exit ds278x_exit(void)
--- linux-2.6.36-rc4-git3/drivers/power/z2_battery.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/power/z2_battery.c	2010-09-17 12:38:56.654297616 +0300
@@ -314,6 +314,9 @@ static void __exit z2_batt_exit(void)
 	i2c_del_driver(&z2_batt_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, z2_batt_id);
+
 module_init(z2_batt_init);
 module_exit(z2_batt_exit);
 
--- linux-2.6.36-rc4-git3/drivers/staging/go7007/wis-ov7640.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/go7007/wis-ov7640.c	2010-09-17 12:39:00.212790117 +0300
@@ -101,6 +101,9 @@ static void __exit wis_ov7640_cleanup(vo
 	i2c_del_driver(&wis_ov7640_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, wis_ov7640_id);
+
 module_init(wis_ov7640_init);
 module_exit(wis_ov7640_cleanup);
 
--- linux-2.6.36-rc4-git3/drivers/staging/go7007/wis-saa7113.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/go7007/wis-saa7113.c	2010-09-17 12:39:00.392589484 +0300
@@ -329,6 +329,9 @@ static void __exit wis_saa7113_cleanup(v
 	i2c_del_driver(&wis_saa7113_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, wis_saa7113_id);
+
 module_init(wis_saa7113_init);
 module_exit(wis_saa7113_cleanup);
 
--- linux-2.6.36-rc4-git3/drivers/staging/go7007/wis-saa7115.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/go7007/wis-saa7115.c	2010-09-17 12:39:00.562601875 +0300
@@ -462,6 +462,9 @@ static void __exit wis_saa7115_cleanup(v
 	i2c_del_driver(&wis_saa7115_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, wis_saa7115_id);
+
 module_init(wis_saa7115_init);
 module_exit(wis_saa7115_cleanup);
 
--- linux-2.6.36-rc4-git3/drivers/staging/go7007/wis-sony-tuner.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/go7007/wis-sony-tuner.c	2010-09-17 12:39:00.720208066 +0300
@@ -713,6 +713,9 @@ static void __exit wis_sony_tuner_cleanu
 	i2c_del_driver(&wis_sony_tuner_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, wis_sony_tuner_id);
+
 module_init(wis_sony_tuner_init);
 module_exit(wis_sony_tuner_cleanup);
 
--- linux-2.6.36-rc4-git3/drivers/staging/go7007/wis-tw2804.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/go7007/wis-tw2804.c	2010-09-17 12:39:00.912580904 +0300
@@ -352,6 +352,9 @@ static void __exit wis_tw2804_cleanup(vo
 	i2c_del_driver(&wis_tw2804_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, wis_tw2804_id);
+
 module_init(wis_tw2804_init);
 module_exit(wis_tw2804_cleanup);
 
--- linux-2.6.36-rc4-git3/drivers/staging/go7007/wis-tw9903.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/go7007/wis-tw9903.c	2010-09-17 12:39:01.062698246 +0300
@@ -334,6 +334,9 @@ static void __exit wis_tw9903_cleanup(vo
 	i2c_del_driver(&wis_tw9903_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, wis_tw9903_id);
+
 module_init(wis_tw9903_init);
 module_exit(wis_tw9903_cleanup);
 
--- linux-2.6.36-rc4-git3/drivers/staging/go7007/wis-uda1342.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/go7007/wis-uda1342.c	2010-09-17 12:39:01.162683389 +0300
@@ -107,6 +107,9 @@ static void __exit wis_uda1342_cleanup(v
 	i2c_del_driver(&wis_uda1342_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, wis_uda1342_id);
+
 module_init(wis_uda1342_init);
 module_exit(wis_uda1342_cleanup);
 
--- linux-2.6.36-rc4-git3/drivers/staging/iio/magnetometer/hmc5843.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/iio/magnetometer/hmc5843.c	2010-09-17 12:39:01.482693157 +0300
@@ -620,5 +620,8 @@ MODULE_AUTHOR("Shubhrajyoti Datta <shubh
 MODULE_DESCRIPTION("HMC5843 driver");
 MODULE_LICENSE("GPL");
 
+
+MODULE_DEVICE_TABLE(i2c, hmc5843_id);
+
 module_init(hmc5843_init);
 module_exit(hmc5843_exit);
--- linux-2.6.36-rc4-git3/drivers/staging/lirc/lirc_i2c.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/lirc/lirc_i2c.c	2010-09-17 12:39:02.503848414 +0300
@@ -532,5 +532,8 @@ MODULE_PARM_DESC(minor, "Preferred minor
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Enable debugging messages");
 
+
+MODULE_DEVICE_TABLE(i2c, ir_receiver_id);
+
 module_init(lirc_i2c_init);
 module_exit(lirc_i2c_exit);
--- linux-2.6.36-rc4-git3/drivers/staging/lirc/lirc_zilog.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/lirc/lirc_zilog.c	2010-09-17 12:39:02.802738200 +0300
@@ -1364,6 +1364,9 @@ static void __exit zilog_exit(void)
 	zilog_notify("Zilog/Hauppauge IR driver unloaded\n");
 }
 
+
+MODULE_DEVICE_TABLE(i2c, ir_transceiver_id);
+
 module_init(zilog_init);
 module_exit(zilog_exit);
 
--- linux-2.6.36-rc4-git3/drivers/video/backlight/tosa_bl.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/video/backlight/tosa_bl.c	2010-09-17 12:39:05.082917502 +0300
@@ -190,6 +190,9 @@ static void __exit tosa_bl_exit(void)
 	i2c_del_driver(&tosa_bl_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, tosa_bl_id);
+
 module_init(tosa_bl_init);
 module_exit(tosa_bl_exit);
 
--- linux-2.6.36-rc4-git3/drivers/w1/masters/ds2482.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/w1/masters/ds2482.c	2010-09-17 12:39:06.739051331 +0300
@@ -519,5 +519,8 @@ MODULE_AUTHOR("Ben Gardner <bgardner@wab
 MODULE_DESCRIPTION("DS2482 driver");
 MODULE_LICENSE("GPL");
 
+
+MODULE_DEVICE_TABLE(i2c, ds2482_id);
+
 module_init(sensors_ds2482_init);
 module_exit(sensors_ds2482_exit);
--- linux-2.6.36-rc4-git3/sound/aoa/codecs/onyx.c	2010-08-02 01:11:14.000000000 +0300
+++ b/sound/aoa/codecs/onyx.c	2010-09-17 12:39:07.536173671 +0300
@@ -1145,5 +1145,8 @@ static void __exit onyx_exit(void)
 	i2c_del_driver(&onyx_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, onyx_i2c_id);
+
 module_init(onyx_init);
 module_exit(onyx_exit);
--- linux-2.6.36-rc4-git3/sound/aoa/codecs/tas.c	2010-08-02 01:11:14.000000000 +0300
+++ b/sound/aoa/codecs/tas.c	2010-09-17 12:39:07.598641032 +0300
@@ -1036,5 +1036,8 @@ static void __exit tas_exit(void)
 	i2c_del_driver(&tas_driver);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, tas_i2c_id);
+
 module_init(tas_init);
 module_exit(tas_exit);
--- linux-2.6.36-rc4-git3/drivers/staging/msm/lcdc_st15.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/msm/lcdc_st15.c	2010-09-17 12:39:01.786455211 +0300
@@ -234,4 +234,9 @@ init_exit:
 	return ret;
 }
 
+
+#ifdef CONFIG_I2C
+MODULE_DEVICE_TABLE(i2c, hmdi_sii_id);
+#endif
+
 module_init(lcdc_st15_init);
--- linux-2.6.36-rc4-git3/drivers/staging/dream/camera/mt9d112.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/dream/camera/mt9d112.c	2010-09-17 12:38:59.252601864 +0300
@@ -759,4 +759,9 @@ static int __init mt9d112_init(void)
 	return platform_driver_register(&msm_camera_driver);
 }
 
+
+#ifdef CONFIG_I2C
+MODULE_DEVICE_TABLE(i2c, mt9d112_i2c_id);
+#endif
+
 module_init(mt9d112_init);
--- linux-2.6.36-rc4-git3/drivers/staging/dream/camera/mt9p012_fox.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/dream/camera/mt9p012_fox.c	2010-09-17 12:38:59.422719634 +0300
@@ -1303,4 +1303,9 @@ static int __init mt9p012_init(void)
 	return platform_driver_register(&msm_camera_driver);
 }
 
+
+#ifdef CONFIG_I2C
+MODULE_DEVICE_TABLE(i2c, mt9p012_i2c_id);
+#endif
+
 module_init(mt9p012_init);
--- linux-2.6.36-rc4-git3/drivers/staging/dream/camera/mt9t013.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/dream/camera/mt9t013.c	2010-09-17 12:38:59.522558641 +0300
@@ -1494,4 +1494,9 @@ static int __init mt9t013_init(void)
 	return platform_driver_register(&msm_camera_driver);
 }
 
+
+#ifdef CONFIG_I2C
+MODULE_DEVICE_TABLE(i2c, mt9t013_i2c_id);
+#endif
+
 module_init(mt9t013_init);
--- linux-2.6.36-rc4-git3/sound/soc/s3c24xx/neo1973_wm8753.c	2010-08-02 01:11:14.000000000 +0300
+++ b/sound/soc/s3c24xx/neo1973_wm8753.c	2010-09-17 12:39:07.917253497 +0300
@@ -698,6 +698,9 @@ static void __exit neo1973_exit(void)
 	platform_device_unregister(neo1973_snd_device);
 }
 
+
+MODULE_DEVICE_TABLE(i2c, lm4857_i2c_id);
+
 module_init(neo1973_init);
 module_exit(neo1973_exit);
 
--- linux-2.6.36-rc4-git3/drivers/rtc/rtc-ds1672.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/rtc/rtc-ds1672.c	2010-09-17 12:38:56.832687659 +0300
@@ -216,5 +216,10 @@ MODULE_DESCRIPTION("Dallas/Maxim DS1672
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
+
+#ifdef CONFIG_I2C
+MODULE_DEVICE_TABLE(i2c, ds1672_id);
+#endif
+
 module_init(ds1672_init);
 module_exit(ds1672_exit);
--- linux-2.6.36-rc4-git3/drivers/rtc/rtc-max6900.c	2010-09-17 12:30:30.000000000 +0300
+++ b/drivers/rtc/rtc-max6900.c	2010-09-17 12:38:57.140955566 +0300
@@ -276,5 +276,10 @@ MODULE_AUTHOR("Dale Farnsworth <dale@far
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
+
+#ifdef CONFIG_I2C
+MODULE_DEVICE_TABLE(i2c, max6900_id);
+#endif
+
 module_init(max6900_init);
 module_exit(max6900_exit);
--- linux-2.6.36-rc4-git3/drivers/staging/dream/camera/s5k3e2fx.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/dream/camera/s5k3e2fx.c	2010-09-17 12:38:59.655947071 +0300
@@ -1303,5 +1303,10 @@ static int __init s5k3e2fx_init(void)
 	return platform_driver_register(&msm_camera_driver);
 }
 
+
+#ifdef CONFIG_I2C
+MODULE_DEVICE_TABLE(i2c, s5k3e2fx_i2c_id);
+#endif
+
 module_init(s5k3e2fx_init);
 
--- linux-2.6.36-rc4-git3/drivers/staging/dream/synaptics_i2c_rmi.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/staging/dream/synaptics_i2c_rmi.c	2010-09-17 12:38:59.842848649 +0300
@@ -641,6 +641,11 @@ static void __exit synaptics_ts_exit(voi
 		destroy_workqueue(synaptics_wq);
 }
 
+
+#ifdef CONFIG_I2C
+MODULE_DEVICE_TABLE(i2c, synaptics_ts_id);
+#endif
+
 module_init(synaptics_ts_init);
 module_exit(synaptics_ts_exit);
 
--- linux-2.6.36-rc4-git3/sound/soc/codecs/tlv320dac33.c	2010-09-17 12:30:31.000000000 +0300
+++ b/sound/soc/codecs/tlv320dac33.c	2010-09-17 12:39:07.801200070 +0300
@@ -1712,6 +1712,9 @@ static int __init dac33_module_init(void
 	}
 	return 0;
 }
+
+MODULE_DEVICE_TABLE(i2c, tlv320dac33_i2c_id);
+
 module_init(dac33_module_init);
 
 static void __exit dac33_module_exit(void)

--------------030607040207030202050801
Content-Type: text/plain;
 name="mods-i2c-next.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods-i2c-next.patch"

Fix lost I2C modaliases (next)

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>


--- linux-2.6.36-rc4-next-20100917/drivers/power/bq20z75.c	2010-09-17 13:11:33.826802996 +0300
+++ b/drivers/power/bq20z75.c	2010-09-17 13:17:18.114340310 +0300
@@ -373,6 +373,11 @@ static int __init bq20z75_battery_init(v
 {
 	return i2c_add_driver(&bq20z75_battery_driver);
 }
+
+#ifdef CONFIG_I2C
+MODULE_DEVICE_TABLE(i2c, bq20z75_id);
+#endif
+
 module_init(bq20z75_battery_init);
 
 static void __exit bq20z75_battery_exit(void)

--------------030607040207030202050801--
