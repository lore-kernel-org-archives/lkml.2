Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2FXUMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 16:12:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58304 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2FXUL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 16:11:57 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Jun 2012 13:11:34 -0700
X-Google-Sender-Auth: W5bFmes-nX_8mga8bGHuRLhUxWs
Message-ID: <CA+55aFxeWM0Zu3eYzMesgU4PaNsDqjxVTpe_r3ZnyLMuXeDCcw@mail.gmail.com>
Subject: Linux 3.5-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

Lots of tiny fixes here. I think the biggest (in lines) change is the
fixup of the kmsg_dump() functionality that got broken due to the new
record-oriented kernel message stuff. And even that really isn't all
that big. The other one that stands out in pure number of lines is the
XFS 'struct log' rename patch (which also did a couple of trivial
whitespace changes).

So while we still have 200+ commits in this -rc, they really are all
pretty tiny and insignificant. Sure, if the particular issue they
fixed hit you (or you are the developer of those life-changing lines
;), you may disagree with the "insignificant" part, but to me, this is
just how I like the -rc's at this point.

The statistics for the -rc are somewhat odd: almost exactly one third
each of arch, drivers, and "rest". Usually drivers dominate more than
that, but I guess this time we had not just arm platform patches, but
also enough random fs and documentation updates to generate that kind
of fairly unusual distribution.

Anyway, let's hope the trend with trivial stuff continues, and we'll
be looking good for a 3.5 release.

                               Linus

---
Alain Renaud (1):
      xfs: xfs_vm_writepage clear iomap_valid when !buffer_uptodate (REV2)

Alex Deucher (4):
      drm/radeon: fix regression in dynpm due to multi-ring rework
      drm/radeon: add some additional 6xx/7xx/EG register init
      drm/radeon: add support for STRMOUT_BASE_UPDATE on 7xx
      drm/radeon: SI tiling fixes for display

Alex Elder (1):
      libceph: osd_client: don't drop reply reference too early

Alexander Block (2):
      Btrfs: introduce btrfs_next_old_item
      Btrfs: don't assume to be on the correct extent in add_all_parents

Anatol Pomozov (1):
      Fix typo in printed messages

Andrea Arcangeli (1):
      thp: avoid atomic64_read in pmd_read_atomic for 32bit PAE

Andrew Lunn (5):
      printk: Fix alignment of buf causing crash on ARM EABI
      ARM: Kirkwood: Fix clk problems modular ethernet driver
      ARM: iconnect: Remove include of removed linux/spi/orion_spi.h
      ARM: Orion5x - Restore parts of io.h, with rework
      ARM: Orion: Fix Virtual/Physical mixup with watchdog

Andy Gross (1):
      staging: omapdrm: fix crash when freeing bad fb

Anton Blanchard (1):
      fault-inject: avoid call to random32() if fault injection is disabled

Anton Vorontsov (5):
      pstore/ram: Should update old dmesg buffer before reading
      pstore/ram_core: Do not reset restored zone's position and size
      pstore/ram_core: Factor persistent_ram_zap() out of post_init()
      pstore/ram: Should zap persistent zone on unlink
      pstore/inode: Make pstore_fill_super() static

Arnaldo Carvalho de Melo (1):
      perf tools: Fix synthesizing tracepoint names from the perf.data headers

Arnd Bergmann (1):
      arm: versatile: fix and enable PCI I/O space

Axel Lin (3):
      extcon: Fix wrong index in max8997_extcon_cable[]
      extcon: Set platform drvdata in gpio_extcon_probe() and fix irq leak
      extcon: max8997: Add missing kfree for info->edev in max8997_muic_remove()

Bart Westgeest (1):
      staging: usbip: bugfix for stack corruption on 64-bit architectures

Ben Chan (1):
      staging: gdm72xx: Release netlink socket properly

Ben Myers (1):
      xfs: shutdown xfs_sync_worker before the log

