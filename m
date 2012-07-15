Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2GOA7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 20:59:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41204 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2GOA7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 20:59:35 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Jul 2012 17:59:13 -0700
X-Google-Sender-Auth: uu_yV9q-TAn3IWWQROp_6uxv26Y
Message-ID: <CA+55aFxLmxGaMUbEVSaG-Og=G1rf1TBrswuVwfwWUqbCPuAVrA@mail.gmail.com>
Subject: Linux 3.5-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys, remember how things have been stabilizing and slowing down,
and all the kernel developers were off on summer vacation?

Yeah, we need to talk about that. Because I last week I thought that
making an -rc7 was not necessarily realy required, except perhaps
mainly to check the late printk changes. But then today and yesterday,
I got a ton of small pull requests, and now I find myself releasing an
-rc7 that is actually bigger than rc6 was.

Not cool, guys. Not cool.

Now, admittedly, most of this is pretty small. The loadavg calculation
fix patch is pretty big, but quite a lot of that is added comments
(*big* added comments). . But there's Andrew's patch-bomb, there's
media fixes, there's random SOC fixes, powerpc fixes, USB, sound, you
name it.

Ok, so it's still not *huge*, but it's bigger than -rc6 was. I had
hoped for less.

But go forth and test. Make sure it's all good. Because I really wish
I won't have to do an -rc8.

                  Linus

---
Alan Cox (1):
      xtensa: fix incorrect memset

Alan Stern (1):
      PCI: EHCI: fix crash during suspend on ASUS computers

Alessandro Rubini (1):
      gpio-sta2x11: don't use pdata if null

Alex Williamson (1):
      KVM: Fix device assignment threaded irq handler

Anton Blanchard (3):
      [media] cx23885: Silence unknown command warnings
      [media] winbond-cir: Fix txandrx module info
      [media] winbond-cir: Initialise timeout, driver_type and allowed_protos

Axel Lin (1):
      mfd: Add terminating entry for i2c_device_id palmas table

Benjamin Herrenschmidt (5):
      powerpc: More fixes for lazy IRQ vs. idle
      powerpc: Fix build of some debug irq code
      powerpc/numa: Avoid stupid uninitialized warning from gcc
      tty/hvc_opal: Fix debug function name
      powerpc/kvm: Fix "PR" KVM implementation of H_CEDE

Benoît Thébaudeau (1):
      drivers/rtc/rtc-mxc.c: fix irq enabled interrupts warning

Bjørn Mork (2):
      USB: option: add ZTE MF60
      USB: cdc-wdm: fix lockup on error in wdm_read

Bob Liu (1):
      fs: ramfs: file-nommu: add SetPageUptodate()

Bob Moore (1):
      ACPICA: Fix possible fault in return package object repair code

Chris Metcalf (1):
      arch/tile: big-endian: properly bswap instruction bundles when backtracing

Christian Dietrich (1):
      gpio/msm_v1: CONFIG_GPIO_MSM_V1 is only available on three SoCs

Corey Minyard (1):
      SH: Convert out[bwl] macros to inline functions

Dan Carpenter (3):
      dma-debug: debugfs_create_bool() takes a u32 pointer
      iommu/amd: fix type bug in flush code
      sgi-xp: nested calls to spin_lock_irqsave()

Dan Williams (1):
      [SCSI] libsas: fix taskfile corruption in sas_ata_qc_fill_rtf

Daniel Mack (1):
      ALSA: snd-usb: move calls to usb_set_interface

Dave Jones (1):
      Remove easily user-triggerable BUG from generic_setlease

David Ahern (3):
      perf script: Fix format regression due to libtraceevent merge
      perf kvm: Fix regression with guest machine creation
      perf kvm: Fix segfault with report and mixed guestmount use

David Dillow (1):
      [media] cx231xx: don't DMA to random addresses

David Howells (1):
      MN10300: Fix a missing semicolon

David Rientjes (1):
      mm, thp: abort compaction if migration page cannot be charged to memcg

Devendra Naga (1):
      drivers/rtc/rtc-spear.c: fix use-after-free in spear_rtc_remove()

