Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab0GYDbK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 23:31:10 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:59563 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0GYDbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 23:31:04 -0400
Date: Sat, 24 Jul 2010 23:30:43 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI patches for Linux-2.6.35-rc6
Message-id: <alpine.LFD.2.00.1007242329170.3081@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

bugfixes.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.35/acpi-release-20100428-2.6.35-rc6.diff.gz

 Documentation/feature-removal-schedule.txt |    7 +++++
 Documentation/kernel-parameters.txt        |    4 +-
 arch/x86/kernel/acpi/cstate.c              |    9 +++++++
 arch/x86/kernel/acpi/sleep.c               |    9 +++++-
 drivers/acpi/acpica/evxfevnt.c             |   19 ++++++++------
 drivers/acpi/battery.c                     |    8 +++++-
 drivers/acpi/blacklist.c                   |    2 +-
 drivers/acpi/processor_core.c              |    2 +-
 drivers/acpi/processor_idle.c              |   10 +++++++-
 drivers/acpi/sleep.c                       |   35 +++++++++++++--------------
 include/acpi/processor.h                   |    3 +-
 include/linux/acpi.h                       |    2 +-
 12 files changed, 74 insertions(+), 36 deletions(-)

through these commits:

Alex Chiang (1):
      ACPI: processor: fix processor_physically_present on UP

KOSAKI Motohiro (1):
      ACPI: fix unused function warning

Len Brown (3):
      ACPI: handle systems which asynchoronously enable ACPI mode
      ACPI: skip checking BM_STS if the BIOS doesn't ask for it
      ACPI: create "processor.bm_check_disable" boot param

Nik A. Melchior (1):
      ACPI video: fix string mismatch for Sony SR290 laptop

Rafael J. Wysocki (1):
      ACPI / Sleep: Allow the NVS saving to be skipped during suspend to RAM

Zhang Rui (1):
      ACPI battery: don't invoke power_supply_changed twice when battery is hot-added

with this log:

commit 0e1cf38889110a7188999388614aef17a84d9d25
Merge: bbac30e 72ad5d7
Author: Len Brown <len.brown@intel.com>
Date:   Sat Jul 24 23:26:22 2010 -0400

    Merge branch 'bugzilla-16396' into release

commit 72ad5d77fb981963edae15eee8196c80238f5ed0
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jul 23 22:59:09 2010 +0200

    ACPI / Sleep: Allow the NVS saving to be skipped during suspend to RAM
    
    Commit 2a6b69765ad794389f2fc3e14a0afa1a995221c2
    (ACPI: Store NVS state even when entering suspend to RAM) caused the
    ACPI suspend code save the NVS area during suspend and restore it
    during resume unconditionally, although it is known that some systems
    need to use acpi_sleep=s4_nonvs for hibernation to work.  To allow
    the affected systems to avoid saving and restoring the NVS area
    during suspend to RAM and resume, introduce kernel command line
    option acpi_sleep=nonvs and make acpi_sleep=s4_nonvs work as its
    alias temporarily (add acpi_sleep=s4_nonvs to the feature removal
    file).
    
    Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16396 .
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-and-tested-by: tomas m <tmezzadra@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bbac30edb39a80426e4a3420a5ec635eb4466f63
Merge: 4a973f2 6c9c0fd
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jul 22 18:19:12 2010 -0400

    Merge branch 'misc' into release

commit 4a973f2495fba8775d1c408b3ee7f2c19b19f13f
Merge: be48b11 d3e7e99
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jul 22 18:18:28 2010 -0400

    Merge branch 'bugzilla-15886' into release

commit be48b11573952b467676b24de87d637e33339e7d
Merge: 27568d8 096486e
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jul 22 18:18:18 2010 -0400

    Merge branch 'bugzilla-102904-workaround' into release

commit 27568d8e5f7a038795dff997a906f775084f927a
Merge: 855977e 153e500
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jul 22 18:18:05 2010 -0400

    Merge branch 'bugzilla-16244' into release

commit 855977ef6d07e8d1d50994ab7310e40d18a64e16
Merge: 840ba24 3d69583
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jul 22 18:17:39 2010 -0400

    Merge branch 'bugzilla-16271' into release

commit 840ba24dd615e71154f0faab136b744c0a481041
Merge: b37fa16 856b185
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jul 22 18:17:33 2010 -0400

    Merge branch 'bugzilla-16357' into release

