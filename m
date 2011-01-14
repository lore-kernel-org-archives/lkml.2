Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab1ANDvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:51:05 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:45032 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1ANDu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:50:57 -0500
Date: Thu, 13 Jan 2011 22:50:49 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] ACPI patches for 2.6.38-merge
Message-id: <alpine.LFD.2.02.1101132237190.9760@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-1884074247-1294977050=:9760"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1884074247-1294977050=:9760
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

AML can now talk to IPMI (some power meters use this)
Thermal sub-system can now send events to user-space (MRST uses this)
Progress deleting some crufty ACPI /procfs code, more is planned.
Rafael has been giving the wakeup events, GPE's and NVS lots of TLC.
ACPICA update is largely to sync with  Rafael's Linux updates.
APEI update uses just printk for kernel/user interface:-)

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.37/acpi-release-20101209-2.6.37.diff.gz

 Documentation/ABI/stable/thermal-notification |    4 +
 Documentation/IPMI.txt                        |   27 +
 Documentation/acpi/apei/output_format.txt     |  122 +++++
 Documentation/feature-removal-schedule.txt    |   11 +
 Documentation/kernel-parameters.txt           |    5 -
 Documentation/thermal/sysfs-api.txt           |   12 +
 arch/ia64/include/asm/io.h                    |    5 +
 arch/x86/kernel/acpi/boot.c                   |    1 +
 arch/x86/kernel/dumpstack.c                   |    1 +
 arch/x86/kernel/e820.c                        |    1 +
 drivers/acpi/Kconfig                          |   18 +-
 drivers/acpi/Makefile                         |    3 +-
 drivers/acpi/ac.c                             |    3 +-
 drivers/acpi/acpi_ipmi.c                      |  525 +++++++++++++++++++
 drivers/acpi/acpica/Makefile                  |    2 +-
 drivers/acpi/acpica/acevents.h                |   21 +-
 drivers/acpi/acpica/acglobal.h                |    7 +-
 drivers/acpi/acpica/achware.h                 |    2 +-
 drivers/acpi/acpica/aclocal.h                 |   13 +-
 drivers/acpi/acpica/evevent.c                 |   12 +-
 drivers/acpi/acpica/evgpe.c                   |  265 +++++++----
 drivers/acpi/acpica/evgpeblk.c                |   33 +-
 drivers/acpi/acpica/evgpeinit.c               |   25 +-
 drivers/acpi/acpica/evgpeutil.c               |   39 ++
 drivers/acpi/acpica/evmisc.c                  |   94 ++--
 drivers/acpi/acpica/evxface.c                 |   77 +++-
 drivers/acpi/acpica/evxfevnt.c                |  600 ----------------------
 drivers/acpi/acpica/evxfgpe.c                 |  669 +++++++++++++++++++++++++
 drivers/acpi/acpica/hwgpe.c                   |   32 +-
 drivers/acpi/acpica/utglobal.c                |    3 +-
 drivers/acpi/apei/apei-internal.h             |    2 +
 drivers/acpi/apei/cper.c                      |  311 ++++++++++++
 drivers/acpi/apei/ghes.c                      |  431 +++++++++++++----
 drivers/acpi/battery.c                        |   16 +
 drivers/acpi/bus.c                            |  153 +++---
 drivers/acpi/button.c                         |    9 +-
 drivers/acpi/dock.c                           |    2 +-
 drivers/acpi/ec.c                             |    5 +-
 drivers/acpi/fan.c                            |   27 +-
 drivers/acpi/glue.c                           |    5 +-
 drivers/acpi/internal.h                       |   13 +-
 {kernel/power => drivers/acpi}/nvs.c          |   20 +-
 drivers/acpi/osl.c                            |   17 +-
 drivers/acpi/power.c                          |  128 +++--
 drivers/acpi/proc.c                           |   41 +--
 drivers/acpi/processor_driver.c               |   80 +---
 drivers/acpi/processor_throttling.c           |  190 +++-----
 drivers/acpi/sbs.c                            |    2 +
 drivers/acpi/scan.c                           |   70 ++-
 drivers/acpi/sleep.c                          |   13 +-
 drivers/acpi/sysfs.c                          |   19 +-
 drivers/acpi/thermal.c                        |    5 +-
 drivers/acpi/video.c                          |  104 +----
 drivers/acpi/video_detect.c                   |   57 +--
 drivers/acpi/wakeup.c                         |   22 +-
 drivers/char/ipmi/ipmi_msghandler.c           |   27 +
 drivers/char/ipmi/ipmi_si_intf.c              |   23 +-
 drivers/gpu/drm/Kconfig                       |    1 -
 drivers/gpu/stub/Kconfig                      |    1 -
 drivers/platform/x86/fujitsu-laptop.c         |    4 +-
 drivers/pnp/Makefile                          |    6 +-
 drivers/pnp/core.c                            |    7 +-
 drivers/pnp/driver.c                          |    7 +-
 drivers/pnp/isapnp/Makefile                   |    6 +-
 drivers/pnp/pnpacpi/Makefile                  |    3 +-
 drivers/pnp/pnpacpi/core.c                    |   93 +++-
 drivers/pnp/pnpbios/Makefile                  |    5 +-
 drivers/thermal/Kconfig                       |    1 +
 drivers/thermal/thermal_sys.c                 |  120 ++++-
 include/acpi/acpi_bus.h                       |   12 +-
 include/acpi/acpixf.h                         |   20 +-
 include/acpi/actypes.h                        |   54 ++-
 include/acpi/processor.h                      |    6 +
 include/linux/acpi.h                          |   10 +
 include/linux/cper.h                          |   86 +++-
 include/linux/ipmi.h                          |   38 ++
 include/linux/ipmi_smi.h                      |    8 +
 include/linux/suspend.h                       |   17 -
 include/linux/thermal.h                       |   47 ++-
 kernel/panic.c                                |    1 +
 kernel/power/Kconfig                          |    5 -
 kernel/power/Makefile                         |    1 -
 lib/ioremap.c                                 |    2 +
 mm/vmalloc.c                                  |    1 +
 84 files changed, 3374 insertions(+), 1612 deletions(-)
 create mode 100644 Documentation/ABI/stable/thermal-notification
 create mode 100644 Documentation/acpi/apei/output_format.txt
 create mode 100644 drivers/acpi/acpi_ipmi.c
 create mode 100644 drivers/acpi/acpica/evxfgpe.c
 rename {kernel/power => drivers/acpi}/nvs.c (86%)

