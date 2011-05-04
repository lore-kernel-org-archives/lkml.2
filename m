Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1EDDOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 23:14:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754945Ab1EDDOa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 23:14:30 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 May 2011 20:13:30 -0700
Message-ID: <BANLkTin=0VvkzVCswMYXcHE2gH78V7V5Lw@mail.gmail.com>
Subject: Linux 2.6.39-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the stuff here no normal user will ever really notice (like
the ARM kprobes series), and most of the rest is the usual one-liner
random driver stuff.

But we had one really interesting bug that showed itself as an RCU
failure on UP, which turned out to be due to a scheduler problem,
which in turn turned out to be a timer initialization issue. That was
interesting and rather obscure.

But most of it is just pretty random. Some media updates, some NFS
work, some drm fixes, documentation, etc. Pretty small, and the bugs
have been pretty obscure on the whole. We're still chasing some stuff
down, but I think we're ok for -rc6. This isn't going to be the final
-rc, but it doesn't seem to be in bad shape, and people who have
posted regression reports please check them again, and people who
haven't, please do give it a test.

                            Linus

---
Adam Jaremko (1):
      net: ftmac100: fix scheduling while atomic during PHY link status change

Alex Deucher (4):
      drm/radeon/kms: add missing safe regs for 6xx/7xx
      drm/radeon/kms: add info query for tile pipes
      drm/radeon/kms: add some new pci ids
      drm/radeon/kms: fix gart setup on fusion parts (v2)

Alexey Dobriyan (1):
      ipv4: don't spam dmesg with "Using LC-trie" messages

Andrea Arcangeli (1):
      mm: thp: fix /dev/zero MAP_PRIVATE and vm_flags cleanups

Andrea Galbusera (1):
      powerpc: Fix multicast problem in fs_enet driver

Andrew Morton (1):
      vfs: avoid large kmalloc()s for the fdtable

Andy Walls (1):
      [media] cx18: Fix list BUG for IDX stream, triggerable in
cx18_probe() error clean up,

Artem Bityutskiy (2):
      UBIFS: do not free write-buffers when in R/O mode
      UBIFS: seek journal heads to the latest bud in replay

Avinash.H.M (1):
      OMAP2/3: hwmod: fix gpio-reset timeouts seen during bootup.

Axel Lin (1):
      hwmon: (twl4030-madc-hwmon) Return proper error if
hwmon_device_register fails

Ben Dooks (1):
      mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish

Ben Hutchings (1):
      ARM: Fix .size directive for xscale_dma_a0_map_area

Benoit Cousson (1):
      OMAP2+: hwmod data: Fix wrong dma_system end address

Boris Ostrovsky (1):
      x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors

Breno Leitao (1):
      ehea: Fix a DLPAR bug on ehea_rereg_mrs().

Bryan Schumaker (9):
      NFS: Remove unused argument from nfs_find_best_sec()
      NFS: Fix infinite loop in gss_create_upcall()
      NFS: flav_array honors NFS_MAX_SECFLAVORS
      NFS: Attempt mount with default sec flavor first
      NFS: don't negotiate when user specifies sec flavor
      NFS: Use correct variable for page bounds checking
      NFSv4.1: Don't update sequence number if rpc_task is not sent
      NFSv4: Handle NFS4ERR_WRONGSEC outside of nfs4_handle_exception()
      NFS: Return meaningful status from decode_secinfo()

Chris Ball (2):
      mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
      mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish

Christopher James Halse Rogers (1):
      drm: Send pending vblank events before disabling vblank.

Daisuke Nishimura (1):
      memcg: update documentation to describe usage_in_bytes

Dan Rosenberg (3):
      [SCSI] mpt2sas: prevent heap overflows and unchecked reads
      [SCSI] pmcraid: reject negative request size
      ARM: 6891/1: prevent heap corruption in OABI semtimedop

Dan Williams (1):
      usbnet: add support for some Huawei modems with cdc-ether ports

Daniel Cordero (1):
      ALSA: hda: add beep quirk for Realtek 0x1043:831a

Daniel Halperin (1):
      iwlwifi: fix frame injection for HT channels

