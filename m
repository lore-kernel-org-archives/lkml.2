Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0FLF2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 01:28:11 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:56727 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0FLF2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 01:28:06 -0400
Date: Sat, 12 Jun 2010 01:27:45 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI patches for 2.6.35-rc3
Message-id: <alpine.LFD.2.00.1006120125540.30329@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

A few significant fixes here:

Rafael fixes a pair of GPE regressions, one from -rc1, and another
going back to 2.6.33.
Matthew fixed a pair of Windows compatibility issues,
one related to IO ports, and another related to resume and NVS.
Plus a couple of less significant fixes.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.35/acpi-release-20100428-2.6.35-rc3.diff.gz

 arch/x86/kernel/e820.c                  |    2 +-
 drivers/acpi/acpi_pad.c                 |   36 +++++++---
 drivers/acpi/acpica/acconfig.h          |    4 +
 drivers/acpi/acpica/acevents.h          |    4 -
 drivers/acpi/acpica/acglobal.h          |    8 ++
 drivers/acpi/acpica/achware.h           |    6 ++-
 drivers/acpi/acpica/evgpe.c             |  115 ++-----------------------------
 drivers/acpi/acpica/evgpeblk.c          |   14 ++++-
 drivers/acpi/acpica/evxface.c           |    7 --
 drivers/acpi/acpica/evxfevnt.c          |   59 ++++++++++++++--
 drivers/acpi/acpica/exsystem.c          |    8 ++
 drivers/acpi/acpica/hwgpe.c             |   94 +++++++++++++++++--------
 drivers/acpi/acpica/hwvalid.c           |   12 +++
 drivers/acpi/acpica/nsinit.c            |    9 +++
 drivers/acpi/blacklist.c                |    8 ++
 drivers/acpi/fan.c                      |    3 +-
 drivers/acpi/processor_driver.c         |    5 ++
 drivers/acpi/sleep.c                    |   34 +++++----
 drivers/acpi/system.c                   |    6 +-
 include/acpi/acexcep.h                  |    2 +-
 include/acpi/acpixf.h                   |    1 +
 include/acpi/actypes.h                  |    3 +-
 include/linux/suspend.h                 |   26 ++++----
 init/main.c                             |    4 +-
 kernel/power/Kconfig                    |    9 ++-
 kernel/power/Makefile                   |    2 +-
 kernel/power/{hibernate_nvs.c => nvs.c} |   24 +++---
 kernel/power/suspend.c                  |    6 ++
 28 files changed, 289 insertions(+), 222 deletions(-)
 rename kernel/power/{hibernate_nvs.c => nvs.c} (80%)

through these commits:

Bob Moore (2):
      ACPICA: Fix namestring associated with AE_NO_HANDLER exception
      ACPICA: Limit maximum time for Sleep() operator

Chen Gong (1):
      ACPI: acpi_pad: Don't needlessly mark LAPIC unstable

Liang Li (1):
      ACPI: fan: fix unbalanced code block

Matthew Garrett (3):
      suspend: Move NVS save/restore code to generic suspend functionality
      ACPI: Store NVS state even when entering suspend to RAM
      ACPICA: Truncate I/O addresses to 16 bits for Windows compatibility

Rafael J. Wysocki (6):
      ACPI / ACPICA: Do not attempt to disable GPE when installing handler
      ACPI / ACPICA: Use helper function for computing GPE masks
      ACPI / ACPICA: Fix low-level GPE manipulation code
      ACPI / ACPICA: Avoid writing full enable masks to GPE registers
      ACPI / ACPICA: Fix GPE initialization
      ACPI / ACPICA: Fix sysfs GPE interface

Thomas Renninger (1):
      ACPI: Do not try to set up acpi processor stuff on cores exceeding maxcpus=

Zhang Rui (1):
      ACPI: Disable Vista compatibility for Sony VGN-NS50B_L

with this log:

commit c1db9d9bb23814a76cfb2416fd84f32c3fd6d82f
Merge: 42de553 934231d
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 12 01:16:51 2010 -0400

    Merge branch 'misc-2.6.35' into release

