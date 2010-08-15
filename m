Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab0HOFMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:12:47 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:50305 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab0HOFMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:12:45 -0400
Date: Sun, 15 Aug 2010 01:12:42 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] ACPI patches for 2.6.36.merge
Message-id: <alpine.LFD.2.00.1008150110440.2294@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.35/acpi-release-20100702-2.6.35.diff.gz

 Documentation/acpi/method-customizing.txt |    2 +
 arch/x86/kernel/cpu/mcheck/mce-apei.c     |    4 +-
 drivers/acpi/Kconfig                      |   11 +-
 drivers/acpi/Makefile                     |    5 +-
 drivers/acpi/acpica/acevents.h            |    4 +
 drivers/acpi/acpica/acglobal.h            |    2 +-
 drivers/acpi/acpica/aclocal.h             |    1 +
 drivers/acpi/acpica/evgpe.c               |   73 +++++
 drivers/acpi/acpica/evxface.c             |   77 ++++--
 drivers/acpi/acpica/evxfevnt.c            |   62 +----
 drivers/acpi/acpica/utmutex.c             |    5 +-
 drivers/acpi/apei/Kconfig                 |    9 +
 drivers/acpi/apei/Makefile                |    1 +
 drivers/acpi/apei/apei-base.c             |    4 +-
 drivers/acpi/apei/erst-dbg.c              |  207 +++++++++++++
 drivers/acpi/apei/ghes.c                  |  172 ++++++-----
 drivers/acpi/apei/hest.c                  |   76 +++++-
 drivers/acpi/bus.c                        |    4 +-
 drivers/acpi/debug.c                      |  422 --------------------------
 drivers/acpi/debugfs.c                    |   93 ++++++
 drivers/acpi/glue.c                       |    3 +-
 drivers/acpi/internal.h                   |    8 +-
 drivers/acpi/numa.c                       |    4 +-
 drivers/acpi/osl.c                        |    7 +-
 drivers/acpi/power.c                      |  130 +--------
 drivers/acpi/proc.c                       |   70 -----
 drivers/acpi/processor_driver.c           |   85 ------
 drivers/acpi/processor_idle.c             |  102 +-------
 drivers/acpi/processor_thermal.c          |   83 -----
 drivers/acpi/processor_throttling.c       |    2 -
 drivers/acpi/sleep.c                      |   60 ++---
 drivers/acpi/sleep.h                      |    5 +-
 drivers/acpi/{system.c => sysfs.c}        |  466 ++++++++++++++++-------------
 drivers/acpi/thermal.c                    |   86 ++++--
 drivers/acpi/video.c                      |  141 ++++++----
 drivers/acpi/wakeup.c                     |   48 +---
 drivers/ata/libata-acpi.c                 |    6 -
 include/acpi/acpixf.h                     |    2 +-
 include/acpi/processor.h                  |    1 -
 include/linux/cper.h                      |    8 +-
 40 files changed, 1071 insertions(+), 1480 deletions(-)
 create mode 100644 drivers/acpi/apei/erst-dbg.c
 delete mode 100644 drivers/acpi/debug.c
 create mode 100644 drivers/acpi/debugfs.c
 rename drivers/acpi/{system.c => sysfs.c} (57%)

through these commits:

Andi Kleen (1):
      gcc-4.6: ACPI: fix unused but set variables in ACPI

Huang Ying (4):
      ACPI, APEI, Fix a typo of error path of apei_resources_request
      ACPI, APEI, Rename CPER and GHES severity constants
      ACPI, APEI, Manage GHES as platform devices
      ACPI, APEI, ERST debug support

Rafael J. Wysocki (6):
      ACPI / Sleep: Free NVS copy if suspending of devices fails
      ACPI / Sleep: Rework enabling wakeup devices
      ACPI / Wakeup: Simplify enabling of wakeup devices
      ACPI / Sleep: Consolidate suspend and hibernation routines
      ACPI / Sleep: Drop acpi_suspend_finish()
      ACPI / ACPICA: Fix reference counting problems with GPE handlers

