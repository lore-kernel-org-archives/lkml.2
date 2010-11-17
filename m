Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934627Ab0KQI2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:28:44 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:64992 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934594Ab0KQI2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:28:43 -0500
Date: Wed, 17 Nov 2010 03:28:24 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: stable@kernel.org
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull 2.6.36.stable] intel_idle patches for 2.6.36.stable
In-reply-to: <alpine.LFD.2.00.1011151227190.2939@x980>
Message-id: <alpine.LFD.2.00.1011170322270.24426@x980>
References: <alpine.LFD.2.00.1011151227190.2939@x980>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I've added upstream commit id's to each commit comment in this series.
If that is enough to make -stable happy, then we're done.

If you would rather not pull this series because it
does not exclude the intermediate syntax patches that
are upstream, then I understand that viewpoint too.

thanks,
-Len Brown, Intel Open Source Technology Center
---

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.36.git idle-release

to sync 2.6.36.y with upstream changes to the intel_idle driver.

After applying this series, 2.6.36.y and upstream intel_idle.c
are identical.

This will update the files shown below.

ps. a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.35/idle-release-2.6.35.8.diff.gz

 arch/x86/include/asm/mwait.h     |   15 ++++
 arch/x86/kernel/acpi/cstate.c    |   11 +---
 drivers/acpi/acpi_pad.c          |    7 +--
 drivers/cpuidle/cpuidle.c        |   31 ++++++++
 drivers/cpuidle/governors/menu.c |   23 ++++--
 drivers/idle/intel_idle.c        |  149 +++++++++++++++++---------------------
 include/linux/cpuidle.h          |    5 ++
 7 files changed, 137 insertions(+), 104 deletions(-)
 create mode 100644 arch/x86/include/asm/mwait.h
 mode change 100755 => 100644 drivers/idle/intel_idle.c

through these commits:

Ai Li (1):
      cpuidle: extend cpuidle and menu governor to handle dynamic states

Arjan van de Ven (1):
      intel_idle: recognize Lincroft Atom Processor

H. Peter Anvin (1):
      x86, mwait: Move mwait constants to a common header file

Len Brown (8):
      intel_idle: delete substates DEBUG modparam
      intel_idle: delete power_policy modparam, and choose substate functions
      intel_idle: add support for Westmere-EX
      intel_idle: enable Atom C6
      intel_idle: simplify test for leave_mm()
      intel_idle: delete bogus data from cpuidle_state.power_usage
      intel_idle: add initial Sandy Bridge support
      intel_idle: do not use the LAPIC timer for ATOM C2

Namhyung Kim (1):
      intel_idle: add missing __percpu markup

Suresh Siddha (1):
      intel_idle: Voluntary leave_mm before entering deeper

Thomas Weber (1):
      intel_idle: Change mode 755 => 644

with this log:

commit 6a059cb9befbfa7bd6679d979aa1594a1d101711
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 23 23:25:53 2010 -0400

    intel_idle: do not use the LAPIC timer for ATOM C2
    
    upstream: c25d29952b2a8c9aaf00e081c9162a0e383030cd
    
    If we use the LAPIC timer during ATOM C2 on
    some nvidia chisets, the system stalls.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=21032
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5561b5a10961288f8748feeb750d6aec3579431f
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 7 00:12:03 2010 -0400

    intel_idle: add initial Sandy Bridge support
    
    upstream: d13780d439d08a57c87c1a07b6e76ddde61da1aa
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0b60f7ae3ae18c5092d238746b6bdd07146fa985
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 21:23:25 2010 -0400

    intel_idle: delete bogus data from cpuidle_state.power_usage
    
    upstream: dea44c6b7df7f8bb67cb059b4c14b24288c4cd04
    
    The mW data in this field is a total fabrication
    and serves no purpose other than to mislead
    those who might see it in sysfs.  Delete it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8e4bdfd5583a2cd7ef8147d68ba14ed9012c3c85
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 20:43:06 2010 -0400

    intel_idle: simplify test for leave_mm()
    
    upstream: c8381cc3d8a9cc6c80f65bf60863c776651f245c
    
    A run-time test to invoke leave_mm() for the deepest
    supported C-state is redundant, since the appropriate
    C-states already have flags with CPUIDLE_FLAG_TLB_FLUSHED set.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f22be1a8995b4150efd3ecd411081b3aabda56b9