commit 42de5532f4a58a52a60bdd8bd4f80f9f210dd65b
Merge: e9e8b4d 2a6b697
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 12 01:15:40 2010 -0400

    Merge branch 'bugzilla-13931-sleep-nvs' into release
    
    Conflicts:
    	drivers/acpi/sleep.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e9e8b4dd142da3b6cbf301ba922804d6cdc31a17
Merge: d9a799d 4b1b29b
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 12 00:58:01 2010 -0400

    Merge branch 'bugzilla-102904-workaround' into release

commit d9a799d197da16fcfb1e872e82ee6cdf7fe8f7ab
Merge: a48ecc7 b681f7d
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 12 00:56:15 2010 -0400

    Merge branch 'acpica-cherry-pick' into release

commit b681f7d9ab4d697a214fa4428795790c3a937a89
Author: Matthew Garrett <mjg@redhat.com>
Date:   Wed May 26 11:50:48 2010 +0800

    ACPICA: Truncate I/O addresses to 16 bits for Windows compatibility
    
    This feature is optional and is enabled if the BIOS requests any
    Windows OSI strings. It can also be enabled by the host OS.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9cbfa18e8a7b34a32eddbd914a07f085962f50a8
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed May 26 11:22:41 2010 +0800

    ACPICA: Limit maximum time for Sleep() operator
    
    To prevent accidental deep sleeps, limit the maximum time that
    Sleep() will sleep. Configurable, default maximum is two seconds.
    ACPICA bugzilla 854.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=854
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d70326689b70b35527765bd3decbb1229459e928
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed May 26 11:06:12 2010 +0800

    ACPICA: Fix namestring associated with AE_NO_HANDLER exception
    
    Was incorrectly AE_WAKE_ONLY_GPE.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a48ecc771852158eb7b9ace242f0a6226a3907b7
Merge: 9263482 8aa4b14
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 12 00:52:19 2010 -0400

    Merge branch 'acpi_pad' into release

commit 92634825571d86417941855a8e3189c07aa3c706
Merge: 7e27d6e 9d3c752
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jun 12 00:51:49 2010 -0400

    Merge branch 'gpe-regression-fixes' into release

