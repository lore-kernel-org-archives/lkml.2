Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1E2JYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 05:24:08 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:51296 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1E2JYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 05:24:05 -0400
Date: Sun, 29 May 2011 05:23:45 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [GIT] ACPI patches for 2.6.40.merge
Message-id: <alpine.LFD.2.02.1105290520040.7577@arrandale.kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="-1463771648-284157137-1306661026=:7577"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463771648-284157137-1306661026=:7577
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center

ps. individual patches are available on linux-acpi@vger.kernel.org

 Documentation/acpi/method-customizing.txt |    5 +
 drivers/acpi/Kconfig                      |   15 ++
 drivers/acpi/Makefile                     |    1 +
 drivers/acpi/acpica/Makefile              |    2 +-
 drivers/acpi/acpica/acconfig.h            |    1 -
 drivers/acpi/acpica/acevents.h            |   17 +-
 drivers/acpi/acpica/acglobal.h            |   13 +-
 drivers/acpi/acpica/amlcode.h             |   15 --
 drivers/acpi/acpica/dswload.c             |    2 +-
 drivers/acpi/acpica/dswload2.c            |    2 +-
 drivers/acpi/acpica/evglock.c             |  335 +++++++++++++++++++++++++++++
 drivers/acpi/acpica/evmisc.c              |  303 --------------------------
 drivers/acpi/acpica/evregion.c            |  121 ++++++++++-
 drivers/acpi/acpica/evrgnini.c            |    2 +-
 drivers/acpi/acpica/evxfregn.c            |   13 +-
 drivers/acpi/acpica/excreate.c            |    3 +-
 drivers/acpi/acpica/nsrepair.c            |   13 +-
 drivers/acpi/acpica/utdecode.c            |    5 +-
 drivers/acpi/acpica/utmutex.c             |   12 +-
 drivers/acpi/bus.c                        |    2 +-
 drivers/acpi/custom_method.c              |  100 +++++++++
 drivers/acpi/debugfs.c                    |   92 +--------
 drivers/acpi/ec.c                         |   19 +-
 drivers/acpi/internal.h                   |    3 +-
 drivers/acpi/osl.c                        |   33 +++-
 drivers/acpi/processor_core.c             |   12 +-
 drivers/acpi/sysfs.c                      |    8 +
 drivers/pci/pci-acpi.c                    |    2 +
 drivers/platform/x86/compal-laptop.c      |   14 +-
 drivers/platform/x86/msi-laptop.c         |   12 +-
 drivers/thermal/thermal_sys.c             |   10 +-
 include/acpi/acpiosxf.h                   |    3 +
 include/acpi/acpixf.h                     |    2 +-
 include/acpi/actypes.h                    |   25 ++-
 include/acpi/processor.h                  |    7 -
 include/linux/acpi.h                      |    3 +-
 36 files changed, 729 insertions(+), 498 deletions(-)
 create mode 100644 drivers/acpi/acpica/evglock.c
 create mode 100644 drivers/acpi/custom_method.c

through these commits:

Bob Moore (6):
      ACPICA: Split all internal Global Lock functions to new file - evglock
      ACPICA: Add more methods eligible for NULL package element removal
      ACPICA: Update internal address SpaceID for DataTable regions
      ACPICA: Move ACPI_NUM_PREDEFINED_REGIONS to a more appropriate place
      ACPICA: Execute an orphan _REG method under the EC device
      ACPICA: Update to version 20110413

Durgadoss R (1):
      ACPI:Fix goto flows in thermal-sys

Lin Ming (5):
      ACPI: osl, add acpi_os_create_lock interface
      ACPICA: Use acpi_os_create_lock interface
      ACPICA: Fix code divergence of global lock handling
      ACPI: processor: fix processor_physically_present in UP kernel
      ACPI: Add D3 cold state

Peter Collingbourne (1):
      ACPI: EC: add another DMI check for ASUS hardware

Thomas Renninger (3):
      ACPI EC: remove dead code
      ACPI: Cleanup custom_method debug stuff
      ACPI: Split out custom_method functionality into an own driver

Zhang Rui (2):
      ACPI EC: enable MSI workaround for Quanta laptops
      ACPI EC: remove redundant code

with this log:

commit 751516f0a9bad32544f40f471037c0e45fb639c9
Merge: 6288cf1 08b53f0
Author: Len Brown <len.brown@intel.com>
Date:   Sun May 29 04:40:39 2011 -0400

    Merge branch 'ec-cleanup' into release
    
    Conflicts:
    	drivers/platform/x86/compal-laptop.c

