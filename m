Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2JEI0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:26:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58393 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab2JEI0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:26:12 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/28] Documentation: leds: update LP55xx family devices
Thread-Topic: [PATCH 28/28] Documentation: leds: update LP55xx family devices
Thread-Index: Ac2i0wwwXGJtrdTcQPuRzvF7n930zQ==
Date: Fri, 5 Oct 2012 08:26:00 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176884@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Add leds-lp55xx.txt.
 Update the platform data information.
 For the LED patterns, detailed information is described in lp55xx document.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/leds/00-INDEX        |    2 +
 Documentation/leds/leds-lp5521.txt |   63 +++-------------------
 Documentation/leds/leds-lp5523.txt |   27 ++--------
 Documentation/leds/leds-lp55xx.txt |  104 ++++++++++++++++++++++++++++++++++++
 4 files changed, 118 insertions(+), 78 deletions(-)
 create mode 100644 Documentation/leds/leds-lp55xx.txt

diff --git a/Documentation/leds/00-INDEX b/Documentation/leds/00-INDEX
index 5fefe37..5246090 100644
--- a/Documentation/leds/00-INDEX
+++ b/Documentation/leds/00-INDEX
@@ -6,5 +6,7 @@ leds-lp5521.txt
 	- notes on how to use the leds-lp5521 driver.
 leds-lp5523.txt
 	- notes on how to use the leds-lp5523 driver.
+leds-lp55xx.txt
+	- description about lp55xx common driver.
 leds-lm3556.txt
 	- notes on how to use the leds-lm3556 driver.
diff --git a/Documentation/leds/leds-lp5521.txt b/Documentation/leds/leds-lp5521.txt
index 0e542ab..270f571 100644
--- a/Documentation/leds/leds-lp5521.txt
+++ b/Documentation/leds/leds-lp5521.txt
@@ -17,19 +17,8 @@ lp5521:channelx, where x is 0 .. 2
 All three channels can be also controlled using the engine micro programs.
 More details of the instructions can be found from the public data sheet.
 
-Control interface for the engines:
-x is 1 .. 3
-enginex_mode : disabled, load, run
-enginex_load : store program (visible only in engine load mode)
-
-Example (start to blink the channel 2 led):
-cd   /sys/class/leds/lp5521:channel2/device
-echo "load" > engine3_mode
-echo "037f4d0003ff6000" > engine3_load
-echo "run" > engine3_mode
-
-stop the engine:
-echo "disabled" > engine3_mode
+LP5521 has the internal program memory for running various LED patterns.
+For the details, please refer to 'firmware' section in leds-lp55xx.txt
 
 sysfs contains a selftest entry.
 The test communicates with the chip and checks that
@@ -47,7 +36,7 @@ The name of each channel can be configurable.
 If the name field is not defined, the default name will be set to 'xxxx:channelN'
 (XXXX : pdata->label or i2c client name, N : channel number)
 