through these commits:

Alan Cox (1):
      thermal: make ops constant

Huang Ying (4):
      Add CPER PCIe error section structure and constants definition
      ACPI, APEI, Add APEI generic error status printing support
      ACPI, APEI, Report GHES error information via printk
      ACPI, APEI, Generic Hardware Error Source POLL/IRQ/NMI notification type support

Jiri Slaby (1):
      PM: Fix oops in suspend/hibernate code related to failing ioremap()

Len Brown (1):
      ACPI: Use ioremap_cache()

Lin Ming (9):
      ACPICA: Move GPE functions to new file evxfgpe.c
      ACPICA: Rename some function and variable names
      ACPICA: New GPE handler callback definition
      ACPICA: Remove unused function declarations
      ACPICA: Fix local variable mess in acpi_ev_asynch_execute_gpe_method
      ACPICA: Implicit notify support
      ACPICA: Global event handler
      ACPICA: Misc comments to minimize code divergence
      ACPICA: Update version to 20101209

R.Durgadoss (1):
      thermal: Add event notification to thermal framework

Rafael J. Wysocki (28):
      PM / ACPI: Move NVS saving and restoring code to drivers/acpi
      ACPI / PM: Update file information and the list of includes in nvs.c
      ACPI / PM: Make suspend_nvs_save() use acpi_os_map_memory()
      ACPI / ACPICA: Fix global lock acquisition
      ACPI / PM: Do not enable multiple devices to wake up simultaneously
      ACPI / PM: Use device wakeup flags for handling ACPI wakeup devices
      ACPI / PM: Drop special ACPI wakeup flags
      ACPI / PM: Report wakeup events from buttons
      ACPI / PM: Blacklist Averatec machine known to require acpi_sleep=nonvs
      PNP / ACPI: Use DEVICE_ACPI_HANDLE() for device ACPI handle access
      ACPI / PM: Prevent acpi_power_get_inferred_state() from making changes
      ACPI / PM: Add functions for manipulating lists of power resources
      ACPI / PM: Introduce function for refcounting device power resources
      ACPI / PM: Introduce __acpi_bus_get_power()
      ACPI / PM: Add function for device power state initialization
      ACPI / PM: Add function for updating device power state consistently
      ACPI / PM: Register acpi_power_driver early
      ACPI / PM: Register power resource devices as soon as they are needed
      ACPI / Fan: Rework the handling of power resources
      Platform / x86: Make fujitsu_laptop use acpi_bus_update_power()
      ACPI / PM: Drop acpi_bus_get_power()
      ACPI / PM: Drop acpi_power_nocheck
      ACPI / PM: Rename acpi_power_off_device()
      ACPI / PM: Check status of power resources under mutexes
      ACPI: Always check if _PRW is present before trying to evaluate it
      ACPI: Drop device flag wake_capable
      ACPI / Battery: Update information on info notification and resume
      ACPI / PM: Fix build problems for !CONFIG_ACPI related to NVS rework

Thomas Renninger (3):
      PNP: Compile all pnp built-in stuff in one module namespace
      PNP: Set up pnp_debug via module and not via boot param.
      ACPI: fix resource check message

Zhang Rui (6):
      ACPI processor: remove processor throttling control procfs I/F
      ACPI video: remove output switching control
      ACPI video: check cap._DDC flag before getting EDID
      ACPI video: introduce module parameter video.use_bios_initial_backlight
      ACPI: update CONFIG_ACPI_PROCFS description
      ACPI: delete CONFIG_ACPI_PROCFS_POWER and power procfs I/F in 2.6.39

Zhao Yakui (5):
      IPMI: Add one interface to get more info of low-level IPMI device
      IPMI: Add the document description of ipmi_get_smi_info
      IPMI/ACPI: Add the IPMI opregion driver to enable ACPI to access BMC controller
      ACPI: Check the returned value of set_cpus_allowed_ptr before T-state operation
      ACPI: Reevaluate whether the T-state is supported or not after cpu is online/offline

with this log:

commit 4263d9a3ae4d15785897d0543bb59316c84ee605
Merge: eab001b 6fed05c
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 16:11:46 2011 -0500

    Merge branch 'suspend-ioremap-cache' into release

commit 6fed05c9c9812b5882bc708f4da4fa8d5df2875c
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Jan 12 22:03:20 2011 +0100

    ACPI / PM: Fix build problems for !CONFIG_ACPI related to NVS rework
    
    The recent rework of the NVS saving/restoring code introduced two
    build issues for !CONFIG_ACPI, a warning in drivers/acpi/internal.h
    and an error in arch/x86/kernel/e820.c.
    
    Fix them by providing suitable static inline definitions of the
    relevant functions.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eab001bf88f68653e87a7d90124a2241131dbeda
Merge: 156d821 106d1a0
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 12:16:14 2011 -0500

    Merge branch 'misc' into test

commit 106d1a0ab2a354b97df3e232be7dedbfaf8e901d
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Dec 20 12:11:45 2010 +0100

    ACPI: fix resource check message
    
    printk("%pR",...)
    is for formatting struct resource only.
    But the list built up in drivers/acpi/osl.c uses it's own struct:
    struct acpi_res_list {}
    
    Without this patch you can see wrongly formatted resources (SMRG is of IO type):
    
    ACPI: resource 0000:00:1f.3 [io  0x0400-0x041f] conflicts with AC
          PI region SMRG [mem 0x00000400-0x0000040f 64bit pref disabled]
    
    https://bugzilla.kernel.org/show_bug.cgi?id=26342
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    CC: Matthew Wilcox <matthew@wil.cx>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 156d821270e131dee7d89fc4aa385f0f9b1900ea
Merge: 3e09898 5b275ce
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 05:14:15 2011 -0500

    Merge branch 'misc' into release

