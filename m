Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812Ab1LQCxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 21:53:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36385 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1LQCxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 21:53:39 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Dec 2011 18:53:17 -0800
X-Google-Sender-Auth: pCS2dxWSwIqpZpSmO9f9IDnyF-E
Message-ID: <CA+55aFzd6K2szJD5MLmy3Stcai9oAR=tRXZdQtKgVWBzDr5bdg@mail.gmail.com>
Subject: Linux 3.2-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, people have clearly figured out and are gaming my release timing,
because over half the commits in -rc6 were merged today.

And that's purely because I got more merge requests today than I got
the rest of the week..

Now, I'll be somewhat generous and just say "ok, people left it to
Friday before the holidays to push me stuff", and maybe it's not
gaming the -rc cycle, but in general I *hate* it when it seems like
people leave their requests to the last moment. So if you did it
consciously, please just stop. It would be much nicer to just spread
things out, and have developers that track current -git give reactions
to things as they come in, rather than having things clump just before
the -rc release.

That said, this is still a smaller -rc release than previous ones, and
things do seem to be calming down. We're at -rc6 now, and while I can
see myself doing an -rc7, I probably won't do an -rc8 unles something
bad pops up. There doesn't seem to be any real reason to drag out this
release any more, and we'll probably have the real 3.2 around new
years.

Shortlog appended, the only thing that stands out is that we have
relatively more fs updates than usual - both btrfs and cifs had some
sizable (for -rc6) updates here, and there's a few smaller ext4
commits too. That said, it's still dominated by drivers (block - swim3
driver - and i915 - more eDP updates), just less than usual. And some
arm and x86 stuff. The rest is really tiny.

Nothing really stands out,

                 Linus

---
Adam Jackson (2):
      drm/i915: no-lvds quirk for ASUS AT5NM10T-I
      drm/i915/dp: Dither down to 6bpc if it makes the mode fit

Al Viro (5):
      procfs: fix a vfsmount longterm reference leak
      ... and the same kind of leak for mqueue
      ubifs: too early register_filesystem()
      fuse: register_filesystem() called too early
      configfs: register_filesystem() called too early

Alex Deucher (1):
      drm/radeon/kms: add some new pci ids

Alex Hermann (1):
      usb: option: Add Huawei E398 controlling interfaces

Amit Daniel Kachhap (1):
      ARM: EXYNOS: Fix for stall in case of cpu hotplug or sleep

Andrea Arcangeli (1):
      ext4: avoid hangs in ext4_da_should_update_i_disksize()

Andrei Emeltchenko (1):
      Bluetooth: Correct version check in hci_setup

Andy Fleming (1):
      fsl_pq_mdio: Clean up tbi address configuration

Antonio Quartulli (2):
      batman-adv: in case of roaming mark the client with TT_CLIENT_ROAM
      batman-adv: delete global entry in case of roaming

Arnaud Patard (1):
      ARM: 7204/1: arch/arm/kernel/setup.c: initialize arm_dma_zone_size earlier

Arne Jansen (1):
      btrfs: keep orphans for subvolume deletion

Ashish Jangam (1):
      gpio: Fix DA9052 GPIO build errors.

