Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0FZSTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 14:19:54 -0400
Received: from imr3.ericy.com ([198.24.6.13]:41956 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab0FZSTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 14:19:47 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 2/3] hwmon: SMM665 driver documentation
Date: Sat, 26 Jun 2010 11:17:52 -0700
Message-ID: <1277576273-14153-3-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1277576273-14153-1-git-send-email-guenter.roeck@ericsson.com>
References: <1277576273-14153-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 Documentation/hwmon/smm665 |  157 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 157 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwmon/smm665

diff --git a/Documentation/hwmon/smm665 b/Documentation/hwmon/smm665
new file mode 100644
index 0000000..358ecc0
--- /dev/null
+++ b/Documentation/hwmon/smm665
@@ -0,0 +1,157 @@
+Kernel driver smm665
+====================
+
+Supported chips:
+  * Summit Microelectronics SMM465
+    Prefix: 'smm465'
+    Addresses scanned: -
+    Datasheet:
+      http://www.summitmicro.com/prod_select/summary/SMM465/SMM465DS.pdf
+  * Summit Microelectronics SMM665, SMM665B
+    Prefix: 'smm665'
+    Addresses scanned: -
+    Datasheet:
+      http://www.summitmicro.com/prod_select/summary/SMM665/SMM665B_2089_20.pdf
+  * Summit Microelectronics SMM665C
+    Prefix: 'smm665c'
+    Addresses scanned: -
+    Datasheet:
+      http://www.summitmicro.com/prod_select/summary/SMM665C/SMM665C_2125.pdf
+  * Summit Microelectronics SMM764
+    Prefix: 'smm764'
+    Addresses scanned: -
+    Datasheet:
+      http://www.summitmicro.com/prod_select/summary/SMM764/SMM764_2098.pdf
+  * Summit Microelectronics SMM766, SMM766B
+    Prefix: 'smm766'
+    Addresses scanned: -
+    Datasheets:
+      http://www.summitmicro.com/prod_select/summary/SMM766/SMM766_2086.pdf
+      http://www.summitmicro.com/prod_select/summary/SMM766B/SMM766B_2122.pdf
+
+Author: Guenter Roeck <guenter.roeck@ericsson.com>
+
+
+Module Parameters
+-----------------
+
+* vref: int
+  Default: 1250 (mV)
+  Reference voltage on VREF_ADC pin in mV. It should not be necessary to set
+  this parameter unless a non-default reference voltage is used.
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
+Support for SMM465, SMM764, and SMM766 has been implemented but is untested.
+
+
+Usage Notes
+-----------
+
+This driver does not probe for devices, since there is no register which
+can be safely used to identify the chip. You will have to instantiate
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
+Min, max, lcrit, and crit values are used by the chip to trigger external signals
+and/or other activity. Triggered signals can include HEALTHY, RST, Power Off,
+or Fault depending on the chip configuration. The driver reports values as lcrit
+or crit if exceeding the limits triggers RST, Power Off, or Fault, and as min or
+max otherwise. For details please see the SMM665 datasheet.
+
+For SMM465 and SMM764, values for Channel E and F are reported but undefined.
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
+in1_lcrit		12v input critical minimum voltage (mV)
+in2_lcrit		3.3V (VDD) input critical minimum voltage (mV)
+in3_lcrit		Channel A critical minimum voltage (mV)
+in4_lcrit		Channel B critical minimum voltage (mV)
+in5_lcrit		Channel C critical minimum voltage (mV)
+in6_lcrit		Channel D critical minimum voltage (mV)
+in7_lcrit		Channel E critical minimum voltage (mV)
+in8_lcrit		Channel F critical minimum voltage (mV)
+in9_lcrit		AIN1 critical minimum voltage (mV)
+in10_lcrit		AIN2 critical minimum voltage (mV)
+
+in1_crit		12v input critical maximum voltage (mV)
+in2_crit		3.3V (VDD) input critical maximum voltage (mV)
+in3_crit		Channel A critical maximum voltage (mV)
+in4_crit		Channel B critical maximum voltage (mV)
+in5_crit		Channel C critical maximum voltage (mV)
+in6_crit		Channel D critical maximum voltage (mV)
+in7_crit		Channel E critical maximum voltage (mV)
+in8_crit		Channel F critical maximum voltage (mV)
+in9_crit		AIN1 critical maximum voltage (mV)
+in10_crit		AIN2 critical maximum voltage (mV)
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
+temp1_fault		Temperature fault
-- 
1.7.0.87.g0901d