commit 3e098984073795bff5e5e3edbc1f5b0514c47c92
Merge: da8aeb9 99fd189
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 05:09:35 2011 -0500

    Merge branch 'bugzilla-21212' into release

commit da8aeb92d4853f37e281f11fddf61f9c7d84c3cd
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:42:27 2011 +0100

    ACPI / Battery: Update information on info notification and resume
    
    A notification event 0x81 from an ACPI battery device requires us to
    re-read the battery information structure.  Follow this requirement
    and remove and re-create the battery's attibutes in sysfs so that
    they reflect the reporting units used by the battery at the moment
    (those units may actually change sometimes at run time, which happens
    on some Thinkpads).
    
    The approach used in this patch was suggested by Matthew Garrett.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d57d09a480e1db38eeee7629c81289b00f338a15
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:41:27 2011 +0100

    ACPI: Drop device flag wake_capable
    
    The wake_capable ACPI device flag is not necessary, because it is
    only used in scan.c for recording the information that _PRW is
    present for the given device.  That information is only used by
    acpi_add_single_object() to decide whether or not to call
    acpi_bus_get_wakeup_device_flags(), so the flag may be dropped
    if the _PRW check is moved to acpi_bus_get_wakeup_device_flags().
    Moreover, acpi_bus_get_wakeup_device_flags() always returns 0,
    so it really should be void.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 86e4e20e8a5301ff7104a4f40f35fd5bee408186
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:40:00 2011 +0100

    ACPI: Always check if _PRW is present before trying to evaluate it
    
    Before evaluating _PRW for devices that are reported as inactive or
    not present by their _STA control methods we should check if those
    methods are actually present (otherwise the evaulation of _PRW will
    obviously fail and a scary message will be printed unnecessarily).
    
    Reported-by: Andreas Mohr <andi@lisas.de>
    Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d0515d9fec68bace144fda57a69f4268fb875209
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:38:57 2011 +0100

    ACPI / PM: Check status of power resources under mutexes
    
    It certainly is not a good idea to execute _ON or _OFF and _STA
    for the same power resource at the same time which may happen in
    some circumstances in theory.  To prevent that from happening,
    read the power state of each power resource under its mutex, as
    that will prevent the state from being changed at the same time.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 36237fa0a711c309a38d7a7a9aed727e0eb76449
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:38:04 2011 +0100

    ACPI / PM: Rename acpi_power_off_device()
    
    Rename acpi_power_off_device() to acpi_power_off() in analogy with
    acpi_power_on().
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 63e8078a12ed287f40f39082ff87e8db6621dab9
Merge: 4b63bd3 4464ed3
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 05:03:39 2011 -0500

    Merge branch 'kconfig-text' into release

commit 4b63bd35eb4e7959b0f7be17634689d34311524b
Merge: 03b6e6e e92b297
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 05:03:13 2011 -0500

    Merge branch 'ipmi' into release

commit 03b6e6e58d9dd5f3068288653810db3c15fde929
Merge: 9e0c20b 81e88fd
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 05:02:22 2011 -0500

    Merge branch 'apei' into release

commit 9e0c20bceb611917a7546172ac617d07e5af0cfa
Merge: fe3ded5 8206955
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 05:02:10 2011 -0500

    Merge branch 'acpi-video' into release

commit fe3ded5078e957d80c43837e1966429cf0029c10
Merge: 77cff3b 5a344a5
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 05:01:08 2011 -0500

    Merge branch 'throttling' into release

commit 77cff3b0d6349cc0212056238108b827b3cc353b
Merge: c1b2dab 4cb1872
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 05:00:44 2011 -0500

    Merge branch 'thermal' into release

commit c1b2dab96f3c1cb051b85d82d7e70e12e9b930f2
Merge: 6d1f23f 6d855fc
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 05:00:07 2011 -0500

    Merge branch 'procfs-cleanup' into release

commit 6d1f23f204c9e4638bd30ff3a768c47e40cd3ac0
Merge: 633379a cdefba0
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 04:59:44 2011 -0500

    Merge branch 'pnp' into release

commit 633379a0f9f16362835d7a3fde141d3a95fd6c97
Merge: d16675e cc8e7a3
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 04:58:51 2011 -0500

    Merge branch 'bugzilla-15100' into release

commit d16675e1f1de98cc73ae77c6df26154ffae6230a
Merge: fb4af41 6d5bbf0
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 04:56:08 2011 -0500

    Merge branch 'suspend-ioremap-cache' into release

commit fb4af417cce9ff87abf33a6bb9a0cf613e285364
Merge: 07bf280 7b33070
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 04:55:46 2011 -0500

    Merge branch 'wakeup-etc-rafael' into release

commit 07bf280521bb06bc8e64f0b998fc391253fcb959
Merge: 1ae5ec9 53eac70
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 04:55:28 2011 -0500

    Merge branch 'power-resource' into release