Brian Foster (1):
      xfs: check for stale inode before acquiring iflock on push

Bryan Schumaker (1):
      NFS: Force the legacy idmapper to be single threaded

Chen Gong (2):
      edac: avoid mce decoding crash after edac driver unloaded
      edac: fix the error about memory type detection on SandyBridge

Chris Ball (1):
      mmc: sdhci: Use DBG() instead of pr_warning() on large timeout

Chris Metcalf (1):
      edac: Do alignment logic properly in edac_align_ptr()

Cyrill Gorcunov (1):
      c/r: prctl: Move PR_GET_TID_ADDRESS to a proper place

Dan Carpenter (1):
      RDMA/ocrdma: Fix off by one in ocrdma_query_gid()

Daniel Mack (3):
      ALSA: snd-usb: fix sync pipe check
      ALSA: snd-usb: make snd_usb_substream_capture_trigger static
      ALSA: 6fire: use NULL instead of 0 for pointer assignment

Daniel Vetter (3):
      drm/i915: eDP aux needs vdd
      Revert "drm/i915/dp: Use auxch precharge value of 5 everywhere"
      drm/edid: don't return stack garbage from supports_rb

Dave Airlie (3):
      drm/udl: only bind to the video devices on the hub.
      drm/radeon/prime: reserve/unreserve around pin
      drm: drop comment about this header being autogenerated.

Dave Chinner (1):
      xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near

David Ahern (1):
      perf tools: Fix endianity swapping for adds_features bitmask

David Rientjes (3):
      mm, oom: fix and cleanup oom score calculations
      mm, thp: print useful information when mmap_sem is unlocked in
zap_pmd_range
      mm, mempolicy: fix mbind() to do synchronous migration

Djamil Elaidi (1):
      ARM: OMAP4+: hwmod: fix issue causing IPs not going back to Smart-Standby

Dylan Reid (1):
      ALSA: hda - Handle open while transitioning to D3.

Eric W. Biederman (1):
      pidns: guarantee that the pidns init will be the last pidns process reaped

Fabio Estevam (4):
      ARM: mx31_3ds: Fix build due to missing IMX_HAVE_PLATFORM_IMX_SSI
      ARM: mx31: Add pinctrl_provide_dummies()
      ARM: mx51: Add pinctrl_provide_dummies()
      pinctrl: mxs: Use kfree to fix build error

Geert Uytterhoeven (5):
      xtensa: replace xtensa-specific _f{data,text} by _s{data,text}
      xtensa: use "test -e" instead of bashism "test -a"
      xtensa: use the declarations provided by <asm/sections.h>
      h8300: fix use of extinct _sbss and _ebss
      h8300: use the declarations provided by <asm/sections.h>

Govindraj.R (1):
      OMAP2+: UART: Add mechanism to probe uart pins and configure rx wakeup

Greg Kroah-Hartman (1):
      Revert "staging: usbip: bugfix for stack corruption on 64-bit
architectures"

Greg Pearson (1):
      mm/memblock: fix overlapping allocation when doubling reserved array

Guenter Roeck (4):
      hwmon: (coretemp) Add support for Atom D2000 and N2000 series CPU models
      hwmon: (coretemp) Improve support for TjMax detection on Atom CPUs
      hwmon: (coretemp) Document TjMax for 3rd generation i5/i7 processors
      hwmon: (emc2103) Fix use of an uninitilized variable in error case

Haojian Zhuang (2):
      ARM: dts: update memory size on brownstone
      ARM: mmp: fix missing cascade_irq in irq handler

Heiko Stübner (1):
      mmc: sdhci-s3c: pass IRQF ONESHOT to request threaded irq

Henrik Rydberg (1):
      hwmon: (applesmc) Limit key length in warning messages

Hugh Dickins (1):
      memcg: fix use_hierarchy css_is_ancestor oops regression

Jaccon Bastiaansen (1):
      ARM i.MX imx21ads: Fix overlapping static i/o mappings

