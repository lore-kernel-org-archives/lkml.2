Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1CaGDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:03:48 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:41797 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab1CaGDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:03:46 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [PATCH 0/9] x86 idle cruft removal - v2
Date: Thu, 31 Mar 2011 02:03:15 -0400
Message-id: <1301551404-8263-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.7.4.2.406.gbe91
In-reply-to: <1300950508-22746-1-git-send-email-lenb@kernel.org>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unchanged:

[PATCH 1/9] x86 idle: remove "no-hlt" cmdline param
[PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
[PATCH 3/9] x86 idle: remove NOP halt_works()
[PATCH 4/9] x86 idle floppy: delete disable_hlt()/enable_hlt()
[PATCH 5/9] x86 idle: remove NOP hlt_use_halt()

new:

[PATCH 6/9] x86 idle APM: delete apm_cpu_idle(), and its use of pm_idle
[PATCH 7/9] x86 idle: do not EXPORT_SYMBOL pm_idle and default_idle
[PATCH 8/9] x86 idle: move mwait_idle_with_hints() to where it is used
[PATCH 9/9] x86 idle: delete mwait_idle()


 Documentation/kernel-parameters.txt |   11 +--
 arch/x86/Kconfig                    |   11 --
 arch/x86/include/asm/processor.h    |   14 +--
 arch/x86/include/asm/system.h       |    7 -
 arch/x86/kernel/acpi/cstate.c       |   24 ++++
 arch/x86/kernel/apm_32.c            |  232 -----------------------------------
 arch/x86/kernel/cpu/bugs.c          |   13 +--
 arch/x86/kernel/cpu/proc.c          |    2 -
 arch/x86/kernel/process.c           |  127 +++-----------------
 arch/x86/kernel/setup.c             |    4 +-
 arch/x86/xen/setup.c                |    3 -
 drivers/acpi/processor_idle.c       |    1 -
 drivers/block/floppy.c              |   35 ------
 13 files changed, 45 insertions(+), 439 deletions(-)

What is next:

handle c1e_idle() vs default_idle()
	run-time check for AMD workaround enable as part of default_idle?
give xen_arch_setup default_idle() w/o having it touch pm_idle
	perhaps it can simply set a flag to disable cpuidle...
		which is what would run if the xen kernel were
		booted on raw iron.  Or can we handle this
		at compile time?
delete pm_idle
	x86 will then use default_idle or cpuidle
allow cpuidle to use default_idle to handle the period
	where it polls because cpus have not yet registered

