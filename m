Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab2K2V4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:56:36 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36483 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2K2V4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:56:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: ACPI / PM: Candidate material for the v3.8 merge window, part I
Date: Thu, 29 Nov 2012 23:01:15 +0100
Message-ID: <5388427.8SxCFZRRtR@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Below is the summary of ACPI and power management material I'm going to include
into my first pull request during the upcoming merge window.  This is not the
whole material I'd like to be merged during that merge window, but that's
what I'm regarding as ready at the moment.

The ACPI enumeration changes for GPIO and SPI are still pending Grant's review,
but the rest appears to be in a reasonably good shape.  The commits are
available from the tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next

Please let me know ASAP if you have any problems with any of them.

Thanks,
Rafael


 Documentation/ABI/testing/sysfs-devices-power      |  31 +
 Documentation/ABI/testing/sysfs-devices-sun        |  14 +
 .../devicetree/bindings/cpufreq/cpufreq-spear.txt  |  42 ++
 Documentation/power/pm_qos_interface.txt           |   2 +-
 arch/arm/Kconfig                                   |   1 +
 arch/ia64/include/asm/device.h                     |   3 -
 arch/ia64/kernel/acpi.c                            |   2 +
 arch/powerpc/platforms/pseries/processor_idle.c    |   4 +-
 arch/x86/include/asm/device.h                      |   3 -
 arch/x86/kernel/acpi/boot.c                        |   6 +
 arch/x86/kernel/acpi/sleep.c                       |   2 +
 drivers/acpi/Kconfig                               |   6 +
 drivers/acpi/Makefile                              |   6 +-
 drivers/acpi/acpi_i2c.c                            | 103 +++
 drivers/acpi/acpi_memhotplug.c                     | 193 +++---
 drivers/acpi/acpi_pad.c                            |   8 +-
 drivers/acpi/acpi_platform.c                       | 104 +++
 drivers/acpi/acpica/Makefile                       |   3 +
 drivers/acpi/acpica/acdebug.h                      |  94 ++-
 drivers/acpi/acpica/acdispat.h                     |  11 +-
 drivers/acpi/acpica/acevents.h                     |   6 +-
 drivers/acpi/acpica/acglobal.h                     |  73 +-
 drivers/acpi/acpica/aclocal.h                      |  16 +-
 drivers/acpi/acpica/acmacros.h                     | 163 ++---
 drivers/acpi/acpica/acobject.h                     |   7 +-
 drivers/acpi/acpica/acopcode.h                     |   6 +-
 drivers/acpi/acpica/acparser.h                     |   3 +-
 drivers/acpi/acpica/acpredef.h                     |  11 +-
 drivers/acpi/acpica/acstruct.h                     |   2 +-
 drivers/acpi/acpica/acutils.h                      |  58 +-
 drivers/acpi/acpica/amlresrc.h                     |   1 -
 drivers/acpi/acpica/dscontrol.c                    |   2 +-
 drivers/acpi/acpica/dsfield.c                      |   2 +-
 drivers/acpi/acpica/dsmethod.c                     |   6 +-
 drivers/acpi/acpica/dsmthdat.c                     |  14 +-
 drivers/acpi/acpica/dsobject.c                     |   6 +-
 drivers/acpi/acpica/dsopcode.c                     |   3 +-
 drivers/acpi/acpica/dsutils.c                      |  33 +-
 drivers/acpi/acpica/dswexec.c                      |  10 +-
 drivers/acpi/acpica/dswload2.c                     |   4 +-
 drivers/acpi/acpica/dswstate.c                     |  26 +-
 drivers/acpi/acpica/evgpe.c                        |  20 +-
 drivers/acpi/acpica/evgpeblk.c                     |   3 +-
 drivers/acpi/acpica/evgpeutil.c                    |   3 +-
 drivers/acpi/acpica/evrgnini.c                     |   7 +-
 drivers/acpi/acpica/evxface.c                      |   2 +-
 drivers/acpi/acpica/evxfgpe.c                      |  13 +-
 drivers/acpi/acpica/exconvrt.c                     |   4 +-
 drivers/acpi/acpica/excreate.c                     |   9 +-
 drivers/acpi/acpica/exdebug.c                      |  10 +-
 drivers/acpi/acpica/exdump.c                       |  20 +-
 drivers/acpi/acpica/exfield.c                      |   4 +-
 drivers/acpi/acpica/exfldio.c                      |  15 +-
 drivers/acpi/acpica/exmisc.c                       |   5 +-
 drivers/acpi/acpica/exmutex.c                      |   9 +-
 drivers/acpi/acpica/exnames.c                      |   9 +-
 drivers/acpi/acpica/exoparg1.c                     |  11 +-
 drivers/acpi/acpica/exoparg2.c                     |   2 +-
 drivers/acpi/acpica/exoparg3.c                     |   3 +-
 drivers/acpi/acpica/exoparg6.c                     |   5 +-
 drivers/acpi/acpica/exprep.c                       |  13 +-
 drivers/acpi/acpica/exregion.c                     |   3 +-
 drivers/acpi/acpica/exresnte.c                     |   9 +-
 drivers/acpi/acpica/exresolv.c                     |   3 +-
 drivers/acpi/acpica/exresop.c                      |   8 +-
 drivers/acpi/acpica/exstore.c                      |   4 +-
 drivers/acpi/acpica/exstoren.c                     |  11 +-
 drivers/acpi/acpica/exstorob.c                     |   5 +-
 drivers/acpi/acpica/exsystem.c                     |   9 +-
 drivers/acpi/acpica/exutils.c                      |   5 +-
 drivers/acpi/acpica/hwacpi.c                       |   3 +-
 drivers/acpi/acpica/hwgpe.c                        |   4 +-
 drivers/acpi/acpica/hwpci.c                        |   4 +-
 drivers/acpi/acpica/hwregs.c                       |   1 -
 drivers/acpi/acpica/hwtimer.c                      |   6 +-
 drivers/acpi/acpica/hwvalid.c                      |   1 -
 drivers/acpi/acpica/hwxface.c                      |   1 -
 drivers/acpi/acpica/hwxfsleep.c                    |  12 +-
 drivers/acpi/acpica/nsaccess.c                     |   7 +-
 drivers/acpi/acpica/nsalloc.c                      |   4 +-
 drivers/acpi/acpica/nsdump.c                       |  10 +-
 drivers/acpi/acpica/nsinit.c                       |   4 +-
 drivers/acpi/acpica/nsload.c                       |  10 +-
 drivers/acpi/acpica/nsnames.c                      |   2 +-
 drivers/acpi/acpica/nsobject.c                     |   8 +-
 drivers/acpi/acpica/nsparse.c                      |   8 +-
 drivers/acpi/acpica/nssearch.c                     |  17 +-
 drivers/acpi/acpica/nsutils.c                      |  18 +-
 drivers/acpi/acpica/nswalk.c                       |  10 +-
 drivers/acpi/acpica/nsxfeval.c                     |  20 +-
 drivers/acpi/acpica/nsxfname.c                     |  66 +-
 drivers/acpi/acpica/nsxfobj.c                      |   4 +-
 drivers/acpi/acpica/psargs.c                       |   8 +-
 drivers/acpi/acpica/psloop.c                       |  61 +-
 drivers/acpi/acpica/psopcode.c                     |  29 +-
 drivers/acpi/acpica/psparse.c                      |  13 +-
 drivers/acpi/acpica/psutils.c                      |   4 +-
 drivers/acpi/acpica/rscalc.c                       |  14 +-
 drivers/acpi/acpica/rslist.c                       |   4 +-
 drivers/acpi/acpica/tbfind.c                       |   2 +-
 drivers/acpi/acpica/tbinstal.c                     |   2 +
 drivers/acpi/acpica/tbutils.c                      |   2 +-
 drivers/acpi/acpica/tbxface.c                      |   4 +-
 drivers/acpi/acpica/tbxfload.c                     |   2 +-
 drivers/acpi/acpica/tbxfroot.c                     |   3 +-
 drivers/acpi/acpica/utcache.c                      | 323 +++++++++
 drivers/acpi/acpica/utclib.c                       | 749 +++++++++++++++++++++
 drivers/acpi/acpica/utdebug.c                      |  37 +-
 drivers/acpi/acpica/utids.c                        | 104 ++-
 drivers/acpi/acpica/utmath.c                       |   2 +-
 drivers/acpi/acpica/utmisc.c                       | 150 ++++-
 drivers/acpi/acpica/utmutex.c                      |  14 +-
 drivers/acpi/acpica/utobject.c                     |   8 +-
 drivers/acpi/acpica/utstate.c                      |   2 +-
 drivers/acpi/acpica/uttrack.c                      | 692 +++++++++++++++++++
 drivers/acpi/acpica/utxface.c                      |   5 +-
 drivers/acpi/acpica/utxferror.c                    |   2 +-
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/acpi/battery.c                             |  77 +++
 drivers/acpi/bus.c                                 |  21 +-
 drivers/acpi/container.c                           |  27 +-
 drivers/acpi/device_pm.c                           | 668 ++++++++++++++++++
 drivers/acpi/dock.c                                |  56 +-
 drivers/acpi/ec.c                                  |  97 +--
 drivers/acpi/glue.c                                |  56 +-
 drivers/acpi/hed.c                                 |   2 +-
 drivers/acpi/internal.h                            |  11 +-
 drivers/acpi/osl.c                                 |  22 +-
 drivers/acpi/pci_irq.c                             |  15 +-
 drivers/acpi/power.c                               |   2 +-
 drivers/acpi/proc.c                                |  11 +-
 drivers/acpi/processor_driver.c                    |  74 +-
 drivers/acpi/processor_idle.c                      |  57 +-
 drivers/acpi/resource.c                            | 526 +++++++++++++++
 drivers/acpi/scan.c                                | 137 +++-
 drivers/acpi/sleep.c                               | 203 +-----
 drivers/acpi/sysfs.c                               |   4 +-
 drivers/acpi/thermal.c                             |  34 +
 drivers/acpi/utils.c                               |  38 ++
 drivers/base/core.c                                |   2 +-
 drivers/base/platform.c                            |  26 +-
 drivers/base/power/clock_ops.c                     |   6 +-
 drivers/base/power/domain.c                        |  11 +-
 drivers/base/power/opp.c                           |  44 +-
 drivers/base/power/power.h                         |   6 +-
 drivers/base/power/qos.c                           | 321 +++++++--
 drivers/base/power/sysfs.c                         |  94 ++-
 drivers/cpufreq/Kconfig.arm                        |   7 +
 drivers/cpufreq/Makefile                           |   5 +-
 drivers/cpufreq/cpufreq-cpu0.c                     |   2 +-
 drivers/cpufreq/cpufreq.c                          |  37 +-
 drivers/cpufreq/cpufreq_conservative.c             | 558 ++++-----------
 drivers/cpufreq/cpufreq_governor.c                 | 318 +++++++++
 drivers/cpufreq/cpufreq_governor.h                 | 176 +++++
 drivers/cpufreq/cpufreq_ondemand.c                 | 731 +++++++-------------
 drivers/cpufreq/cpufreq_performance.c              |   2 +
 drivers/cpufreq/cpufreq_powersave.c                |   2 +
 drivers/cpufreq/cpufreq_stats.c                    |   4 +-
 drivers/cpufreq/cpufreq_userspace.c                |   2 +
 drivers/cpufreq/exynos-cpufreq.c                   |  11 +-
 drivers/cpufreq/freq_table.c                       |   2 +
 drivers/cpufreq/longhaul.c                         |   4 +-
 drivers/cpufreq/powernow-k8.c                      |   4 +-
 drivers/cpufreq/spear-cpufreq.c                    | 291 ++++++++
 drivers/cpuidle/Kconfig                            |   9 +
 drivers/cpuidle/cpuidle.c                          |  55 +-
 drivers/cpuidle/cpuidle.h                          |  13 +-
 drivers/cpuidle/driver.c                           | 209 +++++-
 drivers/cpuidle/governors/menu.c                   | 168 ++++-
 drivers/cpuidle/sysfs.c                            | 201 +++++-
 drivers/devfreq/devfreq.c                          |   4 +-
 drivers/gpio/Kconfig                               |   4 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpiolib-acpi.c                        |  54 ++
 drivers/i2c/i2c-core.c                             |   6 +
 drivers/idle/intel_idle.c                          |  14 +-
 drivers/mmc/host/Kconfig                           |  12 +
 drivers/mmc/host/Makefile                          |   1 +
 drivers/mmc/host/sdhci-acpi.c                      | 304 +++++++++
 drivers/mtd/nand/sh_flctl.c                        |   4 +-
 drivers/pci/pci-acpi.c                             |  79 +--
 drivers/pnp/base.h                                 |   2 +
 drivers/pnp/pnpacpi/core.c                         |   4 +
 drivers/pnp/pnpacpi/rsparser.c                     | 296 +-------
 drivers/pnp/resource.c                             |  16 +
 drivers/spi/spi.c                                  | 103 ++-
 include/acpi/acconfig.h                            |   1 +
 include/acpi/acexcep.h                             |   2 +-
 include/acpi/acnames.h                             |   1 +
 include/acpi/acpi_bus.h                            |  78 ++-
 include/acpi/acpiosxf.h                            |   3 +-
 include/acpi/acpixf.h                              |  18 +-
 include/acpi/actbl3.h                              |  22 +-
 include/acpi/actypes.h                             |  42 +-
 include/linux/acpi.h                               | 135 +++-
 include/linux/acpi_gpio.h                          |  19 +
 include/linux/cpufreq.h                            |   5 +-
 include/linux/cpuidle.h                            |  15 +-
 include/linux/device.h                             |  18 +
 include/linux/freezer.h                            |   1 +
 include/linux/i2c.h                                |   9 +
 include/linux/platform_device.h                    |   1 +
 include/linux/pm.h                                 |   3 +-
 include/linux/pm_qos.h                             |  77 ++-
 include/linux/tick.h                               |   6 +
 kernel/cpu.c                                       |   8 +-
 kernel/power/main.c                                |   2 +-
 kernel/power/qos.c                                 |  65 +-
 kernel/power/swap.c                                |   2 +-
 kernel/time/tick-sched.c                           |   4 +
 tools/power/cpupower/.gitignore                    |   7 +
 tools/power/cpupower/Makefile                      |   3 +-
 tools/power/cpupower/debug/i386/Makefile           |   5 +-
 tools/power/cpupower/man/cpupower-monitor.1        |  15 +-
 tools/power/cpupower/utils/helpers/cpuid.c         |   2 +
 tools/power/cpupower/utils/helpers/helpers.h       |  18 +-
 tools/power/cpupower/utils/helpers/sysfs.c         |  19 -
 tools/power/cpupower/utils/helpers/topology.c      |  53 +-
 .../cpupower/utils/idle_monitor/cpupower-monitor.c |  21 +-
 .../cpupower/utils/idle_monitor/cpupower-monitor.h |  17 +
 tools/power/cpupower/utils/idle_monitor/snb_idle.c |  10 +-
 221 files changed, 8082 insertions(+), 2760 deletions(-)

