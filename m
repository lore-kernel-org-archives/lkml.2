Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab1CXDHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:07:09 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:38969 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab1CXDHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:07:06 -0400
Date: Wed, 23 Mar 2011 23:06:45 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] ACPI patches for 2.6.39
Message-id: <alpine.LFD.2.02.1103232258510.3848@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

I confess that I merged w/ your latest tree yesterday --
I had a dependency on a previous patch in the merge window.
So I stole your fun of resolving an adjacent hunk-delete conflict:-)

No headlines in this batch, mostly incremental improvements
to existing capabilities.

thanks!

Len Brown
Intel Open Source Technology Center

ps. individual patches are available on linux-acpi@vger.kernel.org

 Documentation/acpi/apei/output_format.txt  |   25 +
 Documentation/feature-removal-schedule.txt |    8 -
 arch/ia64/include/asm/acpi.h               |    6 +-
 arch/ia64/kernel/acpi.c                    |   23 +-
 arch/x86/include/asm/acpi.h                |    5 +-
 arch/x86/kernel/acpi/sleep.c               |   12 +-
 arch/x86/kernel/acpi/sleep.h               |    2 +
 arch/x86/kernel/cpu/mcheck/mce-apei.c      |   42 +-
 drivers/acpi/acpi_pad.c                    |   13 +-
 drivers/acpi/acpica/Makefile               |    4 +-
 drivers/acpi/acpica/acdispat.h             |   38 +-
 drivers/acpi/acpica/acglobal.h             |    4 +
 drivers/acpi/acpica/aclocal.h              |   19 -
 drivers/acpi/acpica/dsargs.c               |  391 +++++++++++++++
 drivers/acpi/acpica/dscontrol.c            |  410 ++++++++++++++++
 drivers/acpi/acpica/dsopcode.c             |  725 +---------------------------
 drivers/acpi/acpica/dswload.c              |  670 +-------------------------
 drivers/acpi/acpica/dswload2.c             |  720 +++++++++++++++++++++++++++
 drivers/acpi/acpica/evgpe.c                |    9 +
 drivers/acpi/acpica/evregion.c             |    2 +
 drivers/acpi/acpica/evxfregn.c             |   36 ++-
 drivers/acpi/acpica/exfldio.c              |    4 +-
 drivers/acpi/acpica/hwxface.c              |   10 +-
 drivers/acpi/acpica/tbfadt.c               |    5 +-
 drivers/acpi/acpica/utdecode.c             |  548 +++++++++++++++++++++
 drivers/acpi/acpica/utglobal.c             |  484 +------------------
 drivers/acpi/apei/Kconfig                  |    7 +
 drivers/acpi/apei/cper.c                   |   18 +-
 drivers/acpi/apei/erst-dbg.c               |   24 +-
 drivers/acpi/apei/erst.c                   |  235 ++++++++--
 drivers/acpi/battery.c                     |   22 +
 drivers/acpi/button.c                      |  174 +++----
 drivers/acpi/ec_sys.c                      |    4 -
 drivers/acpi/internal.h                    |    3 -
 drivers/acpi/nvs.c                         |   22 +-
 drivers/acpi/osl.c                         |  139 +++---
 drivers/acpi/pci_link.c                    |   30 +-
 drivers/acpi/processor_core.c              |   17 +-
 drivers/acpi/processor_driver.c            |    4 +-
 drivers/acpi/reboot.c                      |   14 +-
 drivers/acpi/scan.c                        |    1 -
 drivers/acpi/sleep.c                       |   28 +-
 drivers/pci/pci-acpi.c                     |   16 +-
 drivers/pci/pcie/aer/aerdrv.h              |    9 +-
 drivers/pci/pcie/aer/aerdrv_errprint.c     |  182 ++++---
 drivers/thermal/thermal_sys.c              |    3 +-
 include/acpi/acoutput.h                    |   12 +-
 include/acpi/acpi_bus.h                    |    1 -
 include/acpi/acpixf.h                      |    2 +-
 include/acpi/actbl.h                       |   16 +
 include/acpi/actbl2.h                      |   64 +++-
 include/acpi/apei.h                        |    5 +-
 include/linux/acpi_io.h                    |    3 +-
 include/linux/aer.h                        |   24 +
 include/linux/cper.h                       |    2 +
 55 files changed, 2921 insertions(+), 2375 deletions(-)
 create mode 100644 drivers/acpi/acpica/dsargs.c
 create mode 100644 drivers/acpi/acpica/dscontrol.c
 create mode 100644 drivers/acpi/acpica/dswload2.c
 create mode 100644 drivers/acpi/acpica/utdecode.c