commit 53eac700b0df1fef8c957b9eedfd7f48120425e3
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Dec 11 23:45:30 2010 +0100

    ACPI / PM: Drop acpi_power_nocheck
    
    Since acpi_bus_set_power() should not use __acpi_bus_get_power() to
    update the device's device->power.state field before changing its
    power state (this may cause device->power.state to be inconsistent
    with the device power resources' reference counters), remove this
    call from it.  In consequence, the acpi_power_nocheck variable is not
    necessary any more, so it can be dropped along with the DMI table
    used for setting that variable for HP Pavilion 05.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f6767dcf2a4f6e62960912d0affec1e15a246191
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Dec 11 23:44:39 2010 +0100

    ACPI / PM: Drop acpi_bus_get_power()
    
    There are no more users of acpi_bus_get_power(), so it can be
    dropped.  Moreover, it should be dropped, because it modifies
    the device->power.state field of an ACPI device without updating
    the reference counters of the device's power resources, which is
    wrong.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 40b7397579e006c0f9cf4de58e9ccc350e06308f
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Dec 11 23:43:26 2010 +0100

    Platform / x86: Make fujitsu_laptop use acpi_bus_update_power()
    
    Use the new function acpi_bus_update_power(), which is safer than
    acpi_bus_get_power(), for getting device power state in
    acpi_fujitsu_add() and acpi_fujitsu_hotkey_add().
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Reported-and-Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 488a76c52606199100adf09c8eb7cbedbd94e9d9
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:11:24 2010 +0100

    ACPI / Fan: Rework the handling of power resources
    
    Use the new function acpi_bus_update_power() for manipulating power
    resources used by ACPI fan devices, which allows them to be put into
    the right state during initialization and resume.  Consequently,
    remove the flags.force_power_state field from struct acpi_device,
    which is not necessary any more.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bf325f9538d8c89312be305b9779edbcb436af00
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:10:44 2010 +0100

    ACPI / PM: Register power resource devices as soon as they are needed
    
    Depending on the organization of the ACPI namespace, power resource
    device objects may generally be scanned after the "regular" device
    objects that they are referred from through _PRn.  This, in turn, may
    cause acpi_bus_get_power_flags() to attempt to access them through
    acpi_bus_init_power() before they are registered (and initialized by
    acpi_power_driver).  [This is not a theoretical issue, it actually
    happens for one PnP device on my testbed HP nx6325.]
    
    To fix this problem, make acpi_bus_get_power_flags() attempt to
    register power resource devices as soon as they have been found in
    the _PRn output for any other devices.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 97d9a9e9f5ee68f20005ca5aa77c6b684e7cace8
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:10:02 2010 +0100

    ACPI / PM: Register acpi_power_driver early
    
    The ACPI device driver used for handling power resources,
    acpi_power_driver, creates a struct acpi_power_resource object for
    each ACPI device representing a power resource.  These objects are
    then used when setting and reading the power states of devices using
    the corresponding power resources.  Unfortunately, acpi_power_driver
    is registered after acpi_scan_init() that may add devices using the
    power resources before acpi_power_driver has a chance to create
    struct acpi_power_resource objects for them (specifically, the power
    resources may be referred to during the scanning process through
    acpi_bus_get_power() before they have been initialized).
    
    As the first step towards fixing this issue, move the registration
    of acpi_power_driver into acpi_scan_init() so that power resource
    devices can be initialized by it as soon as they have been found in
    the namespace.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 25eed40720fc9005c63a1f436e5f8a78836c26ff
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:09:15 2010 +0100

    ACPI / PM: Add function for updating device power state consistently
    
    Add function acpi_bus_update_power() for reading the actual power
    state of an ACPI device and updating its device->power.state field
    in such a way that its power resources' reference counters will
    remain consistent with that field.
    
    For this purpose introduce __acpi_bus_set_power() setting the
    power state of an ACPI device without updating its
    device->power.state field and make acpi_bus_set_power() and
    acpi_bus_update_power() use it (acpi_bus_set_power() retains the
    current behavior for now).
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ade3e7fef794781c0798d0cf0f046123842ba550
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:08:36 2010 +0100

    ACPI / PM: Add function for device power state initialization
    
    Add function acpi_bus_init_power() for getting the initial power
    state of an ACPI device and reference counting its power resources
    as appropriate.
    
    Make acpi_bus_get_power_flags() use the new function instead of
    acpi_bus_get_power() that updates device->power.state without
    reference counting the device's power resources.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5e6d4fe4296782f1f095575b8213a97c3e925a16
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:07:56 2010 +0100

    ACPI / PM: Introduce __acpi_bus_get_power()
    
    It sometimes is necessary to get the power state of an ACPI device
    without updating its device->power.state field, for example to
    avoid inconsistencies between device->power.state and the reference
    counters of the device's power resources.  For this purpose introduce
    __acpi_bus_get_power() that will return the given device's power
    state via a pointer (instead of modifying device->power.state)
    and make acpi_bus_get_power() use it.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 30d3df41b32b1ea63d3ebc52ef5644cbe41520f4
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:06:55 2010 +0100

    ACPI / PM: Introduce function for refcounting device power resources
    
    Introduce function acpi_power_on_resources() that reference counts
    and possibly turns on ACPI power resources for a given device and
    a given power state of it.
    
    This function will be used for reference counting device power
    resources during initialization.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d2ef555b57292cd818934636ac8e3414cc2a6762
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:06:09 2010 +0100

    ACPI / PM: Add functions for manipulating lists of power resources
    
    ACPI device power resources should be reference counted during
    device initialization, so that their reference counters are always
    up to date.  It is convenient to do that with the help of a function
    that will reference count and possibly turn on power resources in
    a given list, so introduce that function, acpi_power_on_list().
    For symmetry, introduce acpi_power_off_list() for performing the
    reverse operation and use the both of them to simplify
    acpi_power_transition().
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 32a00d274e877eab3ea7ab196b75c9be5170d25e
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:05:17 2010 +0100

    ACPI / PM: Prevent acpi_power_get_inferred_state() from making changes
    
    acpi_power_get_inferred_state() should not update
    device->power.state behind the back of its caller, so make it return
    the state via a pointer instead.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1ae5ec903f71c0ffa583ec54d17415892036ee18
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Dec 27 09:07:43 2010 +0800

    ACPICA: Update version to 20101209
    
    Version 20101209.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit da50337373c90c15c6db6ed4239e87c5a3806f9a
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Dec 13 13:39:37 2010 +0800

    ACPICA: Misc comments to minimize code divergence
    
    Modify/add some comments to minimize ACPICA/linux GPE code divergence.
    
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a0fcdb237fcd4eaa7e5009b28ef5be07415f287d
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Dec 13 13:39:26 2010 +0800

    ACPICA: Global event handler
    
    The global event handler is called whenever a general purpose
    or fixed ACPI event occurs.
    
    Also update Linux OSL to collect events counter with
    global event handler.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit bba63a296ffab20e08d9e8252d2f0d99050ac859
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Dec 13 13:39:17 2010 +0800

    ACPICA: Implicit notify support
    
    This feature provides an automatic device notification for wake devices
    when a wakeup GPE occurs and there is no corresponding GPE method or
    handler. Rather than ignoring such a GPE, an implicit AML Notify
    operation is performed on the parent device object.
    This feature is not part of the ACPI specification and is provided for
    Windows compatibility only.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5a284cd75d635e3c5db0210dc9a9a44c6839f460
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Dec 13 13:39:07 2010 +0800

    ACPICA: Fix local variable mess in acpi_ev_asynch_execute_gpe_method
    
    Change the local variable in acpi_ev_asynch_execute_gpe_method()
    back into a pointer as ACPICA code base does.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 84f6b2a681cd2cc55ecc3fa94bfbe672d7ef4126
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Dec 13 13:38:55 2010 +0800

    ACPICA: Remove unused function declarations
    
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8b6cd8ad18def34bfc5045b2a0234329bf94cf78
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Dec 13 13:38:46 2010 +0800

    ACPICA: New GPE handler callback definition
    
    The new GPE handler callback has 2 additional parameters, gpe_device and
    gpe_number.
    
    typedef
    u32 (*acpi_gpe_handler) (acpi_handle gpe_device, u32 gpe_number, void *context);
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3a37898d507794cfc68a092303e02651d3f01308
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Dec 13 13:36:15 2010 +0800

    ACPICA: Rename some function and variable names
    
    Some function and variable names are renamed to be consistent with
    ACPICA code base.
    
    acpi_raw_enable_gpe -> acpi_ev_add_gpe_reference
    acpi_raw_disable_gpe -> acpi_ev_remove_gpe_reference
    acpi_gpe_can_wake -> acpi_setup_gpe_for_wake
    acpi_gpe_wakeup -> acpi_set_gpe_wake_mask
    acpi_update_gpes -> acpi_update_all_gpes
    acpi_all_gpes_initialized -> acpi_gbl_all_gpes_initialized
    acpi_handler_info -> acpi_gpe_handler_info
    ...
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3cfd53d53f700a225716294842b1a843326dea21
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Mon Dec 13 13:36:02 2010 +0800

    ACPICA: Move GPE functions to new file evxfgpe.c
    
    Create a new file evxfgpe.c and move GPE specific functions to it.
    
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 81e88fdc432a1552401d6e91a984dcccce72b8dc
Author: Huang Ying <ying.huang@intel.com>
Date:   Wed Jan 12 14:44:55 2011 +0800

    ACPI, APEI, Generic Hardware Error Source POLL/IRQ/NMI notification type support
    
    Generic Hardware Error Source provides a way to report platform
    hardware errors (such as that from chipset). It works in so called
    "Firmware First" mode, that is, hardware errors are reported to
    firmware firstly, then reported to Linux by firmware. This way, some
    non-standard hardware error registers or non-standard hardware link
    can be checked by firmware to produce more valuable hardware error
    information for Linux.
    
    This patch adds POLL/IRQ/NMI notification types support.
    
    Because the memory area used to transfer hardware error information
    from BIOS to Linux can be determined only in NMI, IRQ or timer
    handler, but general ioremap can not be used in atomic context, so a
    special version of atomic ioremap is implemented for that.
    
    Known issue:
    
    - Error information can not be printed for recoverable errors notified
      via NMI, because printk is not NMI-safe. Will fix this via delay
      printing to IRQ context via irq_work or make printk NMI-safe.
    
    v2:
    
    - adjust printk format per comments.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6d855fcdd24d2491455527c4999b4d04363f1980
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jan 10 11:16:30 2011 +0800

    ACPI: delete CONFIG_ACPI_PROCFS_POWER and power procfs I/F in 2.6.39
    
    sysfs I/F for ACPI power devices, including AC and Battery,
    has been working in upstream kenrel since 2.6.24, Sep 2007.
    In 2.6.37, we made the sysfs I/F always built in and this option
    disabled by default.
    Now, we plan to remove this option and the ACPI power procfs
    interface in 2.6.39.
    
    First, update the feature-removal-schedule to announce this change.
    Second, add runtime warnings in ACPI AC/Battery/SBS driver, so that
    users will notice this change even if "make oldconfig" is used.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4464ed3b05de7a41ae55c74109cec8aeb138ce14
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Jan 10 11:16:26 2011 +0800

    ACPI: update CONFIG_ACPI_PROCFS description
    
    Update CONFIG_ACPI_PROCFS description because the processor,
    video and thermal zone procfs I/F have been removed.
    
    Some ACPI drivers, e.g. button, have their procfs I/F always built in,
    because we don't have sysfs I/F replacement at the moment.
    But once we finish developing the sysfs I/F for these driver,
    we need CONFIG_ACPI_PROCFS to enabled/disable the corresponding procfs I/F.
    
    So just updating the description rather than removing this option,
    although there is no procfs I/F depends on it for now.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4cb18728709683c91a5f6f8d5f337bfb498b089a
Author: R.Durgadoss <durgadoss.r@intel.com>
Date:   Wed Oct 27 03:33:29 2010 +0530

    thermal: Add event notification to thermal framework
    
    This patch adds event notification support to the generic
    thermal sysfs framework in the kernel. The notification is in the
    form of a netlink event.
    
    Signed-off-by: R.Durgadoss <durgadoss.r@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cc8e7a355c1ec64b06a5b8126c47c5cb47f44fce
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Jan 10 21:23:16 2011 +0100

    PNP / ACPI: Use DEVICE_ACPI_HANDLE() for device ACPI handle access
    
    The PNP ACPI driver squirrels the ACPI handles of PNP devices' ACPI
    companions, but this isn't correct, because those handles should be
    accessed using the DEVICE_ACPI_HANDLE() macro operating on struct
    device objects.
    
    Using DEVICE_ACPI_HANDLE() in the PNP ACPI driver instead of the
    driver's own copies of the ACPI handles allows us to avoid a problem
    with docking stations where a machine docked before suspend to RAM
    and undocked while suspended crashes during the subsequent resume (in
    that case the ACPI companion of the PNP device in question doesn't
    exist any more while the device is being resumed).  It also allows us
    to avoid the problem where suspend to RAM fails when the machine was
    undocked while suspended before (again, the ACPI companion of the PNP
    device is not present any more while it is being suspended).
    
    This change doesn't fix all of the the PNP ACPI driver's problems
    with PNP devices in docking stations (generally speaking, the driver
    has no idea that devices can come and go and doesn't even attempt to
    handle such events), but at least it makes suspend work for the
    users of docking stations who don't use the PNP devices located in
    there.
    
    References: https://bugzilla.kernel.org/show_bug.cgi?id=15100
    
    Reported-and-tested-by: Toralf Förster <toralf.foerster@gmx.de>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5a344a505093dd65f82f338ffdb7208321b3630e
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jan 10 16:35:45 2011 +0800

    ACPI: Reevaluate whether the T-state is supported or not after cpu is online/offline
    
    After one CPU is offlined, it is unnecessary to switch T-state for it.
    So it will be better that the throttling is disabled after the cpu
    is offline.
    At the same time after one cpu is online, we should check whether
    the T-state is supported and then set the corresponding T-state
    flag.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit daef1f35ea1e2cca125eecd5f078f40b55eb9105
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jan 10 16:35:44 2011 +0800

    ACPI: Check the returned value of set_cpus_allowed_ptr before T-state operation
    
    Now before it executes the T-state operation on one CPU, it will try to
    migrate to the target CPU. Especially this is required on the system that
    uses the MSR_IA32_THERMAL_CONTROL register to switch T-state.
    But unfortunately it doesn't check whether the migration is successful or not.
    In such case we will get/set the incorrect T-state on the offline CPU as
    it fails in the migration to the offline CPU.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7b330707dddab1ad772898c1c82516342a551173
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:37:01 2011 +0100

    ACPI / PM: Blacklist Averatec machine known to require acpi_sleep=nonvs
    
    Apparently, Averatec AV1020-ED2 does not resume correctly without
    acpi_sleep=nonvs, so add it to the ACPI sleep blacklist.
    
    References: https://bugzilla.kernel.org/show_bug.cgi?id=16396#c86
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1f83511bd8f44b8a9e2d82263b2c95f26a625fcc
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:36:01 2011 +0100

    ACPI / PM: Report wakeup events from buttons
    
    Since ACPI buttons and lids can be configured to wake up the system
    from sleep states, report wakeup events from these devices.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7fa69baf29de8c77a6b32c054df2abb8f11f8aa4
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:35:10 2011 +0100

    ACPI / PM: Drop special ACPI wakeup flags
    
    Drop special ACPI wakeup flags, wakeup.state.enabled and
    wakeup.flags.always_enabled, that aren't necessary any more after
    we've started to use standard device wakeup flags for handling ACPI
    wakeup devices.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f2b56bc808addb908a5bf435d9b942c02af9a7c4
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:34:22 2011 +0100

    ACPI / PM: Use device wakeup flags for handling ACPI wakeup devices
    
    There are ACPI devices (buttons and the laptop lid) that can wake up
    the system from sleep states and have no "physical" companion
    devices.  The ACPI subsystem uses two flags, wakeup.state.enabled and
    wakeup.flags.always_enabled, for handling those devices, but they
    are not accessible through the standard device wakeup infrastructure.
    User space can only control them via the /proc/acpi/wakeup interface
    that is not really convenient (e.g. the way in which devices are
    enabled to wake up the system is not portable between different
    systems, because it requires one to know the devices' "names" used in
    the system's ACPI tables).
    
    To address this problem, use standard device wakeup flags instead of
    the special ACPI flags for handling those devices.  In particular,
    use device_set_wakeup_capable() to mark the ACPI wakeup devices
    during initialization and use device_set_wakeup_enable() to allow
    or disallow them to wake up the system from sleep states.  Rework
    the /proc/acpi/wakeup interface to take these changes into account.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b014f4f1aad3f25d5c7d877a394869645ea0c96b
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:33:30 2011 +0100

    ACPI / PM: Do not enable multiple devices to wake up simultaneously
    
    If a device is enabled to wake up the system from sleep states via
    /proc/acpi/wakeup and there are other devices associated with the
    same wakeup GPE, all of these devices are automatically enabled to
    wake up the system.  This isn't correct, because the fact the GPE is
    shared need not imply that wakeup power has to be enabled for all the
    devices at the same time (i.e. it is possible that one device will
    have its wakeup power enabled and it will wake up the system from a
    sleep state if the shared wakeup GPE is enabled, while another device
    having its wakeup power disabled will not wake up the system even
    though the GPE is enabled).  Rework acpi_system_write_wakeup_device()
    so that it only enables wakeup for one device at a time.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9cd031441a4fd09273b7c2beb337d0b2683d104c
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Jan 6 23:32:23 2011 +0100

    ACPI / ACPICA: Fix global lock acquisition
    
    There are two problems with the ACPICA's current implementation of
    the global lock acquisition.  First, acpi_ev_global_lock_handler(),
    which in fact is an interface to the outside of the kernel, doesn't
    validate its input, so it only works correctly if the other side
    (i.e. the ACPI firmware) is fully specification-compliant (as far
    as the global lock is concerned).  Unfortunately, that's known not
    to be the case on some systems (i.e. we get spurious global lock
    signaling interrupts without the pending flag set on some systems).
    Second, acpi_ev_global_lock_handler() attempts to acquire the global
    lock on behalf of a thread waiting for it without checking if there
    actually is such a thread.  Both of these shortcomings need to be
    addressed to prevent all possible race conditions from happening.
    
    Rework acpi_ev_global_lock_handler() so that it doesn't try to
    acquire the global lock and make it signal the availability of the
    global lock to the waiting thread instead.  Make sure that the
    availability of the global lock can only be signaled when there
    is a thread waiting for it and that it can't be signaled more than
    once in a row (to keep acpi_gbl_global_lock_semaphore in balance).
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6d5bbf00d251cc73223a71422d69e069dc2e0b8d
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 7 01:46:40 2011 +0100

    ACPI: Use ioremap_cache()
    
    Although the temporary boot-time ACPI table mappings
    were set up with CPU caching enabled, the permanent table
    mappings and AML run-time region memory accesses were
    set up with ioremap(), which on x86 is a synonym for
    ioremap_nocache().
    
    Changing this to ioremap_cache() improves performance as
    seen when accessing the tables via acpidump,
    or /sys/firmware/acpi/tables.  It should also improve
    AML run-time performance.
    
    No change on ia64.
    
    Reported-by: Jack Steiner <steiner@sgi.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit ca9b600be38c73b7d25acfb8b7e4e9a9e941d881
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jan 7 01:45:58 2011 +0100

    ACPI / PM: Make suspend_nvs_save() use acpi_os_map_memory()
    
    It turns out that the NVS memory region that suspend_nvs_save()
    attempts to map has been already mapped by acpi_os_map_memory(), so
    suspend_nvs_save() should better use acpi_os_map_memory() for mapping
    memory to avoid conflicts.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d146df18c13d16e321efa8ef9b57c95c3bec1722
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jan 7 01:44:28 2011 +0100

    ACPI / PM: Update file information and the list of includes in nvs.c
    
    The file information and the list of include in drivers/acpi/nvs.c
    are outdated, so update them.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 976513dbfc1547c7b1822566923058655f0c32fd
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jan 7 01:43:44 2011 +0100

    PM / ACPI: Move NVS saving and restoring code to drivers/acpi
    
    The saving of the ACPI NVS area during hibernation and suspend and
    restoring it during the subsequent resume is entirely specific to
    ACPI, so move it to drivers/acpi and drop the CONFIG_SUSPEND_NVS
    configuration option which is redundant.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 26fcaf60fe3861409eb4c455c5c0d0f00f599b08
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Fri Jan 7 01:42:31 2011 +0100

    PM: Fix oops in suspend/hibernate code related to failing ioremap()
    
    When ioremap() fails (which might happen for some reason), we nicely
    oops in suspend_nvs_save() due to NULL dereference by memcpy() in there.
    Fail gracefully instead.
    
    Signed-off-by: Jiri Slaby <jslaby@suse.cz>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e92b297cc72ade7a58eaec7e01c906d856f8ab6e
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Dec 8 10:10:18 2010 +0800

    IPMI/ACPI: Add the IPMI opregion driver to enable ACPI to access BMC controller
    
    ACPI 4.0 spec adds the ACPI IPMI opregion, which means that the ACPI AML
    code can also communicate with the BMC controller. This is to install
    the ACPI IPMI opregion and enable the ACPI to access the BMC controller
    through the IPMI message.
    
         It will create IPMI user interface for every IPMI device detected
    in ACPI namespace and install the corresponding IPMI opregion space handler.
    Then it can enable ACPI to access the BMC controller through the IPMI
    message.
    
    The following describes how to process the IPMI request in IPMI space handler:
        1. format the IPMI message based on the request in AML code.
        IPMI system address. Now the address type is SYSTEM_INTERFACE_ADDR_TYPE
        IPMI net function & command
        IPMI message payload
        2. send the IPMI message by using the function of ipmi_request_settime
        3. wait for the completion of IPMI message. It can be done in different
    routes: One is in handled in IPMI user recv callback function. Another is
    handled in timeout function.
        4. format the IPMI response and return it to ACPI AML code.
    
    At the same time it also addes the module dependency. The ACPI IPMI opregion
    will depend on the IPMI subsystem.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Corey Minyard <cminyard@mvista.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 37bf501bdda1d5d6ea73ce29d4b00d291b6f3811
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Dec 8 10:10:17 2010 +0800

    IPMI: Add the document description of ipmi_get_smi_info
    
    Add the document description about how to use ipmi_get_smi_info.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Corey Minyard <cminyard@mvista.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 16f4232ce4d6855361b4eb56262f4a202295c978
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Dec 8 10:10:16 2010 +0800

    IPMI: Add one interface to get more info of low-level IPMI device
    
    The IPMI smi_watcher will be used to catch the IPMI interface as they
    come or go.  In order to communicate with the correct IPMI device, it
    should be confirmed whether it is what we wanted especially on the
    system with multiple IPMI devices. But the new_smi callback function
    of smi_watcher provides very limited info(only the interface number
    and dev pointer) and there is no detailed info about the low level
    interface. For example: which mechansim registers the IPMI
    interface(ACPI, PCI, DMI and so on).
    
    This is to add one interface that can get more info of low-level IPMI
    device. For example: the ACPI device handle will be returned for the
    pnp_acpi IPMI device.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Corey Minyard <cminyard@mvista.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 99fd1895ef603f1a0fa9af478c96c637a7b4529d
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Dec 6 15:04:27 2010 +0800

    ACPI video: introduce module parameter video.use_bios_initial_backlight
    
    Introduce module parameter video.use_bios_initial_backlight.
    
    Some BIOSes claim they use the minimum backlight at boot,
    and this may bring dimming screen after boot.
    https://bugzilla.kernel.org/show_bug.cgi?id=21212
    
    use video.use_bios_initl_backlight=0 to use
    the maximum backlight level after boot.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 82069552555cf951d9ade5c1aec61dd40b0765b5
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Dec 6 15:04:24 2010 +0800

    ACPI video: check cap._DDC flag before getting EDID
    
    cap._DDC is defined but never used.
    Check this flag now and don't try to get EDID for video output devices with this flag cleared.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 677bd810eedce61edf15452491781ff046b92edc
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Dec 6 15:04:21 2010 +0800

    ACPI video: remove output switching control
    
    Remove the ACPI video output switching control as it never works.
    
    With the patch applied,
    ACPI video driver still catches the video output notification,
    but it does nothing but raises the notification to userspace.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cef6e8a3790d6bdc305496629c357a56001d59a6
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Dec 6 15:04:15 2010 +0800

    ACPI processor: remove processor throttling control procfs I/F
    
    Remove deprecated ACPI process procfs I/F for throttling control.
    
    This is because the t-state control should only be done in kernel,
    when system is in a overheating state.
    
    Now users can only change the processor t-state indirectly,
    by poking the cooling device sysfs I/F of the processor.
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 32c361f574f85fa47600d84900598e2efc99082e
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue Dec 7 10:22:31 2010 +0800

    ACPI, APEI, Report GHES error information via printk
    
    printk is one of the methods to report hardware errors to user space.
    This patch implements hardware error reporting for GHES via printk.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f59c55d04b43bd72df8efa692dd07224fe94d1ac
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue Dec 7 10:22:30 2010 +0800

    ACPI, APEI, Add APEI generic error status printing support
    
    In APEI, Hardware error information reported by firmware to Linux
    kernel is in the data structure of APEI generic error status (struct
    acpi_hes_generic_status).  While now printk is used by Linux kernel to
    report hardware error information to user space.
    
    So, this patch adds printing support for the data structure, so that
    the corresponding hardware error information can be reported to user
    space via printk.
    
    PCIe AER information printing is not implemented yet.  Will refactor the
    original PCIe AER information printing code to avoid code duplicating.
    
    The output format is as follow:
    
    <error record> :=
    APEI generic hardware error status
    severity: <integer>, <severity string>
    section: <integer>, severity: <integer>, <severity string>
    flags: <integer>
    <section flags strings>
    fru_id: <uuid string>
    fru_text: <string>
    section_type: <section type string>
    <section data>
    
    <severity string>* := recoverable | fatal | corrected | info
    
    <section flags strings># :=
    [primary][, containment warning][, reset][, threshold exceeded]\
    [, resource not accessible][, latent error]
    
    <section type string> := generic processor error | memory error | \
    PCIe error | unknown, <uuid string>
    
    <section data> :=
    <generic processor section data> | <memory section data> | \
    <pcie section data> | <null>
    
    <generic processor section data> :=
    [processor_type: <integer>, <proc type string>]
    [processor_isa: <integer>, <proc isa string>]
    [error_type: <integer>
    <proc error type strings>]
    [operation: <integer>, <proc operation string>]
    [flags: <integer>
    <proc flags strings>]
    [level: <integer>]
    [version_info: <integer>]
    [processor_id: <integer>]
    [target_address: <integer>]
    [requestor_id: <integer>]
    [responder_id: <integer>]
    [IP: <integer>]
    
    <proc type string>* := IA32/X64 | IA64
    
    <proc isa string>* := IA32 | IA64 | X64
    
    <processor error type strings># :=
    [cache error][, TLB error][, bus error][, micro-architectural error]
    
    <proc operation string>* := unknown or generic | data read | data write | \
    instruction execution
    
    <proc flags strings># :=
    [restartable][, precise IP][, overflow][, corrected]
    
    <memory section data> :=
    [error_status: <integer>]
    [physical_address: <integer>]
    [physical_address_mask: <integer>]
    [node: <integer>]
    [card: <integer>]
    [module: <integer>]
    [bank: <integer>]
    [device: <integer>]
    [row: <integer>]
    [column: <integer>]
    [bit_position: <integer>]
    [requestor_id: <integer>]
    [responder_id: <integer>]
    [target_id: <integer>]
    [error_type: <integer>, <mem error type string>]
    
    <mem error type string>* :=
    unknown | no error | single-bit ECC | multi-bit ECC | \
    single-symbol chipkill ECC | multi-symbol chipkill ECC | master abort | \
    target abort | parity error | watchdog timeout | invalid address | \
    mirror Broken | memory sparing | scrub corrected error | \
    scrub uncorrected error
    
    <pcie section data> :=
    [port_type: <integer>, <pcie port type string>]
    [version: <integer>.<integer>]
    [command: <integer>, status: <integer>]
    [device_id: <integer>:<integer>:<integer>.<integer>
    slot: <integer>
    secondary_bus: <integer>
    vendor_id: <integer>, device_id: <integer>
    class_code: <integer>]
    [serial number: <integer>, <integer>]
    [bridge: secondary_status: <integer>, control: <integer>]
    
    <pcie port type string>* := PCIe end point | legacy PCI end point | \
    unknown | unknown | root port | upstream switch port | \
    downstream switch port | PCIe to PCI/PCI-X bridge | \
    PCI/PCI-X to PCIe bridge | root complex integrated endpoint device | \
    root complex event collector
    
    Where, [] designate corresponding content is optional
    
    All <field string> description with * has the following format:
    
    field: <integer>, <field string>
    
    Where value of <integer> should be the position of "string" in <field
    string> description. Otherwise, <field string> will be "unknown".
    
    All <field strings> description with # has the following format:
    
    field: <integer>
    <field strings>
    
    Where each string in <fields strings> corresponding to one set bit of
    <integer>. The bit position is the position of "string" in <field
    strings> description.
    
    For more detailed explanation of every field, please refer to UEFI
    specification version 2.3 or later, section Appendix N: Common
    Platform Error Record.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c9aa308fd5c373faeda588cfb02b04f116904613
Author: Huang Ying <ying.huang@intel.com>
Date:   Tue Dec 7 10:22:29 2010 +0800

    Add CPER PCIe error section structure and constants definition
    
    On some machine, PCIe error is reported via APEI (ACPI Platform Error
    Interface).  The error data is passed from firmware to Linux via CPER
    PCIe error section structure.
    
    This patch adds CPER PCIe error section structure and constants
    definition.
    
    Signed-off-by: Huang Ying <ying.huang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5b275ce27077d6463ca28c9671dce7c2c1f622e2
Author: Alan Cox <alan@linux.intel.com>
Date:   Thu Nov 11 15:27:29 2010 +0000

    thermal: make ops constant
    
    And while touching that function definition do something about the disaster
    of formatting there.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cdefba03e44bd3b3311a3849a81ec7030dfa1519
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Oct 25 21:11:16 2010 +0200

    PNP: Set up pnp_debug via module and not via boot param.
    
    Cleanup only, no functional change (pnp.debug can be enabled
    and disabled at runtime, but that's not a real enhancement).
    
    This one depends on another PNP cleanup patch:
    PNP: Compile all pnp built-in stuff in one module namespace
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 803711afdbea5c6a6dd2b46eca76097f6d50fb53
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Oct 25 21:11:15 2010 +0200

    PNP: Compile all pnp built-in stuff in one module namespace
    
    This is cleanup mostly, nothing urgent.
    I came up with it when looking at dynamic debug which can
    enable pr_debug messages at runtime or boot param
    for a specific module.
    
    Advantages:
      - Any pnp code can make use of the moduleparam.h interface, the modules
        will show up as pnp.param.
      - Passing pnp.ddebug as kernel boot param will enable all pnp debug messages
        with my previous patch and CONFIG_DYNAMIC_DEBUG enabled.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
--8323328-1884074247-1294977050=:9760--
