Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0F1V6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:58:51 -0400
Received: from imr3.ericy.com ([198.24.6.13]:38704 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab0F1V6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:58:49 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>, Crane Cai <crane.cai@amd.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Ralf Baechle <ralf@linux-mips.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH/RFC 3/4] hwmon: pmbus driver documentation
Date: Mon, 28 Jun 2010 14:56:53 -0700
Message-ID: <1277762214-15155-4-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1277762214-15155-1-git-send-email-guenter.roeck@ericsson.com>
References: <1277762214-15155-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/hwmon/pmbus |  117 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 117 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwmon/pmbus

diff --git a/Documentation/hwmon/pmbus b/Documentation/hwmon/pmbus
new file mode 100644
index 0000000..7661a35
--- /dev/null
+++ b/Documentation/hwmon/pmbus
@@ -0,0 +1,117 @@
+Kernel driver pmbus
+====================
+
+Supported chips:
+  * Ericsson BMR45X series
+    DC/DC Converter
+    Prefix: 'bmr45x'
+    Addresses scanned: -
+    Datasheets: Publicly available at the Ericsson website.
+  * Linear Technology LTC2978
+    Octal PMBus Power Supply Monitor and Controller
+    Prefix: 'ltc2978'
+    Addresses scanned: -
+    Datasheet: Publicly available at the Linear Technology website.
+  * Maxim MAX16064
+    Quad Power-Supply Controller
+    Prefix: 'max16064'
+    Addresses scanned: -
+    Datasheet: Publicly available at the Maxim website.
+  * Maxim MAX8688
+    Digital Power-Supply Controller/Monitor
+    Prefix: 'max8688'
+    Addresses scanned: -
+    Datasheet: Publicly available at the Maxim website.
+  * Texas Instruments UCD92xx
+    Digital PWM System Controller
+    Prefix: 'ucd921x', 'ucd9220', 'ucd9240'
+    Addresses scanned: -
+    Datasheets: Publicly available at the Philips website.
+  * Generic PMBus devices
+    Prefix: 'pmbus'
+    Addresses scanned: -
+    Datasheet: n.a.
+
+Author: Guenter Roeck <guenter.roeck@ericsson.com>
+
+
+Description
+-----------
+
+This driver supports hardware montoring for various PMBus compliant devices.
+It supports voltage, current, power, and temperature sensors as supported
+by the device.
+
+Each monitored channel has its own high and low limits, plus a critical
+limit.
+
+
+Usage Notes
+-----------
+
+This driver does not probe for PMBus devices, since there is no register
+which can be safely used to identify the chip (The MFG_ID register is not
+supported by all chips), and since there is no well defined address range for
+PMBus devices. You will have to instantiate the devices explicitly.
+
+Example: the following will load the driver for an LTC2978 at address 0x60
+on I2C bus #1:
+$ modprobe pmbus
+$ echo ltc2978 0x60 > /sys/bus/i2c/devices/i2c-1/new_device
+
+
+Sysfs entries
+-------------
+
+When probing the chip, the driver identifies which PMBus registers are
+supported, and determines available sensors from this information.
+Attribute files only exist if respective sensors are suported by the chip.
+Labels are provided to inform the user about the sensor associated with
+a given sysfs entry.
+
+The following attributes are supported. Limit attributes are read-write; all
+other attributes are read-only.
+
+inX_input		Measured Voltage. From READ_VIN or READ_VOUT register.
+inX_min			Minumum Voltage. From VIN_UV_WARN_LIMIT or
+			VOUT_UV_WARN_LIMIT register.
+inX_max			Maximum Voltage. From VIN_OV_WARN_LIMIT or
+			VOUT_OV_WARN_LIMIT register.
+inX_min_alarm		From VOLTAGE_UV_WARNING status.
+inX_max_alarm		From VOLTAGE_OV_WARNING status.
+inX_min_fault		From VOLTAGE_UV_FAULT status.
+inX_max_fault		From VOLTAGE_OV_FAULT status.
+inX_label		"vin" or "voutY"
+
+currX_input		Measured Current. From READ_IIN or READ_IOUT register.
+currX_min		Minumum Current. For output current only.
+			From IOUT_UC_FAULT_LIMIT register.
+currX_max		Maximum Current. From IIN_OC_WARN_LIMIT or
+			IOUT_OC_WARN_LIMIT register.
+currX_min_alarm		For output current only. From IOUT_UC_FAULT status.
+currX_max_alarm		From IIN_OC_WARNING or IOUT_OC_WARNING status.
+currX_label		"iin" or "vinY"
+
+powerX_input		Measured Power. From READ_PIN or READ_POUT register.
+powerX_cap		Power limit. From POUT_MAX register.
+powerX_max		Power limit. From PIN_OP_WARN_LIMIT or
+			POUT_OP_WARN_LIMIT register.
+powerX_crit		Critical power limit. From POUT_OP_FAULT_LIMIT register.
+powerX_alarm		From POUT_OP_WARNING status.
+powerX_label		"pin" or "poutY"
+
+tempX_input		Measured tempererature. From READ_TEMPERATURE_X
+			register.
+tempX_min		Mimimum tempererature. From UT_WARN_LIMIT register.
+tempX_max		Maximum tempererature. From OT_WARN_LIMIT register.
+tempX_crit		Critical high tempererature. From OT_FAULT_LIMIT
+			register.
+tempX_min_alarm		Chip temperature low alarm. Set by comparing
+			READ_TEMPERATURE_X with UT_WARN_LIMIT if
+			TEMP_UT_WARNING status is set.
+tempX_max_alarm		Chip temperature high alarm. Set by comparing
+			READ_TEMPERATURE_X with OT_WARN_LIMIT if
+			TEMP_OT_WARNING status is set.
+tempX_crit_alarm	Chip temperature critical alarm. Set by comparing
+			READ_TEMPERATURE_X with OT_FAULT_LIMIT if
+			TEMP_OT_FAULT status is set.
-- 
1.7.0.87.g0901d

