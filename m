Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934599Ab0KQIVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:21:41 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:56785 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523Ab0KQIVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:21:39 -0500
Date: Wed, 17 Nov 2010 03:21:19 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [git 2.6.32.stable] intel_idle driver for 2.6.32.stable
In-reply-to: <alpine.LFD.2.00.1011030138010.3378@localhost.localdomain>
Message-id: <alpine.LFD.2.00.1011170315050.24426@x980>
References: <alpine.LFD.2.00.1011030138010.3378@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added the upstream commit id's to each patch,
but the idle-release branch is otherwise unchanged.

cheers,
-Len Brown, Intel Open Source Technology Center.


intel_idle for 2.6.32.stable is available in git:

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.32.y.git 
idle-release

and also as a plain patch:

http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.32/idle-release-2.6.32.25.diff.gz

The patch series is summarized below.

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

commit 97e3bcac24f55fa6c3224f1bc39d08db73495cfb
Author: Len Brown <len.brown@intel.com>
Date:   Sat Oct 23 23:25:53 2010 -0400

    intel_idle: do not use the LAPIC timer for ATOM C2
    
    upstream: c25d29952b2a8c9aaf00e081c9162a0e383030cd
    
    If we use the LAPIC timer during ATOM C2 on
    some nvidia chisets, the system stalls.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=21032
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3f371943e54e8cbc8cdea3e543656d8e62f6b8a9
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jul 7 00:12:03 2010 -0400

    intel_idle: add initial Sandy Bridge support
    
    upstream: d13780d439d08a57c87c1a07b6e76ddde61da1aa
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 263d2d9ba1fd6f8baa2003d46ff1b32733585903
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 21:23:25 2010 -0400

    intel_idle: delete bogus data from cpuidle_state.power_usage
    
    upstream: dea44c6b7df7f8bb67cb059b4c14b24288c4cd04
    
    The mW data in this field is a total fabrication
    and serves no purpose other than to mislead
    those who might see it in sysfs.  Delete it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 731dafe015fc308b40eaf9cc1838739d74554a72
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 20:43:06 2010 -0400

    intel_idle: simplify test for leave_mm()
    
    upstream: c8381cc3d8a9cc6c80f65bf60863c776651f245c
    
    A run-time test to invoke leave_mm() for the deepest
    supported C-state is redundant, since the appropriate
    C-states already have flags with CPUIDLE_FLAG_TLB_FLUSHED set.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0d377ee9506d73b26852a9f2a03e87412532a83a
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
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b302246d3ba6e822e23193516385bd82c3e1d957
Author: Len Brown <len.brown@intel.com>
Date:   Tue Oct 5 13:43:14 2010 -0400

    intel_idle: enable Atom C6
    
    upstream: 7fcca7d900957b43c84da171b750afcf1682808a
    
    ATM-C6 was commented out, pending public documentation.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=19762
    
    Tested-by: Dennis Jansen <Dennis.Jansen@...>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 13fec6ba1116ea16dd28d54cc92a5f19fa1460f5
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

commit 1b4cde4b819b532319b4972355968ea48ad06157
Author: Ai Li <aili@codeaurora.org>
Date:   Mon Aug 9 17:20:13 2010 -0700

    cpuidle: extend cpuidle and menu governor to handle dynamic states
    
    cpuidle: 71abbbf856a0e70ca478782505c800891260ba84
    
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