Dave Airlie (3):
      drm: select FRAMEBUFFER_CONSOLE_PRIMARY if we have FRAMEBUFFER_CONSOLE
      drm/i915: restore only the mode of this driver on lastclose (v2)
      drm/radeon: fix regression on atom cards with hardcoded EDID record.

Dave Jones (1):
      can: Add missing socket check in can/bcm release.

Dave Martin (1):
      ARM: mxc: Correct data alignment in headsmp.S for CONFIG_THUMB2_KERNEL

David Cohen (1):
      [media] omap3isp: stat: update struct ispstat_generic_config's comments

David Henningsson (1):
      ALSA: HDA: Fix automute for Gateway NV79

David Rientjes (1):
      [PARISC] set memory ranges in N_NORMAL_MEMORY when onlined

David S. Miller (1):
      Revert "bridge: Forward reserved group addresses if !STP"

Don Zickus (1):
      perf, x86, nmi: Move LVT un-masking into irq handlers

Eduardo Valentin (2):
      OMAP2+: PM: Fix the saving of CM_AUTOIDLE_PLL register on scratchpad area
      OMAP3: PM: Do not rely on ROM code to restore
CM_AUTOIDLE_PLL.AUTO_PERIPH_DPLL

Eric W. Biederman (1):
      af_unix: Only allow recv on connected seqpacket sockets.

Fabio Estevam (1):
      ARM: mx5/mx53_loco: Fix build warning related to
gpio_keys_button structure

Felipe Contreras (1):
      omap: rx51: mark reserved memory earlier

Felix Fietkau (1):
      ath9k: fix the return value of ath_stoprecv

Florian Mickler (1):
      workqueue: Document debugging tricks

François Romieu (1):
      r8169: don't request firmware when there's no userspace.

Geert Uytterhoeven (1):
      genirq: Fix typo CONFIG_GENIRC_IRQ_SHOW_LEVEL

Guennadi Liakhovetski (10):
      [media] videobuf2: fix core to correctly identify allocation failures
      [media] videobuf2: fix an error message
      [media] v4l2-device: fix a macro definition
      [media] soc-camera: fix a recent multi-camera breakage on sh-mobile
      [media] imx074: return a meaningful error code instead of -1
      [media] soc-camera: don't dereference I2C client after it has been removed
      [media] sh_mobile_csi2: fix module reloading
      [media] V4L: sh_mobile_ceu_camera: fix typos in documentation
      mmc: fix a race between card-detect rescan and clock-gate work instances
      mmc: tmio: fix .set_ios(MMC_POWER_UP) handling

Guenter Roeck (2):
      hwmon: (lm90) Add support for ADT7461A and NCT1008
      hwmon: (lm90) Fix update interval information in driver documentation

H. Peter Anvin (2):
      x86, setup: When probing memory with e801, use ax/bx as a pair
      x86, reboot: Fix relocations in reboot_32.S

Hans Petter Selasky (1):
      cdc_ncm: fix short packet issue on some devices

Heiko Carstens (1):
      [S390] irqstats: fix counting of pfault, dasd diag and virtio irqs

Held Bernhard (1):
      net: provide cow_metrics() methods to blackhole dst_ops

Hillf Danton (1):
      kernel/watchdog.c: disable nmi perf event in the error path of
enabling watchdog

Ian Campbell (1):
      MAINTAINERS: re-alphabetize Xen entries

Ingo Molnar (1):
      perf events, x86: Work around the Nehalem AAJ80 erratum

Ivan Vecera (1):
      be2net: increment work_counter in be_worker

James Bottomley (2):
      [PARISC] slub: fix panic with DISCONTIGMEM
      [SCSI] put stricter guards on queue dead checks

Jean Delvare (5):
      hwmon: (adm1021) Clarify documentation regarding Xeon processors
      hwmon: (lm85) Add missing list terminators
      hwmon: (lm85) Fix error paths in probe function
      i2c-i801: Move device ID definitions to driver
      i2c-parport: Fix adapter list handling

Jeff Layton (1):
      nfs: don't lose MS_SYNCHRONOUS on remount of noac mount

Jesper Juhl (1):
      NFS: Remove dead code from nfs_fs_mount()

Jiri Bohac (1):
      bonding: 802.3ad - fix agg_device_up

Jiri Pirko (1):
      Revert: veth: remove unneeded ifname code from veth_newlink()

