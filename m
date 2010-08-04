Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab0HDACK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 20:02:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:48184 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab0HDACF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 20:02:05 -0400
Date: Wed, 4 Aug 2010 00:01:47 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        len.brown@intel.com
In-Reply-To: <1280448826-12004-6-git-send-email-fenghua.yu@intel.com>
References: <1280448826-12004-6-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hwmon] x86, hwmon: Package Level Thermal/Power: pkgtemp documentation
Message-ID: <tip-a3159864f2978bf2ace9cc787d73d315c98bbf9a@git.kernel.org>
Git-Commit-ID: a3159864f2978bf2ace9cc787d73d315c98bbf9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 Aug 2010 00:01:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3159864f2978bf2ace9cc787d73d315c98bbf9a
Gitweb:     http://git.kernel.org/tip/a3159864f2978bf2ace9cc787d73d315c98bbf9a
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 Jul 2010 17:13:46 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 3 Aug 2010 15:58:56 -0700

x86, hwmon: Package Level Thermal/Power: pkgtemp documentation

Document for package level thermal hwmon driver.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
LKML-Reference: <1280448826-12004-6-git-send-email-fenghua.yu@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/hwmon/pkgtemp |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

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