through these commits:

Bob Moore (10):
      ACPICA: Remove use of unreliable FADT revision field
      ACPICA: Clarify a couple of error messages
      ACPICA: Split large utglobal into utdecode.c.
      ACPICA: Fix unresolved name issue for no-debug and no-error-msg cases
      ACPICA: Split large dsopcode and dsload.c files.
      ACPICA: Add support for FunctionalFixedHW in acpi_ut_get_region_name
      ACPICA: Add mechanism to defer _REG methods for some installed handlers
      ACPICA: Update version to 20110211.
      ACPICA: Header support for SLIC table
      ACPICA: Update version to 20110316

Durgadoss R (1):
      Thermal_Framework-Fix_crash_during_hwmon_unregister

Huang Ying (3):
      ACPI, APEI, Add ERST record ID cache
      PCIe, AER, use pre-generated prefix in error information printing
      ACPI, APEI, Add PCIe AER error information printing support

Jan Beulich (2):
      ACPI: use __init where possible in processor driver
      ACPI: use __cpuinit for the acpi_processor_set_pdc() call tree

Kyle McMartin (1):
      ACPI battery: fribble sysfs files from a resume notifier

Lin Ming (1):
      ACPICA: GPE detect optimization - ignore unused GPE registers

Matthew Garrett (3):
      ACPICA: Fix access width for reset vector
      ACPI: Bug compatibility for Windows on the ACPI reboot vector
      ACPI: Make sure the FADT is at least rev 2 before using the reset register

Naga Chumbalkar (2):
      ACPI: make acpi_pad /sys output more readable
      ACPI: minor printk format change in acpi_pad

Rafael J. Wysocki (18):
      ACPI: Do not export functions that are only used in osl.c
      ACPI: Change acpi_ioremap_lock into a mutex
      ACPI: Avoid walking the list of memory mappings in osl.c twice in a row
      ACPI: Make acpi_os_map_memory() avoid creating unnecessary mappings
      ACPI: Do not use krefs under a mutex in osl.c
      ACPI: Introduce acpi_os_get_iomem()
      ACPI / PM: Use existing ACPI iomaps for NVS save/restore (v2)
      ACPI: Remove the wakeup.run_wake_count device field
      ACPI / Button: Avoid disabling wakeup unnecessarily on remove
      ACPI / PM: Drop acpi_restore_state_mem()
      ACPI / PM: acpi_suspend_enter() need not switch interrupts off
      ACPI / PM: Modify the "low-level resume finished" message
      ACPI / PM: Call acpi_save_state_mem() right before low-level suspend
      ACPI / PM: Merge do_suspend_lowlevel() into acpi_save_state_mem()
      ACPI / PM: acpi_hibernation_enter() need not switch interrupts off
      ACPI: Avoid calling request_irq() many times for the same interrupt
      ACPI: Remove the unused EC sysdev class
      ACPI: Use syscore_ops instead of sysdev class and sysdev

Zhang Rui (1):
      ACPI button: remove unused procfs I/F

with this log:

commit 3d26678e8009b03f27674c2f9e5b236c2f627b14
Merge: 02e2407 c3146df
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 23 02:35:02 2011 -0400

    Merge branch 'sysdev' into release

commit 02e2407858fd62053bf60349c0e72cd1c7a4a60e
Merge: 96e1c40 6447f55d
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 23 02:34:54 2011 -0400

    Merge branch 'linus' into release
    
    Conflicts:
    	arch/x86/kernel/acpi/sleep.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 96e1c408ea8a556c5b51e0e7d56bd2afbfbf5fe9
Merge: f7f28f7 25be582
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 23 02:34:18 2011 -0400

    Merge branch 'battery-sysfs-notifier' into release