commit 9d3c752de65dbfa6e522f1d666deb0ac152ef367
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jun 8 10:50:53 2010 +0200

    ACPI / ACPICA: Fix sysfs GPE interface
    
    The sysfs interface allowing user space to disable/enable GPEs
    doesn't work correctly, because a GPE disabled this way will be
    re-enabled shortly by acpi_ev_asynch_enable_gpe() if it was
    previosuly enabled by acpi_enable_gpe() (in which case the
    corresponding bit in its enable register's enable_for_run mask is
    set).
    
    To address this issue make the sysfs GPE interface use
    acpi_enable_gpe() and acpi_disable_gpe() instead of acpi_set_gpe()
    so that GPE reference counters are modified by it along with the
    values of GPE enable registers.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ce43ace02320a3fb9614ddb27edc3a8700d68b26
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jun 8 10:50:20 2010 +0200

    ACPI / ACPICA: Fix GPE initialization
    
    While developing the GPE reference counting code we overlooked the
    fact that acpi_ev_update_gpes() could have enabled GPEs before
    acpi_ev_initialize_gpe_block() was called.  As a result, some GPEs
    are enabled twice during the initialization.
    
    To fix this issue avoid calling acpi_enable_gpe() from
    acpi_ev_initialize_gpe_block() for the GPEs that have nonzero
    runtime reference counters.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c9a8bbb7704cbf515c0fc68970abbe4e91d68521
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jun 8 10:49:45 2010 +0200

    ACPI / ACPICA: Avoid writing full enable masks to GPE registers
    
    ACPICA uses acpi_hw_write_gpe_enable_reg() to re-enable a GPE after
    an event signaled by it has been handled.  However, this function
    writes the entire GPE enable mask to the GPE's enable register which
    may not be correct.  Namely, if one of the other GPEs in the same
    register was previously enabled by acpi_enable_gpe() and subsequently
    disabled using acpi_set_gpe(), acpi_hw_write_gpe_enable_reg() will
    re-enable it along with the target GPE.
    
    To fix this issue rework acpi_hw_write_gpe_enable_reg() so that it
    calls acpi_hw_low_set_gpe() with a special action value,
    ACPI_GPE_COND_ENABLE, that will make it only enable the GPE if the
    corresponding bit in its register's enable_for_run mask is set.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fd247447c1d94a79d5cfc647430784306b3a8323
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jun 8 10:49:08 2010 +0200

    ACPI / ACPICA: Fix low-level GPE manipulation code
    
    ACPICA uses acpi_ev_enable_gpe() for enabling GPEs at the low level,
    which is incorrect, because this function only enables the GPE if the
    corresponding bit in its enable register's enable_for_run mask is set.
    This causes acpi_set_gpe() to work incorrectly if used for enabling
    GPEs that were not previously enabled with acpi_enable_gpe().  As a
    result, among other things, wakeup-only GPEs are never enabled by
    acpi_enable_wakeup_device(), so the devices that use them are unable
    to wake up the system.
    
    To fix this issue remove acpi_ev_enable_gpe() and its counterpart
    acpi_ev_disable_gpe() and replace acpi_hw_low_disable_gpe() with
    acpi_hw_low_set_gpe() that will be used instead to manipulate GPE
    enable bits at the low level.  Make the users of acpi_ev_enable_gpe()
    and acpi_ev_disable_gpe() call acpi_hw_low_set_gpe() instead and
    make sure that GPE enable masks are only updated by acpi_enable_gpe()
    and acpi_disable_gpe() when GPE reference counters change from 0
    to 1 and from 1 to 0, respectively.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e4e9a735991c80fb0fc1bd4a13a93681c3c17ce0
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jun 8 10:48:26 2010 +0200

    ACPI / ACPICA: Use helper function for computing GPE masks
    
    In quite a few places ACPICA needs to compute a GPE enable mask with
    only one bit, corresponding to a given GPE, set.  Currently, that
    computation is always open coded which leads to unnecessary code
    duplication.  Fix this by introducing a helper function for computing
    one-bit GPE enable masks and using it where appropriate.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a997ab332832519c2e292db13f509e4360495a5a
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Jun 12 00:05:19 2010 +0200

    ACPI / ACPICA: Do not attempt to disable GPE when installing handler
    
    Commit 0f849d2cc6863c7874889ea60a871fb71399dd3f (ACPICA: Minimize
    the differences between linux GPE code and ACPICA code base)
    introduced a change attempting to disable a GPE before installing
    a handler for it in acpi_install_gpe_handler() which was incorrect.
    First, the GPE disabled by it is never enabled again (except during
    resume) which leads to battery insert/remove events not being
    reported on the Maxim Levitsky's machine.  Second, the disabled
    GPE is still reported as enabled by the sysfs interface that only
    checks its enable register's enable_for_run mask.
    
    Revert this change for now, because it causes more damage to happen
    than the bug it was supposed to fix.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-and-tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4b1b29bc8801badd243694add02262e0955dde1b
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Jun 8 15:28:40 2010 +0800

    ACPI: Disable Vista compatibility for Sony VGN-NS50B_L
    
    Disable Vista compatibility for Sony VGN-NS50B_L.
    https://bugzilla.kernel.org/show_bug.cgi?id=12904#c46
    
    Note that this change is a workaround, not a permanent fix.
    For the permanent fix is to figure out what compatibility
    means and to actually be compatible...
    
    Tested-by: Voldemar <harestomper@gmail.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 934231de706d2579fae14f5857fcd8de991009ff
