Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2FQBAF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 21:00:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48626 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2FQBAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 21:00:01 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Jun 2012 17:59:39 -0700
X-Google-Sender-Auth: KGmXwO6jbGWf9RzMO3JurZdghrA
Message-ID: <CA+55aFx2muc8bZtkcLqoeL2GVgYs0cZBmeTu8TA7xf6tBY03mA@mail.gmail.com>
Subject: Linux 3.5-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So at this stage I always wish there were fewer changes in the -rc
releases, but -rc3 is out and while it could be smaller (it's just
under 300 non-merge commits), it doesn't seem too bad.

The week started calm with just a few small pulls, with people
apparently really trying to make my life easier during travels - thank
you. But it kind of devolved at some point, and I think more than half
the pull requests came in the last two days and they were bigger too.
Oh well..

Anyway, my merge summary is as follows:

 - regulator and regmap fixes from Mark Brown
 - crypto fixes from Herbert Xu
 - m68knommu from Greg Ungerer
 - writeback locking fix from Wu Fengguang
 - drm fixes from Dave Airlie
 - omapdss build problem fix from Tomi Valkeinen
 - m68k update from Geert Uytterhoeven
 - led fixes from Bryan Wu
 - SuperH fixes from Paul Mundt
 - sound fixes from Takashi Iwai
 - pinctrl fixes from Linus Walleij
 - kvm fix from Marcelo Tosatti
 - btrfs update (and a later warning fix pull) from Chris Mason
 - target updates from Nicholas Bellinger
 - x86, perf, and core updates (RCU and locking) from Ingo Molnar
 - networking, IDE and sparc update from David S. Miller
 - USB fixes from Greg Kroah-Hartman
 - five Xen bug-fixes from Konrad Rzeszutek Wilk
 - two nfsd bugfixes from J. Bruce Fields
 - PowerPC fix from Paul Mackerras
 - DMA-mapping fixes from Marek Szyprowski
 - NFS client bugfixes from Trond Myklebust
 - SCSI fixes from James Bottomley
 - fbdev fixes from Florian Tobias Schandinat
 - arch/tile update from Chris Metcalf

and for people who are interested, I'm appending the full shortlog.
Apart from the new tilegx ethernet driver that came in through the
networking tree, it's all reasonably small.

Go get it,

                 Linus

---
Alan Cox (1):
      USB: mct_u232: Fix incorrect TIOCMSET return

Alan Stern (2):
      USB: add NO_D3_DURING_SLEEP flag and revert 151b61284776be2
      USB: serial-generic: use a single set of device IDs

Amitkumar Karwar (1):
      cfg80211: use sme_state in ibss start/join path

Anand Gadiyar (1):
      Fix OMAP EHCI suspend/resume failure (i693)

Andiry Xu (1):
      xHCI: Increase the timeout for controller save/restore state operation

Andre Przywara (1):
      xen/setup: filter APERFMPERF cpuid feature out

Andrew Bird (1):
      USB: option: Updated Huawei K4605 has better id

Andrew Lunn (1):
      mv643xx_eth: Fix compile error for architectures without clk.

Andy Adamson (1):
      NFSv4 do not send an empty SETATTR compound

AnilKumar Ch (3):
      can: c_can: fix "BUG! echo_skb is occupied!" during transmit
      can: c_can: fix an interrupt thrash issue with c_can driver
      can: c_can: fix race condition in c_can_open()

Archit Taneja (1):
      OMAPDSS: DSI: Fix bug when calculating LP command interleaving parameters

Arik Nemtsov (1):
      mac80211: fix non RCU-safe sta_list manipulation

Arnd Bergmann (5):
      drivers/video: use correct __devexit_p annotation
      video/ili9320: do not mark exported functions __devexit
      video/console: automatically select a font
      drivers/savagefb: use mdelay instead of udelay
      drivers/tosa: driver needs I2C and SPI to compile

Avinash Patil (2):
      mwifiex: invalidate bss config before setting channel for uAP
      mwifiex: support NL80211_HIDDEN_SSID_ZERO_LEN for uAP

Axel Lin (4):
      regulator: palmas: Fix wrong kfree calls
      regulator: anatop: Use correct __devexit_p annotation
      regulator: core: Properly handle the case min_uV <
