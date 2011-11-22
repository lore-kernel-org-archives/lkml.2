Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab1KVJDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:03:22 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:62061 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1KVJCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:02:55 -0500
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <jj_ding@emc.com.tw>, JJ Ding <dgdunix@gmail.com>
Subject: [PATCH TRIVIAL 2/5] Input: misc: use macro module_platform_driver()
Date: Tue, 22 Nov 2011 17:00:43 +0800
Message-Id: <1321952446-7591-3-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.8-rc2
In-Reply-To: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JJ Ding <dgdunix@gmail.com>

Commit 940ab88962bc1aff3273a8356d64577a6e386736 introduced a new macro to
save some platform_driver boilerplate code. Use it.

Signed-off-by: JJ Ding <dgdunix@gmail.com>
---
 drivers/input/misc/88pm860x_onkey.c    |   13 +------------
 drivers/input/misc/ab8500-ponkey.c     |   13 +------------
 drivers/input/misc/bfin_rotary.c       |   13 +------------
 drivers/input/misc/cobalt_btns.c       |   14 +-------------
 drivers/input/misc/dm355evm_keys.c     |   13 +------------
 drivers/input/misc/ixp4xx-beeper.c     |   13 +------------
 drivers/input/misc/max8925_onkey.c     |   13 +------------
 drivers/input/misc/pcap_keys.c         |   14 +-------------
 drivers/input/misc/pcf50633-input.c    |   13 +------------
 drivers/input/misc/pcspkr.c            |   14 +-------------
 drivers/input/misc/pm8xxx-vibrator.c   |   13 +------------
 drivers/input/misc/pmic8xxx-pwrkey.c   |   13 +------------
 drivers/input/misc/pwm-beeper.c        |   13 +------------
 drivers/input/misc/rb532_button.c      |   14 +-------------
 drivers/input/misc/rotary_encoder.c    |   14 +-------------
 drivers/input/misc/sgi_btns.c          |   13 +------------
 drivers/input/misc/twl4030-pwrbutton.c |   15 ++-------------
 drivers/input/misc/twl4030-vibra.c     |   14 +-------------
 drivers/input/misc/twl6040-vibra.c     |   13 +------------
 drivers/input/misc/wm831x-on.c         |   13 +------------
 20 files changed, 21 insertions(+), 247 deletions(-)

diff --git a/drivers/input/misc/88pm860x_onkey.c b/drivers/input/misc/88pm860x_onkey.c
index 3dca3c1..f2e0cbc 100644
--- a/drivers/input/misc/88pm860x_onkey.c
+++ b/drivers/input/misc/88pm860x_onkey.c
@@ -137,18 +137,7 @@ static struct platform_driver pm860x_onkey_driver = {
 	.probe		= pm860x_onkey_probe,
 	.remove		= __devexit_p(pm860x_onkey_remove),
 };
-
-static int __init pm860x_onkey_init(void)
-{
-	return platform_driver_register(&pm860x_onkey_driver);
-}
-module_init(pm860x_onkey_init);
-
-static void __exit pm860x_onkey_exit(void)
-{
-	platform_driver_unregister(&pm860x_onkey_driver);
-}
-module_exit(pm860x_onkey_exit);
+module_platform_driver(pm860x_onkey_driver);
 
 MODULE_DESCRIPTION("Marvell 88PM860x ONKEY driver");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
index 3d3288a..79d9016 100644
--- a/drivers/input/misc/ab8500-ponkey.c
+++ b/drivers/input/misc/ab8500-ponkey.c
@@ -139,18 +139,7 @@ static struct platform_driver ab8500_ponkey_driver = {
 	.probe		= ab8500_ponkey_probe,
 	.remove		= __devexit_p(ab8500_ponkey_remove),
 };