Jaehoon Chung (1):
      mmc: core: return an error on suspend if mmc_deselect_cards fails

Jan Kara (1):
      xfs: Fix overallocation in xfs_buf_allocate_memory()

Jan Kiszka (1):
      KVM: Fix PCI header check on device assignment

Janne Kalliomäki (1):
      hfsplus: fix overflow in sector calculations in hfsplus_submit_bio

Javi Merino (1):
      DMA: PL330: Fix racy mutex unlock

Javier Martin (1):
      ARM i.MX27 Visstrim M10: fix gpio handling.

Jean Delvare (2):
      hwmon: (coretemp) Improve support of recent Atom CPU models
      hwmon: (coretemp) Drop needless initialization

Jeff Liu (1):
      xfs: fix debug_object WARN at xfs_alloc_vextent()

Jesse Barnes (2):
      drm/i915: don't enumerate HDMID if an eDP panel is already
active on the port
      drm/i915: cache the EDID for eDP panels

Jiri Kosina (1):
      iio: drop wrong reference from Kconfig

Joe Perches (1):
      get_maintainer: Fix --help warning

Johan Hovold (1):
      staging:iio: remove num_interrupt_lines from documentation

Jon Hunter (1):
      arm/dts: OMAP2: Fix interrupt controller binding

Josef Bacik (2):
      Btrfs: add a missing spin_lock
      Btrfs: delay iput with async extents

Kay Sievers (2):
      kmsg - kmsg_dump() use iterator to receive log buffer content
      kmsg - kmsg_dump() fix CONFIG_PRINTK=n compilation

Kevin Hilman (3):
      ARM: OMAP3: PM: fix shared PRCM interrupts: leave disabled at boot
      ARM: OMAP3: clock data: cleanup AM3[35]x SoC detection
      ARM: OMAP: SoC detection: remove unused cpu_is macros

Kim Phillips (1):
      mpc85xx_edac: fix error: too few arguments to function 'edac_mc_alloc'

Konstantin Khlebnikov (1):
      mm: correctly synchronize rss-counters at exit/exec

Kuninori Morimoto (1):
      driver core: fixup reversed deferred probe order

Lars-Peter Clausen (3):
      iio: Fix potential use after free
      staging:iio:ad7606: Re-add missing scale attribute
      staging:iio:ad7298: Fix linker error due to missing IIO kfifo buffer

Lee Jones (3):
      ARM: 7422/1: mmc: mmci: Allocate platform memory during Device Tree boot
      regulator: Change ab8500 match names to reflect Device Tree
      regulator: Change db8500-prcmu match names to reflect Device Tree

Linus Torvalds (1):
      Linux 3.5-rc4

Linus Walleij (2):
      serial/amba-pl011: move custom pin control to driver
      pinctrl/nomadik: document Alt-C glitch

Lubomir Schmidt (1):
      staging: r8712u: Add new USB IDs

Ludovic Desroches (1):
      mmc: atmel-mci: fix data timeout issue

Mahesh Vardhamanaiah (2):
      RDMA/ocrdma: Correct reported max queue sizes
      RDMA/ocrdma: Correct queue SGE calculation

Manohar Vanga (1):
      vme: change maintainer e-mail address

Marc Kleine-Budde (1):
      ARM: Kirkwood: clk_register_gate_fn: add fn assignment

Marek Vasut (1):
      mmc: mxs-mmc: Move of_match_table out of CONFIG_PM

Mark A. Greer (1):
      arm: omap3: am35x: Don't mark missing features as present

Mark Brown (6):
      ASoC: wm8904: Fix GPIO and MICBIAS initialisation for regmap conversion
      ASoC: wm8904: Fix cache only management
      ASoC: wm8996: Remove spurious regulator_bulk_free()
      ASoC: wm8996: Move reset before the initial regulator disable
      ASoC: wm8996: Mark the CODEC as cache only when powering off on boot
      Extcon: Don't try to create duplicate link names