---------------

Aaron Lu (1):
      ACPI / PM: Introduce os_accessible flag for power_state

Adrian Hunter (3):
      ACPI / PNP: skip ACPI device nodes associated with physical nodes already
      ACPI: add SDHCI to ACPI platform devices
      mmc: sdhci-acpi: add SDHCI ACPI driver

Andreas Schwab (1):
      cpufreq: fix jiffies/cputime mixup in conservative/ondemand governors

Andy Shevchenko (3):
      ACPI / x86: Export acpi_[un]register_gsi()
      ACPI / platform: include missed header into acpi_platform.c
      ACPI: remove unnecessary INIT_LIST_HEAD

Bill Pemberton (4):
      cpufreq: remove use of __devexit_p
      cpufreq: remove use of __devinit
      cpufreq: remove use of __devexit
      ACPI: remove use of __devexit

Bob Moore (18):
      Cleanup of invalid ACPI name handling and repair
      ACPICA: Audit/update for ACPICA return macros and debug depth counter
      ACPICA: ACPICA core: Cleanup empty lines at file start and end
      ACPICA: Fix some typos in comments
      ACPICA: Update local C library module comments for ASCII table
      ACPICA: Remove extra spaces after periods within comments
      ACPICA: Remove extra spaces after periods in the Intel license
      ACPICA: Add debug print message for mutex objects that are force-released
      ACPICA: AcpiExec: Improve algorithm for tracking memory leaks
      ACPICA: Add ACPI_MOVE_NAME macro to optimize 4-byte ACPI_NAME copies
      ACPICA: Enhance error reporting for invalid opcodes and bad ACPI_NAMEs
      ACPICA: Update support for ACPI 5 MPST table
      ACPICA: Deploy ACPI_MOVE_NAME across ACPICA source base
      ACPICA: Add starting offset parameter to common dump buffer routine
      ACPICA: Fix externalize name to complete migration to ACPI_MOVE_NAME
      ACPICA: Update for 64-bit generation of recent error message changes
      ACPICA: AcpiGetObjectInfo: Add support for ACPI 5 _SUB method
      ACPICA: Update version to 20121018