rdev->desc->min_uV in map_voltage_linear
      leds: Make LEDS_ASIC3 and LEDS_RENESAS_TPU depend on LEDS_CLASS=y

Barry Song (1):
      pinctrl: sirf: mark of_device_id match table as __devinitconst

Bjørn Mork (5):
      net: sierra_net: device IDs for Aircard 320U++
      USB: cdc-wdm: Add Vodafone/Huawei K5005 support
      USB: option: Add Vodafone/Huawei K5005 support
      USB: qcserial: Add Sierra Wireless device IDs
      USB: serial: Enforce USB driver and USB serial driver match

Borislav Petkov (1):
      x86/smp: Fix topology checks on AMD MCM CPUs

Bruce Allan (1):
      e1000e: test for valid check_reset_block function pointer

Bryan Schumaker (2):
      NFS4: Set parsed mount data version to 4
      NFS: Use the NFS_DEFAULT_VERSION for v2 and v3 mounts

Chris Mason (2):
      Btrfs: init old_generation in get_old_root
      Btrfs: cast devid to unsigned long long for printk %llu

Chris Metcalf (2):
      tilegx network driver: initial support
      tile: fix bug in get_user() for 4-byte values

Christian Borntraeger (1):
      spinlock: Indicate that a lockup is only suspected

Christian Dietrich (2):
      ide: icside.c: Fix compile with CONFIG_BLK_DEV_IDEDMA_ICS=n
      ide: icside.c: fix printk format string compile warning

Christoph Fritz (1):
      usb: gadget: regression fix - usage of usb_ep

Chun-Yeow Yeoh (1):
      mac80211: Fix Unreachable Mesh Station Problem when joining to
another MBSS

Dan Carpenter (3):
      NFSv4.1: integer overflow in decode_cb_sequence_args()
      NFS: add an endian notation for sparse
      USB: Checking the wrong variable in usb_disable_lpm()

Daniel Mack (1):
      USB: fix gathering of interface associations

Dave Jones (1):
      appletalk: Remove out of date message in printk

David Henningsson (1):
      ALSA: HDA: Pin fixup for Zotac Z68 motherboard

David S. Miller (1):
      Revert "niu: Add support for byte queue limits."

Devendra Naga (4):
      pinctrl: pinctrl-imx: free allocated pinctrl_map structure only
once and use kernel facilities for IMX_PMX_DUMP
      pinctrl: pinctrl-imx: free if of_get_parent fails to get the parent node
      pinctrl: pinctrl-mxs: Take care of frees if the kzalloc fails
      pinctrl: pinctrl-mxs: set platform driver data to NULL at
errpath and at unregister

Don Zickus (1):
      watchdog: Quiet down the boot messages

Dong Aisheng (1):
      pinctrl: pinctrl-imx: fix incorrect debug message of maps

Emil Goode (1):
      video: bfin_adv7393fb: Convert to kstrtouint_from_user

Emmanuel Grumbach (2):
      iwlwifi: don't mess up the SCD when removing a key
      iwlwifi: disable the buggy chain extension feature in HW

Eric Dumazet (13):
      drop_monitor: dont sleep in atomic context
      inetpeer: fix a race in inetpeer_gc_worker()
      net: l2tp_eth: fix kernel panic on rmmod l2tp_eth
      net: neighbour: fix neigh_dump_info()
      l2tp: fix a race in l2tp_ip_sendmsg()
      be2net: fix a race in be_xmit()
      virtio-net: fix a race on 32bit arches
      dummy: fix rcu_sched self-detected stalls
      lpc_eth: add missing ndo_change_mtu()
      lpc_eth: fix tx completion
      bonding: Fix corrupted queue_mapping
      netpoll: fix netpoll_send_udp() bugs
      bnx2x: fix checksum validation

Evan McNabb (1):
      USB: ftdi-sio: Add support for RT Systems USB-RTS01 serial adapter

Fabio Estevam (1):
      regmap: Fix the size calculation for map->format.buf_size

Felix Fietkau (1):
      mac80211: add missing rcu_read_lock/unlock in agg-rx session timer

Fred Isaman (2):
      NFS4: Fix open bug when pnfs module blacklisted
      NFS: fix directio refcount bug on commit