Axel Lin (9):
      bbc_i2c: Remove unneeded err variable
      sbus: convert drivers/sbus/char/* to use module_platform_driver()
      ASoC: Include linux/io.h for jz4740 codec
      ASoC: Fix build dependency for SND_SOC_JZ4740_CODEC
      ASoC: Fix a typo in jive_wm8750
      ASoC: Include linux/module.h for smdk2443_wm9710
      ASoC: Fix hx4700 error handling to free gpios if
snd_soc_register_card fails
      hwmon: (jz4740) fix signedness bug
      hwmon: (jz4740) Staticise jz4740_hwmon_driver

Benjamin Herrenschmidt (1):
      block/swim3: Locking fixes

Bing Zhao (1):
      Bluetooth: btmrvl: support Marvell Bluetooth device SD8797

Bjørn Mork (1):
      USB: option: Removing one bogus and adding some new Huawei combinations

Casey Schaufler (1):
      BTRFS: Establish i_ops before calling d_instantiate

Chris Ball (1):
      mmc: Add module.h include to sdhci-cns3xxx.c

Chris Mason (4):
      Btrfs: fix btrfs_end_bio to deal with write errors to a single mirror
      Btrfs: add a cond_resched() into the worker loop
      Btrfs: deal with NULL srv_rsv in the delalloc inode reservation code
      Btrfs: unplug every once and a while

Chris Wilson (1):
      drm/i915/sdvo: Include LVDS panels for the IS_DIGITAL check

Cong Wang (1):
      btusb: fix a memory leak in btusb_send_frame()

Dave Young (1):
      loop: fix loop block driver discard and encryption comment

David Henningsson (2):
      ALSA: HDA: Set position fix to LPIB for an Atom/Poulsbo based device
      ALSA: HDA: Use LPIB Position fix for Intel SCH Poulsbo

David Herrmann (2):
      Bluetooth: cmtp: Fix module reference
      Bluetooth: bnep: Fix module reference

David S. Miller (2):
      ipv6: Check dest prefix length on original route not copied one
in rt6_alloc_cow().
      sparc32: Be less strict in matching %lo part of relocation.

Djalal Harouni (2):
      ppp: fix pptp double release_sock in pptp_bind()
      fs/ncpfs: fix error paths and goto statements in ncp_fill_super()

Dong Aisheng (1):
      ARM: mx5: add __initconst for fec pdata

Eric Dumazet (1):
      sch_gred: should not use GFP_KERNEL while holding a spinlock

Eugeni Dodonov (3):
      drm/i915: prevent division by zero when asking for chipset power
      iommu: Export intel_iommu_enabled to signal when iommu is in use
      drm/i915: enable semaphores on per-device defaults

Felipe Contreras (1):
      ARM: OMAP: rx51: fix USB

Felix Fietkau (1):
      ath9k: fix check for antenna diversity support

Feng Tang (2):
      gpio-ml-ioh: fix a bug in the interrupt handler
      gpio-ml-ioh: Add the irq_disable/irq_enable hooks for ml-ioh irq chip

Girish K S (2):
      mmc: core: Fix setting power notify state variable for non-eMMC
      mmc: core: Fix power_off_notify during suspend

Guennadi Liakhovetski (2):
      mmc: sh_mmcif: fix clock gating on platforms with a .down_pwr() method
      mmc: tmio: fix clock gating on platforms with a .set_pwr() method

Gustavo Maciel Dias Vieira (1):
      ALSA: hda: fix mute led polarity for HP laptops with buggy BIOS

Hauke Mehrtens (1):
      ssb: fix init regression with SoCs

Ian Campbell (1):
      xen: only limit memory map to maximum reservation for domain 0.

Jan Kara (1):
      fs: Make write(2) interruptible by a fatal signal

Jarkko Nikula (1):
      ARM: OMAP: mcbsp: Fix possible memory corruption

Jason Chen (1):
      MXC PWM: should active during DOZE/WAIT/DBG mode

Jesse Barnes (1):
      drm/i915: don't set unpin_work if vblank_get fails

Jingoo Han (2):
      ARM: SAMSUNG: remove duplicated header include
      ARM: S5PV210: Set 1000ns as PWM backlight period on SMDKV210

Johannes Berg (1):
      mac80211: fix another race in aggregation start

Jonathan Neuschäfer (1):
      ASoC: WM8958: correctly show firmware magic on mismatch

Josef Bacik (6):
      Btrfs: fix num_workers_starting bug and other bugs in async thread
      Btrfs: deal with enospc from dirtying inodes properly
      Btrfs: fix how we do delalloc reservations and how we free
reservations on error
      Btrfs: fix leaked space in truncate
      Btrfs: don't panic if orphan item already exists
      Btrfs: only set cache_generation if we setup the block group

Josh Durgin (2):
      rbd: return an error when an invalid header is read
      rbd: remove buggy rollback functionality

Keith Packard (5):
      drm/i915: add multi-threaded forcewake support
      drm/i915: Hook up Ivybridge eDP
      drm/i915: Treat pre-gen4 backlight duty cycle value consistently
      Revert "x86, efi: Calling __pa() with an ioremap()ed address is invalid"
      drm/i915: By default, enable RC6 on IVB and SNB when reasonable

Konrad Rzeszutek Wilk (1):
      xen/swiotlb: Use page alignment for early buffer allocation.

Krzysztof Hałasa (1):
      USB: cdc-acm: add IDs for Motorola H24 HSPA USB module.

Kukjin Kim (1):
      ARM: EXYNOS: Fix build error without CONFIG_LOCAL_TIMERS

Kuninori Morimoto (2):
      usb: renesas_usbhs: typofix: irq_dtch control DTCHE
      usb: renesas_usbhs: add hcd->has_tt for low/full speed

Kyungmin Park (1):
      mmc: core: Fix typo at mmc_card_sleep

Larry Finger (1):
      staging: r8712u: Add new USB ID

Li Wei (1):
      ipv6: Fix for adding multicast route for loopback device automatically.

Li Zefan (1):
      Btrfs: fix ctime update of on-disk inode

Linus Torvalds (3):
      linux/log2.h: Fix rounddown_pow_of_two(1)
      Revert "drm/i915: fix infinite recursion on unbind due to ilk vt-d w/a"
      Linux 3.2-rc6

Lothar Waßmann (2):
      ASoC: mxs: Add missing MODULE_LICENSE("GPL")
      ASoC: mxs: Add appropriate MODULE_ALIAS()

Lukas Czerner (1):
      loop: Fix discard_alignment default setting

Marcos Paulo de Souza (1):
      writeback: Fix issue on make htmldocs

Mark Brown (2):
      ASoC: Fix WM8996 24.576MHz clock operation
      mmc: sdhci-s3c: Remove old and misprototyped suspend operations

Matt Fleming (1):
      x86, efi: Make efi_call_phys_{prelog,epilog} CONFIG_RELOCATABLE-aware

Miao Xie (3):
      Btrfs: fix wrong i_size when truncating a file to a larger size
      Btrfs: fix wrong disk space information of the files
      Btrfs: fix inaccurate available space on raid0 profile

Mike Snitzer (1):
      block: initialize request_queue's numa node during

Miklos Szeredi (2):
      fuse: fix fuse_retrieve
      fuse: llseek fix race

Nicolas Pitre (1):
      ARM: 7186/1: fix Kconfig issue with PHYS_OFFSET and !MMU

Omar Ramirez Luna (2):
      staging: tidspbridge: include module.h by default
      staging: tidspbridge: request dmtimer clocks on init

Paul Mackerras (1):
      ext4: Fix crash due to getting bogus eh_depth value on big-endian systems

Paulo Zanoni (2):
      drm/i915: set the right SDVO transcoder for CPT
      drm/i915: add PCH info to i915_capabilities

Per Forlin (1):
      mmc: omap_hsmmc: DMA unmap only once in case of MMC error

Philipp Dreimann (1):
      rtl8192{ce,cu,de,se}: avoid problems because of possible ERFOFF
-> ERFSLEEP transition

Richard Zhao (1):
      ARM: imx: fix cpufreq build errors

Rob Herring (1):
      gpio: pl061: drop extra check for NULL platform_data

Roel Kluin (1):
      fuse: fix llseek bug

Sage Weil (4):
      ceph: fix rasize reporting by ceph_show_options
      ceph: use i_ceph_lock instead of i_lock
      crush: fix mapping calculation when force argument doesn't exist
      ceph: fix SEEK_CUR, SEEK_SET regression

Sascha Hauer (1):
      mmc: mxcmmc: fix falling back to PIO

Shawn Guo (2):
      net/fec: fix the use of pdev->id
      arm/imx: fix power button on imx51 babbage board

Stefan Nilsson XK (1):
      mmc: core: Add quirk for long data read time

Stephen M. Cameron (2):
      cciss: Add IRQF_SHARED back in for the non-MSI(X) interrupt handler
      cciss: fix flush cache transfer length

Sujit Reddy Thumma (1):
      mmc: core: Fix deadlock when the CONFIG_MMC_UNSAFE_RESUME is not defined

Ted Feng (1):
      ipip, sit: copy parms.name after register_netdevice

Tejun Heo (1):
      block: don't kick empty queue in blk_drain_queue()

Theodore Ts'o (2):
      ext4: fix ext4_end_io_dio() racing against fsync()
      ext4: display the correct mount option in /proc/mounts for [no]init_itable

Thomas Meyer (1):
      sparc: Use kmemdup rather than duplicating its implementation

Uwe Kleine-König (2):
      ARM: 7187/1: fix unwinding for XIP kernels
      ARM: unwinder: fix bisection to find origin in .idx section

Will Deacon (1):
      ARM: 7185/1: perf: don't assign platform_device on unsupported CPUs

Wolfram Sang (1):
      gpio: mpc8xxx: don't allow input-only pins to be output for MPC5121

Wu Fengguang (4):
      writeback: comment on the bdi dirty threshold
      writeback: permit through good bdi even when global dirty exceeded
      writeback: set max_pause to lowest value on zero bdi_dirty
      btrfs: lower the dirty balance poll interval

Yasuaki Ishimatsu (1):
      cfq-iosched: fix cfq_cic_link() race confition

Yehuda Sadeh (1):
      ceph: add missing spin_unlock at ceph_mdsc_build_path()

Yinghai Lu (1):
      ibft: Fix finding IBFT ACPI table on UEFI

Yongqiang Yang (4):
      ext4: avoid potential hang in mpage_submit_io() when blocksize < pagesize
      ext4: correctly handle pages w/o buffers in ext4_discard_partial_buffers()
      ext4: remove a wrong BUG_ON in ext4_ext_convert_to_initialized
      ext4: handle EOF correctly in ext4_bio_write_page()

Yu Xu (1):
      usb: gadget: storage: release superspeed descriptors.

majianpeng (1):
      cfq-iosched: free cic_index if blkio_alloc_blkg_stats fails
