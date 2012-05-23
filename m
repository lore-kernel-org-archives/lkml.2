Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965099Ab2EWDkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:40:31 -0400
Received: from ozlabs.org ([203.10.76.45]:59875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151Ab2EWDk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:40:27 -0400
Message-ID: <1337744423.3038.26.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@ozlabs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 23 May 2012 13:40:23 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are the powerpc goodies for 3.5. Main highlights are:

 - Support for the NX crypto engine in Power7+
 - A bunch of Anton goodness, including some micro optimization
   of our syscall entry on Power7
 - I converted a pile of our thermal control drivers to the
   new i2c APIs (essentially turning the old therm_pm72 into
   a proper set of windfarm drivers). That's one more step
   toward removing the deprecated i2c APIs, there's still a
   few drivers to fix, but we are getting close
 - kexec/kdump support for 47x embedded cores

The big missing thing here is no updates from Freescale. Not sure
what's up here, but with Kumar not working for them anymore things
are a bit in a state of flux in that area.

[Sent from my ozlabs address because gate.crashing.org appears to
have temporarily fallen off the face of the internet]

Cheers,
Ben.

The following changes since commit 7c0482e3d055e5de056d3c693b821e39205b99ae:

  powerpc/irq: Fix another case of lazy IRQ state getting out of sync (2012-05-12 09:40:41 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 2074b1d9d53ae696dd3f49482bad43254f40f01d:

  powerpc: Fix irq distribution (2012-05-22 14:38:26 +1000)

----------------------------------------------------------------
Andre Heider (3):
      powerpc/ps3: Add highmem repository read routines
      powerpc/ps3: Use highmem region from repository
      powerpc/ps3: Remove MEMORY_HOTPLUG requirement

Anshuman Khandual (1):
      powerpc: Fixing a cputhread code documentation

Anton Blanchard (15):
      powerpc: Hide some system call labels from profile tools
      powerpc: No need to save XER in a system call
      powerpc: No need to preserve count register across system call
      powerpc: Better scheduling of CR save code in system call path
      powerpc: Clean up lppaca->cede_latency_hint
      powerpc: Remove iseries specific fields in lppaca
      powerpc: Reformat lppaca.h
      powerpc: Remove empty giveup_altivec function on book3e CPUs
      powerpc: Optimise enable_kernel_altivec
      powerpc: Remove CONFIG_POWER4_ONLY
      powerpc: Require gcc 4.0 on 64-bit
      powerpc: Remove altivec fix for gcc versions before 4.0
      powerpc: Add 64-bit CPU targets for gcc
      powerpc: Use WARN instead of dump_stack when printing EEH error backtrace
      powerpc: Remove old powerpc specific ptrace getregs/setregs calls

Benjamin Herrenschmidt (20):
      Merge remote-tracking branch 'geoff/for-powerpc' into next
      i2c/powermac: Register i2c devices from device-tree
      powerpc/pmac: Convert therm_adt746x to new i2c probing
      powerpc/pmac: Convert windfarm_lm75 to new i2c probing
      powerpc/pmac: Convert windfarm_max6690 to new i2c probing
      powerpc/pmac: Convert windfarm_smu_sat to new i2c probing
      powerpc/windfarm: const'ify and add "priv" field to controls & sensors
      powerpc/windfarm: Remove spurrious sysfs_attr_init()
      powerpc/windfarm: Improve display of fan speeds in sysfs
      powerpc/windfarm: Add useful accessors
      powerpc/windfarm: Add ad7417 sensor
      powerpc/windfarm: Add lm87 sensor
      powerpc/windfarm: Updates to lm75 and max6690 sensors
      powerpc/windfarm: Add Fan Control Unit controls for G5s
      powerpc/powermac: New windfarm driver for PowerMac G5 (AGP) and Xserve G5
      Merge branch 'merge' into next
      powerpc/windfarm: Fix crash on SMU based machine after i2c conversion
      Merge remote-tracking branch 'jwb/next' into next
      Merge branch 'merge' into next
      Revert "powerpc/hw-breakpoint: Use generic hw-breakpoint interfaces for new PPC ptrace flags"

Geoff Levand (5):
      powerpc/ps3: Correct lv1 repository routine names
      powerpc/ps3: Add PS3 repository write support
      powerpc/ps3: Add highmem repository write routines
      powerpc/ps3: Minor Kconfig cleanup
      powerpc/ps3: Refresh ps3_defconfig

Hector Martin (1):
      powerpc/ps3: Add highmem region memory early

Josh Boyer (1):
      powerpc/40x: Use {upper,lower}_32_bits for msi_phys

K.Prasad (1):
      powerpc/hw-breakpoint: Use generic hw-breakpoint interfaces for new PPC ptrace flags

Kent Yoder (17):
      powerpc/pseries: Add new hvcall constants to support PFO
      powerpc/pseries: Add pseries update notifier for OFDT prop changes
      powerpc/pseries: Add PFO support to the VIO bus
      powerpc/pseries/hwrng: PFO-based hwrng driver
      powerpc/pseries: Enable the PFO-based RNG accelerator
      powerpc/crypto: nx driver code supporting nx encryption
      powerpc/crypto: AES-CBC mode routines for nx encryption
      powerpc/crypto: AES-CCM mode routines for nx encryption
      powerpc/crypto: AES-CTR mode routines for nx encryption
      powerpc/crypto: AES-ECB mode routines for nx encryption
      powerpc/crypto: AES-GCM mode routines for nx encryption
      powerpc/crypto: AES-XCBC mode routines for nx encryption
      powerpc/crypto: SHA256 hash routines for nx encryption
      powerpc/crypto: SHA512 hash routines for nx encryption
      powerpc/crypto: debugfs routines and docs for the nx device driver
      powerpc/crypto: Build files for the nx device driver
      powerpc/crypto: Enable the PFO-based encryption device

Kim Phillips (1):
      powerpc: Fix irq distribution

Mai La (2):
      powerpc/44x: Fix PCI MSI support for Maui APM821xx SoC and Bluestone board
      powerpc/44x: Add PCI MSI node for Maui APM821xx SoC and Bluestone board in DTS

Robert Jennings (1):
      powerpc/pseries: Support lower minimum entitlement for virtual processors

Stephen Rothwell (2):
      powerpc/windfarm: fix compiler warning
      powerpc/windfarm: don't pass const strings to snprintf

Suzuki Poulose (3):
      powerpc/44x: Fix/Initialize PID to kernel PID before the TLB search
      powerpc/47x: Kernel support for KEXEC
      powerpc/47x: Enable CRASH_DUMP

Tiejun Chen (1):
      powerpc: Remove now unused _TIF_RUNLATCH

Valentin Ilie (1):
      drivers/ps3: Fix checkpatch warnings in ps3av.c

 Documentation/ABI/testing/debugfs-pfo-nx-crypto |   45 ++
 arch/powerpc/Kconfig                            |    4 +-
 arch/powerpc/Makefile                           |   49 +-
 arch/powerpc/boot/dts/bluestone.dts             |   25 +
 arch/powerpc/configs/g5_defconfig               |    1 -
 arch/powerpc/configs/maple_defconfig            |    1 -
 arch/powerpc/configs/pasemi_defconfig           |    1 -
 arch/powerpc/configs/ps3_defconfig              |    6 -
 arch/powerpc/include/asm/asm-compat.h           |   11 +-
 arch/powerpc/include/asm/cputhreads.h           |    2 +-
 arch/powerpc/include/asm/hvcall.h               |   25 +-
 arch/powerpc/include/asm/lppaca.h               |  196 ++----
 arch/powerpc/include/asm/lv1call.h              |    4 +-
 arch/powerpc/include/asm/pSeries_reconfig.h     |   12 +
 arch/powerpc/include/asm/ppc_asm.h              |   10 +-
 arch/powerpc/include/asm/ptrace.h               |    6 -
 arch/powerpc/include/asm/switch_to.h            |    6 +-
 arch/powerpc/include/asm/thread_info.h          |    1 -
 arch/powerpc/include/asm/vio.h                  |   46 ++
 arch/powerpc/kernel/asm-offsets.c               |    4 -
 arch/powerpc/kernel/entry_64.S                  |   30 +-
 arch/powerpc/kernel/exceptions-64s.S            |    4 -
 arch/powerpc/kernel/head_44x.S                  |    8 -
 arch/powerpc/kernel/head_fsl_booke.S            |    8 -
 arch/powerpc/kernel/irq.c                       |    2 +-
 arch/powerpc/kernel/misc_32.S                   |  203 +++++-
 arch/powerpc/kernel/paca.c                      |    3 -
 arch/powerpc/kernel/process.c                   |    2 +-
 arch/powerpc/kernel/prom_init.c                 |   17 +-
 arch/powerpc/kernel/ptrace.c                    |   42 --
 arch/powerpc/kernel/ptrace32.c                  |   32 -
 arch/powerpc/kernel/vector.S                    |   10 +
 arch/powerpc/kernel/vio.c                       |  273 ++++++--
 arch/powerpc/lib/copyuser_64.S                  |    6 +-
 arch/powerpc/lib/mem_64.S                       |    6 +-
 arch/powerpc/lib/memcpy_64.S                    |    6 +-
 arch/powerpc/platforms/44x/Kconfig              |    2 +
 arch/powerpc/platforms/Kconfig.cputype          |   39 +-
 arch/powerpc/platforms/powermac/low_i2c.c       |    1 +
 arch/powerpc/platforms/ps3/Kconfig              |   22 +-
 arch/powerpc/platforms/ps3/mm.c                 |   77 ++-
 arch/powerpc/platforms/ps3/platform.h           |   16 +
 arch/powerpc/platforms/ps3/repository.c         |  198 ++++++
 arch/powerpc/platforms/pseries/eeh.c            |    2 +-
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    4 +-
 arch/powerpc/platforms/pseries/reconfig.c       |    7 +
 arch/powerpc/sysdev/ppc4xx_msi.c                |   42 +-
 drivers/char/hw_random/Kconfig                  |   13 +
 drivers/char/hw_random/Makefile                 |    1 +
 drivers/char/hw_random/pseries-rng.c            |   96 +++
 drivers/crypto/Kconfig                          |   17 +
 drivers/crypto/nx/Makefile                      |   11 +
 drivers/crypto/nx/nx-aes-cbc.c                  |  141 ++++
 drivers/crypto/nx/nx-aes-ccm.c                  |  468 +++++++++++++
 drivers/crypto/nx/nx-aes-ctr.c                  |  178 +++++
 drivers/crypto/nx/nx-aes-ecb.c                  |  139 ++++
 drivers/crypto/nx/nx-aes-gcm.c                  |  353 ++++++++++
 drivers/crypto/nx/nx-aes-xcbc.c                 |  236 +++++++
 drivers/crypto/nx/nx-sha256.c                   |  246 +++++++
 drivers/crypto/nx/nx-sha512.c                   |  265 +++++++
 drivers/crypto/nx/nx.c                          |  716 +++++++++++++++++++
 drivers/crypto/nx/nx.h                          |  193 ++++++
 drivers/crypto/nx/nx_csbcpb.h                   |  205 ++++++
 drivers/crypto/nx/nx_debugfs.c                  |  103 +++
 drivers/i2c/busses/i2c-powermac.c               |   98 ++-
 drivers/macintosh/Kconfig                       |   23 +-
 drivers/macintosh/Makefile                      |   14 +
 drivers/macintosh/ams/ams-i2c.c                 |    2 +-
 drivers/macintosh/therm_adt746x.c               |  480 ++++++-------
 drivers/macintosh/windfarm.h                    |   51 +-
 drivers/macintosh/windfarm_ad7417_sensor.c      |  347 ++++++++++
 drivers/macintosh/windfarm_core.c               |   23 +-
 drivers/macintosh/windfarm_cpufreq_clamp.c      |    6 -
 drivers/macintosh/windfarm_fcu_controls.c       |  613 ++++++++++++++++
 drivers/macintosh/windfarm_lm75_sensor.c        |  135 +---
 drivers/macintosh/windfarm_lm87_sensor.c        |  201 ++++++
 drivers/macintosh/windfarm_max6690_sensor.c     |  109 +--
 drivers/macintosh/windfarm_mpu.h                |  105 +++
 drivers/macintosh/windfarm_pm72.c               |  847 +++++++++++++++++++++++
 drivers/macintosh/windfarm_pm81.c               |   25 +-
 drivers/macintosh/windfarm_pm91.c               |   33 +-
 drivers/macintosh/windfarm_rm31.c               |  740 ++++++++++++++++++++
 drivers/macintosh/windfarm_smu_controls.c       |    1 -
 drivers/macintosh/windfarm_smu_sat.c            |  132 ++--
 drivers/ps3/ps3av.c                             |   24 +-
 85 files changed, 7827 insertions(+), 1080 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-pfo-nx-crypto
 create mode 100644 drivers/char/hw_random/pseries-rng.c
 create mode 100644 drivers/crypto/nx/Makefile
 create mode 100644 drivers/crypto/nx/nx-aes-cbc.c
 create mode 100644 drivers/crypto/nx/nx-aes-ccm.c
 create mode 100644 drivers/crypto/nx/nx-aes-ctr.c
 create mode 100644 drivers/crypto/nx/nx-aes-ecb.c
 create mode 100644 drivers/crypto/nx/nx-aes-gcm.c
 create mode 100644 drivers/crypto/nx/nx-aes-xcbc.c
 create mode 100644 drivers/crypto/nx/nx-sha256.c
 create mode 100644 drivers/crypto/nx/nx-sha512.c
 create mode 100644 drivers/crypto/nx/nx.c
 create mode 100644 drivers/crypto/nx/nx.h
 create mode 100644 drivers/crypto/nx/nx_csbcpb.h
 create mode 100644 drivers/crypto/nx/nx_debugfs.c
 create mode 100644 drivers/macintosh/windfarm_ad7417_sensor.c
 create mode 100644 drivers/macintosh/windfarm_fcu_controls.c
 create mode 100644 drivers/macintosh/windfarm_lm87_sensor.c
 create mode 100644 drivers/macintosh/windfarm_mpu.h
 create mode 100644 drivers/macintosh/windfarm_pm72.c
 create mode 100644 drivers/macintosh/windfarm_rm31.c