-
-static int __init ab8500_ponkey_init(void)
-{
-	return platform_driver_register(&ab8500_ponkey_driver);
-}
-module_init(ab8500_ponkey_init);
-
-static void __exit ab8500_ponkey_exit(void)
-{
-	platform_driver_unregister(&ab8500_ponkey_driver);
-}
-module_exit(ab8500_ponkey_exit);
+module_platform_driver(ab8500_ponkey_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Sundar Iyer <sundar.iyer@stericsson.com>");
diff --git a/drivers/input/misc/bfin_rotary.c b/drivers/input/misc/bfin_rotary.c
index d00edc9..1c4146f 100644
--- a/drivers/input/misc/bfin_rotary.c
+++ b/drivers/input/misc/bfin_rotary.c
@@ -264,18 +264,7 @@ static struct platform_driver bfin_rotary_device_driver = {
 #endif
 	},
 };
-
-static int __init bfin_rotary_init(void)
-{
-	return platform_driver_register(&bfin_rotary_device_driver);
-}
-module_init(bfin_rotary_init);
-
-static void __exit bfin_rotary_exit(void)
-{
-	platform_driver_unregister(&bfin_rotary_device_driver);
-}
-module_exit(bfin_rotary_exit);
+module_platform_driver(bfin_rotary_device_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
diff --git a/drivers/input/misc/cobalt_btns.c b/drivers/input/misc/cobalt_btns.c
index fd8407a..53e43d2 100644
--- a/drivers/input/misc/cobalt_btns.c
+++ b/drivers/input/misc/cobalt_btns.c
@@ -163,16 +163,4 @@ static struct platform_driver cobalt_buttons_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init cobalt_buttons_init(void)
-{
-	return platform_driver_register(&cobalt_buttons_driver);
-}
-
-static void __exit cobalt_buttons_exit(void)
-{
-	platform_driver_unregister(&cobalt_buttons_driver);
-}
-
-module_init(cobalt_buttons_init);
-module_exit(cobalt_buttons_exit);
+module_platform_driver(cobalt_buttons_driver);
diff --git a/drivers/input/misc/dm355evm_keys.c b/drivers/input/misc/dm355evm_keys.c
index 7283dd2..35083c6 100644
--- a/drivers/input/misc/dm355evm_keys.c
+++ b/drivers/input/misc/dm355evm_keys.c
@@ -267,17 +267,6 @@ static struct platform_driver dm355evm_keys_driver = {
 		.name	= "dm355evm_keys",
 	},
 };
-
-static int __init dm355evm_keys_init(void)
-{
-	return platform_driver_register(&dm355evm_keys_driver);
-}
-module_init(dm355evm_keys_init);
-
-static void __exit dm355evm_keys_exit(void)
-{
-	platform_driver_unregister(&dm355evm_keys_driver);
-}
-module_exit(dm355evm_keys_exit);
+module_platform_driver(dm355evm_keys_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/input/misc/ixp4xx-beeper.c b/drivers/input/misc/ixp4xx-beeper.c
index 302ab46..50e2830 100644
--- a/drivers/input/misc/ixp4xx-beeper.c
+++ b/drivers/input/misc/ixp4xx-beeper.c
@@ -168,16 +168,5 @@ static struct platform_driver ixp4xx_spkr_platform_driver = {
 	.remove		= __devexit_p(ixp4xx_spkr_remove),
 	.shutdown	= ixp4xx_spkr_shutdown,
 };
+module_platform_driver(ixp4xx_spkr_platform_driver);
 
-static int __init ixp4xx_spkr_init(void)
-{
-	return platform_driver_register(&ixp4xx_spkr_platform_driver);
-}
-
-static void __exit ixp4xx_spkr_exit(void)
-{
-	platform_driver_unregister(&ixp4xx_spkr_platform_driver);
-}
-
-module_init(ixp4xx_spkr_init);
-module_exit(ixp4xx_spkr_exit);
diff --git a/drivers/input/misc/max8925_onkey.c b/drivers/input/misc/max8925_onkey.c
index 7de0ded..23cf082 100644
--- a/drivers/input/misc/max8925_onkey.c
+++ b/drivers/input/misc/max8925_onkey.c
@@ -166,18 +166,7 @@ static struct platform_driver max8925_onkey_driver = {
 	.probe		= max8925_onkey_probe,
 	.remove		= __devexit_p(max8925_onkey_remove),
 };
-
-static int __init max8925_onkey_init(void)
-{
-	return platform_driver_register(&max8925_onkey_driver);
-}
-module_init(max8925_onkey_init);
-
-static void __exit max8925_onkey_exit(void)
-{
-	platform_driver_unregister(&max8925_onkey_driver);
-}
-module_exit(max8925_onkey_exit);
+module_platform_driver(max8925_onkey_driver);
 
 MODULE_DESCRIPTION("Maxim MAX8925 ONKEY driver");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff --git a/drivers/input/misc/pcap_keys.c b/drivers/input/misc/pcap_keys.c
index 99335c2..e09b4fe 100644
--- a/drivers/input/misc/pcap_keys.c
+++ b/drivers/input/misc/pcap_keys.c
@@ -125,19 +125,7 @@ static struct platform_driver pcap_keys_device_driver = {
 		.owner	= THIS_MODULE,
 	}
 };