Devin Heitmueller (6):
      [media] cx25840: fix regression in HVR-1800 analog support
      [media] cx25840: fix regression in analog support hue/saturation controls
      [media] cx25840: fix regression in HVR-1800 analog audio
      [media] cx25840: fix vsrc/hsrc usage on cx23888 designs
      [media] cx23885: make analog support work for HVR_1250 (cx23885 variant)
      [media] cx23885: add support for HVR-1255 analog (cx23888 variant)

Eddie Wai (1):
      [SCSI] bnx2i: Removed the reference to the netdev->base_addr

Fengguang Wu (1):
      [media] pms: fix build error in pms_probe()

Gaosen Zhang (1):
      USB: option: Add MEDIATEK product ids

Geert Uytterhoeven (11):
      mn10300: move setup_jiffies_interrupt() to cevt-mn10300.c
      mn10300: remove duplicate definition of PTRACE_O_TRACESYSGOOD
      mn10300: kernel/internal.h needs <linux/irqreturn.h>
      mn10300: kernel/traps.c needs <linux/export.h>
      mn10300: mm/dma-alloc.c needs <linux/export.h>
      mn10300: use "#elif defined(CONFIG_*)" instead of "#elif CONFIG_*"
      h8300/pgtable: add missing #include <asm-generic/pgtable.h>
      h8300/signal: fix typo "statis"
      h8300/time: add missing #include <asm/irq_regs.h>
      h8300/uaccess: remove assignment to __gu_val in unhandled case
of get_user()
      h8300/uaccess: add mising __clear_user()

Graeme Gregory (2):
      mfd: Fix palmas regulator pdata missing
      mfd: Add missing hunk to change palmas irq to clear on read

Grazvydas Ignotas (1):
      gpio/omap: fix irq loss while in idle with debounce on

Guennadi Liakhovetski (1):
      mmc: cd-gpio: pass IRQF_ONESHOT to request_threaded_irq()

Hans de Goede (1):
      gspca_sn9c20x: Fix NULL pointer dereference

Henrik Rydberg (1):
      Input: bcm5974 - Add support for 2012 MacBook Pro Retina

Herton Ronaldo Krzesinski (1):
      mtd: nandsim: don't open code a do_div helper

Hiroshi DOYU (1):
      iommu/tegra: smmu: Fix unsleepable memory allocation

Hugh Dickins (3):
      tmpfs: revert SEEK_DATA and SEEK_HOLE
      shmem: fix negative rss in memcg memory.stat
      shmem: cleanup shmem_add_to_page_cache

Ilia Katsnelson (1):
      Input: xpad - add signature for Razer Onza Tournament Edition

Javier Martin (1):
      media: mx2_camera: Fix mbus format handling

Jean Delvare (1):
      hwmon: (it87) Preserve configuration register bits on init

Jeff Moyer (1):
      block: fix infinite loop in __getblk_slow

Jerry Snitselaar (1):
      gpio/gpio-tps65910: gpio_chip.of_node referenced without
CONFIG_OF_GPIO defined

Jiang Liu (1):
      memory hotplug: fix invalid memory access caused by stale kswapd pointer

Joerg Roedel (1):
      iommu/amd: Initialize dma_ops for hotplug and sriov devices

Johan Hovold (1):
      USB: metro-usb: fix tty_flip_buffer_push use

John Stultz (3):
      hrtimer: Provide clock_was_set_delayed()
      timekeeping: Fix leapsecond triggered load spike issue
      hrtimer: Update hrtimer base offsets each hrtimer_interrupt

Jon Hunter (1):
      gpio/omap: fix invalid context restore of gpio bank-0

Jonathan Nieder (1):
      ACPI / PM: Leave Bus Master Arbitration enabled for suspend/resume

Kamil Debski (1):
      [media] s5p-mfc: Fixed setup of custom controls in decoder and encoder

Kay Sievers (6):
      kmsg: escape the backslash character while exporting data
      kmsg: add the facility number to the syslog prefix
      kmsg: properly handle concurrent non-blocking read() from /proc/kmsg
      kmsg: make sure all messages reach a newly registered boot console
      kmsg: /proc/kmsg - support reading of partial log records
      kmsg: merge continuation records while printing