commit f7f28f7e8c42c67c4bce24415c6cd6da222a1798
Merge: 5c129a8 95cf3e1
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 23 02:34:15 2011 -0400

    Merge branch 'reset' into release

commit 5c129a8600100a5d0f5fdbc1014c5dba1d307bc4
Merge: 797b10a 521cb40
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 23 02:33:54 2011 -0400

    Merge commit 'v2.6.38' into release

commit 797b10a07069e153d41aedb4ae8e76660279e2ee
Merge: 8a9026d 4fdfbe8
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 23 02:33:46 2011 -0400

    Merge branch 'bugfix-thermal' into release

commit 8a9026d2e91b2c46744396222b0e878b2622c567
Merge: 3c7ef21 cdf2a4e
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 23 02:19:58 2011 -0400

    Merge branch 'misc' into release

commit cdf2a4eeded69f66ec8c5098c375fe49e0820127
Author: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Date:   Wed Feb 2 23:27:04 2011 +0000

    ACPI: minor printk format change in acpi_pad
    
    Minor format change.
    
    Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 32297abd90a5d181e8e026c8b8e65ef41e9ffc07
Author: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Date:   Wed Feb 2 23:26:58 2011 +0000

    ACPI: make acpi_pad /sys output more readable
    
    Make /sys output from acpi_pad more readable.
    
    Before the fix:
    # cat idlecpus idlepct rrtime
    00000000510
    
    After the fix:
    # cat idlecpus idlepct rrtime
    00000000
    5
    10
    
    Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3c7ef2138aff285e376aefb74330392442cb2f2d
Merge: 2935b54 d8d75b0
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 23 00:18:32 2011 -0400

    Merge branch 'acpica' into release

commit d8d75b0ee6dbd65c8a2189aef50a03667d81c937
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Mar 22 11:27:29 2011 +0800

    ACPICA: Update version to 20110316
    
    Version 20110316.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5cf4d7338ba23aa8d9eeaf313f16bb50494be369
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Mar 18 09:49:41 2011 +0800

    ACPICA: Header support for SLIC table
    
    We finally have the definition for this table.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95cf3e12e7f659e536215b37c67d46f3e2ce95cc
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri Mar 11 16:12:20 2011 -0500

    ACPI: Make sure the FADT is at least rev 2 before using the reset register
    
    The reset register was only introduced with version 2 of the FADT, so we
    should check that the FADT revision before trusting its contents.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6734fe57a07b2dd23ef1ef2ac1f790747e53eefc
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri Mar 11 16:12:19 2011 -0500

    ACPI: Bug compatibility for Windows on the ACPI reboot vector
    
    Windows ignores the bit_offset and bit_width, despite the spec requiring
    that they be validated. Drop the checks so that we match this behaviour.
    Windows also goes straight for the keyboard controller if the ACPI reboot
    fails, so we shouldn't sleep if we're still alive.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f17d9cbf20c4734c4199caa6dee87047f2f8278f
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri Mar 11 16:12:18 2011 -0500

    ACPICA: Fix access width for reset vector
    
    Section 4.7.3.6 of the ACPI specification requires that the register width
    of the reset vector be 8 bits. Windows simply hardcodes the access to be
    a byte and ignores the width provided in the FADT, so make sure that we
    do the same.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 25be5821521640eb00b7eb219ffe59664510d073
Author: Kyle McMartin <kyle@redhat.com>
Date:   Tue Mar 22 16:19:50 2011 -0400

    ACPI battery: fribble sysfs files from a resume notifier
    
    Commit da8aeb92 re-poked the battery on resume, but Linus reports that
    it broke his eee and partially reverted it in b23fffd7. Unfortunately
    this also results in my x201s giving crack values until the sysfs files
    are poked again. In the revert message, it was suggested that we poke it
    from a PM notifier, so let's do that.
    
    With this in place, I haven't noticed the units going nutty on my
    gnome-power-manager across a dozen suspends or so...
    
    Signed-off-by: Kyle McMartin <kyle@redhat.com>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2935b544041bbdc32a6864ba9350a7629c56d722