Author: Liang Li <liang.li@windriver.com>
Date:   Thu Jun 10 13:42:49 2010 +0800

    ACPI: fan: fix unbalanced code block
    
    The code block braced with CONFIG_ACPI_PROCFS is unblanced. When
    CONFIG_ACPI_PROCFS=n, kernel trace will be produced like:
    
    Call Trace:
     [<c111637d>] ? remove_proc_entry+0x20d/0x290
     [<c111637d>] ? remove_proc_entry+0x20d/0x290
     [<c103b02c>] warn_slowpath_common+0x6c/0xc0
     [<c111637d>] ? remove_proc_entry+0x20d/0x290
     [<c103b0c6>] warn_slowpath_fmt+0x26/0x30
     [<c111637d>] remove_proc_entry+0x20d/0x290
     [<c1116bd7>] ? proc_register+0x117/0x1f0
     [<c1116e83>] ? proc_mkdir_mode+0x33/0x50
     [<c14f483c>] ? acpi_fan_init+0x0/0x2c
     [<c14f485f>] acpi_fan_init+0x23/0x2c
     [<c1001123>] do_one_initcall+0x23/0x180
     [<c107dcf7>] ? init_irq_proc+0x67/0x80
     [<c14d43bd>] kernel_init+0x13c/0x20e
     [<c1030e50>] ? schedule_tail+0x20/0x90
     [<c1389e06>] ? syscall_exit+0x5/0x16
     [<c14d4281>] ? kernel_init+0x0/0x20e
     [<c14d4281>] ? kernel_init+0x0/0x20e
     [<c10032f6>] kernel_thread_helper+0x6/0x30
    ---[ end trace a7919e7f17c0a725 ]---
    
    Then also bracket later error checking code with ACPI_PROCFS
    option to avoid mismatch problem.
    
    Signed-off-by: Liang Li <liang.li@windriver.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2a6b69765ad794389f2fc3e14a0afa1a995221c2
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri May 28 16:32:15 2010 -0400

    ACPI: Store NVS state even when entering suspend to RAM
    
    https://bugzilla.kernel.org/show_bug.cgi?id=13931 describes a bug where
    a system fails to successfully resume after the second suspend. Maxim
    Levitsky discovered that this could be rectified by forcibly saving
    and restoring the ACPI non-volatile state. The spec indicates that this
    is only required for S4, but testing the behaviour of Windows by adding
    an ACPI NVS region to qemu's e820 map and registering a custom memory
    read/write handler reveals that it's saved and restored even over suspend
    to RAM. We should mimic that behaviour to avoid other broken platforms.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dd4c4f17d722ffeb2515bf781400675a30fcead7
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri May 28 16:32:14 2010 -0400

    suspend: Move NVS save/restore code to generic suspend functionality
    
    Saving platform non-volatile state may be required for suspend to RAM as
    well as hibernation. Move it to more generic code.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 75cbfb97a156dd3dabdc81295fb8144576332366
Author: Thomas Renninger <trenn@suse.de>
Date:   Wed May 26 17:03:33 2010 +0200

    ACPI: Do not try to set up acpi processor stuff on cores exceeding maxcpus=
    
    Patch is against latest Linus master branch and is expected to be
    safe bug fix.
    
    You get:
    ACPI: HARDWARE addr space,NOT supported yet
    for each ACPI defined CPU which status is active, but exceeds
    maxcpus= count.
    
    As these "not booted" CPUs do not run an idle routine
    and echo X >/proc/acpi/processor/*/throttling did not work
    I couldn't find a way to really access not onlined/booted
    machines. Still this should get fixed and
    /proc/acpi/processor/X dirs of cores exceeding maxcpus
    should not show up.
    
    I wonder whether this could get cleaned up by truncating possible cpu mask
    and nr_cpu_ids to setup_max_cpus early some day
    (and not exporting setup_max_cpus anymore then).
    But this needs touching of a lot other places...
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    CC: travis@sgi.com
    CC: linux-acpi@vger.kernel.org
    CC: lenb@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8aa4b14eb023fecaa48d55402e98bdf84b375c4a
Author: Chen Gong <gong.chen@linux.intel.com>
Date:   Sun May 30 11:37:08 2010 +0800

    ACPI: acpi_pad: Don't needlessly mark LAPIC unstable
    
    As suggested in Venki's suggestion in the commit 0dc698b,
    add LAPIC unstable detection in the acpi_pad drvier too.
    
    Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