commit 6288cf1e768ae73db5ddaaae54d85245cc1c2b56
Merge: 0a63e23 526b4af 932df74 534bc4e 28c2103 af986d1 b299eb5
Author: Len Brown <len.brown@intel.com>
Date:   Sun May 29 04:38:48 2011 -0400

    Merge branches 'acpica', 'aml-custom', 'bugzilla-16548', 'bugzilla-20242', 'd3-cold', 'ec-asus' and 'thermal-fix' into release

commit 08b53f0e6b565fe8dc0b8f929960ed16d76291bd
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Apr 26 16:29:55 2011 +0800

    ACPI EC: remove redundant code
    
    ec->handle is set in ec_parse_device(), so don't bother to set it again.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 28c2103dad04dba29ba86e22dad5735db8f0e13c
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed May 4 22:56:43 2011 +0800

    ACPI: Add D3 cold state
    
    _SxW returns an Integer containing the lowest D-state supported in state
    Sx. If OSPM has not indicated that it supports _PR3, then the value “3”
    corresponds to D3.  If it has indicated _PR3 support, the value “3”
    represents D3hot and the value “4” represents D3cold.
    
    Linux does set _OSC._PR3, so we should fix it to expect that _SxW can
    return 4.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 932df7414336a00f45e5aec62724cf736b0bcfd4
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon May 16 09:11:00 2011 +0800

    ACPI: processor: fix processor_physically_present in UP kernel
    
    Usually, there are multiple processors defined in ACPI table, for
    example
    
        Scope (_PR)
        {
            Processor (CPU0, 0x00, 0x00000410, 0x06) {}
            Processor (CPU1, 0x01, 0x00000410, 0x06) {}
            Processor (CPU2, 0x02, 0x00000410, 0x06) {}
            Processor (CPU3, 0x03, 0x00000410, 0x06) {}
        }
    
    processor_physically_present(...) will be called to check whether those
    processors are physically present.
    
    Currently we have below codes in processor_physically_present,
    
    cpuid = acpi_get_cpuid(...);
    if ((cpuid == -1) && (num_possible_cpus() > 1))
            return false;
    return true;
    
    In UP kernel, acpi_get_cpuid(...) always return -1 and
    num_possible_cpus() always return 1, so
    processor_physically_present(...) always returns true for all passed in
    processor handles.
    
    This is wrong for UP processor or SMP processor running UP kernel.
    
    This patch removes the !SMP version of acpi_get_cpuid(), so both UP and
    SMP kernel use the same acpi_get_cpuid function.
    
    And for UP kernel, only processor 0 is valid.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=16548
    https://bugzilla.kernel.org/show_bug.cgi?id=16357
    
    Tested-by: Anton Kochkov <anton.kochkov@gmail.com>
    Tested-by: Ambroz Bizjak <ambrop7@gmail.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 526b4af47f44148c9d665e57723ed9f86634c6e3
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu May 26 12:26:24 2011 +0200

    ACPI: Split out custom_method functionality into an own driver
    
    With /sys/kernel/debug/acpi/custom_method root can write
    to arbitrary memory and increase his priveleges, even if
    these are restricted.
    
    -> Make this an own debug .config option and warn about the
    security issue in the config description.
    
    -> Still keep acpi/debugfs.c which now only creates an empty
       /sys/kernel/debug/acpi directory. There might be other
       users of it later.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: rui.zhang@intel.com
    Signed-off-by: Len Brown <len.brown@intel.com>