Geert Uytterhoeven (2):
      m68k: Use generic strncpy_from_user(), strlen_user(), and strnlen_user()
      sh: Setup CROSS_COMPILE at the top

Giuseppe CAVALLARO (5):
      net: icplus: fix interrupt mask
      stmmac: fix driver's doc when run kernel-doc script
      stmmac: update driver's doc
      stmmac: fix driver Kconfig when built as module
      stmmac: fix driver built w/ w/o both pci and platf modules

Grazvydas Ignotas (1):
      usb: musb_gadget: fix crash caused by dangling pointer

Greg Ungerer (4):
      m68k: fix inclusion of arch_gettimeoffset for non-MMU 68k
classic CPU types
      m68knommu: fix 68328 local setting of timer interrupt handler
      m68knommu: fix 68360 local setting of timer interrupt handler
      m68k: make syscall_trace_enter/leave exist for non-MMU classic m68k types

Guennadi Liakhovetski (1):
      pinctrl: fix a minor harmless typo

Haiyang Zhang (1):
      net/hyperv: Use wait_event on outstanding sends during device removal

Hans Schillstrom (1):
      netfilter: xt_HMARK: fix endianness and provide consistent hashing

Hans de Goede (1):
      usb-storage: Add 090c:1000 to unusal-devs

Haojian Zhuang (1):
      regulator: max8649: fix missing regmap in rdev

Hauke Mehrtens (1):
      bcma: fix null pointer in bcma_core_pci_irq_ctl

Heiko Stübner (3):
      regulator: gpio-regulator: do not pass drvdata pointer as reference
      regulator: gpio-regulator: Fix finding of smallest value
      regulator: gpio-regulator: populate selector from set_voltage

Herton Ronaldo Krzesinski (1):
      USB: EHCI: Fix build warning in xilinx ehci driver

Hugh Dickins (1):
      swap: fix shmem swapping when more than 8 areas

Ido Shayevitz (9):
      usb: gadget: atmel_usba_udc: Remove unneeded condition
      usb: gadget: fsl_qe_udc: Remove unneeded condition
      usb: gadget: fsl_udc_core: Remove unneeded condition
      usb: gadget: goku_udc: Remove unneeded condition
      usb: gadget: mv_udc_core: Remove unneeded condition
      usb: gadget: omap_udc: Remove unneeded condition
      usb: gadget: pxa25x_udc: Remove unneeded condition
      usb: gadget: s3c2410_udc: Remove unneeded condition
      usb: gadget: s3c-hsudc.c: Remove unneeded condition

J. Bruce Fields (1):
      nfsd4: BUG_ON(!is_spin_locked()) no good on UP kernels

James Bottomley (1):
      [SCSI] Fix sd_probe_domain config problem

Jan Kara (1):
      writeback: Fix lock imbalance in writeback_sb_inodes()

Jan Safrata (1):
      usb: use usb_serial_put in usb_serial_probe errors

Jan Schmidt (6):
      Btrfs: remove call to btrfs_header_nritems with no effect
      Btrfs: remove obsolete btrfs_next_leaf call from __resolve_indirect_ref
      Btrfs: use btrfs_read_lock_root_node in get_old_root
      Btrfs: fix return value for __tree_mod_log_oldest_root
      Btrfs: add btrfs_next_old_leaf
      Btrfs: fix race in tree mod log addition

Jeff Layton (1):
      rpc_pipefs: allow rpc_purge_list to take a NULL waitq pointer

Jeffrin Jose (1):
      leds: fixed a coding style issue.

Jerome Glisse (1):
      drm/radeon: fix tiling and command stream checking on evergreen v3

Jingoo Han (2):
      video: s3c-fb: clear SHADOWCON register when clearing hardware
window registers
      video: s3c-fb: fix possible division by zero in s3c_fb_calc_pixclk

Joe Perches (3):
      can: cc770: Fix likely misuse of | for &
      mac80211: Fix likely misuse of | for &
      brcmfmac: Fix likely misuse of | for &

Joern Engel (2):
      target: Add TFO->put_session() caller for HW fabric session shutdown
      tcm_qla2xxx: Convert to TFO->put_session() usage