Kevin Hilman (3):
      ARM: OMAP2+: omap2plus_defconfig: EHCI driver is not stable, disable it
      MAINTAINERS: add OMAP CPUfreq driver to OMAP Power Management section
      drivers/rtc/rtc-twl.c: fix threaded IRQ to use IRQF_ONESHOT

Konstantin Khlebnikov (1):
      c/r: prctl: less paranoid prctl_set_mm_exe_file()

Laurent Pinchart (2):
      [media] omap3isp: preview: Fix output size computation depending
on input format
      [media] omap3isp: preview: Fix contrast and brightness handling

Laxman Dewangan (2):
      gpio: fix bits conflict for gpio flags
      gpio: tps65910: initialize of_node of gpio_chip

Lee Jones (5):
      of: address: Don't fail a lookup just because a node has no reg property
      ARM: ux500: Fix build errors/warnings when MACH_UX500_DT is not set
      ARM: ux500: Over-ride the DT device naming scheme for pinctrl
      drivers/rtc/rtc-ab8500.c: use IRQF_ONESHOT when requesting a threaded IRQ
      drivers/rtc/rtc-ab8500.c: ensure correct probing of the AB8500
RTC when Device Tree is enabled

Linus Torvalds (2):
      Revert "of: match by compatible property first"
      Linux 3.5-rc7

Luis Henriques (1):
      ocfs2: fix NULL pointer dereference in __ocfs2_change_file_space()

Magnus Damm (1):
      ARM: shmobile: fix platsmp.c build when ARCH_SH73A0=n

Marek Szyprowski (2):
      ARM: EXYNOS: read initial state of power domain from hw registers
      ARM: EXYNOS: register devices in 'need_restore' state for pm_domains

Mark Brown (1):
      gpiolib: wm8994: Pay attention to the value set when enabling as output

Mark Rustad (1):
      [SCSI] Fix NULL dereferences in scsi_cmd_to_driver

Mauro Carvalho Chehab (2):
      [media] smiapp-core: fix compilation build error
      [media] em28xx: fix em28xx-rc load

Michael S. Tsirkin (1):
      virtio-balloon: fix add/get API use

Mike Dunn (1):
      mtd: ABI documentation: clarification of bitflip_threshold

Namhyung Kim (1):
      MAINTAINERS/sched: Update scheduler file pattern

NeilBrown (1):
      md/raid1: fix use-after-free bug in RAID1 data-check code.

Ohad Ben-Cohen (4):
      remoteproc/omap: fix randconfig unmet direct dependencies
      remoteproc: fix missing CONFIG_FW_LOADER configurations
      rpmsg: avoid premature deallocation of endpoints
      rpmsg: make sure inflight messages don't invoke just-removed callbacks

Paul Bolle (1):
      mfd: Delete ab5500-core.h

Paul E. McKenney (1):
      Revert "rcu: Move PREEMPT_RCU preemption to switch_to() invocation"

Paul Mundt (1):
      sh: Fix up se7721 GPIOLIB=y build warnings.

Paul Walmsley (1):
      ARM: OMAP2+: hwmod code/clockdomain data: fix 32K sync timer

Peter Ujfalusi (1):
      mfd: Update twl6040 Kconfig to avoid build breakage

Peter Zijlstra (1):
      sched/nohz: Rewrite and fix load-avg computation -- again

Philippe Rétornaz (2):
      mfd: Fix mc13xxx SPI regmap
      mfd: mc13xxx workaround SPI hardware bug on i.Mx

Randy Dunlap (1):
      [media] media: pms.c needs linux/slab.h

Roland Stigge (1):
      mips: pci-lantiq: Fix check for valid gpio

Russ Dill (1):
      mfd: USB: Fix the omap-usb EHCI ULPI PHY reset fix issues.

Ryan Bourgeois (1):
      HID: add support for 2012 MacBook Pro Retina

Sachin Kamat (2):
      [media] s5p-fimc: Fix compiler warning in fimc-lite.c
      [media] s5p-fimc: Stop media entity pipeline if
fimc_pipeline_validate fails

Sakari Ailus (1):
      [media] s5p-fimc: media_entity_pipeline_start() may fail

Salman Qazi (1):
      sched: Fix fork() error path to not crash

