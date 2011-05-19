Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab1ESPOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab1ESPOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:14:07 -0400
Date: Thu, 19 May 2011 11:05:36 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: CPUFREQ git pull for 2.6.40 [2/2]
Message-ID: <20110519150536.GC5076@redhat.com>
References: <20110519145605.GA5076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519145605.GA5076@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pull request moves the x86 cpufreq drivers to drivers/cpufreq/
The ARM people are working on moving theirs over afterwards once
the Makefile/Kconfig's have landed in your tree.

Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ move-drivers

 arch/arm/mach-davinci/cpufreq.c                    |    4 +-
 arch/blackfin/mach-common/dpmc.c                   |    3 -
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c            |   44 ++---
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/kernel/cpu/Makefile                       |    1 -
 arch/x86/kernel/cpu/cpufreq/Makefile               |   21 --
 drivers/acpi/processor_perflib.c                   |    6 +-
 drivers/cpufreq/Kconfig                            |   23 +--
 .../cpufreq/Kconfig => drivers/cpufreq/Kconfig.x86 |   13 +--
 drivers/cpufreq/Makefile                           |   26 +++
 .../kernel/cpu => drivers}/cpufreq/acpi-cpufreq.c  |   45 ++---
 .../cpu => drivers}/cpufreq/cpufreq-nforce2.c      |    6 +-
 drivers/cpufreq/cpufreq.c                          |  196 ++++++--------------
 drivers/cpufreq/cpufreq_performance.c              |    5 +-
 drivers/cpufreq/cpufreq_powersave.c                |    5 +-
 drivers/cpufreq/cpufreq_stats.c                    |    3 +-
 drivers/cpufreq/cpufreq_userspace.c                |   13 +-
 .../kernel/cpu => drivers}/cpufreq/e_powersaver.c  |    0
 .../x86/kernel/cpu => drivers}/cpufreq/elanfreq.c  |    0
 drivers/cpufreq/freq_table.c                       |   19 +-
 .../kernel/cpu => drivers}/cpufreq/gx-suspmod.c    |   21 +--
 .../x86/kernel/cpu => drivers}/cpufreq/longhaul.c  |   11 +-
 .../x86/kernel/cpu => drivers}/cpufreq/longhaul.h  |    0
 {arch/x86/kernel/cpu => drivers}/cpufreq/longrun.c |   17 +-
 {arch/x86/kernel/cpu => drivers}/cpufreq/mperf.c   |    0
 {arch/x86/kernel/cpu => drivers}/cpufreq/mperf.h   |    0
 .../kernel/cpu => drivers}/cpufreq/p4-clockmod.c   |   10 +-
 .../kernel/cpu => drivers}/cpufreq/pcc-cpufreq.c   |   51 +++---
 .../kernel/cpu => drivers}/cpufreq/powernow-k6.c   |    0
 .../kernel/cpu => drivers}/cpufreq/powernow-k7.c   |   33 ++--
 .../kernel/cpu => drivers}/cpufreq/powernow-k7.h   |    0
 .../kernel/cpu => drivers}/cpufreq/powernow-k8.c   |  100 +++++-----
 .../kernel/cpu => drivers}/cpufreq/powernow-k8.h   |    2 -
 .../kernel/cpu => drivers}/cpufreq/sc520_freq.c    |    6 +-
 .../cpu => drivers}/cpufreq/speedstep-centrino.c   |   23 +--
 .../kernel/cpu => drivers}/cpufreq/speedstep-ich.c |   28 ++--
 .../kernel/cpu => drivers}/cpufreq/speedstep-lib.c |   43 ++---
 .../kernel/cpu => drivers}/cpufreq/speedstep-lib.h |    0
 .../kernel/cpu => drivers}/cpufreq/speedstep-smi.c |   41 ++---
 include/linux/cpufreq.h                            |   52 ++----
 40 files changed, 344 insertions(+), 529 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/cpufreq/Makefile
 rename arch/x86/kernel/cpu/cpufreq/Kconfig => drivers/cpufreq/Kconfig.x86 (97%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/acpi-cpufreq.c (94%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/cpufreq-nforce2.c (97%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/e_powersaver.c (100%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/elanfreq.c (100%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/gx-suspmod.c (95%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/longhaul.c (98%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/longhaul.h (100%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/longrun.c (94%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/mperf.c (100%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/mperf.h (100%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/p4-clockmod.c (96%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/pcc-cpufreq.c (91%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/powernow-k6.c (100%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/powernow-k7.c (95%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/powernow-k7.h (100%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/powernow-k8.c (93%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/powernow-k8.h (98%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/sc520_freq.c (95%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/speedstep-centrino.c (96%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/speedstep-ich.c (92%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/speedstep-lib.c (90%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/speedstep-lib.h (100%)
 rename {arch/x86/kernel/cpu => drivers}/cpufreq/speedstep-smi.c (90%)

commit ff397e04dcca765e054ffb1ffc9d65fabe357a41
Author: Dave Jones <davej@redhat.com>
Date:   Fri Apr 29 16:09:37 2011 -0400

    [CPUFREQ] Move x86 drivers to drivers/cpufreq/
    
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 84a20cad52e92e51a3a280cae7bcd2af0407a881
Author: Thiago Farina <tfransosi@gmail.com>
Date:   Thu Apr 28 20:42:53 2011 -0300

    [CPUFREQ] cpufreq.h: Fix some checkpatch.pl coding style issues.
    
    Before:
    $ scripts/checkpatch.pl --file --terse include/linux/cpufreq.h
    total: 14 errors, 11 warnings, 419 lines checked
    
    After:
    $ scripts/checkpatch.pl --file --terse include/linux/cpufreq.h
    total: 2 errors, 4 warnings, 422 lines checked
    
    Signed-off-by: Thiago Farina <tfransosi@gmail.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit dbe566fdf03ae56db008abbcd0aba306efd94d06
Author: Dominik Brodowski <linux@dominikbrodowski.net>
Date:   Sun Mar 27 15:04:46 2011 +0200

    [CPUFREQ] use dynamic debug instead of custom infrastructure
    
    With dynamic debug having gained the capability to report debug messages
    also during the boot process, it offers a far superior interface for
    debug messages than the custom cpufreq infrastructure. As a first step,
    remove the old cpufreq_debug_printk() function and replace it with a call
    to the generic pr_debug() function.
    
    How can dynamic debug be used on cpufreq? You need a kernel which has
    CONFIG_DYNAMIC_DEBUG enabled.
    
    To enabled debugging during runtime, mount debugfs and
    
    $ echo -n 'module cpufreq +p' > /sys/kernel/debug/dynamic_debug/control
    
    for debugging the complete "cpufreq" module. To achieve the same goal during
    boot, append
    
    	ddebug_query="module cpufreq +p"
    
    as a boot parameter to the kernel of your choice.
    
    For more detailled instructions, please see
    Documentation/dynamic-debug-howto.txt
    
    Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit d94e52b8d0399331dd500394b8fdcfd997360513
Author: Jacob Shin <jacob.shin@amd.com>
Date:   Wed Apr 27 13:32:11 2011 -0500

    [CPUFREQ] CPU hotplug, re-create sysfs directory and symlinks
    
    When we discover CPUs that are affected by each other's
    frequency/voltage transitions, the first CPU gets a sysfs directory
    created, and rest of the siblings get symlinks. Currently, when we
    hotplug off only the first CPU, all of the symlinks and the sysfs
    directory gets removed. Even though rest of the siblings are still
    online and functional, they are orphaned, and no longer governed by
    cpufreq.
    
    This patch, given the above scenario, creates a sysfs directory for
    the first sibling and symlinks for the rest of the siblings.
    
    Please note the recursive call, it was rather too ugly to roll it
    out. And the removal of redundant NULL setting (it is already taken
    care of near the top of the function).
    
    Signed-off-by: Jacob Shin <jacob.shin@amd.com>
    Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
    Reviewed-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 877e916ea365196a5fd61d60fdaea635e9f5bd4b
Author: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Date:   Tue Apr 26 17:05:18 2011 +0000

    [CPUFREQ] Fix _OSC UUID in pcc-cpufreq
    
    UUID needs to be written out the way it is described in
    Sec 18.5.124 of ACPI 4.0a Specification.
    
    Platform firmware's use of this UUID/_OSC is optional, which is
    why we didn't notice this bug earlier.
    
    Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit a90f86460371305c069eb0c2ffb65026a1994605
Author: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
Date:   Fri Apr 1 17:34:47 2011 -0500

    [CPUFREQ] Drivers: cpufreq/cpufreq_stats.c: Fixed brace coding style issue
    
    Fixed brace coding style issue.
    
    Signed-off-by: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
    Signed-off-by: Dave Jones <davej@redhat.com>
