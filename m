Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754Ab1KAAqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:46:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:32946 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab1KAAqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:46:12 -0400
Date: Mon, 31 Oct 2011 20:45:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <rusty@rustcorp.com.au>, <mingo@elte.hu>, <akpm@linux-foundation.org>,
        <sfr@canb.auug.org.au>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] introduce export.h; reduce module.h usage
Message-ID: <20111101004542.GA18671@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the below to get the module.h split content.  It has been
tested on v3.1-rc6, soaked in linux-next, and re-tested again lots more
today after rebasing it to allow most of the linux-next finds to be
blended in, where they could not be on the original v3.1-rc6 baseline.

A special thanks to Stephen for all his efforts in assisting with this.

Paul.

---


The following changes since commit 839d8810747bbf39e0a5a7f223b67bffa7945f8d:

  Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging (2011-10-30 15:54:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git modsplit-Oct31_2011

Axel Lin (1):
      unicore32: EXPORT_SYMBOL needs export.h

Heiko Carstens (1):
      s390: add missing module.h/export.h includes

Mark Brown (1):
      cpufreq: Fix build of s3c64xx cpufreq driver for header change

Paul Gortmaker (224):
      module.h: split out the EXPORT_SYMBOL into export.h
      module.h: relocate MODULE_PARM_DESC into moduleparam.h
      range: fix bogus misuse of module.h to get printk()
      mm: delete various needless include <linux/module.h>
      mm: Add export.h for EXPORT_SYMBOL to active symbol exporters
      mm: Map most files to use export.h instead of module.h
      mm: fix implicit stat.h usage in dmapool.c
      kernel: Map most files to use export.h instead of module.h
      kernel: Add <linux/module.h> to files using it implicitly
      kernel: fix several implicit usasges of kmod.h
      kernel: fix two implicit header assumptions in irq_work.c
      kernel: ksysfs.c is implicitly using stat.h
      kernel: params.c needs module.h not moduleparam.h
      kernel: fix up module header handling in rcutiny files
      kernel: Fix files explicitly needing EXPORT_SYMBOL infrastructure
      net: Fix files explicitly needing to include module.h
      net: add moduleparam.h for users of module_param/MODULE_PARM_DESC
      net: Add export.h for EXPORT_SYMBOL/THIS_MODULE to non-modules
      net: fix implicit kmod.h usage in bridge/br_stp_if.c
      fs: add export.h to files using EXPORT_SYMBOL/THIS_MODULE macros
      fs: add module.h to files that were implicitly using it
      acpi: add module.h to files implicitly using/relying on it.
      acpi: delete module.h include from files explicitly not needing it
      acpi: downgrade files from module.h to export.h where possible.
      acpi: add export.h to files using THIS_MODULE/EXPORT_SYMBOL
      x86: fix implicit include of <linux/topology.h> in vsyscall_64
      x86: Fix files explicitly requiring export.h for EXPORT_SYMBOL/THIS_MODULE
      x86: fix up files really needing to include module.h
      x86: efi_32.c is implicitly getting asm/desc.h via module.h
      powerpc: io-workarounds.c was implicitly getting init_mm
      powerpc: add export.h to files making use of EXPORT_SYMBOL
      powerpc: include export.h for files using EXPORT_SYMBOL/THIS_MODULE
      powerpc: Fix up modules that should be including module.h
      powerpc: Fix up implicit stat.h users
      powerpc: Fix up implicit sched.h users
      powerpc: cell/beat_wrapper.h is implicitly using memcpy functions
      powerpc: fix implicit notifier use in converting to export.h
      powerpc: fix implicit use of cache.h in kernel/firmware.c
      powerpc: fix implicit use of mutex.h by include/asm/spu.h
      powerpc: fix two implicit header uses in pseries/plpar_wrappers.h
      powerpc: convert hvconsole.c to export.h ; fix implicit use of errno.h
      powerpc: various straight conversions from module.h --> export.h
      powerpc: remove non-required uses of include <linux/module.h>
      arm: add elf.h to arch/arm/kernel/ptrace.c
      arm: fix implicit memset/string.h usage in various arch/arm files
      arm: fix implicit use of page.h in several arch/arm files
      arm: fix implicit use of moduleparam in mach-mx31*.c
      arm: fix implicit use of sched.h in bcmring/dma.c
      arm: add slab.h to plat-samsung files for GFP_KERNEL
      arm: remove several unnecessary module.h include instances
      arm: convert core files from module.h to export.h
      arm: Add export.h to ARM specific files as required.
      arm: fix implicit module.h users by adding it to arch/arm as required.
      arm: Add moduleparam.h to arch/arm files as required
      sparc: fix implicit use of spitfire.h in pcr.c and of_device_64.c
      sparc: fix implicit use of uaccess.h header in mdesc.c
      sparc: add export.h to arch/sparc files as required
      sparc: move symbol exporters to use export.h not module.h
      sparc: remove several unnecessary module.h include instances
      sparc: Add module.h to files previously implicitly using it.
      mips: fix implicit use of asm/elf.h in kernel/cpu-probe.c
      mips: fix implicit smp.h usage in various files.
      mips: migrate core kernel file from module.h --> export.h
      mips: remove needless include of module.h from core kernel files.
      mips: add export.h to files using EXPORT_SYMBOL/THIS_MODULE
      ia64: Add export.h to arch/ia64 specific files as required
      m68k: Add export.h to the m68k specific files as required
      avr32: add export.h to arch/avr32 for EXPORT_SYMBOL/THIS_MODULE
      parisc: Add export.h to files needing EXPORT_SYMBOL/THIS_MODULE
      parisc: add module.h to files really requiring it
      blackfin: Add export.h to files using EXPORT_SYMBOL/THIS_MODULE
      blackfin: add module.h to files implicitly expecting to use it.
      alpha: fix implicit stat.h usage in pci-sysfs.c
      alpha: Add export.h for THIS_MODULE/EXPORT_SYMBOL
      sh: fix implicit use of stat.h in arch/sh specific files
      sh: Add module.h to arch/sh specific files as required.
      sh: Add export.h to arch/sh specific files as required.
      microblaze: Add export.h to arch/microblaze files as required
      drivers/net: Add module.h to drivers who were implicitly using it
      drivers/net: Add export.h to files using EXPORT_SYMBOL/THIS_MODULE
      drivers/net: change moduleparam.h to module.h as required.
      drivers/net: Add moduleparam.h to drivers as required.
      drivers/net: wireless/ath/ath5k/debug.c does not need module.h
      drivers/net: fix mislocated headers in cxgb4/l2t.c
      crypto: add module.h to those files that are explicitly using it
      mtd: Add export.h for EXPORT_SYMBOL/THIS_MODULE where needed
      mtd: Add module.h to drivers users that were implicitly using it.
      block: add export.h to files using EXPORT_SYMBOL/THIS_MODULE macros
      block: Fix files that are modules and hence need module.h
      block: Change module.h -> export.h in bsg-lib.c
      of: of_pci.c needs export.h since it uses EXPORT_SYMBOLS
      drivers/base: transport_class explicitly requires EXPORT_SYMBOL
      drivers: power_supply_sysfs.c needs stat.h
      drivers/input: Add module.h to modular drivers implicitly using it
      drivers/input: add export.h to symbol exporting files.
      hid: Add module.h to fix up implicit users of it
      hid: Fix up files needing export.h for EXPORT_SYMBOL
      md: Add module.h to all files using it implicitly
      md: Add in export.h for files using EXPORT_SYMBOL
      sound: fix drivers needing module.h not moduleparam.h
      sound: add moduleparam.h to users of module_param/MODULE_PARM_DESC
      sound: Add module.h to the previously silent sound users
      sound: Add export.h for THIS_MODULE/EXPORT_SYMBOL where needed
      pci: Fix files needing export.h for EXPORT_SYMBOL/THIS_MODULE
      pci: add module.h to files implicitly relying on its presence.
      scsi: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      scsi: Fix up files implicitly depending on module.h inclusion
      usb: Add module.h to drivers/usb consumers who really use it.
      usb: Add export.h for EXPORT_SYMBOL/THIS_MODULE where needed
      usb: fix implicit usage of gfp.h in host/xhci-hub.c
      bluetooth: add module.h to drivers/bluetooth files as required.
      tty: Add module.h to drivers/tty users who just expect it there.
      tty: Add export.h for EXPORT_SYMBOL/THIS_MODULE to exporters
      rtc: Add module.h to implicit users in drivers/rtc
      i2c: add export.h to i2c-boardinfo.c for EXPORT_SYMBOL
      i2c: Add module.h to modular files prev. implicitly getting it
      cpuidle: Add module.h to drivers/cpuidle files as required.
      cpuidle: ladder.c needs module.h and not just moduleparam.h
      cpufreq: cpufreq_stats.c is a module, and should include module.h
      selinux: Add export.h to files using EXPORT_SYMBOL/THIS_MODULE
      video: Add export.h for THIS_MODULE/EXPORT_SYMBOL to drivers/video
      video: Add module.h to drivers/video files who really use it.
      infiniband: Fix up users implicitly relying on getting stat.h
      infiniband: Fix up module files that need to include module.h
      infiniband: add in export.h for files using EXPORT_SYMBOL/THIS_MODULE
      infiniband: add moduleparam.h to drivers/infiniband as required
      ide/ata: Add export.h for EXPORT_SYMBOL/THIS_MODULE where needed
      ide/ata: Add module.h to the implicit modular users
      drivers/base: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required.
      drivers/base: dma-coherent.c is a module and needs module.h
      drivers/base: base.h implicitly depends on <linux/notifier.h>
      drivers/base: change module.h -> export.h in power/common.c
      drivers/char: Add module.h to those who were using it implicitly
      drivers/char: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      drivers/char: Fix implicit use of err.h in ramoops.c
      drivers/clocksource: Add module.h to those who were using it implicitly
      drivers/dca: Add module.h to dca-core.c
      drivers/dca: Add export.h for THIS_MODULE to dca-sysfs.c
      drivers/dma: Add module.h to files implicitly using it.
      drivers/dma: Add export.h to ste_dma40.c
      drivers/edac: Add module.h to mce_amd_inj.c
      drivers/firewire: Add export.h for EXPORT_SYMBOL to core-iso.c
      drivers/firmware: Add module.h to google/gsmi.c
      drivers/gpio: Fix drivers who are implicit users of module.h
      drivers/hwmon: add module.h to ultra45_env.c
      drivers/isdn: Add module.h to ISDN files implicitly using it.
      drivers/isdn: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required.
      drivers/leds: Add module.h to files using it implicitly
      drivers/leds: Add export.h for THIS_MODULE to leds-cobalt-raq.c
      drivers/media: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      drivers/media: Add module.h to all files using it implicitly
      drivers/memstick: Add module.h to the prev. implicit modular users
      drivers/message: Add module.h to i2o/pci.c
      drivers/misc: Add module.h to files who are really modular.
      drivers/misc: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required.
      drivers/nfc: add module.h to nfcwilink.c
      drivers/of: Add module.h to of_spi.c
      drivers/of: include export.h for EXPORT_SYMBOL_GPL/THIS_MODULE as required
      drivers/power: Add module.h to the actual modules in drivers/power
      drivers/rapidio: idt_gen2.c is implicitly relying on getting stat.h
      drivers/sh: Add export.h for EXPORT_SYMBOL to intc/virq.c
      drivers/target: Add export.h to files as required.
      drivers/target: Add module.h to drivers/target files as required.
      drivers/w1: Add export.h for EXPORT_SYMBOL/THIS_MODULE
      drivers/w1: Add moduleparam.h to drivers/w1/w1_int.c
      drivers/zorro: Add export.h to proc.c
      bcma: add module.h to the modular portions of this driver
      bcma: fix implicit use of export.h contents
      gpu: Add export.h as required to drivers/gpu files.
      gpu: add module.h to drivers/gpu files as required.
      gpu: add moduleparam.h to drivers/gpu/drm/drm_crtc_helper.c
      mfd: Add module.h to the implicit drivers/mfd users
      mfd: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      mmc: Add module.h to drivers/mmc users assuming implicit presence.
      mmc: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      mmc: Fix implicit use of stat.h header in associated files
      ssb: Add module.h to the real modules in drivers/ssb
      ssb: Add export.h to files using EXPORT_SYMBOL/THIS_MODULE
      staging: Add export.h for THIS_MODULE/EXPORT_SYMBOL to drivers/staging users.
      staging: Add moduleparam.h to drivers/staging files as required
      staging: Add module.h to more drivers implicitly using it.
      uio: Add module.h to implicit drivers/uio users
      xen: Add module.h to modular drivers/xen users.
      xen: Add export.h for THIS_MODULE/EXPORT_SYMBOL to various xen users.
      kvm: fix implicit use of stat.h header file
      kvm: iommu.c file requires the full module.h present.
      lguest: add export.h to lguest files for THIS_MODULE/EXPORT_SYMBOL
      virtio: Add module.h to drivers/virtio users.
      intel-iommu: now needs export.h for EXPORT_SYMBOL_GPL
      regulator: Add export.h for THIS_MODULE to dummy.c
      regulator: Add module.h to drivers/regulator users as required
      regulator: Fix implicit use of notifier.h by driver.h
      spi: Add module.h to implicit users in drivers/spi
      spi: Add export.h for THIS_MODULE/EXPORT_SYMBOL to spi.c
      drivers/uwb: fix implicit use of stat.h
      uwb: Add module.h to the real uwb modular users.
      uwb: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      pcmcia: add module.h to db1xxx_ss.c since it is modular.
      pcmcia: Add export.h to drivers/pcmcia as required.
      pnp: Add export.h for EXPORT_SYMBOL/THIS_MODULE as required
      watchdog: Add module.h to drivers/watchdog/stmp3xxx_wdt.c
      lib: dma-debug needs export.h for EXPORT_SYMBOL
      vermagic: delete unused include of <linux/module.h>
      sysdev.h: dont include <linux/module.h> for no reason
      net: inet_timewait_sock doesnt need <linux/module.h>
      net: sch_generic remove redundant use of <linux/module.h>
      device_cgroup.h: delete needless include <linux/module.h>
      miscdevice.h: delete unnecessary inclusion of module.h
      acpi: remove module.h include from platform/aclinux.h
      of_platform.h: delete needless include <linux/module.h>
      of: fix implicit use of errno.h in include/linux/of.h
      stop_machine.h: fix implicit use of smp.h for smp_processor_id
      miscdevice.h: fix up implicit use of lists and types
      linux/dmaengine.h: fix implicit use of bitmap.h and asm/page.h
      pm_runtime.h: explicitly requires notifier.h
      uwb.h: fix implicit use of asm/page.h for PAGE_SIZE
      crypto.h: remove unused crypto_tfm_alg_modname() inline
      include: convert various register fcns to macros to avoid include chaining
      include: replace linux/module.h with "struct module" wherever possible
      nf_conntrack.h: fix up fallout from implicit moduleparam.h presence
      ip_vs.h: fix implicit use of module_get/module_put from module.h
      bluetooth: macroize two small inlines to avoid module.h
      irq: don't put module.h into irq.h for tracking irqgen modules.
      Revert "tracing: Include module.h in define_trace.h"

Randy Dunlap (1):
      drivers/sfi: sfi_acpi.c needs sysfs.h

Stephen Rothwell (2):
      drivers/media: ir-raw.c needs kmod.h for request_module
      pinctrl: EXPORT_SYMBOL needs export.h

 include/acpi/platform/aclinux.h                    |    1 -
 include/drm/drmP.h                                 |    3 +-
 include/linux/bcma/bcma.h                          |    7 +-
 include/linux/blkdev.h                             |    2 +-
 include/linux/cpuidle.h                            |    3 +-
 include/linux/crypto.h                             |    6 --
 include/linux/device.h                             |   15 ++-
 include/linux/device_cgroup.h                      |    1 -
 include/linux/dmaengine.h                          |    2 +
 include/linux/export.h                             |   89 ++++++++++++++++++++
 include/linux/firmware.h                           |    2 +-
 include/linux/ftrace.h                             |    2 +-
 include/linux/gameport.h                           |   17 ++--
 include/linux/hid.h                                |    9 +-
 include/linux/i2c.h                                |   10 +-
 include/linux/ipmi.h                               |    3 +-
 include/linux/ipmi_smi.h                           |    1 -
 include/linux/irq.h                                |   32 +++-----
 include/linux/irqdesc.h                            |    1 +
 include/linux/mdio-bitbang.h                       |    3 +-
 include/linux/miscdevice.h                         |    3 +-
 include/linux/module.h                             |   73 +----------------
 include/linux/moduleparam.h                        |    5 +
 include/linux/mtd/mtd.h                            |    3 +-
 include/linux/of.h                                 |    1 +
 include/linux/of_platform.h                        |    1 -
 include/linux/pci_hotplug.h                        |   10 +--
 include/linux/pm_runtime.h                         |    1 +
 include/linux/regmap.h                             |    2 +-
 include/linux/regulator/driver.h                   |    1 +
 include/linux/serio.h                              |   20 +++--
 include/linux/ssb/ssb.h                            |    7 +-
 include/linux/stop_machine.h                       |    1 +
 include/linux/sunrpc/svc_xprt.h                    |    3 +-
 include/linux/sysdev.h                             |    1 -
 include/linux/textsearch.h                         |    3 +-
 include/linux/uio_driver.h                         |   12 ++--
 include/linux/usb.h                                |    9 +-
 include/linux/uwb.h                                |    1 +
 include/linux/uwb/umc.h                            |    7 +-
 include/linux/vermagic.h                           |    1 -
 include/linux/vlynq.h                              |    3 +-
 include/media/saa7146.h                            |    3 +-
 include/media/v4l2-int-device.h                    |    3 +-
 include/net/bluetooth/hci_core.h                   |   24 +++---
 include/net/inet_timewait_sock.h                   |    1 -
 include/net/ip_vs.h                                |   15 ++--
 include/net/lib80211.h                             |    3 +-
 include/net/netfilter/nf_conntrack.h               |    2 +
 include/net/sch_generic.h                          |    1 -
 include/net/sock.h                                 |    2 +-
 include/sound/core.h                               |    2 +-
 include/trace/define_trace.h                       |   10 --
 include/trace/events/module.h                      |    2 +-
 include/xen/xenbus.h                               |    1 +

 [ ...snip lots of one line change per file diffstat info ... ]

 2059 files changed, 2251 insertions(+), 606 deletions(-)
 create mode 100644 include/linux/export.h
