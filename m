Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1BHVZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:25:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54953 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab1BHVYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:24:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/5] PM: Reorder power management Kconfig options
Date: Tue, 8 Feb 2011 22:21:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20110208122159.GA8284@elte.hu> <201102082218.28015.rjw@sisk.pl>
In-Reply-To: <201102082218.28015.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102082221.49605.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Reorder configuration options in kernel/power/Kconfig so that
the options depended on are at the top of the list.

This patch doesn't introduce any functional changes.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Kconfig |  222 +++++++++++++++++++++++++--------------------------
 1 file changed, 111 insertions(+), 111 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -1,89 +1,3 @@
-config PM
-	bool
-	depends on PM_SLEEP || PM_RUNTIME
-	default y
-
-config PM_DEBUG
-	bool "Power Management Debug Support"
-	depends on PM
-	---help---
-	This option enables various debugging support in the Power Management
-	code. This is helpful when debugging and reporting PM bugs, like
-	suspend support.
-
-config PM_ADVANCED_DEBUG
-	bool "Extra PM attributes in sysfs for low-level debugging/testing"
-	depends on PM_DEBUG
-	default n
-	---help---
-	Add extra sysfs attributes allowing one to access some Power Management
-	fields of device objects from user space.  If you are not a kernel
-	developer interested in debugging/testing Power Management, say "no".
-
-config PM_VERBOSE
-	bool "Verbose Power Management debugging"
-	depends on PM_DEBUG
-	default n
-	---help---
-	This option enables verbose messages from the Power Management code.
-
-config CAN_PM_TRACE
-	def_bool y
-	depends on PM_DEBUG && PM_SLEEP && EXPERIMENTAL
-
-config PM_TRACE
-	bool
-	help
-	  This enables code to save the last PM event point across
-	  reboot. The architecture needs to support this, x86 for
-	  example does by saving things in the RTC, see below.
-
-	  The architecture specific code must provide the extern
-	  functions from <linux/resume-trace.h> as well as the
-	  <asm/resume-trace.h> header with a TRACE_RESUME() macro.
-
-	  The way the information is presented is architecture-
-	  dependent, x86 will print the information during a
-	  late_initcall.
-
-config PM_TRACE_RTC
-	bool "Suspend/resume event tracing"
-	depends on CAN_PM_TRACE
-	depends on X86
-	select PM_TRACE
-	default n
-	---help---
-	This enables some cheesy code to save the last PM event point in the
-	RTC across reboots, so that you can debug a machine that just hangs
-	during suspend (or more commonly, during resume).
-
-	To use this debugging feature you should attempt to suspend the
-	machine, reboot it and then run
-
-		dmesg -s 1000000 | grep 'hash matches'
-
-	CAUTION: this option will cause your machine's real-time clock to be
-	set to an invalid time after a resume.
-
-config PM_SLEEP_SMP
-	bool
-	depends on SMP
-	depends on ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
-	depends on PM_SLEEP
-	select HOTPLUG
-	select HOTPLUG_CPU
-	default y
-
-config PM_SLEEP
-	bool
-	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
-	default y
-
-config PM_SLEEP_ADVANCED_DEBUG
-	bool
-	depends on PM_ADVANCED_DEBUG
-	default n
-
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on ARCH_SUSPEND_POSSIBLE
@@ -93,17 +7,6 @@ config SUSPEND
 	  powered and thus its contents are preserved, such as the
 	  suspend-to-RAM state (e.g. the ACPI S3 state).
 
-config PM_TEST_SUSPEND
-	bool "Test suspend/resume and wakealarm during bootup"
-	depends on SUSPEND && PM_DEBUG && RTC_CLASS=y
-	---help---
-	This option will let you suspend your machine during bootup, and
-	make it wake up a few seconds later using an RTC wakeup alarm.
-	Enable this with a kernel parameter like "test_suspend=mem".
-
-	You probably want to have your system's RTC driver statically
-	linked, ensuring that it's available when this test runs.
-
 config SUSPEND_FREEZER
 	bool "Enable freezer for suspend to RAM/standby" \
 		if ARCH_WANTS_FREEZER_CONTROL || BROKEN
@@ -180,6 +83,117 @@ config PM_STD_PARTITION
 	  suspended image to. It will simply pick the first available swap 
 	  device.
 