Merge: 2507624 912b742
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 22 23:20:49 2011 -0400

    Merge branch 'button-cleanup' into release

commit 912b7427fc13467bac042cc72f2eccbdbc39d773
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Mar 23 10:21:40 2011 +0800

    ACPI button: remove unused procfs I/F
    
    Remove unused ACPI button procfs interface.
    Only /proc/acpi/button/lid/LID/state remains.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 25076246e80c0c48cc4c9115335b83343b9dc727
Merge: 05534c9 c413d76
Author: Len Brown <len.brown@intel.com>
Date:   Tue Mar 22 01:41:47 2011 -0400

    Merge branch 'apei-release' into release

commit c413d7682020a127f54744a1b30f597692aea1fd
Author: Huang Ying <ying.huang@intel.com>
Date:   Mon Feb 21 13:54:43 2011 +0800

    ACPI, APEI, Add PCIe AER error information printing support
    
    The AER error information printing support is implemented in
    drivers/pci/pcie/aer/aer_print.c.  So some string constants, functions
    and macros definitions can be re-used without being exported.
    
    The original PCIe AER error information printing function is not
    re-used directly because the overall format is quite different.  And
    changing the original printing format may make some original users'
    scripts broken.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    CC: Jesse Barnes <jbarnes@virtuousgeek.org>
    CC: Zhang Yanmin <yanmin.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b64a44146540a4761bb1cf8047fffd9dbf0c3090
Author: Huang Ying <ying.huang@intel.com>
Date:   Mon Feb 21 13:54:42 2011 +0800

    PCIe, AER, use pre-generated prefix in error information printing
    
    When printing PCIe AER error information, each line is prefixed with
    PCIe device and driver information.  In original implementation, the
    prefix is generated when each line is printed.  In fact, all lines
    share the same prefix.  So this patch pre-generated the prefix, and
    use that one when each line is printed.
    
    In addition to common prefix can be pre-generated, the trailing white
    spaces in string constants and NULLs in char * array constants can be
    removed too.  These can reduce the object file size further.
    
    The size of object file before and after changing is as follow:
    
               text    data     bss     dec
    before:    3038       0       0    3038
    after:     2118       0       0    2118
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    CC: Jesse Barnes <jbarnes@virtuousgeek.org>
    CC: Zhang Yanmin <yanmin.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 885b976fada5bc6595a9fd3e67e3cb1a3d11f50b
Author: Huang Ying <ying.huang@intel.com>
Date:   Mon Feb 21 13:54:41 2011 +0800

    ACPI, APEI, Add ERST record ID cache
    
    APEI ERST firmware interface and implementation has no multiple users
    in mind.  For example, if there is four records in storage with ID: 1,
    2, 3 and 4, if two ERST readers enumerate the records via
    GET_NEXT_RECORD_ID as follow,
    
    reader 1		reader 2
    1
    			2
    3
    			4
    -1
    			-1
    
    where -1 signals there is no more record ID.
    
    Reader 1 has no chance to check record 2 and 4, while reader 2 has no
    chance to check record 1 and 3.  And any other GET_NEXT_RECORD_ID will
    return -1, that is, other readers will has no chance to check any
    record even they are not cleared by anyone.
    
    This makes raw GET_NEXT_RECORD_ID not suitable for used by multiple
    users.
    
    To solve the issue, an in-memory ERST record ID cache is designed and
    implemented.  When enumerating record ID, the ID returned by
    GET_NEXT_RECORD_ID is added into cache in addition to be returned to
    caller.  So other readers can check the cache to get all record ID
    available.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c3146df2b735912eddd1d7c080c9377d5df0ae94
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Mar 12 22:16:51 2011 +0100

    ACPI: Use syscore_ops instead of sysdev class and sysdev
    
    ACPI uses a sysdev class and a sysdev for executing
    irqrouter_resume() before turning on interrupts on the boot CPU.
    However, since irqrouter_resume() ignores its argument, the entire
    mechanism may be replaced with a struct syscore_ops object which
    is considerably simpler.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4d3fbff26c8e91474e30e575c2b7476be11afd83
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Mar 10 21:21:23 2011 +0100

    ACPI: Remove the unused EC sysdev class
    
    The ACPI EC driver defines a sysdev class, but it doesn't use it, so
    it can be removed.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 05534c9ffc9d5d950b14de8ba49a7609dc59b0b8