Johan Hovold (2):
      USB: option: fix port-data abuse
      USB: option: fix memory leak

Johannes Berg (8):
      iwlwifi: fix TX power antenna access
      mac80211_hwsim: advertise interface combinations
      mac80211: clean up remain-on-channel on interface stop
      iwlwifi: disable WoWLAN if !CONFIG_PM_SLEEP
      iwlwifi: fix double free/complete in firmware loading
      iwlwifi: unregister LEDs if mac80211 registration fails
      cfg80211: fix interface combinations check
      wireless: add my new trees to MAINTAINERS

John Fastabend (2):
      ixgbe: fix_features rxvlan is independent of DCB and needs to be set
      ixgbe: IXGBE_RXD_STAT_VP set even with Rx stripping enabled

Jon Povey (1):
      usb: musb: davinci: Fix build breakage

Josef Bacik (10):
      Btrfs: pass locked_page into extent_clear_unlock_delalloc if
theres an error
      Btrfs: fix locking in btrfs_destroy_delayed_refs
      Btrfs: wake up transaction waiters when aborting a transaction
      Btrfs: abort the transaction if the commit fails
      Btrfs: fix btrfs_destroy_marked_extents
      Btrfs: unlock everything properly in the error case for nocow
      Btrfs: use rcu to protect device->name
      Btrfs: implement ->show_devname
      Btrfs: keep inode pinned when compressing writes
      Btrfs: call filemap_fdatawrite twice for compression

Julia Lawall (1):
      drivers/ide/ide-cs.c: adjust suspicious bit operation

Konrad Rzeszutek Wilk (5):
      xen/hvc: Collapse error logic.
      xen/hvc: Fix error cases around HVM_PARAM_CONSOLE_PFN
      xen/hvc: Check HVM_PARAM_CONSOLE_[EVTCHN|PFN] for correctness.
      xen/events: Add WARN_ON when quick lookup found invalid type.
      xen/balloon: Subtract from xen_released_pages the count that is populated.

Kyle McMartin (1):
      panic: Make panic_on_oops configurable

Laurent Pinchart (2):
      serial: sh-sci: Fix probe error paths
      serial: sh-sci: Make probe fail for ports that exceed the maximum count

Li Zefan (2):
      Btrfs: fix defrag regression
      Btrfs: fix incompat flags setting

Liam Girdwood (3):
      ASoC: dapm: Fix connected widget capture path query.
      ASoC: dpcm: Fix dpcm_get_be() to check that DAI is BE
      ASoC: dapm: Fix input list to use source widgets

Linus Torvalds (1):
      Linux 3.5-rc3

Linus Walleij (2):
      pinctrl: nomadik: add clk_prepare() call
      pinctrl: nomadik: fix up typo

Liu Bo (5):
      Btrfs: fix missing inherited flag in rename
      Btrfs: do not resize a seeding device
      Btrfs: avoid memory leak of extent state in error handling routine
      Btrfs: make sure that we've made everything in pinned tree clean
      Btrfs: update MAINTAINERS info for BTRFS FILE SYSTEM

Marcelo Tosatti (1):
      x86: kvmclock: remove check_and_clear_guest_paused warning

Marek Szyprowski (3):
      ARM: mm: fix type of the arm_dma_limit global variable
      ARM: dma-mapping: fix debug messages in dmabounce code
      x86: dma-mapping: fix broken allocation when dma_mask has been provided

Mark Brown (4):
      ASoC: wm8994: Ensure all AIFnCLK events are run from the _late variants
      ASoC: wm8994: Apply volume updates with clocks enabled
      regmap: Export regmap_reinit_cache()
      ASoC: wm2000: Always use a 4s timeout for the firmware

Martin Pelikan (1):
      x86, um: Correct syscall table type attributes breaking gcc 4.8

Mathias Krause (1):
      crypto: aesni-intel - fix unaligned cbc decrypt for x86-32

Matt Carlson (1):
      tg3: Apply short DMA frag workaround to 5906

Meenakshi Venkataraman (2):
      mac80211: fix error in station state transitions during reconfig
      iwlwifi: use correct supported firmware for 6035 and 6000g2

Miao Xie (1):
      Btrfs: destroy the items of the delayed inodes in error handling routine

