Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423577Ab2KNWnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:43:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423544Ab2KNWnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:43:23 -0500
Date: Wed, 14 Nov 2012 13:22:39 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-80aa1dff65717e7518647d4e27d1d3dcea5818e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1352835171-3958-3-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-3-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86, Kconfig:
  Add config switch for CPU0 hotplug
Git-Commit-ID: 80aa1dff65717e7518647d4e27d1d3dcea5818e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 14 Nov 2012 14:43:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80aa1dff65717e7518647d4e27d1d3dcea5818e6
Gitweb:     http://git.kernel.org/tip/80aa1dff65717e7518647d4e27d1d3dcea5818e6
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 13 Nov 2012 11:32:39 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 09:39:46 -0800

x86, Kconfig: Add config switch for CPU0 hotplug

New config switch CONFIG_BOOTPARAM_HOTPLUG_CPU0 sets default state of whether
the CPU0 hotplug is on or off.

If the switch is off, CPU0 is not hotpluggable by default. But the CPU0 hotplug
feature can still be turned on by kernel parameter cpu0_hotplug at boot.

If the switch is on, CPU0 is always hotpluggable.

The default value of the switch is off.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1352835171-3958-3-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..036e89a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1698,6 +1698,35 @@ config HOTPLUG_CPU
 	    automatically on SMP systems. )
 	  Say N if you want to disable CPU hotplug.
 
+config BOOTPARAM_HOTPLUG_CPU0
+	bool "Set default setting of cpu0_hotpluggable"
+	default n
+	depends on HOTPLUG_CPU && EXPERIMENTAL
+	---help---
+	  Set whether default state of cpu0_hotpluggable is on or off.
+
+	  Say Y here to enable CPU0 hotplug by default. If this switch
+	  is turned on, there is no need to give cpu0_hotplug kernel
+	  parameter and the CPU0 hotplug feature is enabled by default.
+
+	  Please note: there are two known CPU0 dependencies if you want
+	  to enable the CPU0 hotplug feature either by this switch or by
+	  cpu0_hotplug kernel parameter.
+
+	  First, resume from hibernate or suspend always starts from CPU0.
+	  So hibernate and suspend are prevented if CPU0 is offline.
+
+	  Second dependency is PIC interrupts always go to CPU0. CPU0 can not
+	  offline if any interrupt can not migrate out of CPU0. There may
+	  be other CPU0 dependencies.
+
+	  Please make sure the dependencies are under your control before
+	  you enable this feature.
+
+	  Say N if you don't want to enable CPU0 hotplug feature by default.
+	  You still can enable the CPU0 hotplug feature at boot by kernel
+	  parameter cpu0_hotplug.
+
 config COMPAT_VDSO
 	def_bool y
 	prompt "Compat VDSO support"