-
-static int __init pcap_keys_init(void)
-{
-	return platform_driver_register(&pcap_keys_device_driver);
-};
-
-static void __exit pcap_keys_exit(void)
-{
-	platform_driver_unregister(&pcap_keys_device_driver);
-};
-
-module_init(pcap_keys_init);
-module_exit(pcap_keys_exit);
+module_platform_driver(pcap_keys_device_driver);
 
 MODULE_DESCRIPTION("Motorola PCAP2 input events driver");
 MODULE_AUTHOR("Ilya Petrov <ilya.muromec@gmail.com>");
diff --git a/drivers/input/misc/pcf50633-input.c b/drivers/input/misc/pcf50633-input.c
index 9556273..53891de 100644
--- a/drivers/input/misc/pcf50633-input.c
+++ b/drivers/input/misc/pcf50633-input.c
@@ -113,18 +113,7 @@ static struct platform_driver pcf50633_input_driver = {
 	.probe = pcf50633_input_probe,
 	.remove = __devexit_p(pcf50633_input_remove),
 };
-
-static int __init pcf50633_input_init(void)
-{
-	return platform_driver_register(&pcf50633_input_driver);
-}
-module_init(pcf50633_input_init);
-
-static void __exit pcf50633_input_exit(void)
-{
-	platform_driver_unregister(&pcf50633_input_driver);
-}
-module_exit(pcf50633_input_exit);
+module_platform_driver(pcf50633_input_driver);
 
 MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
 MODULE_DESCRIPTION("PCF50633 input driver");
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index 34f4d2e..b2484aa 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -134,17 +134,5 @@ static struct platform_driver pcspkr_platform_driver = {
 	.remove		= __devexit_p(pcspkr_remove),
 	.shutdown	= pcspkr_shutdown,
 };
+module_platform_driver(pcspkr_platform_driver);
 
-
-static int __init pcspkr_init(void)
-{
-	return platform_driver_register(&pcspkr_platform_driver);
-}
-
-static void __exit pcspkr_exit(void)
-{
-	platform_driver_unregister(&pcspkr_platform_driver);
-}
-
-module_init(pcspkr_init);
-module_exit(pcspkr_exit);
diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
index 4319293..dfbfb46 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -277,18 +277,7 @@ static struct platform_driver pm8xxx_vib_driver = {
 		.pm	= &pm8xxx_vib_pm_ops,
 	},
 };
-
-static int __init pm8xxx_vib_init(void)
-{
-	return platform_driver_register(&pm8xxx_vib_driver);
-}
-module_init(pm8xxx_vib_init);
-
-static void __exit pm8xxx_vib_exit(void)
-{
-	platform_driver_unregister(&pm8xxx_vib_driver);
-}
-module_exit(pm8xxx_vib_exit);
+module_platform_driver(pm8xxx_vib_driver);
 
 MODULE_ALIAS("platform:pm8xxx_vib");
 MODULE_DESCRIPTION("PMIC8xxx vibrator driver based on ff-memless framework");
diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index b3cfb9c..0f83d0f 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -213,18 +213,7 @@ static struct platform_driver pmic8xxx_pwrkey_driver = {
 		.pm	= &pm8xxx_pwr_key_pm_ops,
 	},
 };
-
-static int __init pmic8xxx_pwrkey_init(void)
-{
-	return platform_driver_register(&pmic8xxx_pwrkey_driver);
-}
-module_init(pmic8xxx_pwrkey_init);
-
-static void __exit pmic8xxx_pwrkey_exit(void)
-{
-	platform_driver_unregister(&pmic8xxx_pwrkey_driver);
-}
-module_exit(pmic8xxx_pwrkey_exit);
+module_platform_driver(pmic8xxx_pwrkey_driver);
 
 MODULE_ALIAS("platform:pmic8xxx_pwrkey");
 MODULE_DESCRIPTION("PMIC8XXX Power Key driver");
diff --git a/drivers/input/misc/pwm-beeper.c b/drivers/input/misc/pwm-beeper.c
index 57c294f..fc84c8a 100644
--- a/drivers/input/misc/pwm-beeper.c
+++ b/drivers/input/misc/pwm-beeper.c
@@ -180,18 +180,7 @@ static struct platform_driver pwm_beeper_driver = {
 		.pm	= PWM_BEEPER_PM_OPS,
 	},
 };
-
-static int __init pwm_beeper_init(void)
-{
-	return platform_driver_register(&pwm_beeper_driver);
-}
-module_init(pwm_beeper_init);
-
-static void __exit pwm_beeper_exit(void)
-{
-	platform_driver_unregister(&pwm_beeper_driver);
-}
-module_exit(pwm_beeper_exit);
+module_platform_driver(pwm_beeper_driver);
 
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_DESCRIPTION("PWM beeper driver");
diff --git a/drivers/input/misc/rb532_button.c b/drivers/input/misc/rb532_button.c
index e2c7f62..aeb02bc 100644
--- a/drivers/input/misc/rb532_button.c
+++ b/drivers/input/misc/rb532_button.c
@@ -100,19 +100,7 @@ static struct platform_driver rb532_button_driver = {
 		.owner = THIS_MODULE,
 	},
 };
-
-static int __init rb532_button_init(void)
-{
-	return platform_driver_register(&rb532_button_driver);
-}
-
-static void __exit rb532_button_exit(void)
-{
-	platform_driver_unregister(&rb532_button_driver);
-}
-
-module_init(rb532_button_init);
-module_exit(rb532_button_exit);
+module_platform_driver(rb532_button_driver);
 
 MODULE_AUTHOR("Phil Sutter <n0-1@freewrt.org>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/input/misc/rotary_encoder.c b/drivers/input/misc/rotary_encoder.c
index 2be2169..f07f784 100644
--- a/drivers/input/misc/rotary_encoder.c
+++ b/drivers/input/misc/rotary_encoder.c
@@ -284,19 +284,7 @@ static struct platform_driver rotary_encoder_driver = {
 		.owner	= THIS_MODULE,
 	}
 };
-
-static int __init rotary_encoder_init(void)
-{
-	return platform_driver_register(&rotary_encoder_driver);
-}
-
-static void __exit rotary_encoder_exit(void)
-{
-	platform_driver_unregister(&rotary_encoder_driver);
-}
-
-module_init(rotary_encoder_init);
-module_exit(rotary_encoder_exit);
+module_platform_driver(rotary_encoder_driver);
 
 MODULE_ALIAS("platform:" DRV_NAME);
 MODULE_DESCRIPTION("GPIO rotary encoder driver");