Merge: dd87cc5 589c7a3
Author: Len Brown <len.brown@intel.com>
Date:   Fri Mar 18 18:06:08 2011 -0400

    Merge branch 'acpica' into release

commit af10f941ab7807d8b0bb3c66e679d8a6bbbe7485
Author: Jan Beulich <JBeulich@novell.com>
Date:   Thu Feb 17 16:36:24 2011 +0000

    ACPI: use __cpuinit for the acpi_processor_set_pdc() call tree
    
    Once acpi_map_lsapic() in ia64 follows how x86 treats it wrt section
    placement, the whole tree from acpi_processor_set_pdc() can become
    __cpuinit.
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Acked-by: Tony Luck <tony.luck@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6430c9c12a7dbb8f60f0d8294b73b3c0bb03f64f
Author: Jan Beulich <JBeulich@novell.com>
Date:   Thu Feb 17 16:33:53 2011 +0000

    ACPI: use __init where possible in processor driver
    
    Use __init for several functions, remove an unnecessary export and a
    stray use of __ref.
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4fdfbe8506fa236f3c4cc915b24e70f84a6f768a
Author: Durgadoss R <durgadoss.r@intel.com>
Date:   Thu Jan 20 02:40:56 2011 +0530

    Thermal_Framework-Fix_crash_during_hwmon_unregister
    
    This patch fixes the following bug:
    The thermal framework creates a temp*_crit interface, only when
    the get_crit_temp pointer is defined. But during the _unregister_
    path, without checking for the function definition, it is trying to
    remove the temp*_crit interface.
    
    Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 589c7a39ae2f2b74fd13ae344ca1dcca61da6bca
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Feb 14 16:15:21 2011 +0800

    ACPICA: Update version to 20110211.
    
    Version 20110211.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ef09c4f578147464524041cbe3205bb25f900598
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Feb 14 16:13:25 2011 +0800

    ACPICA: Add mechanism to defer _REG methods for some installed handlers
    
    The memory/io/pci/dataTable regions must always be available. For
    any user installed handlers for these spaces, defer execution
    of _REG methods until acpi_enable_subsystem. This prevents any
    chicken/egg problems and ensures that no methods are executed
    until all of these regions are ready and available.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 47863b9cbec29f137b3a7718ec851be879b41137
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Feb 14 16:11:43 2011 +0800

    ACPICA: Add support for FunctionalFixedHW in acpi_ut_get_region_name
    
    Was missing this region type.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9ad19ac456a5f097f7cbbfef820b95297d6a934f
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Feb 14 16:09:40 2011 +0800

    ACPICA: Split large dsopcode and dsload.c files.
    
    Split dsopcode.c into dsargs.c and dscontrol.c.
    Split dsload.c into dsload2.c.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d59a3c6b35995615fa9e4f21d63fdf21328c5b6b
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Feb 14 16:02:36 2011 +0800

    ACPICA: Fix unresolved name issue for no-debug and no-error-msg cases
    
    The _acpi_module_name was left undefined in these cases, but it
    is actually needed as a parameter to some interfaces. Define
    _acpi_module_name as a null string in these cases.  Acpica BZ 888.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=888
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a257e07527890a7f95982b9c330efd8d2de3707a
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Feb 14 16:00:21 2011 +0800

    ACPICA: Split large utglobal into utdecode.c.
    
    utglobal.c contained a lot of code not related to global variables.
    These utility decode functions are moved to utdecode.c
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1b74dfb2f735454031584dc8162f8f27aa5265bf
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Feb 14 15:52:56 2011 +0800

    ACPICA: Clarify a couple of error messages
    
    Clarify region error messages with ID= prefix for space id.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 64b3db22c04586997ab4be46dd5a5b99f8a2d390
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Feb 14 15:50:42 2011 +0800

    ACPICA: Remove use of unreliable FADT revision field
    
    The revision number in the FADT has been found to be completely
    unreliable and cannot be trusted. Only the table length can be
    used to infer the actual version.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6dfad339645247c9deb553e4d68e21211ddc61bd
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Feb 14 15:29:34 2011 +0800

    ACPICA: GPE detect optimization - ignore unused GPE registers
    
    This optimization will simply ignore GPE registers that contain
    no enabled GPEs - there is no need to read the register.
    ACPICA bugzilla 884.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=884
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dd87cc53c42f3260b7eb7f60822de0fa9e58af59
Merge: 981858b bb45e39 aad83b1 23fe363
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Feb 24 20:00:44 2011 +0100

    Merge branches 'acpi-iomem', 'acpi-pm' and 'acpi-sci' into acpi-next