Zhang Rui (8):
      ACPI: introduce drivers/acpi/debugfs.c
      ACPI: introduce module parameter acpi.aml_debug_output
      ACPI: introduce drivers/acpi/sysfs.c
      ACPI: remove deprecated ACPI procfs I/F
      ACPI power_resource: remove unused procfs I/F
      ACPI processor: remove deprecated ACPI procfs I/F
      ACPI video: make procfs I/F depend on CONFIG_ACPI_PROCFS
      ACPI thermal: make procfs I/F depend on CONFIG_ACPI_PROCFS

Zhao Yakui (1):
      ACPI: Add the check of ADR flag in course of finding ACPI handle for PCI device

with this log:

commit 95ee46aa8698f2000647dfb362400fadbb5807cf
Merge: cfa806f 92fa5bd9
Author: Len Brown <len.brown@intel.com>
Date:   Sun Aug 15 01:06:31 2010 -0400

    Merge branch 'linus' into release
    
    Conflicts:
    	drivers/acpi/debug.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cfa806f059801dbe7e435745eb2e187c8bfe1e7f
Author: Andi Kleen <andi@firstfloor.org>
Date:   Tue Jul 20 15:18:36 2010 -0700

    gcc-4.6: ACPI: fix unused but set variables in ACPI
    
    Some minor improvements in error handling, but overall it was mostly dead
    code.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 43d9f87b79804f2d75d9d8a81c862b179f055a15
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jul 15 10:46:44 2010 +0800

    ACPI thermal: make procfs I/F depend on CONFIG_ACPI_PROCFS
    
    Mark the ACPI thermal procfs I/F deprecated, because /sys/class/thermal/
    is already available and has been working for years w/o any problem.
    
    The ACPI thermal procfs I/F will be removed in 2.6.37.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6e37c658aefa57c472b2dbf1de88dbd3c67cdb52
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jul 15 10:46:43 2010 +0800

    ACPI video: make procfs I/F depend on CONFIG_ACPI_PROCFS
    
    Mark ACPI video driver procfs I/F deprecated, including:
    /proc/acpi/video/*/info
    /proc/acpi/video/*/DOS
    /proc/acpi/video/*/ROM
    /proc/acpi/video/*/POST
    /proc/acpi/video/*/POST_info
    /proc/acpi/video/*/*/info
    /proc/acpi/video/*/*/state
    /proc/acpi/video/*/*/EDID
    and
    /proc/acpi/video/*/*/brightness, because
    1. we already have the sysfs I/F /sysclass/backlight/ as the replacement
    of /proc/acpi/video/*/*/brightness.
    2. the other procfs I/F is not useful for userspace.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d09fe55510257f1acd21ea80a9bdd7c72b5895b3
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jul 15 10:46:41 2010 +0800

    ACPI processor: remove deprecated ACPI procfs I/F
    
    Remove deprecated ACPI processor procfs I/F, including:
    /proc/acpi/processor/CPUX/power
    /proc/acpi/processor/CPUX/limit
    /proc/acpi/processor/CPUX/info
    
    /proc/acpi/processor/CPUX/throttling still exists,
    as we don't have sysfs I/F available for now.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 06af7eb043c02822072cea862fce1b7c74115e8f
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jul 15 10:46:38 2010 +0800

    ACPI power_resource: remove unused procfs I/F
    
    Remove unused ACPI power procfs I/F.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 47f5c892b06797336a34f1096b4b617623aa1960
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jul 15 10:46:33 2010 +0800

    ACPI: remove deprecated ACPI procfs I/F
    
    Rmove deprecated ACPI procfs I/F, including
    /proc/acpi/debug_layer
    /proc/acpi/debug_level
    /proc/acpi/info
    /proc/acpi/dsdt
    /proc/acpi/fadt
    /proc/acpi/sleep
    
    because the sysfs I/F is already available
    and has been working well for years.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1c8fce27e275fd7c6b75bc6455745f02d3903ee6
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jul 15 10:46:30 2010 +0800

    ACPI: introduce drivers/acpi/sysfs.c
    
    Introduce drivers/acpi/sysfs.c.
    
    code for ACPI sysfs I/F, including
    #ifdef ACPI_DEBUG
    /sys/module/acpi/parameters/debug_layer
    /sys/module/acpi/parameters/debug_level
    /sys/module/acpi/parameters/trace_method_name
    /sys/module/acpi/parameters/trace_debug_layer
    /sys/module/acpi/parameters/trace_debug_level
    /sys/module/acpi/parameters/trace_state
    #endif
    /sys/module/acpi/parameters/acpica_version
    /sys/firmware/acpi/tables/
    /sys/firmware/acpi/interrupts/
    is moved to this file.
    
    No function change in this patch.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c172cb73bc79fe69915b1a1a48e374aa4b1f8a59