commit bb55febc2a2b41014e8c34ea312848574ac96f5e
Author: Thomas Weber <weber@corscience.de>
Date:   Mon Jul 12 08:56:43 2010 +0200

    intel_idle: Change mode 755 => 644
    
    upstream: 68f160125f0655c21a1c9f896ddff97d98012cb0
    
    Remove execution permission from source file.
    
    Signed-off-by: Thomas Weber <weber@corscience.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1d9ce17be4700a0115bf283c7ff1e67263cfc17a
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Wed Jul 21 23:42:25 2010 -0400

    intel_idle: recognize Lincroft Atom Processor
    
    upstream: 4725fd3ce970c27a1678fb0809bfc7c2f4ac3e4f
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 96076984bc88598023b7fdc823659c4a3ed444e3
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 14 14:44:08 2010 -0400

    intel_idle: no longer EXPERIMENTAL
    
    upstream: 5a5e28daea69652505ac07eb5fbda4d7f0534926
    
    This is a fully supported driver.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6e6c0dae2b32736f270c03f853a166c8b11567a0
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 14 14:40:36 2010 -0400

    intel_idle: disable module support
    
    upstream: 6ce9cd8669fa1195fdc21643370e34523c7ac988
    
    Right now the module capability is cauing more trouble
    than it is worth.  At least one distro built intel_idle as a module
    where it lost the init race with ACPI, making it useless.
    
    Make intel_idle bool so that if you select it, you will use it.
    
    We can restore module capability after cpuidle is enhanced
    to handle run-time changing of idle drivers.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e361b2321279f6c44392bc3e89b4895d68594b67
Author: Len Brown <len.brown@intel.com>
Date:   Mon Jul 26 23:40:19 2010 -0400

    intel_idle: add support for Westmere-EX
    
    upstream: ec67a2ba360d4874b1158e6e87fe1e859b0c9117
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 50ce5830e037e9bf934e3dfaeafb56f2be3f6bb1
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

commit 7b6d47c455d6c9388447ea466881e85864496636
Author: Len Brown <len.brown@intel.com>
Date:   Fri May 28 02:22:03 2010 -0400

    intel_idle: delete substates DEBUG modparam
    
    upstream: c4236282e5921a410e8f074fec795b6ca0af36d5
    
    it isn't useful anymore
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 08479e73c90ed7714ac733434539196025909544
Author: Len Brown <len.brown@intel.com>
Date:   Mon Mar 8 14:07:30 2010 -0500

    intel_idle: native hardware cpuidle driver for latest Intel processors
    
    upstream: 2671717265ae6e720a9ba5f13fbec3a718983b65
    
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

commit 86741cac7bbc7e9a9f20d3999a172a835d4cd152
Author: Len Brown <len.brown@intel.com>
Date:   Sat May 22 17:03:29 2010 -0400

    ACPI: allow a native cpuidle driver to displace ACPI
    
    upstream: 541adf7cd937b3895c7645406a9b060504df453b
    
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

commit 0f4465d44e93651c90813923268a8e9abcf89b58
Author: Len Brown <len.brown@intel.com>
Date:   Sat May 22 16:57:26 2010 -0400

    cpuidle: make cpuidle_curr_driver static
    
    upstream: 752138df0dc2daaae09379c754caeb08c97905dc
    
    cpuidle_register_driver() sets cpuidle_curr_driver
    cpuidle_unregister_driver() clears cpuidle_curr_driver
    
    We should't expose cpuidle_curr_driver to
    potential modification except via these interfaces.
    So make it static and create cpuidle_get_driver() to observe it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 329dc1a14c6ddfd71b0ecff1e2458f50258106cf
Author: Len Brown <len.brown@intel.com>
Date:   Sat May 22 16:34:10 2010 -0400

    cpuidle: add cpuidle_unregister_driver() error check
    
    upstream: c0d64cb031c21f163a0ec15cf10844bcf0ceedcf
    
    Assure that cpuidle_unregister_driver() will not clobber
    the registered driver if unregistered by somebody else.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5991bb561038bc6b7b0a1dbea741a64e499ae118
Author: Len Brown <len.brown@intel.com>
Date:   Tue May 11 16:50:52 2010 -0400

    cpuidle: fail to register if !CONFIG_CPU_IDLE
    
    upstream: 6b2c676bf32be91f43215d5874c07c1becaba013
    
    Signed-off-by: Len Brown <len.brown@intel.com>