Cyril Roelandt (1):
      ACPI: drop unnecessary local variable from acpi_system_write_wakeup_device()

Daniel Lezcano (8):
      cpuidle / sysfs: change function parameter
      cpuidle / sysfs: move kobj initialization in the syfs file
      cpuidle / sysfs: move structure declaration into the sysfs.c file
      cpuidle: fixup device.h header in cpuidle.h
      cpuidle: move driver's refcount to cpuidle
      cpuidle: move driver checking within the lock section
      cpuidle: prepare the cpuidle core to handle multiple drivers
      cpuidle: support multiple drivers

Daniel Walter (1):
      PM / sysfs: replace strict_str* with kstrto*

David Rientjes (1):
      ACPI / PM: Fix build problem related to acpi_target_system_state()

Davidlohr Bueso (1):
      PM / Hibernate: use rb_entry

Deepak Sikri (1):
      cpufreq: SPEAr: Add CPUFreq driver

Fabio Baltieri (2):
      cpufreq: ondemand: fix wrong delay sampling rate
      cpufreq: ondemand: update sampling rate only on right CPUs

Feng Tang (5):
      ACPI / EC: Cleanup the member name for spinlock/mutex in struct
      ACPI / EC: Add more debug info and trivial code cleanup
      ACPI / EC: Don't count a SCI interrupt as a false one
      ACPI / x86: Add quirk for "CheckPoint P-20-00" to not use bridge _CRS_ info
      ACPICA: Resource Mgr: Small fix for buffer size calculation

