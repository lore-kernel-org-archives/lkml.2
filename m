Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab0JZUIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:08:51 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:39966 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab0JZUIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:08:49 -0400
Date: Tue, 26 Oct 2010 16:08:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: [git pull request] ACPI patches for 2.6.37-merge
Message-id: <alpine.LFD.2.00.1010261554260.14156@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-1532557439-1288123706=:14156"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1532557439-1288123706=:14156
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

ACPICA udpate from Bob Moore and Lin Ming,
including work from Rafael Wysocki and Matthew Garrett's GPE efforts
We lost Alexey as the EC and battery sub-maintainer
Myron Stowe addressed a low level problem we had with MMIO
Rui Zhang continues the process of deleting /proc/acpi/
plus various bug-fixes from various contributors.
No APEI update.

This will update the files shown below.


thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.36/acpi-release-20101013-2.6.36.diff.gz

 MAINTAINERS                                |   15 -
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    1 +
 drivers/acpi/Kconfig                       |   13 +-
 drivers/acpi/ac.c                          |   14 -
 drivers/acpi/acpica/Makefile               |    5 +-
 drivers/acpi/acpica/acdebug.h              |    2 +
 drivers/acpi/acpica/acevents.h             |    5 +-
 drivers/acpi/acpica/acglobal.h             |    9 +-
 drivers/acpi/acpica/achware.h              |    7 +
 drivers/acpi/acpica/aclocal.h              |   15 +-
 drivers/acpi/acpica/acmacros.h             |    4 +-
 drivers/acpi/acpica/acnamesp.h             |   12 -
 drivers/acpi/acpica/acobject.h             |    2 +-
 drivers/acpi/acpica/acutils.h              |   56 ++-
 drivers/acpi/acpica/dsmethod.c             |    2 +-
 drivers/acpi/acpica/dswexec.c              |   19 +-
 drivers/acpi/acpica/evevent.c              |   41 --
 drivers/acpi/acpica/evgpeblk.c             |   47 +-
 drivers/acpi/acpica/evgpeinit.c            |   31 +--
 drivers/acpi/acpica/evmisc.c               |    2 +-
 drivers/acpi/acpica/evrgnini.c             |   14 +-
 drivers/acpi/acpica/evxface.c              |   19 +-
 drivers/acpi/acpica/evxfevnt.c             |   61 ++-
 drivers/acpi/acpica/evxfregn.c             |    6 +
 drivers/acpi/acpica/exfldio.c              |   75 ++-
 drivers/acpi/acpica/exmutex.c              |   10 +-
 drivers/acpi/acpica/exprep.c               |   45 +-
 drivers/acpi/acpica/exregion.c             |    4 +-
 drivers/acpi/acpica/hwpci.c                |  412 +++++++++++++++
 drivers/acpi/acpica/nsrepair2.c            |  163 ++++++
 drivers/acpi/acpica/nsutils.c              |   98 ----
 drivers/acpi/acpica/tbfadt.c               |    4 +-
 drivers/acpi/acpica/utdebug.c              |    7 +-
 drivers/acpi/acpica/uteval.c               |  147 ------
 drivers/acpi/acpica/utglobal.c             |    9 +-
 drivers/acpi/acpica/utids.c                |   45 +--
 drivers/acpi/acpica/utinit.c               |    4 +
 drivers/acpi/acpica/utmath.c               |   23 +-
 drivers/acpi/acpica/utmisc.c               |  162 ------
 drivers/acpi/acpica/utmutex.c              |   37 +-
 drivers/acpi/acpica/utosi.c                |  380 ++++++++++++++
 drivers/acpi/acpica/utxface.c              |  138 +++++-
 drivers/acpi/acpica/utxferror.c            |  415 +++++++++++++++
 drivers/acpi/battery.c                     |   94 +++--
 drivers/acpi/bus.c                         |    7 +-
 drivers/acpi/button.c                      |    4 +-
 drivers/acpi/dock.c                        |    7 +-
 drivers/acpi/ec.c                          |    9 +-
 drivers/acpi/fan.c                         |  139 +-----
 drivers/acpi/osl.c                         |  463 ++++++++++-------
 drivers/acpi/pci_irq.c                     |    1 -
 drivers/acpi/pci_link.c                    |    1 -
 drivers/acpi/pci_root.c                    |    1 -
 drivers/acpi/power.c                       |  167 +++----
 drivers/acpi/processor_driver.c            |   22 +-
 drivers/acpi/processor_idle.c              |    1 -
 drivers/acpi/processor_thermal.c           |  178 -------
 drivers/acpi/processor_throttling.c        |    4 +
 drivers/acpi/sbs.c                         |   25 -
 drivers/acpi/scan.c                        |   46 +-
 drivers/acpi/sleep.c                       |   28 +-
 drivers/acpi/sleep.h                       |    1 -
 drivers/acpi/thermal.c                     |  436 +----------------
 drivers/acpi/video.c                       |  771 +---------------------------
 drivers/pnp/base.h                         |    5 +-
 drivers/pnp/core.c                         |    8 +-
 drivers/pnp/driver.c                       |    2 +-
 drivers/pnp/pnpacpi/core.c                 |   31 +-
 drivers/pnp/resource.c                     |   10 +-
 include/acpi/acpi_bus.h                    |   14 +-
 include/acpi/acpi_drivers.h                |    2 -
 include/acpi/acpiosxf.h                    |   14 +-
 include/acpi/acpixf.h                      |   11 +-
 include/acpi/actypes.h                     |   30 +-
 include/acpi/platform/acenv.h              |    6 +
 include/acpi/platform/acgcc.h              |    2 +
 include/acpi/platform/aclinux.h            |    7 +-
 include/linux/acpi.h                       |   11 +-
 78 files changed, 2424 insertions(+), 2714 deletions(-)
 create mode 100644 drivers/acpi/acpica/hwpci.c
 create mode 100644 drivers/acpi/acpica/utosi.c
 create mode 100644 drivers/acpi/acpica/utxferror.c

