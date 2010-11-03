Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0KCFtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 01:49:01 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:46237 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab0KCFs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 01:48:57 -0400
Date: Wed, 03 Nov 2010 01:48:20 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [git 2.6.32.stable] intel_idle driver for 2.6.32.stable
Message-id: <alpine.LFD.2.00.1011030138010.3378@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_idle for 2.6.32.stable is available in git:

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

and also as a plain patch:

http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.32/idle-release-2.6.32.25.diff.gz

The patch series is summarized below.

cheers,
-Len Brown, Intel Open Source Technology Center

 MAINTAINERS                      |    7 +
 arch/x86/include/asm/mwait.h     |   15 ++
 arch/x86/kernel/acpi/cstate.c    |   11 +-
 drivers/Makefile                 |    2 +-
 drivers/acpi/acpi_pad.c          |    7 +-
 drivers/acpi/processor_core.c    |   15 +-
 drivers/cpuidle/cpuidle.c        |   43 ++++-
 drivers/cpuidle/cpuidle.h        |    1 -
 drivers/cpuidle/driver.c         |   16 ++-
 drivers/cpuidle/governors/menu.c |   23 ++-
 drivers/cpuidle/sysfs.c          |    5 +-
 drivers/idle/Kconfig             |   10 +
 drivers/idle/Makefile            |    1 +
 drivers/idle/intel_idle.c        |  448 ++++++++++++++++++++++++++++++++++++++
 include/linux/cpuidle.h          |   13 +-
 15 files changed, 575 insertions(+), 42 deletions(-)
 create mode 100644 arch/x86/include/asm/mwait.h
 create mode 100644 drivers/idle/intel_idle.c

through these commits:

Ai Li (1):
      cpuidle: extend cpuidle and menu governor to handle dynamic states

Arjan van de Ven (1):
      intel_idle: recognize Lincroft Atom Processor

H. Peter Anvin (1):
      x86, mwait: Move mwait constants to a common header file

Len Brown (15):
      cpuidle: fail to register if !CONFIG_CPU_IDLE
      cpuidle: add cpuidle_unregister_driver() error check
      cpuidle: make cpuidle_curr_driver static
      ACPI: allow a native cpuidle driver to displace ACPI
      intel_idle: native hardware cpuidle driver for latest Intel processors
      intel_idle: delete substates DEBUG modparam
      intel_idle: delete power_policy modparam, and choose substate functions
      intel_idle: add support for Westmere-EX
      intel_idle: disable module support
      intel_idle: no longer EXPERIMENTAL
      intel_idle: enable Atom C6
      intel_idle: simplify test for leave_mm()
      intel_idle: delete bogus data from cpuidle_state.power_usage
      intel_idle: add initial Sandy Bridge support
      intel_idle: do not use the LAPIC timer for ATOM C2

Suresh Siddha (1):
      intel_idle: Voluntary leave_mm before entering deeper

Thomas Weber (1):
      intel_idle: Change mode 755 => 644

with this log:

commit 4a72ecc67d0d722ad14516b22e0761150ea8201f
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 23 23:25:53 2010 -0400

    intel_idle: do not use the LAPIC timer for ATOM C2
    
    If we use the LAPIC timer during ATOM C2 on
    some nvidia chisets, the system stalls.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=21032
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8742ad1eb53c3a91934e22a17c22bbb550faf641
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 7 00:12:03 2010 -0400

    intel_idle: add initial Sandy Bridge support
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a244fb119774d591a12cb94ebe15ed90d90fab40
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 21:23:25 2010 -0400

    intel_idle: delete bogus data from cpuidle_state.power_usage
    
    The mW data in this field is a total fabrication
    and serves no purpose other than to mislead
    those who might see it in sysfs.  Delete it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 56aed0ade2eea84a3590e7d5d24a97389a4e9ce6
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 20:43:06 2010 -0400

    intel_idle: simplify test for leave_mm()
    
    A run-time test to invoke leave_mm() for the deepest
    supported C-state is redundant, since the appropriate
    C-states already have flags with CPUIDLE_FLAG_TLB_FLUSHED set.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e4e857d0564162a993b74b08d890cdf813d6ad7e
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Fri Sep 17 15:36:40 2010 -0700

    x86, mwait: Move mwait constants to a common header file
    
    We have MWAIT constants spread across three different .c files, for no
    good reason.  Move them all into a common header file.
    
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
    Cc: Len Brown <lenb@kernel.org>
    LKML-Reference: <tip-*@git.kernel.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 585572a8bf160978fd30ad037aa743b551176817