Jingoo Han (1):
      cpufreq: Remove unnecessary initialization of a local variable

Joe Perches (1):
      ACPI: Fix logging when no pci_irq is allocated

Josh (1):
      ACPI: strict_strtoul() and printk() cleanup in acpi_pad

Julius Werner (1):
      cpuidle: Measure idle state durations with monotonic clock

Kamil Iskra (1):
      ACPI / battery: Correct battery capacity values on Thinkpads

Kristen Carlson Accardi (1):
      ACPI / Sleep: add acpi_sleep=nonvs_s3 parameter

Lan Tianyu (2):
      PM / QoS: Resume device before exposing/hiding PM QoS flags
      ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.

Lan,Tianyu (1):
      PM / QoS: Fix a free error in the dev_pm_qos_constraints_destroy()

Li Haifeng (1):
      PM / Freezer: Fixup compile error of try_to_freeze_nowarn()

Li Zhong (1):
      cpuidle: fix a suspicious RCU usage in menu governor

Liam Girdwood (1):
      PM / OPP: Export symbols for module usage.

LongX Zhang (1):
      driver core / PM: move the calling to device_pm_remove behind the calling to bus_remove_device

Lv Zheng (9):
      ACPI: Add _UID support for ACPI devices.
      ACPI: Add user space interface for identification objects
      ACPICA: Fix unmerged utility divergences.
      ACPICA: Fix unmerged debugger divergences.
      ACPICA: Fix divergences of definition conflicts.
      ACPICA: Fix AcpiSrc caused divergences.
      ACPICA: Fix indent caused divergences.
      ACPICA: Fix unmerged acmacros.h divergences.
      ACPI / PM: Add check preventing transitioning to non-D0 state from D3.