through these commits:

Bjorn Helgaas (1):
      PNP: log PNP resources, as we do for PCI

Bob Moore (16):
      ACPICA: Fix acpi_os_read_pci_configuration prototype
      ACPICA: Revert "Revert "Enable multi-byte EC transfers
      ACPICA: Update version to 20100806
      ACPICA: Obsolete the acpi_os_derive_pci_id OSL interface
      ACPICA: Update math module; no functional change
      ACPICA: Make acpi_gbl_system_awake_and_running publically available
      ACPICA: iASL/Disassembler: Write ACPI errors to stderr instead of output file
      ACPICA: Add repair for _HID and _CID strings
      ACPICA: Increase configurability of error messages
      ACPICA: Update version to 20100915
      ACPICA: Comment update; no functional change
      ACPICA: Change type of _TZ from ThermalZone to Device
      ACPICA: Eliminate duplicate code in acpi_ut_execute_* functions
      ACPICA: Add Vista SP2 to supported _OSI strings
      ACPICA: Update version to 20101013
      Subject: [PATCH] ACPICA: Fix Scope() op in module level code

Colin Ian King (1):
      ACPICA: Clear PCIEXP_WAKE_STS when clearing ACPI events

Dmitry Torokhov (1):
      PNPACPI: cope with invalid device IDs

Jean Delvare (1):
      ACPI: Only processor needs CPU_IDLE

Len Brown (3):
      ACPI: add FW_BUG to OSI(Linux) message
      ACPI: delete dedicated MAINTAINERS entries for ACPI EC and BATTERY drivers
      ACPI: thermal: remove unused limit code

Lin Ming (3):
      ACPICA/ACPI: Add new host interfaces for _OSI support
      ACPICA: Add ACPI_INLINE configuration parameter
      ACPICA: Make acpi_thread_id no longer configurable, always u64

Myron Stowe (6):
      ACPI: Fix ioremap size for MMIO reads and writes
      ACPI: Maintain a list of ACPI memory mapped I/O remappings
      ACPI: Add interfaces for ioremapping/iounmapping ACPI registers
      ACPI: Pre-map 'system event' related register blocks
      ACPI: Convert simple locking to RCU based locking
      ACPI: Page based coalescing of I/O remappings optimization

Rafael J. Wysocki (5):
      ACPI / ACPICA: Defer enabling of runtime GPEs (v3)
      ACPI / PM: Fix problems with acpi_pm_device_sleep_state()
      ACPI / PM: Fix reference counting of power resources
      ACPI / Battery: Return -ENODEV for unknown values in get_property()
      ACPI / PM: Blacklist another machine that needs acpi_sleep=nonvs

Stephen Hemminger (2):
      ACPI: remove dead code
      ACPI: static sleep_states[] and acpi_gts_bfs_check

Thomas Renninger (4):
      ACPI: Remove unused #define ACPI_PROCESSOR_FILE_POWER
      ACPI: Do not export hid/modalias sysfs file for ACPI objects without a HID
      ACPI/PNP: A HID value of an object never changes -> make it const
      ACPI: Make Embedded Controller command timeout delay configurable

Uwe Kleine-König (1):
      ACPI dock: move some functions to .init.text

