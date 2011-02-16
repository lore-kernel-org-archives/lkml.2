Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab1BPEQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:16:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592Ab1BPEQn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:16:43 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Feb 2011 20:16:01 -0800
Message-ID: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
Subject: Linux 2.6.38-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

Nothing much stands out here - we've fixed some regressions
(including, hopefully, a BUG_ON() due to the new RCU filename lookup
that Ubuntu people saw), and things look fairly normal.

Most of the changes are pretty spread out and small, with drivers/gpu
(radeon and i915) somewhat standing out from the pack. And to a lesser
degree drivers/rtc (converting some missed drivers to the
alarm_irq_enable methods) along with some ext4 updates (mainly the
"serialize unaligned async DIO" thing) standing out as being larger
than average.

There's also some device tree documentation movement that looks huge
if you look at traditional patches, but it's just moving files out of
the powerpc directory (since the whole device tree thing is generic
these days).

But most of it is pretty small. The appended ShortLog gives some flavor of it,

                           Linus

---
Ajit Khaparde (1):
      benet: Avoid potential null deref in be_cmd_get_seeprom_data()

Al Viro (5):
      nothing in do_follow_link() is going to see RCU
      in do_lookup() split RCU and non-RCU cases of need_revalidate
      split do_revalidate() into RCU and non-RCU cases
      drop out of RCU in return_reval
      get rid of nameidata_dentry_drop_rcu() calling nameidata_drop_rcu()

Alan Stern (3):
      USB: prevent buggy hubs from crashing the USB stack
      USB: fix race between root-hub resume and wakeup requests
      USB: usb-storage: unusual_devs entry for Coby MP3 player

Alex Deucher (9):
      drm/radeon/kms: fix interlaced modes on dce4+
      drm/radeon/kms: add connector table for mac g5 9600
      drm/radeon/kms: evergreen/ni big endian fixes (v2)
      drm/radeon/kms: use linear aligned for 6xx/7xx bo blits
      drm/radeon/kms: use linear aligned for evergreen/ni bo blits
      drm/radeon/kms: improve 6xx/7xx CS error output
      drm/radeon/kms: fix a few more atombios endian issues
      drm/radeon/kms: add bounds checking to avivo pll algo
      drm/radeon/kms: hopefully fix pll issues for real (v3)

Alexander Duyck (1):
      ixgbe: limit VF access to network traffic

Alexander Stein (1):
      Input: rotary_encoder - use proper irqflags

Alexander Strakh (2):
      Input: wacom - fix error path in wacom_probe()
      drivers/rtc/rtc-proc.c: add module_put on error path in rtc_proc_open()

Alexey Orishko (2):
      CDC NCM errata updates for cdc.h
      USB CDC NCM errata updates for cdc_ncm host driver

Amit Shah (3):
      virtio: console: Move file back to drivers/char/
      virtio: console: Wake up outvq on host notifications
      virtio: console: Update Copyright

Anatolij Gustschin (1):
      dma: ipu_idmac: do not lose valid received data in the irq handler

Andrea Arcangeli (1):
      thp: prevent hugepages during args/env copying into the user stack

Anisse Astier (1):
      ALSA: hda - add quirk for Ordissimo EVE using a realtek ALC662

Ari Kauppi (2):
      oprofile: Fix usage of CONFIG_HW_PERF_EVENTS for
oprofile_perf_init and friends
      ARM: oprofile: Fix backtraces in timer mode

Arnaldo Carvalho de Melo (1):
      perf tools: Fix thread_map event synthesizing in top and record

Arvid Ephraim Picciani (1):
      USB: cdc-acm: Adding second ACM channel support for Nokia N8

Ben Hutchings (1):
      68360serial: Plumb in rs_360_get_icount()

Benny Halevy (1):
      NFSD: use nfserr for status after decode_cb_op_status

Bjørn Forsman (1):
      ARM: pxa/colibri: use correct SD detect pin

Bjørn Mork (1):
      USB: io_edgeport: fix the reported firmware major and minor

Boaz Harrosh (1):
      vfs: call rcu_barrier after ->kill_sb()

Bob Liu (1):
      usb: musb: hsdma: change back to use musb_read/writew

Borislav Petkov (2):
      amd64_edac: Fix DIMMs per DCTs output
      x86: Fix mwait_usable section mismatch

Bruce Rogers (1):
      virtio_net: Add schedule check to napi_enable call

Chris Mason (3):
      md_make_request: don't touch the bio after calling make_request
      Btrfs: fix page->private races
      Btrfs: don't release pages when we can't clear the uptodate bits