commit d3e7e99f2faf9f44ec0a3379f735b41c9173dfa1
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jul 22 17:23:10 2010 -0400

    ACPI: create "processor.bm_check_disable" boot param
    
    processor.bm_check_disable=1" prevents Linux from checking BM_STS
    before entering C3-type cpu power states.
    
    This may be useful for a system running acpi_idle
    where the BIOS exports FADT C-states, _CST IO C-states,
    or _CST FFH C-states with the BM_STS bit set;
    while configuring the chipset to set BM_STS
    more frequently than perhaps is optimal.
    
    Note that such systems may have been developed
    using a tickful OS that would quickly clear BM_STS,
    rather than a tickless OS that may go for some time
    between checking and clearing BM_STS.
    
    Note also that an alternative for newer systems
    is to use the intel_idle driver, which always
    ignores BM_STS, relying Linux device drivers
    to register constraints explicitly via PM_QOS.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=15886
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 718be4aaf3613cf7c2d097f925abc3d3553c0605
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jul 22 16:54:27 2010 -0400

    ACPI: skip checking BM_STS if the BIOS doesn't ask for it
    
    It turns out that there is a bit in the _CST for Intel FFH C3
    that tells the OS if we should be checking BM_STS or not.
    
    Linux has been unconditionally checking BM_STS.
    If the chip-set is configured to enable BM_STS,
    it can retard or completely prevent entry into
    deep C-states -- as illustrated by turbostat:
    
    http://userweb.kernel.org/~lenb/acpi/utils/pmtools/turbostat/
    
    ref: Intel Processor Vendor-Specific ACPI Interface Specification
    table 4 "_CST FFH GAS Field Encoding"
    Bit 1: Set to 1 if OSPM should use Bus Master avoidance for this C-state
    
    https://bugzilla.kernel.org/show_bug.cgi?id=15886
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6c9c0fd062a6540dbee233151679b5f03ce433d9
Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date:   Tue Jul 20 15:18:35 2010 -0700

    ACPI: fix unused function warning
    
    CONFIG_ACPI_PROCFS=n:
    
    drivers/acpi/processor_idle.c:83: warning: 'us_to_pm_timer_ticks' defined but not used.
    
    Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 856b185dd23da39e562983fbf28860f54e661b41
Author: Alex Chiang <achiang@canonical.com>
Date:   Thu Jun 17 09:08:54 2010 -0600

    ACPI: processor: fix processor_physically_present on UP
    
    The commit 5d554a7bb06 (ACPI: processor: add internal
    processor_physically_present()) is broken on uniprocessor (UP)
    configurations, as acpi_get_cpuid() will always return -1.
    
    We use the value of num_possible_cpus() to tell us whether we got
    an invalid cpuid from acpi_get_cpuid() in the SMP case, or if
    instead, we are UP, in which case num_possible_cpus() is #defined
    as 1.
    
    We use num_possible_cpus() instead of num_online_cpus() to
    protect ourselves against the scenario of CPU hotplug, and we've
    taken down all the CPUs except one.
    
    Thanks to Jan Pogadl for initial report and analysis and Chen
    Gong for review.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=16357
    
    Reported-by: Jan Pogadl <pogadl.jan@googlemail.com>:
    Reviewed-by: Chen Gong <gong.chen@linux.intel.com>
    Signed-off-by: Alex Chiang <achiang@canonical.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 096486eece7ef38cf1ee46b704482c75c4010fb1
Author: Nik A. Melchior <melchior+kernel@cmu.edu>
Date:   Mon Jun 21 12:47:05 2010 +0800

    ACPI video: fix string mismatch for Sony SR290 laptop
    
    Fix string mismatch for Sony SR290 laptop.
    https://bugzilla.kernel.org/show_bug.cgi?id=12904#c45
    
    Signed-off-by: Nik A. Melchior <melchior+kernel@cmu.edu>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 153e500f516329f439856f52ccbf61d1fd1a946a
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Jul 7 09:11:57 2010 +0800

    ACPI battery: don't invoke power_supply_changed twice when battery is hot-added
    
    When battery is hot-added, we should not invoke power_supply_changed
    in acpi_battery_notify, because it has been invoked in acpi_battery_update,
    and battery->bat.changed_work is queued in keventd already.
    https://bugzilla.kernel.org/show_bug.cgi?id=16244
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Alexey Starikovskiy <astarikovskiy@sude.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3d695839a135a9b3f24b0d7cfd9c4fde2eadd2c5
Author: Len Brown <len.brown@intel.com>
Date:   Mon Jun 28 20:55:01 2010 -0400

    ACPI: handle systems which asynchoronously enable ACPI mode
    
    Folklore suggested that such systems existed
    in the pre-history of ACPI.
    
    However, we removed the SCI_EN polling loop from
    acpi_hw_set_mode() in b430acbd7c4b919886fa7fd92eeb7a695f1940d3
    because it delayed resume by 3 seconds on boxes
    that refused to set SCI_EN.
    
    Matthew removed the call to acpi_enable() from
    the suspend resume path.
    
    James found a modern system that still needs to be polled
    upon boot.
    
    So here we restore the workaround, except that we
    put it in acpi_enable() rather than the low level
    acpi_hw_set_mode().
    
    https://bugzilla.kernel.org/show_bug.cgi?id=16271
    
    Signed-off-by: Len Brown <len.brown@intel.com>