Joe Perches (1):
      amd8111e: trivial typo spelling: Negotitate -> Negotiate

Johannes Berg (1):
      mac80211: fix SMPS debugfs locking

Jon Medhurst (29):
      ARM: kprobes: Fix probing of conditionally executed instructions
      ARM: kprobes: Remove redundant condition checks from simulation routines
      ARM: kprobes: Fix emulation of CMP, CMN, TST and TEQ instructions.
      ARM: kprobes: Fix emulation of Data-processing (immediate) instructions
      ARM: kprobes: Reject probing MRS instructions which read SPSR
      ARM: kprobes: Fix emulation of MRS instruction
      ARM: kprobes: Reject probing of instructions which write to PC
unpredictably.
      ARM: kprobes: Fix error in comment
      ARM: kprobes: Reject probing of undefined multiply instructions
      ARM: kprobes: Reject probing of STREX and LDREX instructions
      ARM: kprobes: Fix emulation of LDRH, STRH, LDRSB and LDRSH instructions
      ARM: kprobes: Reject probing of LDR/STR instructions which
update PC unpredictably
      ARM: kprobes: Fix emulation of LDRD and STRD instructions
      ARM: kprobes: Reject probing of LDRB instructions which load PC
      ARM: kprobes: Add emulation of RBIT instruction
      ARM: kprobes: Reject probing of undefined media instructions
      ARM: kprobes: Fix emulation of SXTB16, SXTB, SXTH, UXTB16, UXTB
and UXTH instructions
      ARM: kprobes: Fix emulation of SMUAD, SMUSD and SMMUL instructions
      ARM: kprobes: Fix emulation of USAD8 instructions
      ARM: kprobes: Reject probing of all coprocessor instructions
      ARM: kprobes: Consolidate stub decoding functions
      ARM: kprobes: Reject probing of SETEND instructions
      ARM: kprobes: Fix emulation of PLD instructions
      ARM: kprobes: Remove redundant code in space_1111
      ARM: kprobes: Reject probing of undefined data processing instructions
      ARM: kprobes: Add emulation of MOVW and MOVT instructions
      ARM: kprobes: Add emulation of SBFX, UBFX, BFI and BFC instructions
      ARM: kprobes: Add emulation of hint instructions like NOP and WFI
      ARM: kprobes: Tidy-up kprobes-decode.c

KOSAKI Motohiro (1):
      oom: use pte pages in OOM score

Kevin Hilman (1):
      davinci: fix DEBUG_LL code for p2v changes

Konrad Rzeszutek Wilk (1):
      xen/mmu: Add workaround "x86-64, mm: Put early page table high"

Kukjin Kim (2):
      MAINTAINERS: update Documentation file entry of GPIO subsystem
      MAINTAINERS: add EXYNOS ARM architectures

Lasse Collin (1):
      XZ decompressor: Fix decoding of empty LZMA2 streams

Laurent Pinchart (8):
      [media] media: Use correct ioctl name in MEDIA_IOC_SETUP_LINK
documentation
      [media] omap3isp: resizer: Center the crop rectangle
      [media] omap3isp: resizer: Use 4-tap mode equations when the
ratio is <= 512
      [media] media: Properly handle link flags in link setup, link
notify callback
      [media] omap3isp: isp: Reset the ISP when the pipeline can't be stopped
      [media] omap3isp: Don't increment node entity use count when poweron fails
      [media] v4l: Don't register media entities for subdev device nodes
      [media] omap3isp: queue: Don't corrupt buf->npages when
get_user_pages() fails

Lifeng Sun (1):
      networking: inappropriate ioctl operation should return ENOTTY

Linus Torvalds (2):
      logfs: initialize superblock entries earlier
      Linux 2.6.39-rc6

Lucas De Marchi (1):
      Revert wrong fixes for common misspellings

Lucian Adrian Grijincu (1):
      sysctl: net: call unregister_net_sysctl_table where needed

Luiz Augusto von Dentz (1):
      Bluetooth: fix shutdown on SCO sockets

Lydia Wang (1):
      ALSA: hda - VIA: Fix notify_aa_path_ctls() invalid issue.

Marek Szyprowski (2):
      [media] media: vb2: fix incorrect v4l2_buffer->flags handling
      [media] media: vb2: correct queue initialization order