Mark Tinguely (1):
      xfs: rename log structure to xlog

Matthew Garrett (1):
      hfsplus: fix bless ioctl when used with hardlinks

Michael Hennerich (1):
      iio: documentation: Add out_altvoltage and friends

Mircea Gherzan (1):
      ARM: 7421/1: bpf_jit: BPF_S_ANC_ALU_XOR_X support

Márton Németh (2):
      drm via: initialize object_idr
      drm sis: initialize object_idr

NeilBrown (1):
      ARM: OMAP2+: INTC: fix suspend abort, set IRQCHIP_SKIP_SET_WAKE

Nicolas Ferre (1):
      mmc: atmel-mci: fix burst/chunk size modification

Ohad Ben-Cohen (1):
      remoteproc/omap: fix dev_err typo

Olaf Hering (1):
      Tools: hv: verify origin of netlink connector message

Oleg Nesterov (1):
      pidns: find_new_reaper() can no longer switch to init_pid_ns.child_reaper

Ozan Çağlayan (1):
      vga_switcheroo: Add include guard

Parav Pandit (2):
      RDMA/ocrdma: Fixed GID table for vlan and events
      RDMA/ocrdma: Fixed RQ error CQE polling

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Drop locks around call to kvmppc_pin_guest_page

Paul Mundt (2):
      Makefile: fix up CROSS_COMPILE and READABLE_ASM interaction.
      bug.h: Fix up powerpc build regression.

Paul Walmsley (4):
      ARM: OMAP4: hwmod data: fix 32k sync timer idle modes
      ARM: OMAP4: clock data: add clockdomains for clocks used as main clocks
      ARM: OMAP2+: CM: increase the module disable timeout
      ARM: OMAP2+: mux: fix sparse warning

Peter Korsgaard (1):
      hwrng: atmel-rng - fix data valid check

Pravin B Shelar (1):
      mm: fix slab->page _count corruption when using slub

Qiao Zhou (2):
      ARM: MMP: add pxa910-ssp into ssp_id_table
      ASoC: fix pxa-ssp compiling issue under mach-mmp

Rabin Vincent (1):
      ARM: 7423/1: kprobes: run t32_simulate_ldr_literal() without insn slot

Rafał Miłecki (1):
      drm/radeon: enable HDMI on DCE5 (AKA NI excluding Aruba)

Randy Dunlap (6):
      staging/comedi: fix build for USB not enabled
      serial: fix kernel-doc warnings in 8250.c
      serial: fix serial_txx9.c build warning/typo
      vga_switcheroo.h: fix pci_dev warning
      mm/memory.c: fix kernel-doc warnings
      media: pms.c needs linux/slab.h

Ricardo Neri (1):
      ARM: OMAP4: hwmod data: Force HDMI in no-idle while enabled

Richard Zhao (3):
      ARM: i.MX: change timer clock from ipg to perclk
      ARM: imx6q: prepare and enable init on clks directly instead of
clk_get first
      dma: imx-sdma: buf_tail should be initialize in prepare function

Rob Herring (1):
      ARM: highbank: Add smc calls to enable/disable the L2

Roland Stigge (2):
      ARM: 7426/1: mmc: mmci: Remove wrong error handling of gpio 0
      ARM: 7427/1: mmc: mmci: Defer probe() in case of yet uninitialized GPIOs

Russ Dill (1):
      ARM: OMAP: Fix Beagleboard DVI reset gpio

Russell King (1):
      SPI: fix over-eager devm_xxx() conversion

Ryusuke Konishi (1):
      nilfs2: ensure proper cache clearing for gc-inodes

Sachin Kamat (1):
      DMA: PL330: Add missing static storage class specifier

Sage Weil (2):
      libceph: use con get/put ops from osd_client
      libceph: flush msgr queue during mon_client shutdown

Salman Qazi (3):
      cgroup: make sure that decisions in __css_put are atomic
      perf: Use css_tryget() to avoid propping up css refcount
      cgroups: Account for CSS_DEACT_BIAS in __css_put

