Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab1ESPDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab1ESPDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:03:48 -0400
Date: Thu, 19 May 2011 11:03:43 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CPUFREQ git pull for 2.6.40 [1/2] [fixed]
Message-ID: <20110519150342.GB5076@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110519145605.GA5076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519145605.GA5076@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops, sent wrong pull request from last cycle. Here's the correct one.

Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ next

 arch/arm/mach-davinci/cpufreq.c                  |    4 +-
 arch/blackfin/mach-common/dpmc.c                 |    3 -
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c          |   44 ++---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   45 ++---
 arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c    |    6 +-
 arch/x86/kernel/cpu/cpufreq/gx-suspmod.c         |   21 +--
 arch/x86/kernel/cpu/cpufreq/longhaul.c           |   11 +-
 arch/x86/kernel/cpu/cpufreq/longrun.c            |   17 +-
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c        |   10 +-
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c        |   51 +++---
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c        |   33 ++--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |  100 +++++-----
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h        |    2 -
 arch/x86/kernel/cpu/cpufreq/sc520_freq.c         |    6 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   23 +--
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |   28 ++--
 arch/x86/kernel/cpu/cpufreq/speedstep-lib.c      |   43 ++---
 arch/x86/kernel/cpu/cpufreq/speedstep-smi.c      |   41 ++---
 drivers/acpi/processor_perflib.c                 |    6 +-
 drivers/cpufreq/Kconfig                          |   13 --
 drivers/cpufreq/cpufreq.c                        |  215 ++++++----------------
 drivers/cpufreq/cpufreq_performance.c            |    5 +-
 drivers/cpufreq/cpufreq_powersave.c              |    5 +-
 drivers/cpufreq/cpufreq_stats.c                  |   24 ++-
 drivers/cpufreq/cpufreq_userspace.c              |   13 +-
 drivers/cpufreq/freq_table.c                     |   19 +-
 include/linux/cpufreq.h                          |   52 ++----
 27 files changed, 331 insertions(+), 509 deletions(-)

commit 1a8e1463a49aaa452da1cefe184a00d4df47f1ef
Author: Kees Cook <kees.cook@canonical.com>
Date:   Wed May 4 08:38:56 2011 -0700

    [CPUFREQ] remove redundant sprintf from request_module call.
    
    Since format string handling is part of request_module, there is no
    need to construct the module name. As such, drop the redundant sprintf
    and heap usage.
    
    Signed-off-by: Kees Cook <kees.cook@canonical.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 469057d587a9de2cd6087d71a008b908e785a5b6
Author: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
Date:   Fri Apr 1 17:34:47 2011 -0500

    [CPUFREQ] cpufreq_stats.c: Fixed brace coding style issue
    
    Fixed brace coding style issue.
    
    Signed-off-by: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 98586ed8b8878e10691203687e89a42fa3355300
Author: steven finney <Steven.Finney@palm.com>
Date:   Mon May 2 11:29:17 2011 -0700

    [CPUFREQ] Fix memory leak in cpufreq_stat
    
    When a CPU is taken offline in an SMP system, cpufreq_remove_dev()
    nulls out the per-cpu policy before cpufreq_stats_free_table() can
    make use of it.  cpufreq_stats_free_table() then skips the
    call to sysfs_remove_group(), leaving about 100 bytes of sysfs-related
    memory unclaimed each time a CPU-removal occurs. Break up
    cpu_stats_free_table into sysfs and table portions, and
    call the sysfs portion early.
    
    Signed-off-by: Steven Finney <steven.finney@palm.com>
    Signed-off-by: Dave Jones <davej@redhat.com>
    Cc: stable@kernel.org

commit 335dc3335ff692173bc766b248f7a97f3a23b30a
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

commit 2d06d8c49afdcc9bb35a85039fa50f0fe35bd40e
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

commit 27ecddc2a9f99ce4ac9a59a0acd77f7100b6d034
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
    Cc: stable@kernel.org

commit 904cc1e637a00dba1b58e7752f485f90ebf2a568
Author: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Date:   Tue Apr 26 17:05:18 2011 +0000

    [CPUFREQ] Fix _OSC UUID in pcc-cpufreq
    
    UUID needs to be written out the way it is described in
    Sec 18.5.124 of ACPI 4.0a Specification.
    
    Platform firmware's use of this UUID/_OSC is optional, which is
    why we didn't notice this bug earlier.
    
    Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
    Signed-off-by: Dave Jones <davej@redhat.com>
    Cc: stable@kernel.org