Zhang Rui (9):
      acpi-cpufreq: fix a memleak when unloading driver
      ACPI ac/battery/sbs: sysfs I/F always built in, procfs I/F disabled by default
      ACPI fan: remove deprecated procfs I/F
      ACPI thermal: remove deprecated procfs I/F
      ACPI video: remove deprecated procfs I/F
      ACPI processor: make /proc/acpi/processor/*/throttle depends on CONFIG_ACPI_PROCFS
      ACPI: remove unused declaration of proc_fs.h
      ACPI battery: support percentage battery remaining capacity
      ACPI: install ACPI table handler before any dynamic tables being loaded

with this log:

commit 7e31842441776b4d6ec7fd916c91663ad05b7814
Merge: 1bd64d4 b1d248d
Author: Len Brown <len.brown@intel.com>
Date:   Tue Oct 26 14:51:00 2010 -0400

    Merge branch 'misc' into release

commit 1bd64d42abdd4f9d44f77011a31f0292112f4c3b
Merge: 4895ae6 4a3cba5
Author: Len Brown <len.brown@intel.com>
Date:   Tue Oct 26 14:50:56 2010 -0400

    Merge branch 'acpi-mmio' into release
    
    Conflicts:
    	drivers/acpi/osl.c
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b1d248d96c71665c79befb81207f38f894c7c082
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Oct 26 10:06:54 2010 +0800

    ACPI: install ACPI table handler before any dynamic tables being loaded
    
    ACPI table sysfs I/F is broken by commit
    
    78f1699659963fff97975df44db6d5dbe7218e55
    Author: Alex Chiang <achiang@hp.com>
    Date:   Sun Dec 20 12:19:09 2009 -0700
        ACPI: processor: call _PDC early
    
    because dynamic SSDT tables may be loaded in _PDC,
    before installing the ACPI table handler.
    As a result, the sysfs I/F of these dynamic tables are
    located at  /sys/firmware/acpi/tables instead of
    /sys/firmware/acpi/tables/dynamic, which is not true.
    
    Invoke acpi_sysfs_init() before acpi_early_processor_set_pdc(),
    so that the table handler is installed before any dynamic tables loaded.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=21142
    
    CC: Dennis Jansen <dennis.jansen@web.de>
    CC: Alex Chiang <achiang@hp.com>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit af48931c4863ced64cc52c58757be6e254437f9a
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Oct 17 21:01:21 2010 +0200

    ACPI / PM: Blacklist another machine that needs acpi_sleep=nonvs
    
    Sony Vaio VPCEB1Z1E is reported to require acpi_sleep=nonvs for
    suspend/resume to work on it correctly, so blacklist it.
    
    Reported-by: Emanuele Bigiarini <pulmro@gmail.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4895ae6f9f81011bf3a6fea70d46bab08d58fd8c
Merge: 8c654bb 7a18e96
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:14:50 2010 -0400

    Merge branch 'ec-param' into release

commit 8c654bb80801aeafba071396602c777758604980
Merge: b10b977 c1f3f28
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:13:48 2010 -0400

    Merge branch 'pnp-log' into release

commit b10b977b792bb28c03267e00562c8254dca50f36
Merge: 22156ea 420a0f6
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:13:44 2010 -0400

    Merge branch 'pnpacpi-invalid-device-id' into release

commit 22156ea7bb631ac4d74b706f4875d41b2520dc26
Merge: d3b683d 3e384ee
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:13:37 2010 -0400

    Merge branch 'power-refcount' into release

commit d3b683d3b0e260938b9ed568f76a00991d5c692b
Merge: 6e04c41 eaeca2e
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:13:21 2010 -0400

    Merge branch 'cleanup' into release

commit 6e04c417aed5b0a5bd6ae80928bbd759fa1faabc
Merge: 8803080 a210080
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:13:09 2010 -0400

    Merge branch 'gpe-defer' into release

commit 880308089d0abebac365c3a1378b4e3238b100ac
Merge: e000f8f a1b4bd6
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:12:57 2010 -0400

    Merge branch 'battery' into release

commit e000f8f72908e2ae924ec3900f2c0e18e76d26da
Merge: 38add9b 761afb8
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:12:46 2010 -0400

    Merge branch 'acpi_pm_device_sleep_state' into release

commit 38add9b4baec61655228d86b8d0caa62f15fd857
Merge: f3ab69a dab5fff 557d586 620e112
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:12:27 2010 -0400

    Merge branches 'bugzilla-15807', 'bugzilla-15979-v2' and 'bugzilla-19162' into release

commit f3ab69a321d08ce123dce8166eabe7fddd94b949
Merge: aca209e 03e7c34
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:11:49 2010 -0400

    Merge branch 'procfs-cleanup-v2' into release

commit aca209e5e654951a3a90f5aaa8e04e0c470993b4
Merge: f6f94e2 8df3fc9
Author: Len Brown <len.brown@intel.com>
Date:   Mon Oct 25 02:10:36 2010 -0400

    Merge branch 'acpica' into release
    
    Conflicts:
    	drivers/acpi/acpica/aclocal.h
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4a3cba5e72a5232842ff7c1ca691ec3450af64b9
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Thu Oct 21 14:24:14 2010 -0600

    ACPI: Page based coalescing of I/O remappings optimization
    
    This patch optimizes ACPI MMIO remappings by keeping track of the
    remappings on a PAGE_SIZE granularity.
    
    When an ioremap() occurs, the underlying infrastructure works on a 'page'
    based granularity.  As such, an ioremap() request for 1 byte for example,
    will end up mapping in an entire (PAGE_SIZE) page.  Huang Ying took
    advantage of this in commit 15651291a2f8c11e7e6a42d8bfde7a213ff13262 by
    checking if subsequent ioremap() requests reside within any of the list's
    existing remappings still in place, and if so, incrementing a reference
    count on the existing mapping as opposed to performing another ioremap().
    
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 78cdb3ed4053798c894899b15d2255fb880edad4
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Thu Oct 21 14:24:09 2010 -0600

    ACPI: Convert simple locking to RCU based locking
    
    Convert the simple locking introduced earlier for the ACPI MMIO
    remappings list to an RCU based locking scheme.
    
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d362edaf5386acedad4319a6721bb1540b74dcf7
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Thu Oct 21 14:24:04 2010 -0600

    ACPI: Pre-map 'system event' related register blocks
    
    During ACPI initialization, pre-map fixed hardware registers that are
    accessed during ACPI's 'system event' related IRQ handing.
    
    ACPI's 'system event' handing accesses specific fixed hardware
    registers; namely PM1a event, PM1b event, GPE0, and GPE1 register
    blocks which are declared within the FADT.  If these registers are
    backed by MMIO, as opposed to I/O port space, accessing them within
    interrupt context will cause a panic as acpi_os_read_memory()
    depends on ioremap() in such cases - BZ 18012.
    
    By utilizing the functionality provided in the previous two patches -
    ACPI: Maintain a list of ACPI memory mapped I/O remappings, and, ACPI:
    Add interfaces for ioremapping/iounmapping ACPI registers - accesses
    to ACPI MMIO areas will now be safe from within interrupt contexts (IRQ
    and/or NMI) provided the area was pre-mapped.  This solves BZ 18012.
    
    ACPI "System Event" reference(s):
      ACPI Specification, Revision 4.0, Section 3 "ACPI Overview",
      3.8 "System Events", 5.6 "ACPI Event Programming Model".
    
    Reference: https://bugzilla.kernel.org/show_bug.cgi?id=18012
    
    Reported-by: <bjorn.helgaas@hp.com>
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 29718521237a1b1607ea05b49243100ea2044337
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Thu Oct 21 14:23:59 2010 -0600

    ACPI: Add interfaces for ioremapping/iounmapping ACPI registers
    
    Add remapping and unmapping interfaces for ACPI registers that are
    backed by memory mapped I/O (MMIO).  These interfaces, along with
    the MMIO remapping list, enable accesses of such registers from within
    interrupt context.
    
    ACPI Generic Address Structure (GAS) reference (ACPI's fixed/generic
    hardware registers use the GAS format):
      ACPI Specification, Revision 4.0, Section 5.2.3.1, "Generic Address
      Structure".
    
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 620242ae8c3d9c0b1a77451744fb2d855d1e7342
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Thu Oct 21 14:23:53 2010 -0600

    ACPI: Maintain a list of ACPI memory mapped I/O remappings
    
    For memory mapped I/O (MMIO) remappings, add a list to maintain the
    remappings and augment the corresponding mapping and unmapping interface
    routines (acpi_os_map_memory() and acpi_os_unmap_memory()) to
    dynamically add to, and delete from, the list.
    
    The current ACPI I/O accessing methods - acpi_read() and acpi_write() -
    end up calling ioremap() when accessing MMIO.  This prevents use of these
    methods within interrupt context (IRQ and/or NMI), since ioremap() may
    block to allocate memory.  Maintaining a list of MMIO remappings enables
    accesses to such areas from within interrupt context provided they have
    been pre-mapped.
    
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b3ba1efec2a58f4dc0647f4c0099c27d6ab92595
Author: Myron Stowe <myron.stowe@hp.com>
Date:   Thu Oct 21 14:23:48 2010 -0600

    ACPI: Fix ioremap size for MMIO reads and writes
    
    The size used for I/O remapping MMIO read and write accesses has not
    accounted for the basis of ACPI's Generic Address Structure (GAS)
    'Register Bit Width' field which is bits, not bytes.  This patch
    adjusts the ioremap() 'size' argument accordingly.
    
    ACPI "Generic Register" reference:
      ACPI Specification, Revision 4.0, Section 5.2.3.1, "Generic Address
      Structure".
    
    Signed-off-by: Myron Stowe <myron.stowe@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a1b4bd694a803eba49d637de32bb249638ceadb4
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Oct 23 19:35:15 2010 +0200

    ACPI / Battery: Return -ENODEV for unknown values in get_property()
    
    The function acpi_battery_get_property() is called by the
    power supply framework's function power_supply_show_property()
    implementing the sysfs interface for power supply devices as the
    ACPI battery driver's ->get_property() callback.  Thus it is supposed
    to return error code if the value of the given property is unknown.
    Unfortunately, however, it returns 0 in those cases and puts a
    wrong (negative) value into the intval field of the
    union power_supply_propval object provided by
    power_supply_show_property().  In consequence, wrong negative
    values are read by user space from the battery's sysfs files.
    
    Fix this by making acpi_battery_get_property() return -ENODEV
    for properties with unknown values (-ENODEV is returned, because
    power_supply_uevent() returns with error for any other error code
    returned by power_supply_show_property()).
    
    Reported-and-tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e384ee6c687cb397581ee8f9440fc8220cfac80
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Oct 22 02:35:54 2010 +0200

    ACPI / PM: Fix reference counting of power resources
    
    The reference counting of ACPI power resources is currently broken
    for a few reasons.  First, instead of using a simple reference
    counter per power resource it uses a list of objects representing
    refereces to the given power resource from devices.  This leads to
    the second breakage, because it prevents power resources from
    being referenced more than once by one device, which is necessary
    if the device is configured to signal wakeup.  Namely, when putting
    the device into a low power state we first call
    acpi_enable_wakeup_device_power() that should reference count power
    resources needed for signaling wakeup and then we call
    acpi_power_transition() to power off the device.  The latter call
    drops references to the device's power resources, possibly including
    the ones added by acpi_enable_wakeup_device_power(), so the device
    can't signal wakeup as a result.  Apart from this, the locking
    in acpi_power_on() and acpi_power_off_device() doesn't prevent
    all possible races from happening, which may be problematic for
    runtime PM and asynchronous suspend and resume.
    
    Fix the problem by using a counter for power resources reference
    counting and putting the evaluation of ACPI _ON and _OFF methods
    under the power resource mutex.
    
    Reported-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8df3fc981dc12d9fdcaef4100a2193b605024d7a
Author: Bob Moore <robert.moore@intel.com>
Date:   Sat Oct 23 01:36:40 2010 -0400

    Subject: [PATCH] ACPICA: Fix Scope() op in module level code
    
    Some Panasonic Toughbooks create nodes in module level code.
    Module level code is the executable AML code outside of control method,
    for example, below AML code creates a node \_SB.PCI0.GFX0.DD02.CUBL
    
            If (\_OSI ("Windows 2006"))
            {
                Scope (\_SB.PCI0.GFX0.DD02)
                {
                    Name (CUBL, Ones)
                    ...
                }
            }
    
    Scope() op does not actually create a new object, it refers to an
    existing object(\_SB.PCI0.GFX0.DD02 in above example). However, for
    Scope(), we want to indeed open a new scope, so the child nodes(CUBL in
    above example) can be created correctly under it.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=19462
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 557d58687dcdee6bc00c1a8f1fd4e0eac8fefce9
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Oct 22 10:02:06 2010 +0800

    ACPI battery: support percentage battery remaining capacity
    
    According to the ACPI spec, some kinds of primary battery can
    report percentage battery remaining capacity directly to OS.
    
    In this case, it reports the LastFullChargedCapacity == 100,
    BatteryPresentRate = 0xFFFFFFFF, and BatteryRemaingCapacity a
    percentage value, which actually means RemainingBatteryPercentage.
    
    Now we found some battery follows this rule even if it's a rechargeable.
    https://bugzilla.kernel.org/show_bug.cgi?id=15979
    
    Handle these batteries correctly in ACPI battery driver
    so that they won't break userspace.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7a18e96dcbdec3c96876444ae2c7e36ce458e151
Author: Thomas Renninger <trenn@suse.de>
Date:   Thu Oct 21 18:24:57 2010 +0200

    ACPI: Make Embedded Controller command timeout delay configurable
    
    Here and then there show up machines which need higher timeout values.
    Finding this on affected machines can be cumbersome, because
    ACPI_EC_DELAY is a compile option -> make it configurable via boot param.
    
    This can even be provided writable at runtime via:
    /sys/modules/acpi/parameters/ec_delay
    
    Known machines where this helps:
    Some HP machines where for whatever reasons specific EC accesses take
    very long at resume from S3 (in _WAK function).
    The AE_TIME error is passed upwards and the ACPI interpreter will
    not execute the rest of the _WAK function which results in not properly
    initialized devices/variables with different side-effects.
    
    Afaik, on some MSI machines this helped as well.
    
    If this param is needed there probably are underlying problems like:
      - EC firmware bug
      - A kernel EC driver bug
      - An ACPI interpreter behavior (e.g. timings when specific
        EC accesses happen and how) which the EC does not like
      - ...
    which should get evaluated further, but often are nasty or
    impossible to fix from OS side.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d38a5edf812c2f715242aa20b6beb785939a0096
Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Tue Oct 19 09:13:39 2010 +0200

    ACPI dock: move some functions to .init.text
    
    find_dock and find_bay are only called by dock_init which lives in
    .init.text dock_add is only called by find_dock and find_bay.  So all
    three functions can be moved to .init.text, too.
    
    This fixes:
    
            WARNING: vmlinux.o(.text+0x2134b7): Section mismatch in reference from the function dock_add() to the function .init.text:platform_device_register_resndata()
            The function dock_add() references
            the function __init platform_device_register_resndata().
            This is often because dock_add lacks a __init
            annotation or the annotation of platform_device_register_resndata is wrong.
    
    for a build with unset CONFIG_MODULES.
    
    Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ab7c13c4a5a22335b0cfc6f364ee77abed66503c
Author: Len Brown <len.brown@intel.com>
Date:   Tue Oct 19 13:58:34 2010 -0400

    ACPI: thermal: remove unused limit code
    
    acpi_processor_apply_limit()
    acpi_thermal_cpufreq_increase()
    acpi_thermal_cpufreq_decrease()
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 01eac60bccdb0ce49a2937d59da1e4749697a9aa
Author: Stephen Hemminger <shemminger@vyatta.com>
Date:   Mon Oct 18 18:47:25 2010 -0700

    ACPI: static sleep_states[] and acpi_gts_bfs_check
    
    Only used in one file so should be static.
    
    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5ba8b1c6fe40c314a02e28553c25552d8f1442e7
Author: Stephen Hemminger <shemminger@vyatta.com>
Date:   Mon Oct 18 08:42:48 2010 -0700

    ACPI: remove dead code
    
    Found by running make namespacecheck on linux-next
    
    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3a2468d0274d10916baf5318f9004a8061533370
Author: Len Brown <len.brown@intel.com>
Date:   Thu Oct 14 20:43:56 2010 -0400

    ACPI: delete dedicated MAINTAINERS entries for ACPI EC and BATTERY drivers
    
    We thank Alexey Starikovskiy for his significant contributions
    not only to the ACPI EC and battery code, but for his profound
    positive impact on the ACPICA core itself.
    
    Alexey is busy with new challenges now, and so we'll take his
    name out of MAINTAINERS to reflect that the EC and battery
    are once again maintained as part part of the general ACPI
    sub-system without a dedicated sub-maintainer.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a4084c147bd06ecc13d787eec626ff1faf8f5851
Author: Jean Delvare <khali@linux-fr.org>
Date:   Sun Oct 10 14:54:52 2010 +0200

    ACPI: Only processor needs CPU_IDLE
    
    ACPI support itself doesn't need CPU_IDLE, only ACPI_PROCESSOR does,
    so only ACPI_PROCESSOR should select CPU_IDLE.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8af2cdeaeefb2712b752e223c6d3396b9894b80d
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Oct 18 09:10:58 2010 +0800

    ACPICA: Update version to 20101013
    
    Version 20101013.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 49b3c1e04e1dd3cd9a428b0d8367193b73e472c1
Author: Colin Ian King <colin.king@canonical.com>
Date:   Mon Oct 18 09:38:36 2010 +0800

    ACPICA: Clear PCIEXP_WAKE_STS when clearing ACPI events
    
    When clearing status bits via acpi_hw_clear_acpi_status, also clear
    the PCIEXP_WAKE_STS bit. Original change from Colin King.
    ACPICA BZ 880.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=880
    http://bugs.launchpad.net/bugs/613381
    
    Signed-off-by: Colin Ian King <colin.king@canonical.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 23ebbf07068f84b7ed119a0bef4a3f0ebb82c894
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Oct 18 08:50:47 2010 +0800

    ACPICA: Add Vista SP2 to supported _OSI strings
    
    Added "Windows 2006 SP2" for Vista SP2.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 34cf66e724a2bf0a406d59b18f5bfeed746d7979
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Oct 18 08:47:16 2010 +0800

    ACPICA: Eliminate duplicate code in acpi_ut_execute_* functions
    
    Now that the nsrepair code automatically repairs _HID-related
    strings, this type of code is no longer needed in acpi_ut_execute_HID,
    acpi_ut_execute_CID, and acpi_ut_execute_UID. ACPICA BZ 878.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=878
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 81256669aaaa8b06a617f8d0613cb7fb24f8b910
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Oct 18 08:44:34 2010 +0800

    ACPICA: Change type of _TZ from ThermalZone to Device
    
    The type of ThermalZone was confusing hosts as they process the
    various ThermalZone objects. ACPICA BZ 876.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=876
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3989170f8e3c1bd71d8f7ec6e3d52e46815ee096
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Oct 18 08:43:13 2010 +0800

    ACPICA: Comment update; no functional change
    
    Add a usage note to InstallAddressSpaceHandler.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 03e7c3432d40d067476eaf49ede29128b637998f
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Oct 8 13:55:17 2010 +0800

    ACPI: remove unused declaration of proc_fs.h
    
    Remove unused declaration of proc_fs.h.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d5c6887c7fbaf7a149c3bf441338fa833c529fb4
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Oct 8 13:55:15 2010 +0800

    ACPI processor: make /proc/acpi/processor/*/throttle depends on CONFIG_ACPI_PROCFS
    
    As a feature that would only be used when system is overheating,
    the processor t-state control should not be exported to user space.
    Make /proc/acpi/processor/*/throttle depends on CONFIG_ACPI_PROCFS,
    which is cleared by default.
    And we will remove this I/F in 2.6.38.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 39fe394d05be43481ceac8b3db19dfd5189097f6
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Oct 8 13:55:11 2010 +0800

    ACPI video: remove deprecated procfs I/F
    
    Remove the deprecated ACPI video driver procfs I/F,
    as stated in the changelog of commit 6e37c658aefa57c472b2dbf1de88dbd3c67cdb52
    
    New sysfs I/F is available at /sys/class/backlight/
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c57b62f5b1e6dd69ff8c96f6db7f86ea31c0e21f
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Oct 8 13:55:06 2010 +0800

    ACPI thermal: remove deprecated procfs I/F
    
    Remove the deprecated ACPI thermal driver procfs I/F,
    as stated in the changelog of commit 43d9f87b79804f2d75d9d8a81c862b179f055a15
    
    sysfs I/F is available at /sys/class/thermal/thermal_zoneX/
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b2a44989c1dbfae409035eaffad4292c27fc7cb8
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Oct 8 13:55:03 2010 +0800

    ACPI fan: remove deprecated procfs I/F
    
    Remove deprecated ACPI Fan driver procfs interface.
    
    The ACPI fan driver (CONFIG_ACPI_FAN) selects
    the generic thermal sysfs driver (CONFIG_THERMAL) since 2.6.26,
    so new sysfs I/F is available at /sys/class/thermal/cooling_devicecX/
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1b3d4c3b9a597e216c08bff2c59a8de872ef2d09
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Fri Oct 8 13:54:57 2010 +0800

    ACPI ac/battery/sbs: sysfs I/F always built in, procfs I/F disabled by default
    
    ACPI AC/Battery/SBS driver has different kernel option for procfs and sysfs I/F.
    
    This patch,
    1. Change CONFIG_ACPI_PROCFS_POWER to 'n' by default so that we can remove it in the next release or two.
    2. Remove CONFIG_ACPI_SYSFS_POWER and always build in the sysfs I/F of these drivers.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3af283e1141474925b33383425bbe038e75fd03a
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 15 21:38:57 2010 -0400

    ACPI: add FW_BUG to OSI(Linux) message
    
    Linux-2.6.22 initiated a dmesg complaint when it saw BIOS that invoked
    OSI(Linux).  Linux-2.6.23 continued that complaint and started our
    policy of ignoring the bogus BIOS request.
    
    Past-time for Linux to label that complaint with FW_BUG.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 761afb869f649ea23e2dea7bfe9b550d3a1b7631
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Oct 14 23:24:13 2010 +0200

    ACPI / PM: Fix problems with acpi_pm_device_sleep_state()
    
    There is a number of problems with acpi_pm_device_sleep_state() now.
    First, if _S0W is not defined, it prevents devices from being put
    into D3 by PCI runtime PM, which shouldn't happen.  Second, it
    shouldn't use adev->wakeup.state.enabled, because if it's set, it
    only means that either the device is permanently enabled to wake up
    the system, or that it has been enabled to do that through
    /proc/acpi/wakeup.  Finally, it should be compiled if CONFIG_PM_SLEEP
    is not set, so that PCI runtime PM works correctly in that case.
    Fix these problems.
    
    Reported-by: Matthew Garrett <mjg59@srcf.ucam.org>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit dab5fff14df2cd16eb1ad4c02e83915e1063fece
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Tue Oct 12 09:09:37 2010 +0800

    acpi-cpufreq: fix a memleak when unloading driver
    
    We didn't free per_cpu(acfreq_data, cpu)->freq_table
    when acpi_freq driver is unloaded.
    
    Resulting in the following messages in /sys/kernel/debug/kmemleak:
    
    unreferenced object 0xf6450e80 (size 64):
      comm "modprobe", pid 1066, jiffies 4294677317 (age 19290.453s)
      hex dump (first 32 bytes):
        00 00 00 00 e8 a2 24 00 01 00 00 00 00 9f 24 00  ......$.......$.
        02 00 00 00 00 6a 18 00 03 00 00 00 00 35 0c 00  .....j.......5..
      backtrace:
        [<c123ba97>] kmemleak_alloc+0x27/0x50
        [<c109f96f>] __kmalloc+0xcf/0x110
        [<f9da97ee>] acpi_cpufreq_cpu_init+0x1ee/0x4e4 [acpi_cpufreq]
        [<c11cd8d2>] cpufreq_add_dev+0x142/0x3a0
        [<c11920b7>] sysdev_driver_register+0x97/0x110
        [<c11cce56>] cpufreq_register_driver+0x86/0x140
        [<f9dad080>] 0xf9dad080
        [<c1001130>] do_one_initcall+0x30/0x160
        [<c10626e9>] sys_init_module+0x99/0x1e0
        [<c1002d97>] sysenter_do_call+0x12/0x26
        [<ffffffff>] 0xffffffff
    
    https://bugzilla.kernel.org/show_bug.cgi?id=15807#c21
    
    Tested-by: Toralf Forster <toralf.foerster@gmx.de>
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 620e112cfe1c9281c176de8ad1a7691c4eb4950d
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Oct 1 10:54:00 2010 +0200

    ACPI/PNP: A HID value of an object never changes -> make it const
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2b2ae7c7f8e25043793042eb9df88aa875b4cff8
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Oct 1 10:53:59 2010 +0200

    ACPI: Do not export hid/modalias sysfs file for ACPI objects without a HID
    
    Boot and compile tested.
    The fact that pnp.ids can now be empty needs testing on some
    further machines, though.
    
    This should handle a "modprobe is wrongly called by udev" issue:
    https://bugzilla.kernel.org/show_bug.cgi?id=19162
    
    Modaliase files in
    /sys/devices/LNXSYSTM:00/
    went down from 113 to 71 on my tested system.
    
    This is a sysfs change, but userspace must already be able to handle it.
    
    Also do not fill up pnp.ids list with a "struct hid"
    entry. This comment:
         * This generic ID isn't useful for driver binding, but it provides
         * the useful property that "every acpi_device has an ID."
    is still half way true:
    Best you never touch pnp.ids list directly or make sure it can be empty,
    instead use:
    char *acpi_device_hid()
    which always returns a value ("device" as a dummy if the object
    has no hid).
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    CC: Zhang Rui <rui.zhang@intel.com>
    CC: kay.sievers@vrfy.org
    CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eaeca2e9a7dbd8f05a8a47e66e3e1de105426f0b
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Oct 1 10:54:53 2010 +0200

    ACPI: Remove unused #define ACPI_PROCESSOR_FILE_POWER
    
    Looks like a left over from /proc/acpi/processor/*/power which got removed
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 420a0f66378c84b00b0e603e4d38210102dbe367
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Sat Sep 18 10:11:09 2010 -0700

    PNPACPI: cope with invalid device IDs
    
    If primary ID (HID) is invalid try locating first valid ID on compatible
    ID list before giving up.
    
    This helps, for example, to recognize i8042 AUX port on Sony Vaio VPCZ1
    which uses SNYSYN0003 as HID. Without the patch users are forced to
    boot with i8042.nopnp to make use of their touchpads.
    
    Tested-by: Jan-Hendrik Zab <jan@jhz.name>
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1f3f2819667a238585c65bba96c8b16af39a442
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Wed Sep 29 12:24:23 2010 -0600

    PNP: log PNP resources, as we do for PCI
    
    ACPI devices are often involved in address space conflicts with PCI devices,
    so I think it's worth logging the resources they use.  Otherwise we have to
    depend on lspnp or groping around in sysfs to find them.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 846b44ad4ed11fe4dc1bddd484dde71c272bcf1b
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Sep 17 08:15:02 2010 +0800

    ACPICA: Update version to 20100915
    
    Version 20100915.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 75434a2ae37b78887b7a1d70d0a23bbd5e09fb01
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Sep 17 08:14:01 2010 +0800

    ACPICA: Increase configurability of error messages
    
    Update to utxferror.c
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 77b23f712bc40a65160e7d02b045f1562bb43ff1
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Sep 15 14:11:02 2010 +0800

    ACPICA: Add repair for _HID and _CID strings
    
    This dynamic repair will fix these problems:
    1) Remove a leading asterisk in the string
    2) Uppercase the entire string
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cc84e262b71bab53c3b2be2e71209c85b88b4b4d
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Sep 15 14:09:14 2010 +0800

    ACPICA: iASL/Disassembler: Write ACPI errors to stderr instead of output file
    
    This keeps the output files clean of random error messages that
    may originate from within the namespace/interpreter code.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 31b3d4c3b3c599a2329c3e66ffab7a045b169c85
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Sep 15 14:02:56 2010 +0800

    ACPICA: Make acpi_gbl_system_awake_and_running publically available
    
    Added extern for this boolean in acpixf.h. Some hosts utilize
    this value during suspend/restore operations.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e786db75406b30fa74dea095c571c8c164a2f3dd
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Sep 15 14:00:53 2010 +0800

    ACPICA: Update math module; no functional change
    
    Move the 64-bit overlay structures to the utmath module since
    they are used nowhere else. Update module comment. ACPICA BZ 829.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=829
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 28eb3fcf8762a3b52f4fef5af29dce50d23c7151
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Sep 15 13:55:13 2010 +0800

    ACPICA: Make acpi_thread_id no longer configurable, always u64
    
    Change definition of acpi_thread_id to always be a u64. This
    simplifies the code, especially any printf output. u64 is
    the only common data type for all thread_id types across all
    operating systems. We now force the OSL to cast the native
    thread_id type to u64 before returning the value to ACPICA
    (via acpi_os_get_thread_id).
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8f40f171a29d0d2ae1ca8bd4a0c3fc9f514d1e20
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Sep 15 13:36:55 2010 +0800

    ACPICA: Add ACPI_INLINE configuration parameter
    
    The C inline keyword is not standardized, ACPI_INLINE allows this
    to be configured on a per-compiler basis.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95abccb576c44bc593e05fa1245d0ad26ce6107b
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Sep 15 13:22:46 2010 +0800

    ACPICA: Obsolete the acpi_os_derive_pci_id OSL interface
    
    This function is not OS-dependent and has been replaced by
    acpi_hw_derive_pci_id, which is now in the ACPICA core code.  Local
    implementations of acpi_os_derive_pci_id are no longer necessary and
    are removed. ACPICA BZ 857.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=857
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6087658d7d576b8aeed8f9188cd9917db29aa0dd
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Aug 11 10:14:35 2010 +0800

    ACPICA: Update version to 20100806
    
    Version 20100806.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b0ed7a915abac309fcb5a51bccd3782e3daa7417
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Fri Aug 6 09:35:51 2010 +0800

    ACPICA/ACPI: Add new host interfaces for _OSI support
    
    Adds install/remove interfaces so that the host can dynamically
    alter the global _OSI table. Also adds support for _OSI handlers.
    Additional support: new debugger command (osi), and test support in
    the acpiexec utility. Adds new file, utilities/utosi.c.
    ACPICA bugzilla 836.
    
    The Linux OSL _OSI code is also changed.
    acpi_osi_setup can't call acpi_install/remove_interface because ACPICA
    is not initialized yet at this early time.
    So we just save the osi string in acpi_osi_setup and will handle it
    later in a new function acpi_osi_setup_late.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=836
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 09387b43153953006471dbb06ece6bf779d10937
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Aug 6 09:09:33 2010 +0800

    ACPICA: Revert "Revert "Enable multi-byte EC transfers
    
    This reverts commit f23b9c7(http://git.moblin.org/cgit.cgi/acpica/commit/?id=f23b9c7)
    The problem with this change was determined to be a problem with
    the FreeBSD host OSL (OS services layer), not with this patch
    itself. Therefore, re-introducing this change into the main ACPICA
    code. See ACPICA bugzilla 863.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=863
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c5f0231ee6b0441e4c45f461f2b6652b10195494
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Aug 6 08:57:53 2010 +0800

    ACPICA: Fix acpi_os_read_pci_configuration prototype
    
    Prototype in acpiosxf.h had the output value pointer as a (u32 *).
    Should be a (u64 *).
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a210080195c95ebca2a517ee3057d71607aa65e0
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Sep 16 00:30:43 2010 +0200

    ACPI / ACPICA: Defer enabling of runtime GPEs (v3)
    
    The current ACPI GPEs initialization code has a problem that it
    enables some GPEs pointed to by device _PRW methods, generally
    intended for signaling wakeup events (system or device wakeup).
    These GPEs are then almost immediately disabled by the ACPI namespace
    scanning code with the help of acpi_gpe_can_wake(), but it would be
    better not to enable them at all until really necessary.
    
    Modify the initialization of GPEs so that the ones that have
    associated _Lxx or _Exx methods and are not pointed to by any _PRW
    methods will be enabled after the namespace scan is complete.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>
--8323328-1532557439-1288123706=:14156--