Mark Brown (3):
      Input: wm831x-ts - fix races with IRQ management
      Input: wm831x-ts - allow IRQ flags to be specified
      Input: wm831x-ts - move BTN_TOUCH reporting to data transfer

Martin Schwidefsky (1):
      [S390] prng: fix pointer arithmetic

Mauro Carvalho Chehab (1):
      cx23885: Fix stv0367 Kconfig dependency

Mel Gorman (1):
      mm: check if PTE is already allocated during page fault

Michael Buesch (1):
      mmc: omap: Fix possible NULL pointer deref

Michael Jones (5):
      [media] omap3isp: Fix trivial typos
      [media] v4l: add V4L2_PIX_FMT_Y12 format
      [media] media: add missing 8-bit bayer formats and Y12
      [media] omap3isp: ccdc: support Y10/12, 8-bit bayer fmts
      [media] omap3isp: lane shifter support

Michael Krufky (5):
      [media] tda18271: fix calculation bug in tda18271_rf_tracking_filters_init
      [media] tda18271: prog_cal and prog_tab variables should be s32, not u8
      [media] tda18271: fix bad calculation of main post divider byte
      [media] tda18271: update tda18271_rf_band as per NXP's rev.04 datasheet
      [media] tda18271: update tda18271c2_rf_cal as per NXP's rev.04 datasheet

Michael Schmitz (1):
      m68k/mm: Set all online nodes in N_NORMAL_MEMORY

Michael Williamson (2):
      davinci: mityomapl138: Use correct id for NAND controller
      davinci: mityomapl138: Use auto-probe to determine attached PHY ID

Michal Simek (1):
      ftrace: Build without frame pointers on Microblaze

Michał Mirosław (1):
      mmc: core: mmc_add_card(): fix missing break in switch statement

Mike Snitzer (1):
      [SCSI] scsi_dh: fix reference counting in scsi_dh_activate error path

Neil Horman (2):
      netconsole: fix deadlock when removing net driver that
netconsole is using (v2)
      bnx2: cancel timer on device removal

Nishanth Menon (1):
      OMAP3+: voltage: remove initial voltage

Oliver Hartkopp (1):
      can: add missing socket check in can/raw release

Oliver Neukum (1):
      usbnet: Transfer of maintainership

Oskar Andero (1):
      arm: omap2: enable smc instruction for sleep34xx

Patrick Boettcher (4):
      [media] DIB0700: fix typo in dib0700_devices.c
      [media] FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci
      [media] dib0700: fix possible NULL pointer dereference
      [media] Fix dependencies for Technisat USB2.0 DVB-S/S2

Paul Parsons (1):
      ARM: pxa/hx4700: bq24022 regulator needs to be enabled

Paul Stewart (1):
      usbnet: Resubmit interrupt URB if device is open

Peter Korsgaard (1):
      dsa/mv88e6131: fix unknown multicast/broadcast forwarding on mv88e6085

Peter Zijlstra (1):
      perf, x86: Fix BTS condition

Philipp Zabel (1):
      ARM: pxa/magician: bq24022 regulator needs to be enabled

Rabin Vincent (1):
      smsc95xx: fix reset check

Rafael J. Wysocki (3):
      PM / Wakeup: Fix initialization of wakeup-related device sysfs files
      ACPI / PM: Avoid infinite recurrence while registering power resources
      tg3: Fix failure to enable WoL by default when possible

Rafał Miłecki (1):
      b43: trivial: update module info about ucode16_mimo firmware

Randy Dunlap (1):
      uml: fix hppfs build

Raymond Yau (1):
      ALSA - au88x0 - Add buffer bytes constraints

Richard Weinberger (2):
      um: mdd support for 64 bit atomic operations
      um: adjust current_thread_info() for newer gcc versions

Ruiyi Zhang (1):
      Bluetooth: Only keeping SAR bits when retransmitting one frame.

Russell King (1):
      CLKDEV: Fix clkdev return value for NULL clk case

Russell King - ARM Linux (1):
      ARM: Davinci: Fix I2C build errors

Sakari Ailus (1):
      [media] omap3isp: resizer: Improved resizer rsz factor formula

