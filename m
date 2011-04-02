Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab1DBGXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:23:11 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:44569 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1DBGXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:23:10 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: idle cleanup - v3
Date: Sat, 02 Apr 2011 02:22:42 -0400
Message-id: <1301725380-10579-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <alpine.LFD.2.02.1104010020280.2797@x980>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reviews, tests & Acks -- keep 'em coming!

By the end of this series, pm_idle is removed as a public
x86 idle-loop registration mechanism.  A few other things are
cleaned up in the process.

thanks,
Len Brown - Intel Open Source Technology Center

The first 11 are staged here:
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release
I would like to see it make 2.6.39, and some for .stable

[PATCH 01/18] cpuidle: menu: fixed wrapping timers at 4.294 seconds
[PATCH 02/18] x86 idle floppy: deprecate disable_hlt()
[PATCH 03/18] x86 idle APM: deprecate CONFIG_APM_CPU_IDLE
[PATCH 04/18] x86 idle: EXPORT_SYMBOL(default_idle, pm_idle) only
[PATCH 05/18] x86 idle: deprecate "no-hlt" cmdline param
[PATCH 06/18] x86 idle: deprecate mwait_idle() and "idle=mwait"
[PATCH 07/18] x86 idle: clarify AMD erratum 400 workaround
[PATCH 08/18] cpuidle: create bootparam "cpuidle.off=1"
[PATCH 09/18] cpuidle: replace xen access to x86 pm_idle and default_idle
[PATCH 10/18] x86 idle: move mwait_idle_with_hints() to where it is used
[PATCH 11/18] cpuidle: stop using pm_idle

 Documentation/feature-removal-schedule.txt |   36 +++++++++++++++
 Documentation/kernel-parameters.txt        |    3 +
 arch/arm/kernel/process.c                  |    4 +-
 arch/sh/kernel/idle.c                      |    6 ++-
 arch/x86/include/asm/acpi.h                |    2 +-
 arch/x86/include/asm/idle.h                |    2 +-
 arch/x86/include/asm/processor.h           |    6 +--
 arch/x86/kernel/acpi/cstate.c              |   24 ++++++++++
 arch/x86/kernel/apm_32.c                   |    2 +
 arch/x86/kernel/cpu/bugs.c                 |    1 +
 arch/x86/kernel/cpu/common.c               |    2 +-
 arch/x86/kernel/process.c                  |   66 ++++++++++------------------
 arch/x86/kernel/process_32.c               |    4 +-
 arch/x86/kernel/process_64.c               |    4 +-
 arch/x86/kernel/smpboot.c                  |    2 +-
 arch/x86/xen/setup.c                       |    3 +-
 drivers/acpi/processor_idle.c              |    2 +-
 drivers/block/floppy.c                     |    1 +
 drivers/cpuidle/cpuidle.c                  |   50 +++++++++++++--------
 drivers/cpuidle/cpuidle.h                  |    1 +
 drivers/cpuidle/driver.c                   |    3 +
 drivers/cpuidle/governor.c                 |    3 +
 drivers/cpuidle/governors/menu.c           |    4 +-
 include/linux/cpuidle.h                    |    4 ++
 24 files changed, 157 insertions(+), 78 deletions(-)

The rest are staged here:
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-test
which is a super-set of the above.  These will wait for 2.6.40.

[PATCH 12/18] 2.6.40: x86 idle: remove deprecated "no-hlt" cmdline
[PATCH 13/18] 2.6.40: x86 idle: remove deprecated "hlt_bug: no" in
[PATCH 14/18] 2.6.40: x86 idle floppy: remove deprecated disalbe_hlt
[PATCH 15/18] 2.6.40: x86 idle: remove deprecated hlt_use_halt()
[PATCH 16/18] 2.6.40: x86 idle APM: remove deprecated apm_cpu_idle()
[PATCH 17/18] 2.6.40: x86 idle: do not export default_idle() and
[PATCH 18/18] 2.6.40: x86 idle: remove deprecated mwait_idle()

 Documentation/feature-removal-schedule.txt |   36 -----
 Documentation/kernel-parameters.txt        |   11 +--
 arch/x86/Kconfig                           |   11 --
 arch/x86/include/asm/processor.h           |   12 +--
 arch/x86/include/asm/system.h              |    9 -
 arch/x86/kernel/apm_32.c                   |  234 ----------------------------
 arch/x86/kernel/cpu/bugs.c                 |   14 +--
 arch/x86/kernel/cpu/proc.c                 |    2 -
 arch/x86/kernel/process.c                  |  109 ++-----------
 arch/x86/kernel/setup.c                    |    4 +-
 arch/x86/xen/setup.c                       |    3 -
 drivers/acpi/processor_idle.c              |    1 -
 drivers/block/floppy.c                     |   36 -----
 13 files changed, 22 insertions(+), 460 deletions(-)