+config PM_SLEEP
+	bool
+	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
+	default y
+
+config PM_SLEEP_SMP
+	bool
+	depends on SMP
+	depends on ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE
+	depends on PM_SLEEP
+	select HOTPLUG
+	select HOTPLUG_CPU
+	default y
+
+config PM_RUNTIME
+	bool "Run-time PM core functionality"
+	depends on !IA64_HP_SIM
+	---help---
+	  Enable functionality allowing I/O devices to be put into energy-saving
+	  (low power) states at run time (or autosuspended) after a specified
+	  period of inactivity and woken up in response to a hardware-generated
+	  wake-up event or a driver's request.
+
+	  Hardware support is generally required for this functionality to work
+	  and the bus type drivers of the buses the devices are on are
+	  responsible for the actual handling of the autosuspend requests and
+	  wake-up events.
+
+config PM
+	bool
+	depends on PM_SLEEP || PM_RUNTIME
+	default y
+
+config PM_DEBUG
+	bool "Power Management Debug Support"
+	depends on PM
+	---help---
+	This option enables various debugging support in the Power Management
+	code. This is helpful when debugging and reporting PM bugs, like
+	suspend support.
+
+config PM_VERBOSE
+	bool "Verbose Power Management debugging"
+	depends on PM_DEBUG
+	default n
+	---help---
+	This option enables verbose messages from the Power Management code.
+
+config PM_ADVANCED_DEBUG
+	bool "Extra PM attributes in sysfs for low-level debugging/testing"
+	depends on PM_DEBUG
+	default n
+	---help---
+	Add extra sysfs attributes allowing one to access some Power Management
+	fields of device objects from user space.  If you are not a kernel
+	developer interested in debugging/testing Power Management, say "no".
+
+config PM_SLEEP_ADVANCED_DEBUG
+	bool
+	depends on PM_ADVANCED_DEBUG
+	default n
+
+config PM_TEST_SUSPEND
+	bool "Test suspend/resume and wakealarm during bootup"
+	depends on SUSPEND && PM_DEBUG && RTC_CLASS=y
+	---help---
+	This option will let you suspend your machine during bootup, and
+	make it wake up a few seconds later using an RTC wakeup alarm.
+	Enable this with a kernel parameter like "test_suspend=mem".
+
+	You probably want to have your system's RTC driver statically
+	linked, ensuring that it's available when this test runs.
+
+config CAN_PM_TRACE
+	def_bool y
+	depends on PM_DEBUG && PM_SLEEP && EXPERIMENTAL
+
+config PM_TRACE
+	bool
+	help
+	  This enables code to save the last PM event point across
+	  reboot. The architecture needs to support this, x86 for
+	  example does by saving things in the RTC, see below.
+
+	  The architecture specific code must provide the extern
+	  functions from <linux/resume-trace.h> as well as the
+	  <asm/resume-trace.h> header with a TRACE_RESUME() macro.
+
+	  The way the information is presented is architecture-
+	  dependent, x86 will print the information during a
+	  late_initcall.
+
+config PM_TRACE_RTC
+	bool "Suspend/resume event tracing"
+	depends on CAN_PM_TRACE
+	depends on X86
+	select PM_TRACE
+	default n
+	---help---
+	This enables some cheesy code to save the last PM event point in the
+	RTC across reboots, so that you can debug a machine that just hangs
+	during suspend (or more commonly, during resume).
+
+	To use this debugging feature you should attempt to suspend the
+	machine, reboot it and then run
+
+		dmesg -s 1000000 | grep 'hash matches'
+
+	CAUTION: this option will cause your machine's real-time clock to be
+	set to an invalid time after a resume.
+
 config APM_EMULATION
 	tristate "Advanced Power Management Emulation"
 	depends on PM && SYS_SUPPORTS_APM_EMULATION
@@ -206,20 +220,6 @@ config APM_EMULATION
 	  anything, try disabling/enabling this option (or disabling/enabling
 	  APM in your BIOS).
 
-config PM_RUNTIME
-	bool "Run-time PM core functionality"
-	depends on !IA64_HP_SIM
-	---help---
-	  Enable functionality allowing I/O devices to be put into energy-saving
-	  (low power) states at run time (or autosuspended) after a specified
-	  period of inactivity and woken up in response to a hardware-generated
-	  wake-up event or a driver's request.
-
-	  Hardware support is generally required for this functionality to work
-	  and the bus type drivers of the buses the devices are on are
-	  responsible for the actual handling of the autosuspend requests and
-	  wake-up events.
-
 config PM_OPS
 	bool
 	depends on PM_SLEEP || PM_RUNTIME