diff --git a/drivers/input/misc/sgi_btns.c b/drivers/input/misc/sgi_btns.c
index 1a80c0d..5d9fd55 100644
--- a/drivers/input/misc/sgi_btns.c
+++ b/drivers/input/misc/sgi_btns.c
@@ -164,17 +164,6 @@ static struct platform_driver sgi_buttons_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init sgi_buttons_init(void)
-{
-	return platform_driver_register(&sgi_buttons_driver);
-}
-
-static void __exit sgi_buttons_exit(void)
-{
-	platform_driver_unregister(&sgi_buttons_driver);
-}
+module_platform_driver(sgi_buttons_driver);
 
 MODULE_LICENSE("GPL");
-module_init(sgi_buttons_init);
-module_exit(sgi_buttons_exit);
diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index 38e4b50..19a6882 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -107,25 +107,14 @@ static int __exit twl4030_pwrbutton_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver twl4030_pwrbutton_driver = {
+	.probe		= twl4030_pwrbutton_probe,
 	.remove		= __exit_p(twl4030_pwrbutton_remove),
 	.driver		= {
 		.name	= "twl4030_pwrbutton",
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init twl4030_pwrbutton_init(void)
-{
-	return platform_driver_probe(&twl4030_pwrbutton_driver,
-			twl4030_pwrbutton_probe);
-}
-module_init(twl4030_pwrbutton_init);
-
-static void __exit twl4030_pwrbutton_exit(void)
-{
-	platform_driver_unregister(&twl4030_pwrbutton_driver);
-}
-module_exit(twl4030_pwrbutton_exit);
+module_platform_driver(twl4030_pwrbutton_driver);
 
 MODULE_ALIAS("platform:twl4030_pwrbutton");
 MODULE_DESCRIPTION("Triton2 Power Button");
diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index 3c1a432..3765137 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -278,21 +278,9 @@ static struct platform_driver twl4030_vibra_driver = {
 #endif
 	},
 };
-
-static int __init twl4030_vibra_init(void)
-{
-	return platform_driver_register(&twl4030_vibra_driver);
-}
-module_init(twl4030_vibra_init);
-
-static void __exit twl4030_vibra_exit(void)
-{
-	platform_driver_unregister(&twl4030_vibra_driver);
-}
-module_exit(twl4030_vibra_exit);
+module_platform_driver(twl4030_vibra_driver);
 
 MODULE_ALIAS("platform:twl4030-vibra");
-
 MODULE_DESCRIPTION("TWL4030 Vibra driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Nokia Corporation");
diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index ad153a4..45874fe 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -410,18 +410,7 @@ static struct platform_driver twl6040_vibra_driver = {
 		.pm	= &twl6040_vibra_pm_ops,
 	},
 };
-
-static int __init twl6040_vibra_init(void)
-{
-	return platform_driver_register(&twl6040_vibra_driver);
-}
-module_init(twl6040_vibra_init);
-
-static void __exit twl6040_vibra_exit(void)
-{
-	platform_driver_unregister(&twl6040_vibra_driver);
-}
-module_exit(twl6040_vibra_exit);
+module_platform_driver(twl6040_vibra_driver);
 
 MODULE_ALIAS("platform:twl6040-vibra");
 MODULE_DESCRIPTION("TWL6040 Vibra driver");
diff --git a/drivers/input/misc/wm831x-on.c b/drivers/input/misc/wm831x-on.c
index c3d7ba5..47f18d6 100644
--- a/drivers/input/misc/wm831x-on.c
+++ b/drivers/input/misc/wm831x-on.c
@@ -145,18 +145,7 @@ static struct platform_driver wm831x_on_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init wm831x_on_init(void)
-{
-	return platform_driver_register(&wm831x_on_driver);
-}
-module_init(wm831x_on_init);
-
-static void __exit wm831x_on_exit(void)
-{
-	platform_driver_unregister(&wm831x_on_driver);
-}
-module_exit(wm831x_on_exit);
+module_platform_driver(wm831x_on_driver);
 
 MODULE_ALIAS("platform:wm831x-on");
 MODULE_DESCRIPTION("WM831x ON pin");
-- 
1.7.8-rc2

