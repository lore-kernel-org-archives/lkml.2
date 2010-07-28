Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0G1TJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:09:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:61943 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab0G1TJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:09:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,275,1278313200"; 
   d="scan'208";a="305514052"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>, "Len Brown" <lenb@kernel.org>,
        "Guenter Roeck" <guenter.roeck@ericsson.com>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "Jean Delvare" <khali@linux-fr.org>, "Huaxu Wan" <huaxu.wan@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATH V2 5/5] Package Level Thermal Control and Power Limit Notification: pkgtemp doc
Date: Wed, 28 Jul 2010 12:00:53 -0700
Message-Id: <1280343653-26380-6-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280343653-26380-1-git-send-email-fenghua.yu@intel.com>
References: <1280343653-26380-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Document for package level thermal hwmon driver.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Reviewed-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/hwmon/pkgtemp |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwmon/pkgtemp

diff --git a/Documentation/hwmon/pkgtemp b/Documentation/hwmon/pkgtemp
new file mode 100644
index 0000000..c8e1fb0
--- /dev/null
+++ b/Documentation/hwmon/pkgtemp
@@ -0,0 +1,36 @@
+Kernel driver pkgtemp
+======================
+
+Supported chips:
+  * Intel family
+    Prefix: 'pkgtemp'
+    CPUID:
+    Datasheet: Intel 64 and IA-32 Architectures Software Developer's Manual
+               Volume 3A: System Programming Guide
+
+Author: Fenghua Yu
+
+Description
+-----------
+
+This driver permits reading package level temperature sensor embedded inside
+Intel CPU package. The sensors can be in core, uncore, memory controller, or
+other components in a package. The feature is first implemented in Intel Sandy
+Bridge platform.
+
+Temperature is measured in degrees Celsius and measurement resolution is
+1 degree C. Valid temperatures are from 0 to TjMax degrees C, because the actual
+value of temperature register is in fact a delta from TjMax.
+
+Temperature known as TjMax is the maximum junction temperature of package.
+We get this from MSR_IA32_TEMPERATURE_TARGET. If the MSR is not accessible,
+we define TjMax as 100 degrees Celsius. At this temperature, protection
+mechanism will perform actions to forcibly cool down the package. Alarm
+may be raised, if the temperature grows enough (more than TjMax) to trigger
+the Out-Of-Spec bit. Following table summarizes the exported sysfs files:
+
+temp1_input	  - Package temperature (in millidegrees Celsius).
+temp1_max        - All cooling devices should be turned on.
+temp1_crit	  - Maximum junction temperature (in millidegrees Celsius).
+temp1_crit_alarm - Set when Out-of-spec bit is set, never clears.
+		    Correct CPU operation is no longer guaranteed.
-- 
1.7.2