Mathias Nyman (1):
      gpio / ACPI: add ACPI support

Mika Westerberg (7):
      driver core / ACPI: Move ACPI support to core device and driver types
      ACPI: Provide generic functions for matching ACPI device nodes
      ACPI / ia64: Export acpi_[un]register_gsi()
      ACPI: Add support for platform bus type
      ACPI / platform: use ACPI device name instead of _HID._UID
      i2c / ACPI: add ACPI enumeration support
      spi / ACPI: add ACPI enumeration support

Murali Karicheri (1):
      base: power - use clk_prepare_enable and clk_prepare_disable

Nishanth Menon (1):
      PM / OPP: predictable fail results for opp_find* functions, v2

Palmer Cox (6):
      cpupower tools: Remove brace expansion from clean target
      cpupower tools: Update .gitignore for files created in the debug directories
      cpupower tools: Fix minor warnings
      cpupower tools: Fix issues with sysfs_topology_read_file
      cpupower tools: Fix malloc of cpu_info structure
      cpupower tools: Fix warning and a bug with the cpu package count

Rafael J. Wysocki (31):
      PM / QoS: Prepare device structure for adding more constraint types
      PM / QoS: Introduce request and constraint data types for PM QoS flags
      PM / QoS: Prepare struct dev_pm_qos_request for more request types
      PM / QoS: Introduce PM QoS device flags support
      PM / QoS: Make it possible to expose PM QoS device flags to user space
      PM / Domains: Check device PM QoS flags in pm_genpd_poweroff()
      PM / ACPI: Take device PM QoS flags into account
      PM / QoS: Fix the return value of dev_pm_qos_update_request()
      PM / QoS: Document request manipulation requirement for flags
      ACPI / PM: Fix device PM kernedoc comments and #ifdefs
      ACPI / PM: Move routines for adding/removing device wakeup notifiers
      ACPI / PM: Move device power state selection routine to device_pm.c
      ACPI / PM: Move runtime remote wakeup setup routine to device_pm.c
      ACPI / PM: Split device wakeup management routines
      ACPI / PM: Provide device PM functions operating on struct acpi_device
      ACPI / PM: Move device PM functions related to sleep states
      ACPI / PM: Provide ACPI PM callback routines for subsystems
      ACPI: Make seemingly useless check in osl.c more understandable
      ACPI: Move device resources interpretation code from PNP to ACPI core
      ACPI / platform: Use common ACPI device resource parsing routines
      ACPI: Centralized processing of ACPI device resources
      ACPI / PM: Fix build problem when CONFIG_ACPI or CONFIG_PM is not set
      Revert "ACPI / x86: Add quirk for "CheckPoint P-20-00" to not use bridge _CRS_ info"
      ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks
      ACPI: Allow ACPI handles of devices to be initialized in advance
      ACPI / driver core: Introduce struct acpi_dev_node and related macros
      ACPI / platform: Initialize ACPI handles of platform devices in advance
      cpufreq: governors: Fix jiffies/cputime mixup (revisited)
      PM / QoS: Handle device PM QoS flags while removing constraints
      ACPI / PM: Allow attach/detach routines to change device power states
      platform / ACPI: Attach/detach ACPI PM during probe/remove/shutdown

