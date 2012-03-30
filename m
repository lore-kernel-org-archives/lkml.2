Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240Ab2C3LjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:39:01 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:62104 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933561Ab2C3Lix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:38:53 -0400
Message-ID: <4F759B4A.5010807@kernel.org>
Date: Fri, 30 Mar 2012 07:38:50 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Lee <rob.lee@linaro.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI & Power Management patches for Linux-3.4-merge
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these ACPI & Power Management patches.

ACPI 5.0 after-ripples, ACPICA/Linux divergence cleanup
cpuidle evolving, more ARM use
thermal sub-system evolving, ditto
assorted other PM bits

The top commit is a merge with your latest tree
to address some cpuidle/ARM conflicts.

Rob, Daniel,

As you both modified at91_enter_idle(), and I don't know the semantics
of at91_standby(), I had to guess at the correct merge.
Please double check it and correct as necessary.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit f52b69f86e27903d6896ed5fa7cd280fec8de532:

  Merge tag 'sh-for-linus' of git://github.com/pmundt/linux-sh (2012-03-30 00:09:17 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to 14b5e206d755327ca176920ce2984c55191bbe1d:

  Merge branch 'upstream' into release (2012-03-30 07:00:19 -0400)

----------------------------------------------------------------

Alex He (1):
      ACPI: Clean redundant codes in scan.c

Amit Daniel Kachhap (1):
      thermal: Fix for setting the thermal zone mode to enable/disable

Andi Kleen (3):
      ACPI: ec: Do request_region outside WARN()
      ACPI: Make ACPI interrupt threaded
      Disable MCP limit exceeded messages from Intel IPS driver

Bjorn Helgaas (1):
      ACPI / PM: print physical addresses consistently with other parts of kernel

Bob Moore (16):
      ACPICA: Update _REV return value to 5
      ACPICA: ACPI 5: Support for new FADT SleepStatus, SleepControl registers
      ACPICA: Move ACPI timer prototypes to public acpixf file
      ACPICA: Support for custom ACPICA build for ACPI 5 reduced hardware
      ACPICA: Expand OSL memory read/write interfaces to 64 bits
      ACPICA: ACPI 5: Update debug output for new notify values
      ACPICA: Add acpi_os_physical_table_override interface
      ACPICA: Distill multiple sleep method functions to a single function
      ACPICA: Split sleep/wake functions into two files
      ACPICA: Add table-driven dispatch for sleep/wake functions
      ACPICA: Update to version 20120215
      ACPICA: Clarify METHOD_NAME* defines for full-pathname cases
      ACPICA: Change exception code for invalid pathname in acpi_evaluate_object
      ACPICA: Debugger: Add missing object info to namespace dump
      ACPICA: Object repair code: Support to add Package wrappers
      ACPICA: Update to version 20120320

Boris Ostrovsky (2):
      idle, x86: Allow off-lined CPU to enter deeper C states
      cpuidle: power_usage should be declared signed integer

Chen Gong (3):
      ACPI, APEI, EINJ, limit the range of einj_param
      ACPI, APEI, EINJ, new parameter to control trigger action
      Update documentation for parameter *notrigger* in einj.txt

Corentin Chary (1):
      ACPI / Video: blacklist some samsung laptops

Dan Carpenter (2):
      thermal: spear13xx: checking for NULL instead of IS_ERR()
      ACPI throttling: fix endian bug in acpi_read_throttling_status()

Daniel Lezcano (3):
      cpuidle: use the driver's state_count as default
      cpuidle: remove useless array definition in cpuidle_structure
      cpuidle: remove unused 'governor_data' field

Fabio Estevam (1):
      drivers/thermal/thermal_sys.c: fix build warning

Gary Hade (1):
      ACPI, APEI: Fix incorrect APEI register bit width check and usage

Jan Beulich (1):
      ACPI: consistently use should_use_kmap()

Jiang Liu (2):
      ACPI, APEI, Fix ERST header length check
      CPER failed to handle generic error records with multiple sections

Joe Perches (4):
      thermal_sys: remove unnecessary line continuations
      thermal_sys: remove obfuscating used-once macros
      thermal_sys: kernel style cleanups
      thermal_sys: convert printks to pr_<level>

Julia Lawall (1):
      ACPI: processor_driver: add missing kfree

Julian Anastasov (1):
      ACPICA: Fix regression in FADT revision checks

Konrad Rzeszutek Wilk (1):
      tboot: Add return values for tboot_sleep

Len Brown (11):
      ACPI: ignore FADT reset-reg-sup flag
      Merge branch 'stable/for-x86-for-3.4' of git://git.kernel.org/.../konrad/xen into tboot
      tools turbostat: add summary option
      tools turbostat: reduce measurement overhead due to IPIs
      tools turbostat: harden against cpu online/offline
      Merge branches 'acpica', 'bgrt', 'bz-11533', 'cpuidle', 'ec', 'hotplug', 'misc', 'thermal', 'turbostat' and 'video' into release
      Merge branch 'apei' into release
      Merge branch 'red-hat-bz-727865' into release
      Merge branch 'd3' into release
      Merge branch 'tboot' into release
      Merge branch 'upstream' into release