Sebastian Andrzej Siewior (2):
      x86: devicetree: Configure IOAPIC pin only once
      x86: ce4100: Configure IOAPIC pins for USB and SATA to level type

Sergei Shtylyov (1):
      DA830: fix SPI1 base address

Shan Wei (1):
      ipv6: udp: fix the wrong headroom check

Shweta Gulati (1):
      OMAP4: Intialize IVA Device in addition to DSP device.

Sonny Rao (1):
      ARM: 6884/1: Fix infinite loop in ARM user perf_event backtrace code

Stanimir Varbanov (1):
      [media] omap3isp: Use isp xclk defines

Stanislaw Gruszka (5):
      iwlwifi: fix skb usage after free
      iwl4965: fix skb usage after free
      iwl4965: fix "TX Power requested while scanning"
      iwlagn: fix "Received BA when not expected"
      iwl4965: fix "Received BA when not expected"

Stefano Stabellini (1):
      xen: mask_rw_pte mark RO all pagetable pages up to pgt_buf_top

Steffen Klassert (3):
      xfrm: Fix replay window size calculation on initialization
      esp6: Fix scatterlist initialization
      xfrm: Check for the new replay implementation if an esn state is inserted

Stephen Boyd (1):
      ARM: 6887/1: Mark broadcast_timer_setup() __cpuinit

Sylwester Nawrocki (4):
      [media] s5p-fimc: Fix FIMC3 pixel limits on Exynos4
      [media] s5p-fimc: Do not allow changing format after REQBUFS
      [media] s5p-fimc: Fix bytesperline and plane payload setup
      [media] s5p-fimc: Add support for the buffer timestamps and sequence

Takashi Iwai (2):
      Revert "ALSA: hda - Fix pin-config of Gigabyte mobo"
      ALSA: hda - Fix Realtek's chained fixup checks

Tejun Heo (1):
      workqueue: fix deadlock in worker_maybe_bind_and_lock()

Thomas Egerer (1):
      ipv6: Remove hoplimit initialization to -1

Thomas Gleixner (2):
      ARM: mxc: Add missing lockdep annotation
      hrtimer: Initialize CLOCK_ID to HRTIMER_BASE table statically

Tim Gardner (1):
      atl1c: Fix work event interrupt/task races

Tomi Valkeinen (1):
      OMAP4: clock data: Change DSS clock aliases

Trond Myklebust (8):
      NFS: Eliminate duplicate call to nfs_mark_request_dirty
      NFS: Get rid of pointless test in nfs_commit_done
      SUNRPC: Fix the SUNRPC Kerberos V RPCSEC_GSS module dependencies
      NFSv4.1: Ensure state manager thread dies on last umount
      NFSv4.1: Don't loop forever in nfs4_proc_create_session
      SUNRPC: Allow RPC calls to return ETIMEDOUT instead of EIO
      NFSv4: Ensure that clientid and session establishment can time out
      NFSv4: Ensure we request the ordinary fileid when doing readdirplus

Uwe Kleine-König (3):
      ARM: imx: fix usb related build failure for mach-vpr200
      ARM: mxs/clock-mx28: fix up name##_set_rate
      [media] V4L: mx3_camera: select VIDEOBUF2_DMA_CONTIG instead of
VIDEOBUF_DMA_CONTIG

Viktor Rosendahl (1):
      kprobes/arm: Fix ldrd/strd emulation

Ville Tervo (1):
      Bluetooth: Fix refcount balance for hci connection

Vinicius Costa Gomes (1):
      Bluetooth: Fix keeping the command timer running

Vladislav Zolotarov (1):
      bnx2x: fix UDP csum offload

Weston Andros Adamson (1):
      Don't mark_inode_dirty_sync() while holding lock

Wey-Yi Guy (1):
      iwlegacy: led stay solid on when no traffic

Wolfgang Breyha (1):
      ALSA: usb-audio - Terratec Aureon 7.1 USB ID as C-Media cm6206 quirks

Yinghai Lu (1):
      x86, NUMA: Fix empty memblk detection in numa_cleanup_meminfo()

Zhangfei Gao (1):
      rtc: max8925: Call dev_set_drvdata before rtc_device_register

artpol (1):
      mii: add support of pause frames in mii_get_an

omar ramirez (1):
      OMAP3: l3: fix for "irq 10: nobody cared" message
