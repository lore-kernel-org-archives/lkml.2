Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032Ab0FRQIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:08:50 -0400
Received: from imr3.ericy.com ([198.24.6.13]:41162 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760945Ab0FRQIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:08:48 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 2/3] hwmon: SMM665 driver documentation
Date: Fri, 18 Jun 2010 09:06:33 -0700
Message-ID: <1276877194-28214-3-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1276877194-28214-1-git-send-email-guenter.roeck@ericsson.com>
References: <1276877194-28214-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/hwmon/smm665 |  116 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 116 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwmon/smm665

diff --git a/Documentation/hwmon/smm665 b/Documentation/hwmon/smm665
new file mode 100644
index 0000000..d8cce5e
--- /dev/null
+++ b/Documentation/hwmon/smm665
@@ -0,0 +1,116 @@
+Kernel driver smm665
+====================
+
+Supported chips:
+  * Summit Microelectronics SMM665, SMM665B
+    Prefix: 'smm665'
+    Addresses scanned: -
+    Datasheet: Publicly available at the Summit Microelectronics website.
+
+Author: Guenter Roeck <guenter.roeck@ericsson.com>
+
+
+Description
+-----------
+
+[From datasheet] The SMM665 is an Active DC Output power supply Controller
+that monitors, margins and cascade sequences power. The part monitors six
+power supply channels as well as VDD, 12V input, two general-purpose analog
+inputs and an internal temperature sensor using a 10-bit ADC.
+
+Each monitored channel has its own high and low limits, plus a critical
+limit.
+
+Usage Notes
+-----------
+
+This driver does not probe for SMM665 devices, since there is no register
+which can be safely used to identify the chip. You will have to instantiate
+the devices explicitly. When instantiating the device, you have to specify
+its configuration register address.
+
+Example: the following will load the driver for an SMM665 at address 0x57
+on I2C bus #1:
+$ modprobe smm665
+$ echo smm665 0x57 > /sys/bus/i2c/devices/i2c-1/new_device
+
+
+Sysfs entries
+-------------
+
+This driver uses the values in the datasheet to convert ADC register values
+into the values specified in the sysfs-interface document. All attributes are
+read only.
+
+in1_input		12V input voltage (mV)
+in2_input		3.3V (VDD) input voltage (mV)
+in3_input		Channel A voltage (mV)
+in4_input		Channel B voltage (mV)
+in5_input		Channel C voltage (mV)
+in6_input		Channel D voltage (mV)
+in7_input		Channel E voltage (mV)
+in8_input		Channel F voltage (mV)
+in9_input		AIN1 voltage (mV)
+in10_input		AIN2 voltage (mV)
+
+in1_min			12v input minimum voltage (mV)
+in2_min			3.3V (VDD) input minimum voltage (mV)
+in3_min			Channel A minimum voltage (mV)
+in4_min			Channel B minimum voltage (mV)
+in5_min			Channel C minimum voltage (mV)
+in6_min			Channel D minimum voltage (mV)
+in7_min			Channel E minimum voltage (mV)
+in8_min			Channel F minimum voltage (mV)
+in9_min			AIN1 minimum voltage (mV)
+in10_min		AIN2 minimum voltage (mV)
+
+in1_min_alarm		12v input undervoltage alarm
+in2_min_alarm		3.3V (VDD) input undervoltage alarm
+in3_min_alarm		Channel A undervoltage alarm
+in4_min_alarm		Channel B undervoltage alarm
+in5_min_alarm		Channel C undervoltage alarm
+in6_min_alarm		Channel D undervoltage alarm
+in7_min_alarm		Channel E undervoltage alarm
+in8_min_alarm		Channel F undervoltage alarm
+in9_min_alarm		AIN1 undervoltage alarm
+in10_min_alarm		AIN2 undervoltage alarm
+
+in1_max			12v input maximum voltage (mV)
+in2_max			3.3V (VDD) input maximum voltage (mV)
+in3_max			Channel A maximum voltage (mV)
+in4_max			Channel B maximum voltage (mV)
+in5_max			Channel C maximum voltage (mV)
+in6_max			Channel D maximum voltage (mV)
+in7_max			Channel E maximum voltage (mV)
+in8_max			Channel F maximum voltage (mV)
+in9_max			AIN1 maximum voltage (mV)
+in10_max		AIN2 maximum voltage (mV)
+
+in1_max_alarm		12v input overvoltage alarm
+in2_max_alarm		3.3V (VDD) input overvoltage alarm
+in3_max_alarm		Channel A overvoltage alarm
+in4_max_alarm		Channel B overvoltage alarm
+in5_max_alarm		Channel C overvoltage alarm
+in6_max_alarm		Channel D overvoltage alarm
+in7_max_alarm		Channel E overvoltage alarm
+in8_max_alarm		Channel F overvoltage alarm
+in9_max_alarm		AIN1 overvoltage alarm
+in10_max_alarm		AIN2 overvoltage alarm
+
+in1_fault		12v input fault
+in2_fault		3.3V (VDD) input fault
+in3_fault		Channel A fault
+in4_fault		Channel B fault
+in5_fault		Channel C fault
+in6_fault		Channel D fault
+in7_fault		Channel E fault
+in8_fault		Channel F fault
+in9_fault		AIN1 fault
+in10_fault		AIN2 fault
+
+temp1_input		Chip tempererature
+temp1_min		Mimimum chip tempererature
+temp1_max		Maximum chip tempererature
+temp1_crit		Critical chip tempererature
+temp1_min_alarm		Chip temperature low alarm
+temp1_max_alarm		Chip temperature high alarm
-- 
1.7.0.87.g0901d