Merge: e8eb622 28f4f8a
Author: Len Brown <len.brown@intel.com>
Date:   Sun Aug 15 00:25:40 2010 -0400

    Merge branch 'acpica-gpe' into release

commit e8eb6228094bcf0c84d9aa32b6363e78da68e1f5
Merge: ecd8ee0 108029f
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 14 23:57:32 2010 -0400

    Merge branch 'bugzilla-16422' into release

commit ecd8ee0955a2f21914c2e2ffff82541211c5bd43
Merge: feb29c5 c637e48
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 14 23:55:57 2010 -0400

    Merge branch 'procfs-cleanup' into release

commit feb29c5175e61d0f1ec2cbcaccdfa55e588780be
Merge: f2a6618 2ff729d
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 14 23:55:47 2010 -0400

    Merge branch 'apei' into release

commit f2a66185bed21427d8d347a42eaf0ad1d3d9fc63
Merge: 9fe6206 618d7fd
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 14 23:55:44 2010 -0400

    Merge branch 'nvs' into release

commit c637e4861c7db8165d0f438db3829e7878c96059
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jul 15 10:46:17 2010 +0800

    ACPI: introduce module parameter acpi.aml_debug_output
    
    Introduce module parameter acpi.aml_debug_output.
    
    With acpi.aml_debug_output set, we can get AML debug object output
    (Store (AAA, Debug)), even with CONFIG_ACPI_DEBUG cleared.
    
    Together with the runtime custom method mechanism,
    we can debug AML code problems without rebuilding the kernel.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a25ee9200eef07377e1703697afbb5d81f89e500
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jul 15 10:46:15 2010 +0800

    ACPI: introduce drivers/acpi/debugfs.c
    
    Introduce drivers/acpi/debugfs.c.
    
    Code for ACPI debugfs I/F,
    i.e. /sys/kernel/debug/acpi/custom_method,
    is moved to this file.
    
    And make ACPI debugfs always built in,
    even if CONFIG_ACPI_DEBUG is cleared.
    
    BTW:this adds about 400bytes code to ACPI, when
    CONFIG_ACPI_DEBUG is cleared.
    
    [uaccess.h build fix from Andrew Morton <akpm@linux-foundation.org>]
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2ff729d506e8db82d76a93bc963df4d0a4d46b57
Author: Huang Ying <ying.huang@intel.com>
Date:   Thu Aug 12 11:55:17 2010 +0800

    ACPI, APEI, ERST debug support
    
    This patch adds debugging/testing support to ERST. A misc device is
    implemented to export raw ERST read/write/clear etc operations to user
    space. With this patch, we can add ERST testing support to
    linuxfirmwarekit ISO (linuxfirmwarekit.org) to verify the kernel
    support and the firmware implementation.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7ad6e9435596f692ff65f399da12816c94960185
Author: Huang Ying <ying.huang@intel.com>
Date:   Mon Aug 2 15:48:24 2010 +0800

    ACPI, APEI, Manage GHES as platform devices
    
    Register GHES during HEST initialization as platform devices. And make
    GHES driver into platform device driver. So that the GHES driver
    module can be loaded automatically when there are GHES available.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ad4ecef2f13c790f95b55320f2925c205d8f971f
Author: Huang Ying <ying.huang@intel.com>
Date:   Mon Aug 2 15:48:23 2010 +0800

    ACPI, APEI, Rename CPER and GHES severity constants
    
    The abbreviation of severity should be SEV instead of SER, so the CPER
    severity constants are renamed accordingly. GHES severity constants
    are renamed in the same way too.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2663b3f23537618c0c286551b138353fe26b3df8