Mikko Tuumanen (1):
      USB: serial: cp210x: add Optris MS Pro usb id

Nicholas Bellinger (1):
      tcm_qla2xxx: Clear session s_id + loop_id earlier during shutdown

Oleksij Rempel (1):
      b43: do not call ieee80211_unregister_hw if we are not registred

Otto Meta (1):
      usb: cdc-acm: fix devices not unthrottled on open

Pablo Neira Ayuso (1):
      netfilter: nf_ct_h323: fix bug in rtcp natting

Paul Bolle (2):
      sparc: remove two unused headers
      sh: Kill off last dead UBC header

Paul E. McKenney (4):
      rcu: RCU_FAST_NO_HZ detection of callback adoption
      rcu: Update RCU_FAST_NO_HZ tracing for lazy callbacks
      rcu: Move RCU_FAST_NO_HZ per-CPU variables to rcu_dynticks structure
      rcu: Precompute RCU_FAST_NO_HZ timer offsets

Paul Mackerras (1):
      Make hard_irq_disable() actually hard-disable interrupts

Paul Mundt (12):
      sh: arch/sh/kernel/process.c needs asm/fpu.h for unlazy_fpu().
      sh64: Fix up fallout from generic init_task conversion.
      sh: convert to kbuild asm-generic support.
      bug.h: need linux/kernel.h for TAINT_WARN.
      clocksource: sh_cmt: Convert timer lock to raw spinlock.
      clocksource: sh_mtu2: Convert timer lock to raw spinlock.
      clocksource: sh_tmu: Convert timer lock to raw spinlock.
      clocksource: sh_tmu: Use clockevents_config_and_register().
      sh: switch to generic strncpy_from_user().
      sh: use the new generic strnlen_user() function
      sh: Fix up link time defsym warnings.
      sh: Kill off additional asm-generic wrappers.

Paul Pluzhnikov (1):
      net: Make linux/tcp.h C++ friendly (trivial)

Paulo Zanoni (1):
      drm: increase DRM_OBJECT_MAX_PROPERTY to 24

Peter Korsgaard (1):
      hwrng: atmel-rng - fix race condition leading to repeated bits

Qasim Javed (1):
      mac80211_hwsim: Set IEEE80211_STAT_ACK flag when userspace
indicates that the frame has been acknowledged.

Rafal Prylowski (1):
      leds: don't disable blinking when writing the same value to
delay_on or delay_off

Randy Dunlap (3):
      net/core: fix kernel-doc warnings
      netdev: fix drivers/net/phy/ kernel-doc warnings
      exofs: fix sparse non-ANSI function warning

Ricardo Martins (1):
      USB: fix PS3 EHCI systems

Richard Zhao (1):
      ASoC: imx-audmux: add pinctrl support

Roland Dreier (7):
      net: Reorder initialization in ip_route_output to fix gcc warning
      target: Return error to initiator if SET TARGET PORT GROUPS
emulation fails
      tcm_qla2xxx: Don't insert nacls without sessions into the btree
      qla2xxx: Don't crash if we can't find cmd for failed CTIO
      qla2xxx: Don't leak commands we give up on in qlt_do_work()
      tcm_qla2xxx: tcm_qla2xxx_handle_tmr() can be static
      tcm_qla2xxx: Handle malformed wwn strings properly

Roland Stigge (1):
      USB: ohci-hub: Mark ohci_finish_controller_resume() as __maybe_unused

Sachin Kamat (2):
      ARM: dma-mapping: Add missing static storage class specifier
      qla2xxx: Remove version.h header file inclusion

Sachin Prabhu (1):
      NFSv2: EOF incorrectly set on short read

Sarah Sharp (1):
      xhci: Fix error path return value.

Sasha Levin (1):
      NFC: Fix possible NULL ptr deref when getting the name of a socket

Seiji Aguchi (1):
      kdump: Execute kmsg_dump(KMSG_DUMP_PANIC) after smp_send_stop()

Seth Forshee (1):
      bcma: add ext PA workaround for BCM4331 and BCM43431

Shimoda, Yoshihiro (1):
      usb: ehci-sh: fix illegal phy_init() running when platform_data is NULL