Randy Dunlap (1):
      ACPI: add newline in power.c message

Robert Moore (1):
      ACPICA: Fix for predefined name loop during ACPICA initialization

Tang Chen (1):
      ACPI: Fix a hard coding style when determining if a device is a container, v3

Thomas Renninger (2):
      cpupower: Provide -c param for cpupower monitor to schedule process on all cores
      cpupower: IvyBridge (0x3a and 0x3e models) support

Tomasz Figa (1):
      cpufreq: exynos: Broadcast frequency change notifications for all cores

Toshi Kani (10):
      ACPI: dock: Remove redundant ACPI NS walk
      ACPI: Fix stale pointer access to flags.lockable
      ACPI: Remove unused lockable in acpi_device_flags
      ACPI: Export functions for hot-remove
      ACPI: Add ACPI CPU hot-remove support
      ACPI: Add acpi_handle_<level>() interfaces
      ACPI: Update CPU hotplug error messages
      ACPI: Update Memory hotplug error messages
      ACPI: Update Container hotplug error messages
      ACPI: Update Dock hotplug error messages

Tushar Behera (1):
      cpufreq: exynos: Use static for functions used in only this file

Vincent Guittot (1):
      PM / OPP: RCU reclaim

Viresh Kumar (7):
      cpufreq: Improve debug prints
      cpufreq: return early from __cpufreq_driver_getavg()
      cpufreq: governors: remove redundant code
      cpufreq: Fix sparse warnings by updating cputime64_t to u64
      cpufreq: Fix sparse warning by making local function static
      cpufreq: Avoid calling cpufreq driver's target() routine if target_freq == policy->cur
      cpufreq: Make sure target freq is within limits