Samuel Ortiz (1):
      misc: mei: Disable MSI when IRQ registration fails

Sangbeom Kim (1):
      regulator: Fix the s5m8767a problem of the division by null

Sascha Hauer (5):
      ARM i.MX5: fix gpt peripheral clock path
      ARM i.MX: remove now unnecessary argument from mxc_timer_init
      ARM i.MX pllv2: use standard register set unconditionally
      ARM i.MX pllv2: make round_rate accurate
      ARM i.MX53: Fix PLL4 base address

Sasha Levin (1):
      9p: BUG before corrupting memory

Sean Hefty (1):
      RDMA/cma: QP type check on received REQs should be AND not OR

Seungwon Jeon (4):
      mmc: dw_mmc: fix the transmission handling in IDMAC
      mmc: dw_mmc: fix the IDMAC sw reset
      mmc: dw_mmc: fix incorrect setting of host->data of NULL
      mmc: dw_mmc: correct the calculation for CLKDIV

Shawn Guo (1):
      ARM: imx6: exit coherency when shutting down a cpu

Sjur Brændeland (2):
      remoteproc: fix print format warnings
      remoteproc: fix missing fault indication in error-path

Stephane Eranian (1):
      perf stat: Fix default output file

Stephen Warren (2):
      ASoC: tegra+wm8903: turn of mic detect when card is removed
      ARM: tegra: make tegra_cpu_reset_handler_enable() __init

Steven Rostedt (1):
      ftrace: Make all inline tags also include notrace

Todd Poynor (1):
      ARM: OMAP: PM: Lock clocks list while generating summary

Tomas Winkler (4):
      misc: mei: set IRQF_ONESHOT for msi request_threaded_irq
      misc: mei: unregister misc device in pci_remove function
      misc: mei: fix stalled read
      misc: mei: set WDIOF_ALARMONLY on mei watchdog

Tony Lindgren (9):
      ARM: OMAP: Fix lis3lv02d accelerometer to use gpio_to_irq
      ARM: OMAP: Fix MMC_OMAP build when only MMC_OMAP_HS is selected
      ARM: OMAP3: Fix omap3_l3_block_irq warning when CONFIG_BUG is not set
      ARM: OMAP2+: Fix compile for CONFIG_TIDSPBRIDGE platform init code
      mmc: omap: Fix a section warning regression
      mmc: omap: Fix NULL pointer dereference if mmc_omap_new_slot() fails
      mmc: omap: Fix broken reg_shift initialization
      ARM: OMAP2+: Fix MUSB ifdefs for platform init code
      ARM: OMAP2: Fix tusb6010 GPIO interrupt for n8x0

Trond Myklebust (4):
      NFSv4.1: Fix umount when filelayout DS is also the MDS
      NFSv4.1: Fix a race in set_pnfs_layoutdriver
      NFS: Fix a refcounting issue in O_DIRECT
      NFS: Initialise commit_info.rpc_out when !defined(CONFIG_NFS_V4)

Tushar Behera (1):
      dmaengine: pl330: dont complete descriptor for cyclic dma

Uwe Kleine-König (2):
      ARM: imx: only specify i2c device type once
      ARM: imx: only call l2x0_init if it's available

Viresh Kumar (1):
      Viresh has moved

Wanpeng Li (1):
      mm: fix kernel-doc warnings

Will Deacon (1):
      ARM: 7425/1: extable: ensure fixup entries are 4-byte aligned

Yan, Zheng (2):
      ceph: check PG_Private flag before accessing page->private
      rbd: Clear ceph_msg->bio_iter for retransmitted message

Yong Ding (1):
      mmc: sdio: fix setting card data bus width as 4-bit

Yuanhan Liu (2):
      printk: use mutex lock to stop syslog_seq from going wild
      printk: return -EINVAL if the message len is bigger than the buf size
