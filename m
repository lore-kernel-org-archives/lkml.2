Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146Ab2FBGdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 02:33:06 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42197 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965123Ab2FBGdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 02:33:03 -0400
Message-ID: <4FC9B39B.403@kernel.org>
Date: Sat, 02 Jun 2012 02:32:59 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI & Power Management Patches for Linux-3.5-merge
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these ACPI & Power Management patches.
Gradual evolution here of ACPICA, cpuidle, thermal, run-time D3,
plus other assorted small changes.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:

  Linux 3.4 (2012-05-20 15:29:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to cffc28828853829dc89e53c325e2dfda3748b0e2:

  Merge branches 'acpica', 'battery', 'cpuidle-coupled', 'cpuidle-tweaks', 'intel_idle-ivb', 'misc', 'ost', 'pss-workaround', 'rafael-queue', 'thermal-cpu-cooling', 'thermal-trip-points', 'turbostat', 'video' and 'ying-add-deep-d-state-limit' into release (2012-06-02 01:50:25 -0400)

Note that there will be 3 conflicts when merging with your tree.
If you don't feel like resolving them, you can pull my "next" branch,
which is simply my "release" branch merged with your latest tree on Friday.

ps. Sorry for sending this request at the tails of the merge window --
I'll try to be earlier next time.

----------------------------------------------------------------

Alan Cox (3):
      acpi_video: fix leaking PCI references
      acpi_video: Intel video is not always i915
      gma500: don't register the ACPI video bus

Amit Daniel Kachhap (5):
      thermal: add generic cpufreq cooling implementation
      hwmon: exynos4: move thermal sensor driver to driver/thermal directory
      thermal: exynos5: add exynos5 thermal sensor driver support
      thermal: exynos: register the tmu sensor with the kernel thermal layer
      ARM: exynos: add thermal sensor driver platform data support

Andy Whitcroft (1):
      ACPI battery: only refresh the sysfs files when pertinent information changes

Bob Moore (9):
      ACPICA: Object dump routines: Use common function for string output
      ACPICA: Lint fixes for acpi_write, no functional changes
      ACPICA: Add support for multiple notify handlers
      ACPICA: Update to version 20120420
      ACPICA: Disassembler: Add support for Operation Region externals
      ACPICA: ACPI 5/iASL: Add support for PCC keyword
      ACPICA: iASL: Improved pathname support
      ACPICA: Add FADT error message for GAS BitWidth overflow
      ACPICA: Update to version 20120518

Colin Cross (4):
      cpuidle: refactor out cpuidle_enter_state
      cpuidle: fix error handling in __cpuidle_register_device
      cpuidle: add support for states that affect multiple cpus
      cpuidle: coupled: add parallel barrier function

Dan Carpenter (1):
      ACPI video: use after input_unregister_device()

Daniel Drake (2):
      ACPI / PM: Generate wakeup events on fixed power button
      rtc-cmos / PM: report wakeup event on ACPI RTC alarm

Durgadoss R (2):
      ACPI-Thermal: Make Thermal trip points writeable
      ACPI-Thermal: Add Hysteresis attributes

Fabio Estevam (1):
      drivers: acpi: Fix dependency for ACPI_HOTPLUG_CPU

Huang Ying (1):
      ACPI, PM, Specify lowest allowed state for device sleep state

Jesper Juhl (1):
      ACPICA: AML Parser: Fix two possible memory leaks in error path

Len Brown (3):
      intel_idle: initial IVB support
      tools/power: turbostat v2 - re-write for efficiency
      Merge branches 'acpica', 'battery', 'cpuidle-coupled', 'cpuidle-tweaks', 'intel_idle-ivb', 'misc', 'ost', 'pss-workaround', 'rafael-queue', 'thermal-cpu-cooling', 'thermal-trip-points', 'turbostat', 'video' and 'ying-add-deep-d-state-limit' into release

Lin Ming (1):
      ACPICA: Remove argument of acpi_os_wait_events_complete

Marco Aurelio da Costa (1):
      ACPI: Ignore invalid _PSS entries, but use valid ones

Rafael J. Wysocki (3):
      ACPI / PM: Fix error messages in drivers/acpi/bus.c
      ACPI / PM: Make __acpi_bus_get_power() cover D3cold correctly
      ACPI / PM: Make acpi_pm_device_sleep_state() follow the specification

Sergey Senozhatsky (1):
      cpuidle: remove unused hrtimer_peek_ahead_timers() call

Srivatsa S. Bhat (1):
      cpuidle: add checks to avoid NULL pointer dereference

Toshi Kani (6):
      ACPI: Add an interface to evaluate _OST
      ACPI: Add _OST support for sysfs eject
      ACPI: Add _OST support for ACPI CPU hotplug
      ACPI: Add _OST support for ACPI memory hotplug
      ACPI: Add _OST support for ACPI container hotplug
      ACPI: Set hotplug _OST support bit to _OSC

Viresh Kumar (1):
      drivers/thermal/spear_thermal.c: add Device Tree probing capability

srinivas pandruvada (1):
      ACPI Battery: Added capacity

 .../devicetree/bindings/thermal/spear-thermal.txt  |   14 +
 Documentation/thermal/cpu-cooling-api.txt          |   60 +
 .../{hwmon/exynos4_tmu => thermal/exynos_thermal}  |   35 +-
 Documentation/thermal/sysfs-api.txt                |   10 +-
 drivers/acpi/Kconfig                               |    2 +-
 drivers/acpi/acpi_memhotplug.c                     |   43 +-
 drivers/acpi/acpica/acglobal.h                     |    3 +-
 drivers/acpi/acpica/aclocal.h                      |   13 +-
 drivers/acpi/acpica/acobject.h                     |    9 +-
 drivers/acpi/acpica/acutils.h                      |    2 +
 drivers/acpi/acpica/dsfield.c                      |   81 ++
 drivers/acpi/acpica/evmisc.c                       |  185 +--
 drivers/acpi/acpica/evxface.c                      |  444 +++----
 drivers/acpi/acpica/exdump.c                       |   29 +-
 drivers/acpi/acpica/hwesleep.c                     |    9 +-
 drivers/acpi/acpica/psargs.c                       |    2 +
 drivers/acpi/acpica/tbfadt.c                       |   32 +-
 drivers/acpi/acpica/utdelete.c                     |   24 +-
 drivers/acpi/acpica/utglobal.c                     |    4 +-
 drivers/acpi/acpica/utmisc.c                       |   29 +
 drivers/acpi/battery.c                             |   19 +-
 drivers/acpi/bus.c                                 |   92 +-
 drivers/acpi/container.c                           |   43 +-
 drivers/acpi/osl.c                                 |    4 +-
 drivers/acpi/power.c                               |    2 +-
 drivers/acpi/processor_driver.c                    |   28 +-
 drivers/acpi/processor_perflib.c                   |   30 +-
 drivers/acpi/scan.c                                |   59 +-
 drivers/acpi/sleep.c                               |   75 +-
 drivers/acpi/thermal.c                             |    4 +-
 drivers/acpi/utils.c                               |   42 +
 drivers/acpi/video.c                               |   33 +-
 drivers/cpuidle/Kconfig                            |    3 +
 drivers/cpuidle/Makefile                           |    1 +
 drivers/cpuidle/coupled.c                          |  715 +++++++++++
 drivers/cpuidle/cpuidle.c                          |   85 +-
 drivers/cpuidle/cpuidle.h                          |   32 +
 drivers/gpu/drm/gma500/psb_drv.c                   |    2 +-
 drivers/hwmon/Kconfig                              |   10 -
 drivers/hwmon/Makefile                             |    1 -
 drivers/hwmon/exynos4_tmu.c                        |  514 --------
 drivers/idle/intel_idle.c                          |   37 +
 drivers/pci/pci-acpi.c                             |    3 +-
 drivers/platform/x86/acerhdf.c                     |    2 +-
 drivers/platform/x86/intel_mid_thermal.c           |    2 +-
 drivers/pnp/pnpacpi/core.c                         |    4 +-
 drivers/rtc/rtc-cmos.c                             |    9 +-
 drivers/thermal/Kconfig                            |   21 +
 drivers/thermal/Makefile                           |    4 +-
 drivers/thermal/cpu_cooling.c                      |  483 +++++++
 drivers/thermal/exynos_thermal.c                   |  956 ++++++++++++++
 drivers/thermal/spear_thermal.c                    |   28 +-
 drivers/thermal/thermal_sys.c                      |  193 ++-
 include/acpi/acpi_bus.h                            |   18 +-
 include/acpi/acpiosxf.h                            |    2 +-
 include/acpi/acpixf.h                              |    2 +-
 include/acpi/actypes.h                             |    7 +-
 include/linux/acpi.h                               |   40 +-
 include/linux/cpu_cooling.h                        |   99 ++
 include/linux/cpuidle.h                            |   11 +
 .../{exynos4_tmu.h => exynos_thermal.h}            |   31 +-
 include/linux/platform_data/spear_thermal.h        |   26 -
 include/linux/thermal.h                            |   15 +-
 tools/power/x86/turbostat/turbostat.8              |   77 +-
 tools/power/x86/turbostat/turbostat.c              | 1324 +++++++++++++-------
 65 files changed, 4443 insertions(+), 1775 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/spear-thermal.txt
 create mode 100644 Documentation/thermal/cpu-cooling-api.txt
 rename Documentation/{hwmon/exynos4_tmu => thermal/exynos_thermal} (71%)
 create mode 100644 drivers/cpuidle/coupled.c
 delete mode 100644 drivers/hwmon/exynos4_tmu.c
 create mode 100644 drivers/thermal/cpu_cooling.c
 create mode 100644 drivers/thermal/exynos_thermal.c
 create mode 100644 include/linux/cpu_cooling.h
 rename include/linux/platform_data/{exynos4_tmu.h => exynos_thermal.h} (74%)
 delete mode 100644 include/linux/platform_data/spear_thermal.h