commit aecad432fd68dafa5b3b497c4816fbfce6fd4066
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu May 26 12:26:23 2011 +0200

    ACPI: Cleanup custom_method debug stuff
    
    - Move param aml_debug_output to other params into sysfs.c
    - Split acpi_debugfs_init to prepare custom_method to be
      an own .config option and driver.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: rui.zhang@intel.com
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 534bc4e3d27096e2f3fc00c14a20efd597837a4f
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Apr 26 16:30:02 2011 +0800

    ACPI EC: enable MSI workaround for Quanta laptops
    
    Enable MSI workaround for Quanta laptops.
    https://bugzilla.kernel.org/show_bug.cgi?id=20242
    
    Tested-by: Jan-Matthias Braun <jan_braun@gmx.net>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0a63e2308cbbdc7e2f5645769afaf53785bcb9fa
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Apr 15 09:12:47 2011 +0800

    ACPICA: Update to version 20110413
    
    Version 20110413
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e2066ca1b211ff08325c98be9fb8ad95affbaba8
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 13 13:22:04 2011 +0800

    ACPICA: Execute an orphan _REG method under the EC device
    
    This change will force the execution of a _REG method underneath
    the EC device even if there is no corresponding operation region
    of type EmbeddedControl. Fixes a problem seen on some machines
    and apparently is compatible with Windows behavior.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=875
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 07aa99e9df2184e78068f7d5414e29e4a5a1b452
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 13 13:20:49 2011 +0800

    ACPICA: Move ACPI_NUM_PREDEFINED_REGIONS to a more appropriate place
    
    Moved to where the predefined regions are actually defined.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 82a1b7cb83b6bd7d2fe3972e847c8ccbff55cb9c
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 13 13:19:35 2011 +0800

    ACPICA: Update internal address SpaceID for DataTable regions
    
    Moved this internal space id in preparation for ACPI 5.0 changes
    that will include some new space IDs.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 945488b9c5fc3f85e3f6a3580235b5c73febc8a6
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 13 13:15:58 2011 +0800

    ACPICA: Add more methods eligible for NULL package element removal
    
    This change adds another group of predefined names to the list
    of names eligible to have NULL package elements dynamically
    removed. This group is the names that return a single
    variable-length package containing simple data types such
    as integers, buffers, strings. This includes: _ALx,_BCL,_CID,
    _DOD,_EDL,_FIX,_PCL,_PLD,_PMD,_PRx,_PSL,_Sx, and _TZD.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=914
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0f6896f195df014064014493c8287a8e2d18f938
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Apr 13 11:33:17 2011 +0800

    ACPICA: Split all internal Global Lock functions to new file - evglock
    
    These functions were moved from evmisc.c
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit af986d101d141f10231ffa7e40ae397dc7356857
Author: Peter Collingbourne <peter@pcc.me.uk>
Date:   Sun Apr 24 22:09:32 2011 +0100

    ACPI: EC: add another DMI check for ASUS hardware
    
    Commit 0adf3c746a73684b3f8c2821a584e1db998f61e9 introduced a regression
    by making the ECDT validation test for ASUS hardware more restrictive.
    The previous test used the dmi_name_in_vendors function which searches
    a number of DMI fields, while the new test checked only the BIOS
    vendor, which is known to not match on an ASUS F5GL laptop which
    requires ECDT validation.
    
    Add a rule to ec_dmi_table based on an alternative DMI pattern for
    ASUS hardware as found elsewhere in the kernel.
    
    Signed-off-by: Peter Collingbourne <peter@pcc.me.uk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1cb7b1e0de6a1f8f071f4a146e3d10f3a662f707
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu Mar 31 13:36:38 2011 +0200

    ACPI EC: remove dead code
    
    static void acpi_ec_gpe_query(void *ec_cxt);
    -> The function is right above this declaration -> not needed.
    
    poll_force is also not used, cleaned up in ec.c and its users:
    compal-laptop and msi-laptop.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 749c27639b95c5c4a8185e02a4efb189034944ed
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Mar 23 17:26:36 2011 +0800

    ACPICA: Fix code divergence of global lock handling
    
    Commit 9cd0314(ACPI / ACPICA: Fix global lock acquisition) was backported
    into ACPICA code base, and some divergence was introduced.
    
    This patch fixed it,
    - rename acpi_ev_global_lock_pending/acpi_ev_global_lock_pending_lock
      to acpi_gbl_global_lock_pending/acpi_gbl_global_lock_pending_lock.
    
    - move the initialization of acpi_gbl_global_lock_pending_lock from
      acpi_ut_mutex_initialize to acpi_ev_init_global_lock_handler.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3854c8e32f46ffa6ee0bf2eb01137f5a48b2754f
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Mar 23 17:26:35 2011 +0800

    ACPICA: Use acpi_os_create_lock interface
    
    Replace spin_lock_init with acpi_os_create_lock.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9f63b88bd7a1ac1afbb4358772a39abaeddbdd13
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Mar 23 17:26:34 2011 +0800

    ACPI: osl, add acpi_os_create_lock interface
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b299eb5cde1a91706c450804006c6559b0826df8
Author: Durgadoss R <durgadoss.r@intel.com>
Date:   Thu Mar 3 04:30:13 2011 +0530

    ACPI:Fix goto flows in thermal-sys
    
    This patch fixes two minor bugs in thermal_sys:
    (a) The flow of goto's in thermal_hwmon_add_sysfs.
    (b) Remove the temp*_crit only if there is a get_crit_temp defined, in
        thermal_remove_hwmon_sysfs.
    
    Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
---1463771648-284157137-1306661026=:7577--