commit 23fe36306ea489eef7dd88506bdcefdc8da39c91
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:48:16 2011 +0100

    ACPI: Avoid calling request_irq() many times for the same interrupt
    
    In principle acpi_os_install_interrupt_handler() may be called
    multiple times for different interrupts, either from
    acpi_ev_get_gpe_xrupt_block(), or from acpi_ev_install_sci_handler().
    However, it always attempts to request the same interrupt,
    acpi_gbl_FADT.sci_interrupt and it doesn't check whether or not this
    interrupt has already been requested.
    
    Modify this function so that it refuses to request interrupts other
    than acpi_gbl_FADT.sci_interrupt and change
    acpi_os_remove_interrupt_handler() so that it refuses to free such
    interrupts.  Use the observation that the only supported ACPI
    interrupt must be equal to acpi_gbl_FADT.sci_interrupt and drop an
    unnecessary variable acpi_irq_irq.
    
    This change has been tested on Toshiba Portege R500 and HP nx6325
    without introducing any visible problems.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit aad83b143008e1d406248803550bfbfc600b6398
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:42:35 2011 +0100

    ACPI / PM: acpi_hibernation_enter() need not switch interrupts off
    
    The function acpi_hibernation_enter() is always called with
    interrupts off, so it doesn't need to switch them off and on.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit f1a2003e22f6b50ea21f7f4b38b38c5ebc9c8017
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:42:22 2011 +0100

    ACPI / PM: Merge do_suspend_lowlevel() into acpi_save_state_mem()
    
    The function do_suspend_lowlevel() is specific to x86 and defined in
    assembly code, so it should be called from the x86 low-level suspend
    code rather than from acpi_suspend_enter().
    
    Merge do_suspend_lowlevel() into the x86's acpi_save_state_mem() and
    change the name of the latter to acpi_suspend_lowlevel(), so that the
    function's purpose is better reflected by its name.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 979f11b060c0b35b03b86ae854d6f21a710305d0
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:42:09 2011 +0100

    ACPI / PM: Call acpi_save_state_mem() right before low-level suspend
    
    Since acpi_save_state_mem() is only called by acpi_suspend_enter()
    if the target sleep state is S3, it's better to call it under the
    switch (acpi_state), right before do_suspend_lowlevel().
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 7a63f08b2b904d25e966dd0e15c9af4a13c80b90
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:41:57 2011 +0100

    ACPI / PM: Modify the "low-level resume finished" message
    
    Move the low-level resume completion message to the point where
    control goes back to acpi_suspend_enter() during resume and change
    it so that it's more informative.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 82911fe1988fadfc9c01673202cbc411aa803244
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:41:47 2011 +0100

    ACPI / PM: acpi_suspend_enter() need not switch interrupts off
    
    The function acpi_suspend_enter() is always called with interrupts
    off, so it doesn't need to switch them off and on.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit c41b93fb8551148a93d3bba870365e8489317f02
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:41:35 2011 +0100

    ACPI / PM: Drop acpi_restore_state_mem()
    
    The function acpi_restore_state_mem() has never been and most likely
    never will be used, so remove it.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit c19f9a84ec807da57fd75bbd9a3f2b8269611f79
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:41:13 2011 +0100

    ACPI / Button: Avoid disabling wakeup unnecessarily on remove
    
    If a button device had already been enabled to wake up the system
    from sleep states before the button driver saw it, the driver
    shouldn't disable the device's wakeup capability when being detached
    from the device.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 5190726765b40774c069e187a958e10ccd970e65
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:40:37 2011 +0100

    ACPI: Remove the wakeup.run_wake_count device field
    
    The wakeup.run_wake_count ACPI device field is only used by the PCI
    runtime PM code to "protect" devices from being prepared for
    generating wakeup signals more than once in a row.  However, it
    really doesn't provide any protection, because (1) all of the
    functions it is supposed to protect use their own reference counters
    effectively ensuring that the device will be set up for generating
    wakeup signals just once and (2) the PCI runtime PM code uses
    wakeup.run_wake_count in a racy way, since nothing prevents
    acpi_dev_run_wake() from being called concurrently from two different
    threads for the same device.
    
    Remove the wakeup.run_wake_count ACPI device field which is
    unnecessary, confusing and used in a wrong way.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit bb45e394e21eb2abc710ad43d98ebac1069bf355
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:38:38 2011 +0100

    ACPI / PM: Use existing ACPI iomaps for NVS save/restore (v2)
    
    Modify the NVS save/restore code to use acpi_os_get_iomem() and
    acpi_os_unmap_memory() to acquire and release references to ACPI
    iomaps, respectively.  If there's no ACPI iomap corresponding to the
    given NVS page, acpi_os_ioremap() is used to map that page and
    iounmap() is used to unmap it during resume.  [If the page is not
    present in the ACPI iomaps already, it doesn't make sense to add its
    mapping to the list of ACPI iomaps, because it's going to be thrown
    away during the subsequent resume anyway.]
    
    Testing on my HP nx6325 shows that approx. 90% of the NVS pages
    have already been mapped by ACPI before suspend and are present in
    the ACPI iomaps, so this change appears to be the right thing to do
    in general.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 13606a2de1996f8d83a9ce296f74022bdbadf712
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:38:25 2011 +0100

    ACPI: Introduce acpi_os_get_iomem()
    
    Introduce function acpi_os_get_iomem() that may be used by its callers
    to get a reference to an ACPI iomap.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit b7c1fadd6c2eead56d0664a3a921980120de0c11
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:38:15 2011 +0100

    ACPI: Do not use krefs under a mutex in osl.c
    
    The reference counting of ACPI iomaps is carried out entirely under
    acpi_ioremap_lock, so it is sufficient to use simple counters instead
    of krefs for this purpose.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 7ffd0443f2502478545e23e194b7eb8e16376072
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:38:05 2011 +0100

    ACPI: Make acpi_os_map_memory() avoid creating unnecessary mappings
    
    Modify acpi_os_map_memory() so that it doesn't call acpi_os_ioremap()
    unconditionally every time it is executed (except when
    acpi_gbl_permanent_mmap is unset), which pretty much defeats the
    purpose of maintaining the list of ACPI iomaps in osl.c.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 7fe135dc058faea0ce319a03e3b6f98c5049955c
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:37:53 2011 +0100

    ACPI: Avoid walking the list of memory mappings in osl.c twice in a row
    
    Make acpi_os_unmap_generic_address() use acpi_map_lookup() to find
    the desired iomap and drop the reference to it directly (and
    eventually remove it if necessary) instead of calling
    acpi_os_unmap_memory(), which requires us to walk the list of ACPI
    iomaps twice in a row (first, to get the virtual address associated
    with the iomap and second, to get the iomap itself).
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 7bbb890358b96cb6f77adc6815f2072bdf813d5d
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:37:42 2011 +0100

    ACPI: Change acpi_ioremap_lock into a mutex
    
    There's no reason why acpi_ioremap_lock has to be a spinlock,
    because all of the functions it is used in may sleep anyway and
    there's no reason why it should be locked with interrupts off.
    Use a mutex instead (that's going to allow us to put some more
    operations under the lock later).
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 073b4964b3b75fd9e19bf3933b26d9c23591c9db
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:37:31 2011 +0100

    ACPI: Do not export functions that are only used in osl.c
    
    The functions acpi_os_map_generic_address() and
    acpi_os_unmap_generic_address() are only used in drivers/acpi/osl.c,
    so make them static and remove the extern definitions of them from
    include/linux/acpi_io.h.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