Author: Len Brown <len.brown@intel.com>
Date:   Tue Oct 5 13:43:14 2010 -0400

    intel_idle: enable Atom C6
    
    upstream: 7fcca7d900957b43c84da171b750afcf1682808a
    
    ATM-C6 was commented out, pending public documentation.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=19762
    
    Tested-by: Dennis Jansen <Dennis.Jansen@...>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b58d00fe466fa87a70b45c9dd7a96c35f2059d46
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Thu Sep 30 21:19:07 2010 -0400

    intel_idle: Voluntary leave_mm before entering deeper
    
    upstream: 6110a1f43c27b516e16d5ce8860fca50748c2a87
    
    Avoid TLB flush IPIs for the cores in deeper c-states by voluntary leave_mm()
    before entering into that state. CPUs tend to flush TLB in those c-states
    anyways.
    
    acpi_idle does this with C3-type states, but it was not caried over
    when intel_idle was introduced.  intel_idle can apply it
    to C-states in addition to those that ACPI might export as C3...
    
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a75baccab28d82e0df59bff8d71abcbebf00f1bf
Author: Ai Li <aili@codeaurora.org>
Date:   Mon Aug 9 17:20:13 2010 -0700

    cpuidle: extend cpuidle and menu governor to handle dynamic states
    
    upstream: 71abbbf856a0e70ca478782505c800891260ba84
    
    On some SoC chips, HW resources may be in use during any particular idle
    period.  As a consequence, the cpuidle states that the SoC is safe to
    enter can change from idle period to idle period.  In addition, the
    latency and threshold of each cpuidle state can vary, depending on the
    operating condition when the CPU becomes idle, e.g.  the current cpu
    frequency, the current state of the HW blocks, etc.
    
    cpuidle core and the menu governor, in the current form, are geared
    towards cpuidle states that are static, i.e.  the availabiltiy of the
    states, their latencies, their thresholds are non-changing during run
    time.  cpuidle does not provide any hook that cpuidle drivers can use to
    adjust those values on the fly for the current idle period before the menu
    governor selects the target cpuidle state.
    
    This patch extends cpuidle core and the menu governor to handle states
    that are dynamic.  There are three additions in the patch and the patch
    maintains backwards-compatibility with existing cpuidle drivers.
    
    1) add prepare() to struct cpuidle_device.  A cpuidle driver can hook
       into the callback and cpuidle will call prepare() before calling the
       governor's select function.  The callback gives the cpuidle driver a
       chance to update the dynamic information of the cpuidle states for the
       current idle period, e.g.  state availability, latencies, thresholds,
       power values, etc.
    
    2) add CPUIDLE_FLAG_IGNORE as one of the state flags.  In the prepare()
       function, a cpuidle driver can set/clear the flag to indicate to the
       menu governor whether a cpuidle state should be ignored, i.e.  not
       available, during the current idle period.
    
    3) add power_specified bit to struct cpuidle_device.  The menu governor
       currently assumes that the cpuidle states are arranged in the order of
       increasing latency, threshold, and power savings.  This is true or can
       be made true for static states.  Once the state parameters are dynamic,
       the latencies, thresholds, and power savings for the cpuidle states can
       increase or decrease by different amounts from idle period to idle
       period.  So the assumption of increasing latency, threshold, and power
       savings from Cn to C(n+1) can no longer be guaranteed.
    
    It can be straightforward to calculate the power consumption of each
    available state and to specify it in power_usage for the idle period.
    Using the power_usage fields, the menu governor then selects the state
    that has the lowest power consumption and that still satisfies all other
    critieria.  The power_specified bit defaults to 0.  For existing cpuidle
    drivers, cpuidle detects that power_specified is 0 and fills in a dummy
    set of power_usage values.
    
    Signed-off-by: Ai Li <aili@codeaurora.org>
    Cc: Len Brown <len.brown@intel.com>
    Acked-by: Arjan van de Ven <arjan@linux.intel.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Venkatesh Pallipadi <venki@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit b9f18c200c48d2cd851763843eeaecc22b932959
Author: Namhyung Kim <namhyung@gmail.com>
Date:   Sun Aug 8 03:10:03 2010 +0900

    intel_idle: add missing __percpu markup
    
    upstream: 3265eba0bed7645cacd5e2cb3614d504b5ac29e6
    
    intel_idle_cpuidle_devices is a percpu pointer
    but was missing __percpu markup.
    
    Signed-off-by: Namhyung Kim <namhyung@gmail.com>
    Acked-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 22bef8cef0e24982c49be2080f15b2acac471023
Author: Thomas Weber <weber@corscience.de>
Date:   Mon Jul 12 08:56:43 2010 +0200

    intel_idle: Change mode 755 => 644
    
    upstream: 68f160125f0655c21a1c9f896ddff97d98012cb0
    
    Remove execution permission from source file.
    
    Signed-off-by: Thomas Weber <weber@corscience.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3ed9263fe2db73b82909b93d7995f4f402e50959
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Fri Sep 17 15:36:40 2010 -0700

    x86, mwait: Move mwait constants to a common header file
    
    upstream: bc83cccc761953f878088cdfa682de0970b5561f
    
    We have MWAIT constants spread across three different .c files, for no
    good reason.  Move them all into a common header file.
    
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
    Cc: Len Brown <lenb@kernel.org>
    LKML-Reference: <tip-*@git.kernel.org>

commit 0b4281f91f5651f818fa8a0ae89e90ffcafb394b
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Wed Jul 21 23:42:25 2010 -0400

    intel_idle: recognize Lincroft Atom Processor
    
    upstream: 4725fd3ce970c27a1678fb0809bfc7c2f4ac3e4f
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2eef191712247f3924ac6396e763aad2009d42dd
Author: Len Brown <len.brown@intel.com>
Date:   Mon Jul 26 23:40:19 2010 -0400

    intel_idle: add support for Westmere-EX
    
    upstream: ec67a2ba360d4874b1158e6e87fe1e859b0c9117
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b8dc00bc475902f33408ffe61301e7e2947ef813
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jul 23 16:04:46 2010 -0400

    intel_idle: delete power_policy modparam, and choose substate functions
    
    upstream: 0394c6676e3fa48587fbe4821390d3264672c530
    
    The idea behind power policy was that it would start off as a modparam,
    and then hook into the new "global" in-kernel power vs energy tunable.
    But that tunable isn't happening, so delete the hook here.
    
    With the policy hook gone, the sub-state choice functions
    do not do anything useful, so delete them from the critical path.
    
    To handle sub-states in the future, we will advertise them
    with dedicated cpuidle_state entries.  That is necessary
    because some of the sub-states will have substantially different
    properties than their peer sub-states.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 313d1cff4a3d0fcf03e39147b3052bb4d0af4bc9
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 28 02:22:03 2010 -0400

    intel_idle: delete substates DEBUG modparam
    
    upstream: c4236282e5921a410e8f074fec795b6ca0af36d5
    
    it isn't useful anymore
    
    Signed-off-by: Len Brown <len.brown@intel.com>