Lin Ming (4):
      ACPICA: Sleep/Wake interfaces: optionally execute _GTS and _BFS
      ACPI: Move module parameter gts and bfs to sleep.c
      ACPI: Add interface to register/unregister device to/from power resources
      ACPI, PCI: Move acpi_dev_run_wake() to ACPI core

Matthew Garrett (4):
      ACPI: Evaluate thermal trip points before reading temperature
      ACPI: Ensure thermal limits match CPU frequencies
      ACPI: export acpi_kobj
      ACPI: Add support for exposing BGRT data

Myron Stowe (1):
      ACPI: Fix logic for removing mappings in 'acpi_unmap'

Paul E. McKenney (1):
      ACPI: Fix unprotected smp_processor_id() in acpi_processor_cst_has_changed()

Petr Vandrovec (1):
      ACPI: Fix use-after-free in acpi_map_lsapic

Robert Lee (9):
      cpuidle: Add common time keeping and irq enabling
      ARM: at91: Consolidate time keeping and irq enable
      ARM: kirkwood: Consolidate time keeping and irq enable
      ARM: davinci: Consolidate time keeping and irq enable
      ARM: omap: Consolidate OMAP3 time keeping and irq enable
      ARM: omap: Consolidate OMAP4 time keeping and irq enable
      ARM: shmobile: Consolidate time keeping and irq enable
      SH: shmobile: Consolidate time keeping and irq enable
      ARM: davinci: Fix for cpuidle consolidation changes

ShuoX Liu (1):
      cpuidle: add a sysfs entry to disable specific C state for debug purpose.

Tang Liang (1):
      x86, acpi, tboot: Have a ACPI os prepare sleep instead of calling tboot_sleep.

Toshi Kani (1):
      ACPI: Add CPU hotplug support for processor device objects

Vincenzo Frascino (1):
      thermal: add support for thermal sensor present on SPEAr13xx machines

Viresh Kumar (1):
      thermal/spear_thermal: replace readl/writel with lighter _relaxed variants

Yinghai Lu (1):
      PNPACPI: Fix device ref leaking in acpi_pnp_match

