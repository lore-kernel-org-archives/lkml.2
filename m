Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab1ALEVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 23:21:18 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:54148 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ALEVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 23:21:16 -0500
Date: Tue, 11 Jan 2011 23:20:50 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [git pull] tools/power patches for 2.6.38
Message-id: <alpine.LFD.2.02.1101112315270.11311@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git tools

This creates a power directory under tools/ and puts two new tools there,
turbostat and x86_energy_perf_policy.  While the tools/ directory is
not the most organized part of the kernel tree, this patch ups the
bar on some of code there by supplying Makefiles and man pages.

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-pm@lists.linux-foundation.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/tools/patches/2.6.37/acpi-tools-20101013-2.6.37.diff.gz

 tools/power/x86/turbostat/Makefile                 |    8 +
 tools/power/x86/turbostat/turbostat.8              |  172 ++++
 tools/power/x86/turbostat/turbostat.c              | 1048 ++++++++++++++++++++
 tools/power/x86/x86_energy_perf_policy/Makefile    |    8 +
 .../x86_energy_perf_policy.8                       |  104 ++
 .../x86_energy_perf_policy.c                       |  325 ++++++
 6 files changed, 1665 insertions(+), 0 deletions(-)
 create mode 100644 tools/power/x86/turbostat/Makefile
 create mode 100644 tools/power/x86/turbostat/turbostat.8
 create mode 100644 tools/power/x86/turbostat/turbostat.c
 create mode 100644 tools/power/x86/x86_energy_perf_policy/Makefile
 create mode 100644 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.8
 create mode 100644 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c

through these commits:

with this log:

commit eca0bdd326d2cf9127bbb6ac602bfbcbf169c10d
Merge: 3c0eee3 103a8fe d5532ee
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jan 11 23:06:28 2011 -0500

    Merge branches 'turbostat' and 'x86_energy_perf_policy' into tools

commit d5532ee7b40b4a64e605e543b0387694430ecb79
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 22 23:53:03 2010 -0400

    tools: create power/x86/x86_energy_perf_policy
    
    MSR_IA32_ENERGY_PERF_BIAS first became available on Westmere Xeon.
    It is implemented in all Sandy Bridge processors -- mobile, desktop and server.
    It is expected to become increasingly important in subsequent generations.
    
    x86_energy_perf_policy is a user-space utility to set the
    hardware energy vs performance policy hint in the processor.
    Most systems would benefit from "x86_energy_perf_policy normal"
    at system startup, as the hardware default is maximum performance
    at the expense of energy efficiency.
    
    See x86_energy_perf_policy.8 man page for more information.
    
    Background:
    
    Linux-2.6.36 added "epb" to /proc/cpuinfo to indicate
    if an x86 processor supports MSR_IA32_ENERGY_PERF_BIAS,
    without actually modifying the MSR.
    
    In March, 2010, Venkatesh Pallipadi proposed a small driver
    that programmed MSR_IA32_ENERGY_PERF_BIAS, based on
    the cpufreq governor in use.  It also offered
    a boot-time cmdline option to override.
    http://lkml.org/lkml/2010/3/4/457
    But hiding the hardware policy behind the
    governor choice was deemed "kinda icky".
    
    In June, 2010, I proposed a generic user/kernel API to
    generalize the power/performance policy trade-off.
    "RFC: /sys/power/policy_preference"
    http://lkml.org/lkml/2010/6/16/399
    That is my preference for implementing this capability,
    but I received no support on the list.
    
    So in September, 2010, I sent x86_energy_perf_policy.c to LKML,
    a user-space utility that scribbles directly to the MSR.
    http://lkml.org/lkml/2010/9/28/246
    
    Here is that same utility, after responding to some review feedback,
    to live in tools/power/, where it is easily found.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 103a8fea9b420d5faef43bb87332a28e2129816a
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 22 23:53:03 2010 -0400

    tools: create power/x86/turbostat
    
    turbostat is a Linux tool to observe proper operation
    of Intel(R) Turbo Boost Technology.
    
    turbostat displays the actual processor frequency
    on x86 processors that include APERF and MPERF MSRs.
    
    Note that turbostat is of limited utility on Linux
    kernels 2.6.29 and older, as acpi_cpufreq cleared
    APERF/MPERF up through that release.
    
    On Intel Core i3/i5/i7 (Nehalem) and newer processors,
    turbostat also displays residency in idle power saving states,
    which are necessary for diagnosing any cpuidle issues
    that may have an effect on turbo-mode.
    
    See the turbostat.8 man page for example usage.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