Santosh Nayak (1):
      [media] dvb-core: Release semaphore on error path dvb_register_device()

Sarah Sharp (1):
      xhci: Fix hang on back-to-back Set TR Deq Ptr commands.

Sascha Hauer (2):
      mtd: mxc_nand: use 32bit copy functions
      mtd: gpmi-nand: fix read page when reading to vmalloced area

Shinya Kuribayashi (1):
      hwspinlock/core: use global ID to register hwspinlocks on multiple devices

Shuah Khan (1):
      iommu/amd: Fix missing iommu_shutdown initialization in passthrough mode

Silva Paulo (1):
      blk: fix wrong idr_pre_get() error check in loop.c

Stanislaw Ledwon (1):
      usb: Add support for root hub port status CAS

Stephen Boyd (1):
      regulator: Fix recursive mutex lockdep warning

Stephen Warren (1):
      gpio: export devm_gpio_request_one

Steven J. Magnani (1):
      fat: fix non-atomic NFS i_pos read

Sylwester Nawrocki (12):
      [media] s5p-fimc: Fix bug in capture node open()
      [media] s5p-fimc: Don't create multiple active links to same sink entity
      [media] s5p-fimc: Honour sizeimage in VIDIOC_S_FMT
      [media] s5p-fimc: Remove superfluous checks for buffer type
      [media] s5p-fimc: Prevent lock-up in multiple sensor systems
      [media] s5p-fimc: Fix fimc-lite system wide suspend procedure
      [media] s5p-fimc: Shorten pixel formats description
      [media] s5p-fimc: Update to the control handler lock changes
      [media] s5p-fimc: Add missing FIMC-LITE file operations locking
      [media] Revert "[media] V4L: JPEG class documentation corrections"
      ARM: S3C24XX: Correct AC97 clock control bit for S3C2440
      ARM: S3C24XX: Correct CAMIF interrupt definitions

Takashi Iwai (1):
      ALSA: usb-audio: Fix the first PCM interface assignment

Tejun Heo (2):
      Revert "cgroup: superblock can't be released with active dentries"
      cgroup: fix cgroup hierarchy umount race

Thomas Gleixner (3):
      timekeeping: Maintain ktime_t based offsets for hrtimers
      hrtimers: Move lock held region in hrtimer_interrupt()
      timekeeping: Provide hrtimer update function

Thomas Renninger (1):
      cpufreq / ACPI: Fix not loading acpi-cpufreq driver regression

Todd Poynor (1):
      ARM: SAMSUNG: fix race in s3c_adc_start for ADC

Tomas Winkler (1):
      mei: pci_resume: set IRQF_ONESHOT for msi request_threaded_irq

Tomi Valkeinen (2):
      OMAPDSS: Use PM notifiers for system suspend
      OMAPDSS: fix warnings if CONFIG_PM_RUNTIME=n

Trond Myklebust (2):
      NFS: Fix list manipulation snafus in fs/nfs/direct.c
      NFSv4: Fix an NFSv4 mount regression

Tushar Behera (1):
      ARM: SAMSUNG: Update default rate for xusbxti clock

Uwe Kleine-König (1):
      gpio/mxc: make irqs work for fsl,imx21-gpio devices

Vaibhav Nagarnaik (2):
      ring-buffer: Fix crash due to uninitialized new_pages list head
      ring-buffer: Fix accounting of entries when removing pages

Venkatraman S (1):
      mmc: core: Revert "skip card initialization if power class
selection fails"

Wen Congyang (1):
      mm/memory_hotplug.c: release memory resources if hotadd_new_pgdat() fails

Will Drewry (2):
      x86/vsyscall: allow seccomp filter in vsyscall=emulate
      vsyscall_64: add missing ifdef CONFIG_SECCOMP

Yinghai Lu (3):
      mm: sparse: fix section usemap placement calculation
      mm: sparse: fix usemap allocation above node descriptor section
      memblock: free allocated memblock_reserved_regions later

Yuri Khan (2):
      Input: xpad - handle all variations of Mad Catz Beat Pad
      Input: xpad - add Andamiro Pump It Up pad

liu chuansheng (1):
      printk: replacing the raw_spin_lock/unlock with raw_spin_lock/unlock_irq