Chris Wilson (7):
      drm/i915: Invalidate TLB caches on SNB BLT/BSD rings
      drm/i915/lvds: Restore dithering on native modes for gen2/3
      drm/i915: Disable RC6 on Ironlake
      drm/i915/sdvo: If we have an EDID confirm it matches the mode of
the connection
      drm/i915: Trigger modesetting if force-audio changes
      drm/i915/tv: Use polling rather than interrupt-based hotplug
      drm/i915: Fix resume regression from 5d1d0cc

Chris Wright (3):
      security: add cred argument to security_capable()
      pci: use security_capable() when checking capablities during
config space read
      pci: use security_capable() when checking capablities during
config space read

Christian Lamparter (1):
      carl9170: fix typo in PS code

Clemens Ladisch (2):
      ALSA: hrtimer: handle delayed timer interrupts
      ALSA: hrtimer: remove superfluous tasklet invocation

Corey Minyard (1):
      char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver

Curt Wohlgemuth (1):
      ext4: Fix data corruption with multi-block writepages support

Cédric Cano (3):
      drm/radeon: 6xx/7xx non-kms endian fixes
      drm/radeon/kms: atombios big endian fixes
      drm/radeon/kms: 6xx/7xx big endian fixes

Dan Rosenberg (1):
      btrfs: prevent heap corruption in btrfs_ioctl_space_info()

Dan Williams (1):
      dmaengine: add slave-dma maintainer

Dave Airlie (2):
      drm/radeon: fix memory debugging since
d961db75ce86a84f1f04e91ad1014653ed7d9f46
      drm/radeon: fix race between GPU reset and TTM delayed delete thread.

Dave Martin (1):
      ARM: 6659/1: Thumb-2: Make CONFIG_OABI_COMPAT depend on
!CONFIG_THUMB2_KERNEL

David Henningsson (1):
      ALSA: HDA: Add subwoofer quirk for Acer Aspire 8942G

David Miller (1):
      klist: Fix object alignment on 64-bit.

David S. Miller (4):
      net/caif: Fix dangling list pointer in freed object on error.
      net: Fix lockdep regression caused by initializing netdev queues
too early.
      isdn: hysdn: Kill (partially buggy) CVS regision log reporting.
      x25: Do not reference freed memory.

David Teigland (1):
      dlm: use single thread workqueues

Dirk Eibach (1):
      hwmon: (lm63) Consider LM64 temperature offset

Dmitry Eremin-Solenikov (1):
      ARM: 6658/1: collie: do actually pass locomo_info to locomo driver

Dmitry Torokhov (3):
      Input: sysrq - rework re-inject logic
      Revert "Input: do not pass injected events back to the
originating handler"
      Input: ads7846 - check proper condition when freeing gpio

Don Fry (1):
      iwlagn: Re-enable RF_KILL interrupt when down

Don Skidmore (3):
      ixgbe: fix for 82599 erratum on Header Splitting
      ixgbe: cleanup variable initialization
      ixgbe: update version string

Don Zickus (1):
      watchdog, nmi: Lower the severity of error messages

Duncan Laurie (1):
      Input: serio - clear pending rescans after sysfs driver rebind

Emil Tantilov (1):
      ixgbe: fix variable set but not used warnings by gcc 4.6

Eric Miao (1):
      ARM: pxa: only save/restore registers when pm functions are defined

Eric Sandeen (3):
      ext4: fix panic on module unload when stopping lazyinit thread
      ext4: make grpinfo slab cache names static
      ext4: serialize unaligned asynchronous DIO

Felipe Balbi (1):
      usb: musb: disable double buffering when it's broken

Felix Fietkau (1):
      mac80211: fix the skb cloned check in the tx path

Florian Fainelli (1):
      e1000: add support for Marvell Alaska M88E1118R PHY

Geert Uytterhoeven (1):
      m68knommu: Remove dependencies on nonexistent M68KNOMMU

Grant Likely (6):
      dt: Move device tree documentation out of powerpc directory
      dt: Remove obsolete description of powerpc boot interface
      dt: add documentation of ARM dt boot interface
      MAINTAINERS: Add entry for GPIO subsystem
      MAINTAINERS: Add entry for GPIO subsystem
      Revert "dt: add documentation of ARM dt boot interface"

Greg Ungerer (8):
      m68knommu: fix use of un-defined _TIF_WORK_MASK
      m68k: remove arch specific non-optimized memcmp()
      m68knommu: add optimize memmove() function
      m68knommu: fix mis-named variable int set_irq_chip loop
      m68knommu: add missing linker __modver section
      m68knommu: fix dereference of port.tty
      m68knommu: remove use of IRQ_FLG_LOCK from 68360 platform support
      m68knommu: set flow handler for secondary interrupt controller of 5249