Stanislav Kinsbursky (1):
      NFS: hard-code init_net for NFS callback transports

Stanislav Yakovlev (1):
      net/wireless: ipw2100: Fix WARN_ON occurring in wiphy_register
called by ipw2100_pci_init_one

Stanislaw Gruszka (4):
      mac80211: run scan after finish connection monitoring
      rt2x00: use atomic variable for seqno
      rtl8187: ->brightness_set can not sleep
      mac80211: add back channel change flag

Stefan Roese (1):
      net: stmmac: Fix clock en-/disable calls

Stefano Stabellini (1):
      xen: mark local pages as FOREIGN in the m2p_override

Stephane Eranian (1):
      perf/x86: Fix broken LBR fixup code

Stephen Boyd (1):
      memblock: Document memblock_is_region_{memory,reserved}()

Stephen Warren (2):
      regmap: clean up debugfs if regmap_init fails
      ASoC: tegra: add MODULE_DEVICE_TABLE to tegra30_ahub

Steve Dickson (1):
      NFS: Map minor mismatch error to protocol not support error.

Steven King (1):
      m68knommu: m528x qspi definition fix

Steven Newbury (1):
      ALSA: hda - HDMI Audio init all connectors when VGA-switcheroo is off

Steven Rostedt (1):
      tracing: Have tracing_off() actually turn tracing off

Takashi Iwai (9):
      ALSA: usb-audio: Fix substream assignments
      vga_switcheroo: Add a helper function to get the client state
      ALSA: hda - Fix uninitialized HDMI controllers with VGA-switcheroo
      vga_switcheroo: Fix error without CONFIG_VGA_SWITCHEROO
      vga_switcheroo: Enable/disable audio clients at the right time
      ALSA: hda - Fix detection of Creative SoundCore3D controllers
      ALSA: hda - Don't forget to call init verbs added by fixup list
      xhci: Fix invalid loop check in xhci_free_tt_info()
      xhci: Don't free endpoints in xhci_mem_cleanup()

Thomas Graf (1):
      ipv6: fib: Restore NTF_ROUTER exception in fib6_age()

Thomas Hellstrom (1):
      drm/ttm: Fix buffer object metadata accounting regression v2

Tom Cassidy (1):
      USB: serial: sierra: Add support for Sierra Wireless AirCard 320U modem

Tomi Valkeinen (4):
      OMAPDSS: fix build when DEBUG_FS or DSS_DEBUG_SUPPORT disabled
      OMAPDSS: Taal: fix compilation warning
      OMAPDSS: fix bogus WARN_ON in dss_runtime_put()
      OMAPDSS: fix registration of DPI and SDI devices

Tony Zelenoff (1):
      USB: mos7840: Fix compilation of usb serial driver

Trond Myklebust (9):
      NFSv4.1: Fix a request leak on the back channel
      NFSv4: Fix an Oops in the open recovery code
      NFSv4: Fix up decode_attr_mdsthreshold
      NFSv4.1: Convert a trivial printk into a dprintk
      NFSv4.1: Ensure we clear session state flags after a session creation
      NFS: Fix a commit bug
      NFS: Remove incorrect BUG_ON in nfs_found_client
      NFSv4.1: Convert another trivial printk into a dprintk
      NFSv4: Fix unnecessary delegation returns in nfs4_do_open

Vincent Bernat (1):
      snmp: fix OutOctets counter to include forwarded datagrams

Vinicius Costa Gomes (1):
      Bluetooth: Fix checking the wrong flag when accepting a socket

Vinod Koul (2):
      ALSA: compress_core: don't wake up on pause
      ALSA: compress_core: cleanup pointers on stop

Wanpeng Li (1):
      x86/mm: Fix some kernel-doc warnings

Weiping Pan (1):
      bonding:record primary when modify it via sysfs

Zhang, Yang Z (1):
      xen/pci: Check for PCI bridge before using it.

françois romieu (1):
      r8169: avoid NAPI scheduling delay.

nagalakshmi.nandigama@lsi.com (1):
      [SCSI] mpt2sas: Fix unsafe using smp_processor_id() in preemptible

stephen hemminger (1):
      sky2: fix checksum bit management on some chips

说不得 (1):
      USB: option: add more YUGA device ids