Wei Yongjun (1):
      PM / OPP: using kfree_rcu() to simplify the code

Wen Congyang (6):
      ACPI / memory-hotplug: call acpi_bus_trim() to remove memory device
      ACPI / memhotplug: deal with eject request in hotplug queue
      ACPI / memhotplug: fix memory leak when memory device is unbound from acpi_memhotplug
      ACPI / memhotplug: free memory device if acpi_memory_enable_device() failed
      ACPI / memhotplug: don't allow to eject the memory device if it is being used
      ACPI / memhotplug: bind the memory device when the driver is being loaded

Yasuaki Ishimatsu (3):
      ACPI / processor: prevent cpu from becoming online
      ACPI / memory-hotplug: add memory offline code to acpi_memory_device_remove()
      ACPI: create _SUN sysfs file

Youquan Song (4):
      cpuidle: Quickly notice prediction failure for repeat mode
      cpuidle: Quickly notice prediction failure in general case
      cpuidle: Set residency to 0 if target Cstate not enter
      cpuidle: Get typical recent sleep interval

Yuanhan Liu (1):
      ACPI: move acpi_no_s4_hw_signature() declaration into #ifdef CONFIG_HIBERNATION

Zhang Rui (1):
      ACPI / thermal: _TMP and _CRT/_HOT/_PSV/_ACx dependency fix

viresh kumar (3):
      cpufreq / core: Fix typo in comment describing show_bios_limit()
      cpufreq / core: Fix printing of governor and driver name
      cpufreq: Move common part from governors to separate file, v2


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