Guennadi Liakhovetski (1):
      spi/spi_sh_msiof: fix wrong address calculation, which leads to an Oops

Guenter Roeck (1):
      hwmon: (emc1403) Fix I2C address range

Haiyang Zhang (1):
      staging: hv: Enable sending GARP packet after live migration

Harsha Priya (1):
      staging: sst: Fix for dmic capture on v2 pmic

Ian Abbott (2):
      Staging: comedi: Add MODULE_LICENSE and similar to NI modules
      Staging: Comedi: Fix a few NI module dependencies

Ilya Dryomov (1):
      Btrfs - Fix memory leak in btrfs_init_new_device()

Ionut Nicu (1):
      USB: ti_usb: fix module removal

J. Bruce Fields (9):
      nfsd: don't leak dentry count on mnt_want_write failure
      nfsd4: split up nfsd_break_deleg_cb
      nfsd4: add helper function for lease setup
      nfsd4: fix leak on allocation error
      nfsd4: split lease setting into separate function
      nfsd4: remove unused deleg dprintk's.
      nfsd4: modify fi_delegations under recall_lock
      nfsd4: acquire only one lease per file
      nfsd: break lease on unlink due to rename

Jan Beulich (1):
      x86: Fix section mismatch in LAPIC initialization

Janusz Krzysztofik (1):
      ASoC: fill in snd_soc_pcm_runtime.card before calling
snd_soc_dai_link.init()

Jarkko Nikula (1):
      usb: ehci-omap: Show fatal probing time errors to end user

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: ftdi_sio: add ST Micro Connect Lite uart support

Jeff Layton (2):
      cifs: clean up checks in cifs_echo_request
      cifs: don't always drop malformed replies on the floor (try #3)

Jesper Juhl (5):
      wireless, wl1251: Fix potential NULL pointer dereference in
wl1251_op_bss_info_changed()
      USB SL811HS HCD: Fix memory leak in sl811h_urb_enqueue()
      USB, Mass Storage, composite, gadget: Fix build failure and
memset of a struct
      sis900: Fix mem leak in sis900_rx error path
      radeon mkregtable: Add missing fclose() calls

Jesse Brandeburg (1):
      e1000e: tx_timeout should not increment for non-hang events

Joerg Roedel (1):
      KVM: SVM: Make sure KERNEL_GS_BASE is valid when loading gs_index

Johannes Berg (1):
      mac80211: fix TX status cookie in HW offload case

Johannes Weiner (1):
      vmscan: fix zone shrinking exit when scan work is done

John Stultz (3):
      RTC: Fix rtc driver ioctl specific shortcutting
      RTC: Convert rtc drivers to use the alarm_irq_enable method
      RTC: Fix minor compile warning

Joseph Teichman (1):
      ALSA: usbaudio - Enable the E-MU 0204 USB

Julia Lawall (1):
      drivers/w1/masters/omap_hdq.c: add missing clk_put

Justin TerAvest (1):
      cfq-iosched: Don't wait if queue already has requests.

KAMEZAWA Hiroyuki (1):
      memcg: fix leak of accounting at failure path of hugepage collapsing

