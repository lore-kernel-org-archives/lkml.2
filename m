Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab1KDGuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 02:50:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33713 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1KDGuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 02:50:00 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-0c-4eb38b16275b
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, dg77.kim@samsung.com,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: [RFC PATCH 0/2] HWMON: add in-kernel interfaces to read sensor values.
Date: Fri, 04 Nov 2011 15:50:31 +0900
Message-id: <1320389433-1671-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 04 Nov 2011 06:49:43.0649 (UTC)
 FILETIME=[EF052510:01CC9ABD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been reading hwmon values (TMU, the SoC-core temperature sensor,
and NTC, the ambient or battery surface temperature sensor) for
Charger-Manager. However, because hwmon does not have in-kernel interface,
we have been using undesired method, including "../../../fs/*.h".

This patch is to provide in-kernel interface for hwmon:
hwmon_get_value and hwmon_set_value. In order to use these two functions,
the hwmon driver should provide its sysfs attributes to hwmon framework
as well. If the hwmon driver does not provide (by providing NULL), the users
of the hwmon won't be able to use hwmon_get/set_value();
The sysfs attribute (struct attribuyte_group *) is provided with
hwmon_device_register; adding the second parameter to hwmon_device_register().
The 2/2 patch shows the changes in device drivers due to this.

Among the HWMON device, all but ntc_thermistor.c does not setup attribute_group
for HWMON; thus they do not support hwmon_get/set_value with this patch.

As soon as the server synchronizes git repositories, you can see how
hwmon_get_value() is used at:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/charger-manager


MyungJoo Ham (2):
  HWMON: add interfaces to read/write hwmon values inside kernel
  HWMON: adapt to the HWMON interface changes

 drivers/char/i8k.c                   |    2 +-
 drivers/gpu/drm/nouveau/nouveau_pm.c |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c   |    2 +-
 drivers/hwmon/abituguru.c            |    2 +-
 drivers/hwmon/abituguru3.c           |    2 +-
 drivers/hwmon/acpi_power_meter.c     |    2 +-
 drivers/hwmon/ad7414.c               |    2 +-
 drivers/hwmon/ad7418.c               |    2 +-
 drivers/hwmon/adcxx.c                |    2 +-
 drivers/hwmon/adm1021.c              |    2 +-
 drivers/hwmon/adm1025.c              |    2 +-
 drivers/hwmon/adm1026.c              |    2 +-
 drivers/hwmon/adm1029.c              |    2 +-
 drivers/hwmon/adm1031.c              |    2 +-
 drivers/hwmon/adm9240.c              |    2 +-
 drivers/hwmon/ads1015.c              |    2 +-
 drivers/hwmon/ads7828.c              |    2 +-
 drivers/hwmon/ads7871.c              |    2 +-
 drivers/hwmon/adt7411.c              |    2 +-
 drivers/hwmon/adt7462.c              |    2 +-
 drivers/hwmon/adt7470.c              |    2 +-
 drivers/hwmon/adt7475.c              |    2 +-
 drivers/hwmon/amc6821.c              |    2 +-
 drivers/hwmon/applesmc.c             |    2 +-
 drivers/hwmon/asb100.c               |    2 +-
 drivers/hwmon/asc7621.c              |    2 +-
 drivers/hwmon/asus_atk0110.c         |    2 +-
 drivers/hwmon/atxp1.c                |    2 +-
 drivers/hwmon/coretemp.c             |    2 +-
 drivers/hwmon/dme1737.c              |    4 +-
 drivers/hwmon/ds1621.c               |    2 +-
 drivers/hwmon/ds620.c                |    2 +-
 drivers/hwmon/emc1403.c              |    2 +-
 drivers/hwmon/emc2103.c              |    2 +-
 drivers/hwmon/emc6w201.c             |    2 +-
 drivers/hwmon/f71805f.c              |    2 +-
 drivers/hwmon/f71882fg.c             |    2 +-
 drivers/hwmon/f75375s.c              |    2 +-
 drivers/hwmon/fam15h_power.c         |    2 +-
 drivers/hwmon/fschmd.c               |    2 +-
 drivers/hwmon/g760a.c                |    2 +-
 drivers/hwmon/gl518sm.c              |    2 +-
 drivers/hwmon/gl520sm.c              |    2 +-
 drivers/hwmon/gpio-fan.c             |    2 +-
 drivers/hwmon/hwmon.c                |  108 +++++++++++++++++++++++++++++++++-
 drivers/hwmon/i5k_amb.c              |    2 +-
 drivers/hwmon/ibmaem.c               |    4 +-
 drivers/hwmon/ibmpex.c               |    2 +-
 drivers/hwmon/it87.c                 |    2 +-
 drivers/hwmon/jc42.c                 |    2 +-
 drivers/hwmon/jz4740-hwmon.c         |    2 +-
 drivers/hwmon/k10temp.c              |    2 +-
 drivers/hwmon/k8temp.c               |    2 +-
 drivers/hwmon/lineage-pem.c          |    2 +-
 drivers/hwmon/lm63.c                 |    2 +-
 drivers/hwmon/lm70.c                 |    2 +-
 drivers/hwmon/lm73.c                 |    2 +-
 drivers/hwmon/lm75.c                 |    2 +-
 drivers/hwmon/lm77.c                 |    2 +-
 drivers/hwmon/lm78.c                 |    4 +-
 drivers/hwmon/lm80.c                 |    2 +-
 drivers/hwmon/lm83.c                 |    2 +-
 drivers/hwmon/lm85.c                 |    2 +-
 drivers/hwmon/lm87.c                 |    2 +-
 drivers/hwmon/lm90.c                 |    2 +-
 drivers/hwmon/lm92.c                 |    2 +-
 drivers/hwmon/lm93.c                 |    2 +-
 drivers/hwmon/lm95241.c              |    2 +-
 drivers/hwmon/lm95245.c              |    2 +-
 drivers/hwmon/ltc4151.c              |    2 +-
 drivers/hwmon/ltc4215.c              |    2 +-
 drivers/hwmon/ltc4245.c              |    2 +-
 drivers/hwmon/ltc4261.c              |    2 +-
 drivers/hwmon/max1111.c              |    2 +-
 drivers/hwmon/max16065.c             |    2 +-
 drivers/hwmon/max1619.c              |    2 +-
 drivers/hwmon/max1668.c              |    2 +-
 drivers/hwmon/max6639.c              |    2 +-
 drivers/hwmon/max6642.c              |    2 +-
 drivers/hwmon/max6650.c              |    2 +-
 drivers/hwmon/mc13783-adc.c          |    2 +-
 drivers/hwmon/ntc_thermistor.c       |   15 +----
 drivers/hwmon/pc87360.c              |    2 +-
 drivers/hwmon/pc87427.c              |    2 +-
 drivers/hwmon/pcf8591.c              |    2 +-
 drivers/hwmon/pmbus/pmbus_core.c     |    2 +-
 drivers/hwmon/s3c-hwmon.c            |    2 +-
 drivers/hwmon/sch5627.c              |    2 +-
 drivers/hwmon/sch5636.c              |    2 +-
 drivers/hwmon/sht15.c                |    2 +-
 drivers/hwmon/sht21.c                |    2 +-
 drivers/hwmon/sis5595.c              |    2 +-
 drivers/hwmon/smm665.c               |    2 +-
 drivers/hwmon/smsc47b397.c           |    2 +-
 drivers/hwmon/smsc47m1.c             |    2 +-
 drivers/hwmon/smsc47m192.c           |    2 +-
 drivers/hwmon/thmc50.c               |    2 +-
 drivers/hwmon/tmp102.c               |    2 +-
 drivers/hwmon/tmp401.c               |    2 +-
 drivers/hwmon/tmp421.c               |    2 +-
 drivers/hwmon/twl4030-madc-hwmon.c   |    2 +-
 drivers/hwmon/ultra45_env.c          |    2 +-
 drivers/hwmon/via-cputemp.c          |    2 +-
 drivers/hwmon/via686a.c              |    2 +-
 drivers/hwmon/vt1211.c               |    2 +-
 drivers/hwmon/vt8231.c               |    2 +-
 drivers/hwmon/w83627ehf.c            |    2 +-
 drivers/hwmon/w83627hf.c             |    2 +-
 drivers/hwmon/w83781d.c              |    4 +-
 drivers/hwmon/w83791d.c              |    2 +-
 drivers/hwmon/w83792d.c              |    2 +-
 drivers/hwmon/w83793.c               |    2 +-
 drivers/hwmon/w83795.c               |    2 +-
 drivers/hwmon/w83l785ts.c            |    2 +-
 drivers/hwmon/w83l786ng.c            |    2 +-
 drivers/hwmon/wm831x-hwmon.c         |    2 +-
 drivers/hwmon/wm8350-hwmon.c         |    2 +-
 drivers/input/touchscreen/ads7846.c  |    2 +-
 drivers/platform/x86/asus-wmi.c      |    2 +-
 drivers/platform/x86/compal-laptop.c |    2 +-
 drivers/platform/x86/eeepc-laptop.c  |    2 +-
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 drivers/thermal/thermal_sys.c        |    2 +-
 include/linux/hwmon.h                |   11 +++-
 124 files changed, 245 insertions(+), 139 deletions(-)

-- 
1.7.4.1