Author: Len Brown <len.brown@intel.com>
Date:   Tue Oct 5 13:43:14 2010 -0400

    intel_idle: enable Atom C6
    
    ATM-C6 was commented out, pending public documentation.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=19762
    
    Tested-by: Dennis Jansen <Dennis.Jansen@...>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9b4bab268c14082aa085523326dc3a80a5b8260d
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Thu Sep 30 21:19:07 2010 -0400

    intel_idle: Voluntary leave_mm before entering deeper
    
    Avoid TLB flush IPIs for the cores in deeper c-states by voluntary leave_mm()
    before entering into that state. CPUs tend to flush TLB in those c-states
    anyways.
    
    acpi_idle does this with C3-type states, but it was not caried over
    when intel_idle was introduced.  intel_idle can apply it
    to C-states in addition to those that ACPI might export as C3...
    
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cab349dee0df0cc3984a124b7c13791c1244d7ed
Author: Ai Li <aili@codeaurora.org>
Date:   Mon Aug 9 17:20:13 2010 -0700

    cpuidle: extend cpuidle and menu governor to handle dynamic states
    
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
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6a06b21da93f610aacdad69f22907671195c770f
Author: Thomas Weber <weber@corscience.de>
Date:   Mon Jul 12 08:56:43 2010 +0200

    intel_idle: Change mode 755 => 644
    
    Remove execution permission from source file.
    
    Signed-off-by: Thomas Weber <weber@corscience.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 004fa204948744d2dec47f7403bab91346865e86
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Wed Jul 21 23:42:25 2010 -0400

    intel_idle: recognize Lincroft Atom Processor
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0d6b75b069efbd0fccd12c659c98053bb735651e
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 14 14:44:08 2010 -0400

    intel_idle: no longer EXPERIMENTAL
    
    This is a fully supported driver.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ac42593b4e644676de0b79ac1fdaaf92792274dd
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 14 14:40:36 2010 -0400

    intel_idle: disable module support
    
    Right now the module capability is cauing more trouble
    than it is worth.  At least one distro built intel_idle as a module
    where it lost the init race with ACPI, making it useless.
    
    Make intel_idle bool so that if you select it, you will use it.
    
    We can restore module capability after cpuidle is enhanced
    to handle run-time changing of idle drivers.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8caa41b55daf1b2b2941549c9ef38a8558090c07
Author: Len Brown <len.brown@intel.com>
Date:   Mon Jul 26 23:40:19 2010 -0400

    intel_idle: add support for Westmere-EX
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 55d53f89a3d47f622be0cda9553f0cf9a6ad4a4c
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jul 23 16:04:46 2010 -0400

    intel_idle: delete power_policy modparam, and choose substate functions
    
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

commit 0aa4bd37b8f5c2a728eef4b3abd9162f0900a4f0
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 28 02:22:03 2010 -0400

    intel_idle: delete substates DEBUG modparam
    
    it isn't useful anymore
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6337fa0599b79761c3e3b1e2bb397ad9c0409086
Author: Len Brown <len.brown@intel.com>
Date:   Mon Mar 8 14:07:30 2010 -0500

    intel_idle: native hardware cpuidle driver for latest Intel processors
    
    This EXPERIMENTAL driver supersedes acpi_idle on
    Intel Atom Processors, Intel Core i3/i5/i7 Processors
    and associated Intel Xeon processors.
    
    It does not support the Intel Core2 processor or earlier.
    
    For kernels configured with ACPI, CONFIG_INTEL_IDLE=y
    allows intel_idle to probe before the ACPI processor driver.
    Booting with "intel_idle.max_cstate=0" disables intel_idle
    and the system will fall back on ACPI's "acpi_idle".
    
    Typical Linux distributions load ACPI processor module early,
    making CONFIG_INTEL_IDLE=m not easily useful on ACPI platforms.
    
    intel_idle probes all processors at module_init time.
    Processors that are hot-added later will be limited
    to using C1 in idle.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8a73284f4c0b95fe0d1c8f27fbdaac2763dcff74
Author: Len Brown <len.brown@intel.com>
Date:   Sat May 22 17:03:29 2010 -0400

    ACPI: allow a native cpuidle driver to displace ACPI
    
    The ACPI driver would fail probe when it found that
    another driver had previously registered with cpuidle.
    
    But this is a natural situation, as a native hardware
    cpuidle driver should be able to bind instead of ACPI,
    and the ACPI processor driver should be able to handle
    yielding control of C-states while still handling
    P-states and T-states.
    
    Add a KERN_DEBUG line showing when acpi_idle
    does successfully register.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e1bb0411e0f791719e12ffc0b6bd403857ddae0f
Author: Len Brown <len.brown@intel.com>
Date:   Sat May 22 16:57:26 2010 -0400

    cpuidle: make cpuidle_curr_driver static
    
    cpuidle_register_driver() sets cpuidle_curr_driver
    cpuidle_unregister_driver() clears cpuidle_curr_driver
    
    We should't expose cpuidle_curr_driver to
    potential modification except via these interfaces.
    So make it static and create cpuidle_get_driver() to observe it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7a643ed4b275c5a1a418a051b40014a58e1de0ae
Author: Len Brown <len.brown@intel.com>
Date:   Sat May 22 16:34:10 2010 -0400

    cpuidle: add cpuidle_unregister_driver() error check
    
    Assure that cpuidle_unregister_driver() will not clobber
    the registered driver if unregistered by somebody else.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 429b500b87a38e008e9911d1798bfa7af298ee38
Author: Len Brown <len.brown@intel.com>
Date:   Tue May 11 16:50:52 2010 -0400

    cpuidle: fail to register if !CONFIG_CPU_IDLE
    
    Signed-off-by: Len Brown <len.brown@intel.com>