Kees Cook (2):
      timer debug: Hide kernel addresses via %pK in /proc/timer_list
      drm: do not leak kernel addresses via /proc/dri/*/vma

Ken Mills (1):
      n_gsm: copy mtu over when configuring via ioctl interface

Konstantin Khorenko (1):
      NFSD: memory corruption due to writing beyond the stat array

Krzysztof Wojcik (2):
      Add raid1->raid0 takeover support
      FIX: md: process hangs at wait_barrier after 0->10 takeover

Kukjin Kim (1):
      ARM: S5PV310: Cleanup System MMU

Len Brown (1):
      tools: turbostat: style updates

Linus Torvalds (4):
      cap_syslog: accept CAP_SYS_ADMIN for now
      Fix possible filp_cachep memory corruption
      Revert "pci: use security_capable() when checking capablities
during config space read"
      Linux 2.6.38-rc5

Lukas Czerner (1):
      ext4: unregister features interface on module unload

Marek Olšák (3):
      drm/radeon/kms: optimize CS state checking for r100->r500
      drm/radeon/kms: fix tracking of BLENDCNTL, COLOR_CHANNEL_MASK,
and GB_Z on r300
      drm/radeon/kms: check AA resolve registers on r300

Marek Vasut (1):
      ARM: pxa: Properly configure PWM period for palm27x

Mark Brown (3):
      ASoC: Create an AIF1ADCDAT signal widget to match AIF2
      ASoC: Improve WM8994 digital power sequencing
      ARM: SAMSUNG: Ensure struct sys_device is declared in plat/pm.h

Martin Schwidefsky (1):
      s390: remove task_show_regs

Mian Yousaf Kaukab (2):
      usb: musb: maintain three states for buffer mappings instead of two
      usb: musb: introduce api for dma code to check compatibility
with usb request

Michael Buesch (1):
      ssb-pcmcia: Fix parsing of invariants tuples

Michael Karcher (1):
      ACPI / Video: Probe for output switch method when searching video devices.

Michael Williamson (1):
      USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research spectrograph

Michal Simek (4):
      microblaze: Fix IRQ flag handling for MSR=0
      microblaze: Fix asm compilation warning
      microblaze: Fix pte_update function
      microblaze: Fix msr instruction detection

Michel Lespinasse (2):
      mlock: fix race when munlocking pages in do_wp_page()
      mlock: do not munlock pages in __do_fault()

Ming Lei (1):
      usb: musb: fix kernel panic during s2ram(v2)

Mohammed Shafi Shajakhan (1):
      ath9k: Fix possible double free of PAPRD skb's

Naga Chumbalkar (1):
      x86, dmi, debug: Log board name (when present) in dmesg/oops output

NeilBrown (8):
      md: revert change to raid_disks on failure.
      md: simplify some 'if' conditionals in raid5_start_reshape.
      md: fix the test for finding spares in raid5_start_reshape.
      md: don't abort checking spares as soon as one cannot be added.
      md: Remove the AllReserved flag for component devices.
      md: Don't use remove_and_add_spares to remove failed devices
from a read-only array
      md: don't clear curr_resync_completed at end of resync.
      md: Don't allow slot_store while resync/recovery is happening.

Nick Holloway (1):
      USB: Storage: Add unusual_devs entry for VTech Kidizoom

Nicolas de Pesloüan (1):
      deb-pkg: Fix building outside of source tree (O=...).

Nitin Gupta (1):
      staging: zram: fix data corruption issue

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack: set conntrack templates again if we
return NF_REPEAT

Paul Bolle (2):
      devicetree-discuss is moderated for non-subscribers
      x86, ioapic: Don't warn about non-existing IOAPICs if we have none

Pavankumar Kondeti (1):
      USB: Fix trout build failure with ci13xxx_msm gadget

Peter Zijlstra (2):
      Revert "lockdep, timer: Fix del_timer_sync() annotation"
      x86: Fix text_poke_smp_batch() deadlock

Philippe De Muyter (2):
      m68knommu: fix m548x_wdt.c compilation after headers renaming
      m68knommu: Rename m548x_wdt.c to m54xx_wdt.c

Ping Cheng (1):
      Input: wacom_w8001 - report resolution to userland

Rabin Vincent (1):
      ARM: 6654/1: perf/oprofile: fix off-by-one in stack check

Rafael J. Wysocki (3):
      ACPI: Fix acpi_os_read_memory() and acpi_os_write_memory() (v2)
      ACPI / ACPICA: Avoid crashing if _PRW is defined for the root object
      ACPI / Wakeup: Enable button GPEs unconditionally during initialization

Randy Dunlap (1):
      can: softing_cs needs slab.h

Roland Stigge (1):
      drivers/gpio/pca953x.c: add a mutex to fix race condition

Roland Vossen (1):
      staging: brcm80211: bugfix for softmac crash on multi cpu configurations

Russell King (3):
      ARM: Avoid building unsafe kernels on OMAP2 and MX3
      ARM: make SWP emulation explicit on !CPU_USE_DOMAINS
      ARM: fixup SMP alternatives in modules

Russell King - ARM Linux (2):
      DMA: PL08x: fix infinite wait when terminating transfers
      DMA: PL08x: fix channel pausing to timeout rather than lockup

Sascha Hauer (10):
      dmaengine i.MX SDMA: Fix firmware loading
      dmaengine i.MX sdma: set maximum segment size for our device
      dmaengine i.MX sdma: check sg entries for valid addresses and lengths
      dmaengine i.MX SDMA: do not initialize chan_id field
      dmaengine i.MX SDMA: initialize dma capabilities outside channel loop
      dmaengine i.MX SDMA: reserve channel 0 by not registering it
      dmaengine i.MX dma: set maximum segment size for our device
      dmaengine i.MX dma: check sg entries for valid addresses and lengths
      dmaengine i.MX DMA: do not initialize chan_id field
      dmaengine i.MX dma: initialize dma capabilities outside channel loop

Sergei Shtylyov (1):
      usb: musb: core: fix IRQ check

Sergey Senozhatsky (1):
      loop: queue_lock NULL pointer derefence in blk_throtl_exit

Shawn Guo (7):
      dmaengine: imx-sdma: propagate error in sdma_probe() instead of
returning 0
      dmaengine: imx-sdma: fix inconsistent naming in sdma_assign_cookie()
      dmaengine: imx-sdma: remove IMX_DMA_SG_LOOP handling in
sdma_prep_slave_sg()
      dmaengine: imx-sdma: set sdmac->status to DMA_ERROR in err_out
of sdma_prep_slave_sg()
      dmaengine: imx-sdma: return sdmac->status in sdma_tx_status()
      dmaengine: imx-sdma: correct sdmac->status in sdma_handle_channel_loop()
      dmaengine: imx-sdma: fix up param for the last BD in sdma_prep_slave_sg()

Simon Arlott (1):
      cdrom: support devices that have check_events but not media_changed

Sonic Zhang (1):
      serial: bfin_5xx: split uart RX lock from uart port lock to avoid deadlock

Soren Hansen (1):
      nbd: remove module-level ioctl mutex

Stefan Berger (1):
      tpm_tis: Use timeouts returned from TPM

Stephen M. Cameron (1):
      cciss: make cciss_revalidate not loop through CISS_MAX_LUNS
volumes unnecessarily.

Steve French (1):
      [CIFS] Do not send SMBEcho requests on new sockets until SMBNegotiate

Sven Eckelmann (1):
      batman-adv: Linearize fragment packets before merge

Takashi Iwai (2):
      ALSA: hda - Fix missing CA initialization for HDMI/DP
      ALSA: hda - Don't handle empty patch files

Tao Ma (1):
      blktrace: Don't output messages if NOTIFY isn't set.

Tejun Heo (1):
      ptrace: use safer wake up on ptrace_detach()

Theodore Ts'o (2):
      ext4: fix up ext4 error handling
      jbd2: call __jbd2_log_start_commit with j_state_lock write locked

Thomas Abraham (1):
      ARM: S5PV310: Add support System MMU on SMDKV310

Thomas Gleixner (1):
      x86: Readd missing irq_to_desc() in fixup_irq()

Thomas Renninger (1):
      tools: turbostat: fix bitwise and operand

Tim Deegan (1):
      fix jiffy calculations in calibrate_delay_direct to handle overflow

Tomoya (3):
      pch_can: fix 800k comms issue
      pch_can: fix rmmod issue
      pch_can: fix module reload issue with MSI

Tomoya MORINAGA (1):
      pch_can: fix tseg1/tseg2 setting issue

Toshiharu Okada (1):
      pch_gbe: Fix the issue which a driver locks when rx offload is
set by ethtool

Tracey Dent (2):
      drivers/block/Makefile: replace the use of <module>-objs with <module>-y
      drivers/block/aoe/Makefile: replace the use of <module>-objs
with <module>-y

Trilok Soni (1):
      Input: matrix_keypad - increase the limit of rows and columns

Tsutomu Itoh (1):
      Btrfs: check return value of alloc_extent_map()

Vaibhav Bedia (1):
      asoc: davinci: da830/omap-l137: correct cpu_dai_name

Vivek Goyal (2):
      cfq: rename a function to give it more appropriate name
      blkio-throttle: Avoid calling blkiocg_lookup_group() for root group

Vladislav Zolotarov (1):
      bnx2x: Duplication in promisc mode

Wey-Yi Guy (1):
      iwlagn: overwrite EEPROM chain setting for 6250 devices

Will Deacon (2):
      ARM: 6656/1: hw_breakpoint: avoid UNPREDICTABLE behaviour when
reading DBGDSCR
      ARM: 6657/1: hw_breakpoint: fix ptrace breakpoint advertising on
unsupported arch

Xiao Jiang (1):
      drm: fix wrong usages of drm_device in DRM Developer's Guide

Yan, Zheng (1):
      Btrfs: Fix balance panic

Yin Kangkai (1):
      USB: EHCI: fix scheduling while atomic during suspend

Yinghai Lu (1):
      memblock: don't adjust size in memblock_find_base()

Yu Tang (1):
      ARM: pxa: fix mfpr_sync to read from valid offset

Yusuke Goda (1):
      usb: r8a66597-udc: Fixed bufnum of Bulk

andrew hendry (1):
      x25: possible skb leak on bad facilities

maximilian attems (1):
      deb-pkg: Use $SRCARCH for include path

Łukasz Wojniłowicz (1):
      ALSA: hda - switch lfe with side in mixer for 4930g