Author: Huang Ying <ying.huang@intel.com>
Date:   Mon Aug 2 15:48:22 2010 +0800

    ACPI, APEI, Fix a typo of error path of apei_resources_request
    
    Fix a typo of error path of apei_resources_request. release_mem_region
    and release_region should be interchange.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 28f4f8a9def2b1f3a6066bae791c77043ec49524
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Aug 3 23:55:14 2010 +0200

    ACPI / ACPICA: Fix reference counting problems with GPE handlers
    
    If a handler is installed for a GPE associated with an AML method and
    such that it cannot wake up the system from sleep states, the GPE
    remains enabled after the handler has been installed, although it
    should be disabled in that case to avoid spurious execution of the
    handler.
    
    Fix this issue by making acpi_install_gpe_handler() disable GPEs
    that were previously associated with AML methods and cannot wake up
    the system from sleep states.
    
    Analogously, make acpi_remove_gpe_handler() enable the GPEs that
    are associated with AML methods after their handlers have been
    removed and cannot wake up the system from sleep states.  In addition
    to that, fix a code ordering issue in acpi_remove_gpe_handler() that
    renders the locking ineffective (ACPI_MTX_EVENTS is released
    temporarily in the middle of the routine to wait for the completion
    of events already in progress).
    
    For this purpose introduce acpi_raw_disable_gpe() and
    acpi_raw_enable_gpe() to be called with acpi_gbl_gpe_lock held
    and rework acpi_disable_gpe() and acpi_enable_gpe(), respectively, to
    use them.  Also rework acpi_gpe_can_wake() to use
    acpi_raw_disable_gpe() instead of calling acpi_disable_gpe() after
    releasing the lock to avoid the possible theoretical race with
    acpi_install_gpe_handler().
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Cc: "Moore, Robert" <robert.moore@intel.com>
    Cc: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 108029ff84fcad8f9199d2d2e2583ae2747d45a4
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Jul 13 03:36:08 2010 +0000

    ACPI: Add the check of ADR flag in course of finding ACPI handle for PCI device
    
    The _ADR object is used to provide OSPM with the address of one device on its
    parent bus. In course of finding ACPI handle for the corresponding PCI device,
    we will firstly evaluate the _ADR object and then compare the two addresses to
    see whether it is the target ACPI device. But for one PCI device(0000:00:00.0)
    under the PCI root bridge, the corresponding address will be constructed as
    zero.In such case maybe the ACPI device without _ADR object will be misdetected
    and then be used to create the relationship between PCI device and ACPI device.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=16422
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 618d7fd0d4e51a45d25d9bc6097a0cb1e5a2f226
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jul 2 00:14:57 2010 +0200

    ACPI / Sleep: Drop acpi_suspend_finish()
    
    The function acpi_suspend_finish() is not necessary any more, because
    acpi_pm_finish() can be used instead of it just fine.  Remove it.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c5f7a1bb65bca03253c189e946b3ca79669f08af
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jul 2 00:14:09 2010 +0200

    ACPI / Sleep: Consolidate suspend and hibernation routines
    
    Some hibernation and suspend routines can be merged, which reduces
    the complexity of code a bit.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 78f5f023167813130d2cf657d1b9eadc32f0e992
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jul 6 22:09:38 2010 -0400

    ACPI / Wakeup: Simplify enabling of wakeup devices
    
    To simplify the enabling of wakeup devices during system suspend and
    hibernation, merge acpi_enable_wakeup_device_prep() with
    acpi_disable_wakeup_device() and remove unnecessary (and no longer
    valid) comments from the latter.  Rename acpi_enable_wakeup_device()
    to acpi_enable_wakeup_devices() and acpi_disable_wakeup_device()
    to acpi_disable_wakeup_devices(), because these functions usually
    operate on multiple device objects.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 25bed55753b8cf243406e8837990b55946c5278d
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jul 2 00:12:26 2010 +0200

    ACPI / Sleep: Rework enabling wakeup devices
    
    There is no reason why acpi_enable_wakeup_device() should be called
    with interrupts disabled, because it doesn't access hardware.  Thus
    it is possible to move it next to acpi_enable_wakeup_device_prep()
    and make the ACPI suspend, hibernate and poweroff code more
    straightforward.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e96c4b081df0991a57b244f68c3955a9ea00bd0a
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Jul 6 18:28:35 2010 -0400

    ACPI / Sleep: Free NVS copy if suspending of devices fails
    
    If suspending of devices fails or system suspend is tested in the
    "devices" mode, the memory allocated for storing a copy of the ACPI
    NVS area will not be freed, because acpi_pm_finish() is not called
    in that case.  Fix this by moving the suspend_nvs_free() call to
    acpi_pm_end().
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>