-static struct lp5521_led_config lp5521_led_config[] = {
+static struct lp55xx_led_config lp5521_led_config[] = {
         {
 		.name = "red",
                 .chan_nr        = 0,
@@ -81,10 +70,10 @@ static void lp5521_enable(bool state)
 	/* Control of chip enable signal */
 }
 
-static struct lp5521_platform_data lp5521_platform_data = {
+static struct lp55xx_platform_data lp5521_platform_data = {
         .led_config     = lp5521_led_config,
         .num_channels   = ARRAY_SIZE(lp5521_led_config),
-        .clock_mode     = LP5521_CLOCK_EXT,
+        .clock_mode     = LP55XX_CLOCK_EXT,
         .setup_resources   = lp5521_setup,
         .release_resources = lp5521_release,
         .enable            = lp5521_enable,
@@ -105,47 +94,9 @@ example of update_config :
 			LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT | \
 			LP5521_CLK_INT)
 
-static struct lp5521_platform_data lp5521_pdata = {
+static struct lp55xx_platform_data lp5521_pdata = {
 	.led_config = lp5521_led_config,
 	.num_channels = ARRAY_SIZE(lp5521_led_config),
-	.clock_mode = LP5521_CLOCK_INT,
+	.clock_mode = LP55XX_CLOCK_INT,
 	.update_config = LP5521_CONFIGS,
 };
-
-LED patterns : LP5521 has autonomous operation without external control.
-Pattern data can be defined in the platform data.
-
-example of led pattern data :
-
-/* RGB(50,5,0) 500ms on, 500ms off, infinite loop */
-static u8 pattern_red[] = {
-		0x40, 0x32, 0x60, 0x00,	0x40, 0x00, 0x60, 0x00,
-		};
-
-static u8 pattern_green[] = {
-		0x40, 0x05, 0x60, 0x00, 0x40, 0x00, 0x60, 0x00,
-		};
-
-static struct lp5521_led_pattern board_led_patterns[] = {
-	{
-		.r = pattern_red,
-		.g = pattern_green,
-		.size_r = ARRAY_SIZE(pattern_red),
-		.size_g = ARRAY_SIZE(pattern_green),
-	},
-};
-
-static struct lp5521_platform_data lp5521_platform_data = {
-        .led_config     = lp5521_led_config,
-        .num_channels   = ARRAY_SIZE(lp5521_led_config),
-        .clock_mode     = LP5521_CLOCK_EXT,
-	.patterns = board_led_patterns,
-	.num_patterns = ARRAY_SIZE(board_led_patterns),
-};
-
-Then predefined led pattern(s) can be executed via the sysfs.
-To start the pattern #1,
-# echo 1 > /sys/bus/i2c/devices/xxxx/led_pattern
-(xxxx : i2c bus & slave address)
-To end the pattern,
-# echo 0 > /sys/bus/i2c/devices/xxxx/led_pattern
diff --git a/Documentation/leds/leds-lp5523.txt b/Documentation/leds/leds-lp5523.txt
index c2743f5..899fdad 100644
--- a/Documentation/leds/leds-lp5523.txt
+++ b/Documentation/leds/leds-lp5523.txt
@@ -27,25 +27,8 @@ c) Default
 If both fields are NULL, 'lp5523' is used by default.
 /sys/class/leds/lp5523:channelN  (N: 0 ~ 8)
 
-The chip provides 3 engines. Each engine can control channels without
-interaction from the main CPU. Details of the micro engine code can be found
-from the public data sheet. Leds can be muxed to different channels.
-
-Control interface for the engines:
-x is 1 .. 3
-enginex_mode : disabled, load, run
-enginex_load : microcode load (visible only in load mode)
-enginex_leds : led mux control (visible only in load mode)
-
-cd /sys/class/leds/lp5523:channel2/device
-echo "load" > engine3_mode
-echo "9d80400004ff05ff437f0000" > engine3_load
-echo "111111111" > engine3_leds
-echo "run" > engine3_mode
-
-sysfs contains a selftest entry. It measures each channel
-voltage level and checks if it looks reasonable. If the level is too high,
-the led is missing; if the level is too low, there is a short circuit.
+LP5523 has the internal program memory for running various LED patterns.
+For the details, please refer to 'firmware' section in leds-lp55xx.txt
 
 Selftest uses always the current from the platform data.
 
@@ -58,7 +41,7 @@ Example platform data:
 
 Note - chan_nr can have values between 0 and 8.
 
-static struct lp5523_led_config lp5523_led_config[] = {
+static struct lp55xx_led_config lp5523_led_config[] = {
         {
 		.name		= "D1",
                 .chan_nr        = 0,
@@ -88,10 +71,10 @@ static void lp5523_enable(bool state)
 	/* Control chip enable signal */
 }
 
-static struct lp5523_platform_data lp5523_platform_data = {
+static struct lp55xx_platform_data lp5523_platform_data = {
         .led_config     = lp5523_led_config,
         .num_channels   = ARRAY_SIZE(lp5523_led_config),
-        .clock_mode     = LP5523_CLOCK_EXT,
+        .clock_mode     = LP55XX_CLOCK_EXT,
         .setup_resources   = lp5523_setup,
         .release_resources = lp5523_release,
         .enable            = lp5523_enable,
diff --git a/Documentation/leds/leds-lp55xx.txt b/Documentation/leds/leds-lp55xx.txt
new file mode 100644
index 0000000..ea1e446
--- /dev/null
+++ b/Documentation/leds/leds-lp55xx.txt
@@ -0,0 +1,104 @@
+LP5521/LP5523/LP55231 Common Driver
+===================================
+
+Authors: Milo(Woogyom) Kim <milo.kim@ti.com>
+
+Description
+-----------
+LP5521, LP5523/55231 have common features as below.
+
+  Register access via the I2C
+  Device initialization/deinitialization
+  Create LED class devices for multiple output channels
+  Device attributes for user-space interface
+  Program memory for running LED patterns
+
+The LP55xx common driver provides these features using exported functions.
+  lp55xx_init_device() / lp55xx_deinit_device()
+  lp55xx_register_leds() / lp55xx_unregister_leds()
+  lp55xx_regsister_sysfs() / lp55xx_unregister_sysfs()
+
+( Driver Structure Data )
+
+In lp55xx common driver, two different data structure is used.
+
+o lp55xx_led
+  control multi output LED channels such as led current, channel index.
+o lp55xx_chip
+  general chip control such like the I2C and platform data.
+
+For example, LP5521 has maximum 3 LED channels.
+LP5523/55231 has 9 output channels.
+
+lp55xx_chip for LP5521 ... lp55xx_led #1
+                           lp55xx_led #2
+                           lp55xx_led #3
+
+lp55xx_chip for LP5523 ... lp55xx_led #1
+                           lp55xx_led #2
+                                 .
+                                 .
+                           lp55xx_led #9
+
+( Chip Dependent Code )
+
+To support device specific configurations, special structure
+'lpxx_device_config' is used.
+
+  Maximum number of channels
+  Reset command, chip enable command
+  Chip specific initialization
+  Brightness control register access
+  Setting LED output current
+  Program memory address access for running patterns
+  Additional device specific attributes
+
+( Firmware Interface )
+
+LP55xx family devices have the internal program memory for running
+various LED patterns.
+This pattern data can saved as a file in the user-land or
+hex byte string is written into the memory through the I2C.
+LP55xx common driver supports the firmware interface.
+
+LP55xx chips have three program engines.
+To load and run the pattern, the programming sequence is following.
+  (1) Select an engine number (1/2/3)
+  (2) Mode change to load
+  (3) Write pattern data into selected area
+  (4) Mode change to run
+
+The LP55xx common driver provides very simple interface as below.
+select_engine : Select which engine is used for running program
+run_engine    : Start program which is loaded via the firmware interface
+firmware      : Load program data
+
+For example, run blinking pattern in engine #1
+echo 1 > /sys/bus/i2c/devices/xxxx/select_engine
+echo 1 > /sys/class/firmware/lp5521/loading
+echo "4000600040FF6000" > /sys/class/firmware/lp5521/data
+echo 0 > /sys/class/firmware/lp5521/loading
+echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
+
+To start blinking patterns in engine #2 and #3 simultaneously,
+for idx in 2 3
+do
+  echo $idx > /sys/class/leds/red/device/select_engine
+  sleep 0.1
+  echo 1 > /sys/class/firmware/lp5521/loading
+  echo "4000600040FF6000" > /sys/class/firmware/lp5521/data
+  echo 0 > /sys/class/firmware/lp5521/loading
+done
+echo 1 > /sys/class/leds/red/device/run_engine
+ 
+As soon as 'loading' is set to 0, registered callback is called.
+Inside the callback, the selected engine is loaded and memory is updated.
+To run programmed pattern, 'run_engine' attribute should be enabled.
+
+( 'run_engine' and 'firmware_cb' )
+The sequence of running the program data is common.
+But each device has own specific register addresses for commands.
+To support this, 'run_engine' and 'firmware_cb' are configurable in each driver.
+run_engine  : Control the selected engine
+firmware_cb : The callback function after loading the firmware is done.
+              Chip specific commands for loading and updating program memory.
-- 
1.7.9.5


Best Regards,
Milo