Zhang Rui (1):
      ACPI: Introduce ACPI D3_COLD state support

 Documentation/ABI/testing/sysfs-firmware-acpi    |   20 +
 Documentation/acpi/apei/einj.txt                 |    8 +
 Documentation/cpuidle/sysfs.txt                  |    5 +
 arch/arm/include/asm/cpuidle.h                   |   29 ++
 arch/arm/kernel/Makefile                         |    2 +-
 arch/arm/kernel/cpuidle.c                        |   21 ++
 arch/arm/mach-at91/cpuidle.c                     |   63 ++--
 arch/arm/mach-davinci/cpuidle.c                  |   83 ++--
 arch/arm/mach-kirkwood/cpuidle.c                 |   72 ++--
 arch/arm/mach-omap2/cpuidle34xx.c                |   42 +--
 arch/arm/mach-omap2/cpuidle44xx.c                |   21 +-
 arch/arm/mach-shmobile/cpuidle.c                 |   31 +-
 arch/sh/kernel/cpu/shmobile/cpuidle.c            |   10 +-
 arch/x86/kernel/acpi/boot.c                      |    3 +-
 arch/x86/kernel/smpboot.c                        |    4 +-
 arch/x86/kernel/tboot.c                          |    9 +-
 drivers/acpi/Kconfig                             |    9 +
 drivers/acpi/Makefile                            |    1 +
 drivers/acpi/acpica/Makefile                     |    4 +-
 drivers/acpi/acpica/accommon.h                   |    1 -
 drivers/acpi/acpica/acdebug.h                    |    8 +-
 drivers/acpi/acpica/acevents.h                   |   21 +-
 drivers/acpi/acpica/acglobal.h                   |   11 +-
 drivers/acpi/acpica/achware.h                    |   32 +-
 drivers/acpi/acpica/aclocal.h                    |    1 +
 drivers/acpi/acpica/acmacros.h                   |    6 +
 drivers/acpi/acpica/acnamesp.h                   |    5 +-
 drivers/acpi/acpica/actables.h                   |    5 +
 drivers/acpi/acpica/evevent.c                    |    4 +-
 drivers/acpi/acpica/evglock.c                    |    4 +-
 drivers/acpi/acpica/evgpe.c                      |    4 +-
 drivers/acpi/acpica/evgpeblk.c                   |    4 +-
 drivers/acpi/acpica/evgpeinit.c                  |    4 +-
 drivers/acpi/acpica/evgpeutil.c                  |    3 +
 drivers/acpi/acpica/evmisc.c                     |   26 +-
 drivers/acpi/acpica/evsci.c                      |    4 +-
 drivers/acpi/acpica/evxface.c                    |  436 +++++++++++-----------
 drivers/acpi/acpica/evxfevnt.c                   |    2 +
 drivers/acpi/acpica/evxfgpe.c                    |    2 +
 drivers/acpi/acpica/hwacpi.c                     |    3 +
 drivers/acpi/acpica/hwesleep.c                   |  247 ++++++++++++
 drivers/acpi/acpica/hwgpe.c                      |    4 +-
 drivers/acpi/acpica/hwregs.c                     |   16 +-
 drivers/acpi/acpica/hwsleep.c                    |  401 ++++----------------
 drivers/acpi/acpica/hwtimer.c                    |    2 +
 drivers/acpi/acpica/hwxface.c                    |   50 +--
 drivers/acpi/acpica/hwxfsleep.c                  |  431 +++++++++++++++++++++
 drivers/acpi/acpica/nsdump.c                     |   15 +-
 drivers/acpi/acpica/nsdumpdv.c                   |    2 +-
 drivers/acpi/acpica/nspredef.c                   |    4 +-
 drivers/acpi/acpica/nsrepair.c                   |  159 +++-----
 drivers/acpi/acpica/nsutils.c                    |    2 +-
 drivers/acpi/acpica/tbfadt.c                     |    8 +-
 drivers/acpi/acpica/tbinstal.c                   |  117 +++++-
 drivers/acpi/acpica/tbutils.c                    |   95 ++---
 drivers/acpi/acpica/utdecode.c                   |   34 +-
 drivers/acpi/acpica/utglobal.c                   |    9 +-
 drivers/acpi/acpica/utinit.c                     |   37 +-
 drivers/acpi/acpica/utxface.c                    |    6 +-
 drivers/acpi/apei/apei-base.c                    |   61 +--
 drivers/acpi/apei/cper.c                         |    2 +
 drivers/acpi/apei/einj.c                         |   17 +-
 drivers/acpi/apei/erst.c                         |    2 +-
 drivers/acpi/bgrt.c                              |  175 +++++++++
 drivers/acpi/bus.c                               |    1 +
 drivers/acpi/ec.c                                |    8 +-
 drivers/acpi/nvs.c                               |    4 +-
 drivers/acpi/osl.c                               |  124 ++----
 drivers/acpi/power.c                             |  166 +++++++-
 drivers/acpi/processor_driver.c                  |   62 ++-
 drivers/acpi/processor_idle.c                    |   34 +-
 drivers/acpi/processor_thermal.c                 |   45 ++-
 drivers/acpi/processor_throttling.c              |    5 +-
 drivers/acpi/reboot.c                            |    3 +-
 drivers/acpi/scan.c                              |   12 +-
 drivers/acpi/sleep.c                             |   76 +++-
 drivers/acpi/thermal.c                           |    8 +-
 drivers/acpi/video_detect.c                      |   49 +++
 drivers/cpuidle/cpuidle.c                        |   97 ++++-
 drivers/cpuidle/driver.c                         |    2 +-
 drivers/cpuidle/governors/menu.c                 |    7 +-
 drivers/cpuidle/sysfs.c                          |   40 ++
 drivers/pci/pci-acpi.c                           |   40 +-
 drivers/platform/x86/intel_ips.c                 |   13 +-
 drivers/pnp/pnpacpi/core.c                       |    7 +-
 drivers/thermal/Kconfig                          |    8 +
 drivers/thermal/Makefile                         |    1 +
 drivers/thermal/spear_thermal.c                  |  206 ++++++++++
 drivers/thermal/thermal_sys.c                    |   94 ++---
 {drivers/acpi/acpica => include/acpi}/acconfig.h |   19 +-
 include/acpi/acexcep.h                           |    7 +-
 include/acpi/acnames.h                           |   12 +-
 include/acpi/acpi_bus.h                          |    7 +
 include/acpi/acpiosxf.h                          |   13 +-
 include/acpi/acpixf.h                            |  229 ++++++++----
 include/acpi/actbl.h                             |    7 +
 include/acpi/actypes.h                           |   22 +-
 include/linux/acpi.h                             |   10 +
 include/linux/cpuidle.h                          |   22 +-
 include/linux/platform_data/spear_thermal.h      |   26 ++
 include/linux/tboot.h                            |    1 -
 tools/power/x86/turbostat/turbostat.8            |   99 +++--
 tools/power/x86/turbostat/turbostat.c            |  245 ++++++++----
 103 files changed, 3205 insertions(+), 1545 deletions(-)
 create mode 100644 arch/arm/include/asm/cpuidle.h
 create mode 100644 arch/arm/kernel/cpuidle.c
 create mode 100644 drivers/acpi/acpica/hwesleep.c
 create mode 100644 drivers/acpi/acpica/hwxfsleep.c
 create mode 100644 drivers/acpi/bgrt.c
 create mode 100644 drivers/thermal/spear_thermal.c
 rename {drivers/acpi/acpica => include/acpi}/acconfig.h (92%)
 create mode 100644 include/linux/platform_data/spear_thermal.h
