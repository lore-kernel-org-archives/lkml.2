Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0LPDKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 22:10:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401Ab0LPDKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 22:10:53 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Dec 2010 19:10:28 -0800
Message-ID: <AANLkTikWYd1UOJgMHiBb-cZwEHVOFWPBupcf8unfEKxo@mail.gmail.com>
Subject: Linux 2.6.37-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been a bit over a week since -rc5, and now -rc6 is out. It was
slightly delayed by the fact that I was traveling without a laptop,
and while I was able to track things and read email, I didn't do
actual pulls for most of last week.

Nothing specific stands out - as should be at -rc6, it's basically
bugfixes. The appended shortlog hopefully fives some idea about
things, but it's about half drivers, and the rest is mostly some arch
updates (arm, sparc) and filesystems (btrfs, ceph, cifs, and small
ext4 regression fixes). And some networking.

The diffstat isn't quite as flat as I'd like to see at this stage, but
as I've mentioned to people: I'm not opening the merge window until
after the holidays, so we still have a few weeks to go. In particular,
we still have the PCI resource allocation regressions to work on.

Go forth and test. And please do remember to ping bugzilla (or
developers) about any regressions you find, whether new or old.

                        Linus

---
Aaro Koskinen (2):
      arm: omap2: io: fix clk_get() error check
      ext4: fix typo which broke '..' detection in ext4_find_entry()

Alan Cox (1):
      i2c_intel_mid: Fix slash in sysfs name

Alex Deucher (4):
      drm/radeon/kms: fix formatting of vram and gtt info
      drm/radeon/kms: fix vram base calculation on rs780/rs880
      drm/kms: remove spaces from connector names (v2)
      drm/radeon/kms: don't apply 7xx HDP flush workaround on AGP

Alexander V. Lukyanov (1):
      tulip: fix hang in dmfe driver on sending of big packet

Alexey Starikovskiy (1):
      ACPI: EC: Add another dmi match entry for MSI hardware

Anatolij Gustschin (1):
      dmaengine: imx-sdma: fix bug in buffer descriptor initialization

Anders Franzen (1):
      Make the ip6_tunnel reflect the true mtu.

Andrei Konovalov (1):
      EDAC: Correct MiB_TO_PAGES() macro

Andrej Ota (1):
      pppoe.c: Fix kernel panic caused by __pppoe_xmit

Andrew Kephart (1):
      fbdev: Fix fb_find_nearest_mode refresh comparison

Andrew Vasquez (1):
      [SCSI] qla2xxx: Correct issue where NPIV-config data was not
being allocated for 82xx parts.

Aneesh Kumar K.V (1):
      nfs: Discard ACL cache on mode update

Anil Ravindranath (1):
      [SCSI] pmcraid: disable msix and expand device config entry

Anisse Astier (2):
      msi-wmi: Add mute key support
      msi-wmi: fix semantically incorrect use of keycode instead of scancode

Anssi Hannula (3):
      ALSA: hda - Do not wrongly restrict min_channels based on ELD
      ALSA: hda - Always allow basic audio irrespective of ELD info
      ALSA: hda - Reset sample sizes and max bitrates when reading ELD

Apollon Oikonomopoulos (1):
      x25: decrement netdev reference counts on unload

Arnaldo Carvalho de Melo (2):
      perf symbols: Fix kallsyms kernel/module map splitting
      perf record: Fix eternal wait for stillborn child

Axel Lin (4):
      dma: imx-dma: fix imxdma_probe error path
      dma: intel_mid_dma: fix double free on mid_setup_dma error path
      ASoC: Hold client_mutex while calling snd_soc_instantiate_cards()
      ASoC: Fix resource leak if soc_register_ac97_dai_link failed

Bala Shanmugam (1):
      Bluetooth: Add new PID for Atheros 3011

Bastien Nocera (1):
      Input: add keycodes for touchpad on/off keys

Ben Dooks (1):
      ARM: mini2440: Fix Kconfig to allow kernel to build

Ben Hutchings (2):
      sfc: Fix crash in legacy onterrupt handler during ring reallocation
      sfc: Fix NAPI list corruption during ring reallocation

Borislav Petkov (2):
      EDAC: Fix workqueue-related crashes
      amd64_edac: Fix interleaving check

Breno Leitao (1):
      ehea: Fixing LRO configuration

Carmelo AMOROSO (1):
      sh: wire up accept4 syscall (non-multiplexed path)

Casey Leedom (1):
      cxgb4vf: Ingress Queue Entry Size needs to be 64 bytes

Catalin Marinas (2):
      ARM: 6527/1: Use CTR instead of CCSIDR for the D-cache line size on ARMv7
      ARM: 6528/1: Use CTR for the I-cache line size on ARMv7

Changli Gao (1):
      ifb: goto resched directly if error happens and dp->tq isn't empty

Chris Bagwell (1):
      eeepc-wmi: add cpufv sysfs documentation

Chris Mason (3):
      Btrfs: EIO when we fail to read tree roots
      Btrfs: account for missing devices in RAID allocation profiles
      Btrfs: prevent RAID level downgrades when space is low

Chris Wilson (10):
      drm/i915: Clean conflicting modesetting registers upon init
      drm/i915: Death to the unnecessary 64bit divide
      drm/i915: Factor in pixel-repeat in FDI M/N calculation
      drm/i915/ringbuffer: Only print an error on the second attempt
to reset head
      drm/i915/lvds: Always restore panel-fitter when enabling the LVDS
      drm/i915: Emit a request to clear a flushed and idle ring for unbusy bo
      drm/i915/dp: Only apply the workaround if the select is still active
      drm: Add missing drm_vblank_put() along queue vblank error path
      drm: Don't try and disable an encoder that was never enabled
      ACPI: video: fix build for CONFIG_ACPI=n

Christian Lamparter (2):
      carl9170: fix carl9170_tx_prepare typo
      mac80211: ignore non-bcast mcast deauth/disassoc franes

Christof Schmitt (1):
      [SCSI] zfcp: Issue FCP command without holding SCSI host_lock

Christoph Hellwig (1):
      xfs: log timestamp changes to the source inode in rename

Chuck Lever (1):
      NFS: Fix panic after nfs_umount()

Corentin Chary (1):
      asus-laptop: add wimax and wwan support

Dan Carpenter (3):
      IB/uverbs: Handle large number of entries in poll CQ
      drm: use after free in drm_queue_vblank_event()
      [SCSI] osd: checking NULL instead of ERR_PTR()

Dan Williams (2):
      intel_mid_dma: fix section mismatch warnings
      atm: correct sysfs 'device' link creation and parent relationships

Daniel Drake (1):
      libertas: fix memory corruption in lbs_remove_card()

Daniel Hellstrom (1):
      SPARC/LEON: removed constant timer initialization as if HZ=100,
now it reflects the value of HZ

Daniel T Chen (2):
      ALSA: hda: Use model=lg quirk for LG P1 Express to enable
playback and capture
      ALSA: hda: Use position_fix=1 for Acer Aspire 5538 to enable
capture on internal mic

Daniel Vetter (1):
      drm/i915: announce to userspace that the bsd ring is coherent

Daniel Walker (1):
      MAINTAINERS: update MSM git tree

Danny Huang (4):
      regulator: tps6586x: Add missing bit mask generation
      regulator: tps6586x: Fix TPS6586X_DVM to store goreg/bit
      regulator: tps6586x: Handle both enable reg/bits being the same
      regulator: tps6586x: correct register table

Dave Airlie (1):
      drm/i915: i915 cannot provide switcher services.

Dave Martin (2):
      ARM: 6533/1: Thumb-2: Make CONFIG_THUMB2_KERNEL depend on !CPU_V6
      ARM: 6534/1: Make CONFIG_FPE_NWFPE depend on !CONFIG_THUMB2_KERNEL

David Foley (2):
      Input: wacom - add IDs for two new Bamboo PTs
      Input: wacom - add new Bamboo PT (0xdb)

David Henningsson (1):
      ALSA: HDA: Quirk for Dell Vostro 320 to make microphone work

David Howells (1):
      MN10300: Fix interrupt mask alteration function call name in gdbstub

David Kilroy (4):
      orinoco: abort scan on interface down
      orinoco: initialise priv->hw before assigning the interrupt
      orinoco: clear countermeasure setting on commit
      orinoco: fix TKIP countermeasure behaviour

David McCullough (1):
      net/ipv6/sit.c: return unhandled skb to tunnel4_rcv

David S. Miller (10):
      sparc64: Delete prom_puts() unused.
      sparc: Remove prom_pathtoinode()
      sparc: Kill prom devops_{32,64}.c
      sparc64: Unexport prom_service_exists().
      sparc64: Delete prom_setcallback().
      sparc: Do not export prom_nb{get,put}char().
      sparc: Pass buffer pointer all the way down to prom_{get,put}char().
      sparc: Delete prom_*getchar().
      sparc: Write to prom console using indirect buffer.
      econet: Fix crash in aun_incoming().

David Strand (1):
      bonding: check for assigned mac before adopting the slaves mac address

Dimitris Michailidis (1):
      cxgb4: fix MAC address hash filter

Dmitry Torokhov (2):
      eeepc-wmi: fix compiler warning
      Input: document struct input_absinfo

Don Skidmore (1):
      ixgbe: fix possible NULL pointer deference in shutdown path

Eric Anholt (2):
      drm/i915: Always set the DP transcoder config to 8BPC.
      drm/i915: Apply a workaround for transitioning from DP on pipe B to HDMI.

Eric Dumazet (5):
      filter: fix sk_filter rcu handling
      llc: fix a device refcount imbalance
      tcp: avoid a possible divide by zero
      tcp: protect sysctl_tcp_cookie_size reads
      net: fix skb_defer_rx_timestamp()

Felix Fietkau (3):
      ath9k_hw: fix endian issues with CTLs on AR9003
      ath9k_hw: fix more bitfield related endian issues
      ath9k: fix a DMA related race condition on reset

Forrest Shi (1):
      fsldma: fix issue of slow dma

Franck Bui-Huu (1):
      perf header: Don't assume there's no attr info if no sample ids
is provided

Gabor Juhos (2):
      ath9k: use per-device struct for pm_qos_* operations
      Input: add input driver for polled GPIO buttons

Gabriele Gorla (2):
      hwmon: (adm1026) Fix setting fan_div
      hwmon: (adm1026) Allow 1 as a valid divider value

Giuseppe CAVALLARO (1):
      phy: add the IC+ IP1001 driver

Glenn Sommer (1):
      Input: usbtouchscreen - add support for LG Flatron T1710B

Gustavo F. Padovan (1):
      Bluetooth: Fix not returning proper error in SCO

Hauke Mehrtens (1):
      b44: fix workarround for wap54g10

Heiko Carstens (3):
      printk: Fix wake_up_klogd() vs cpu hotplug
      nohz: Fix printk_needs_cpu() return value on offline cpus
      [S390] nohz/s390: fix arch_needs_cpu() return value on offline cpus

Helmut Schaa (1):
      mac80211: Fix BUG in pskb_expand_head when transmitting shared skbs

Herb Shiu (3):
      ceph: Handle file locks in replies from the MDS.
      ceph: pass lock information by struct file_lock instead of as
individual params.
      ceph: Behave better when handling file lock replies.

Hitoshi Mitake (1):
      workqueue: check the allocation of system_unbound_wq

Huang Ying (1):
      ACPI, APEI, use raw spinlock in ERST

Ian Kent (1):
      autofs4 - remove ioctl mutex (bz23142)

Ira W. Snyder (1):
      hwmon: (ltc4215) make sysfs file match the alarm cause

James Bottomley (1):
      [SCSI] Eliminate error handler overload of the SCSI serial number

James Smart (1):
      [SCSI] bsg: correct fault if queue object removed while dev_t open

Jan Beulich (4):
      Btrfs: fix compiler warnings
      ACPI/PNP: avoid section mismatch warning
      ACPI: eliminate unused variable warning for !ACPI_SLEEP
      ACPI/HEST: adjust section selection

Jason Chagas (1):
      ARM: mmp2: remove not used clk_rtc

Jason Wessel (1):
      kgdboc,input: Fix regression with keyboard release key and early debugging

Jassi Brar (1):
      ASoC: WM8580: Debug BCLK and sample size

Javier Cardona (3):
      ath5k: Fix beaconing in mesh mode
      ath5k: Prevent mesh interfaces from being counted as ad-hoc
      ath5k: Put the right tsf value in mesh beacons

Jean Delvare (1):
      hwmon: (it87) Fix manual fan speed control on IT8721F

Jeff Layton (4):
      cifs: fix use of CONFIG_CIFS_ACL
      cifs: remove Local_System_Name
      cifs: fix check of error return from is_path_accessable
      cifs: allow calling cifs_build_path_to_root on incomplete cifs_sb

Jeremy Fitzhardinge (2):
      x86/pvclock: Zero last_value on resume
      xen: Provide a variant of __RING_SIZE() that is an integer
constant expression

Jerome Glisse (1):
      drm/radeon/kms: forbid big bo allocation (fdo 31708) v3

Jiandong Zheng (1):
      Change bcmring Maintainer list.

Joe Jin (1):
      driver/net/benet: fix be_cmd_multicast_set() memcpy bug

Joe Perches (1):
      drivers/dma/ppc4xx: Use printf extension %pR for struct resource

Johannes Berg (1):
      ath9k/carl9170: advertise P2P

John Baboval (1):
      ALSA: hda - Fix ThinkPad T410[s] docking station line-out

John W. Linville (1):
      Revert "ath9k: Fix STA disconnect issue due to received MIC
failed bcast frames"

Jon Dowland (1):
      toshiba_acpi.c: Add key_entry for a lone FN keypress

Josef Bacik (5):
      Btrfs: fix use after free in O_DIRECT
      Btrfs: deal with space cache errors better
      Btrfs: do not do fast caching if we are allocating blocks for tree_root
      Btrfs: fixup return code for btrfs_del_orphan_item
      Btrfs: do not BUG if we fail to remove the orphan item for dead snapshots

Jouni Malinen (1):
      mac80211: Fix frame injection using non-AP vif

Julia Lawall (1):
      drivers/platform/x86/thinkpad_acpi.c: delete double assignment

Kenji Kaneshige (1):
      genirq: Fix incorrect proc spurious output

Kevin Hilman (3):
      omap: PM debug: fix wake-on-timer debugfs dependency
      OMAP1: SRAM: fix size for OMAP1611 SoCs
      OMAP2+: PM/serial: fix console semaphore acquire during suspend

Kim Lilliestierna XX (1):
      CAIF: Fix U5500 compile error for shared memory driver

Krzysztof Halasa (1):
      WAN: Fix a TX IRQ causing BUG() in PC300 and PCI200SYN drivers.

Kyle McMartin (1):
      MAINTAINERS: remove me from tulip

Len Brown (2):
      intel_idle: recognize ARAT on WSM-EX
      ACPI: video: fix build for VIDEO_OUTPUT_CONTROL=n

Li Zefan (2):
      Btrfs: Fix a crash when mounting a subvolume
      Btrfs: Make async snapshot ioctl more generic

Lin Ming (2):
      acpi: fix _OSI string setup regression
      ACPI: fix allowing to add/remove multiple _OSI strings

Linus Torvalds (2):
      Call the filesystem back whenever a page is removed from the page cache
      Linux 2.6.37-rc6

Madhuranath Iyengar (1):
      [SCSI] qla2xxx: Update version number to 8.03.05-k0.

Major Lee (1):
      dw_spi: Fix missing final read in some polling situations

Manoj Iyer (1):
      ALSA: hda - Enable jack sense for Thinkpad Edge 13

Marek Vasut (2):
      ARM: pxa: fix pxa2xx-flash section mismatch
      ARM: pxa/palm: fix ifdef around gen_nand driver registration

Mark Brown (1):
      ASoC: Correct WM8962 interrupt mask register read

Martin Lucina (1):
      net: Document the kernel_recvmsg() function

Matteo Croce (1):
      ath9k: fix bug in tx power

Mi Jinlong (1):
      nfs: kernel should return EPROTONOSUPPORT when not support NFSv4

Michael S. Tsirkin (1):
      vhost: correctly set bits of dirty pages

Michal Marek (1):
      l2tp: Fix modalias of l2tp_ip

Mike Hernandez (2):
      [SCSI] qla2xxx: Populate Command Type 6 LUN field properly.
      [SCSI] qla2xxx: Change MSI initialization from using incorrect
request_irq parameter.

Mike Miller (1):
      [SCSI] hpsa: fix redefinition of PCI_DEVICE_ID_CISSF

Miklos Szeredi (2):
      fuse: fix ioctl when server is 32bit
      fuse: verify ioctl retries

Ming Lei (1):
      perf symbols: Figure out start address of kernel map from kallsyms

Namhyung Kim (1):
      Input: turbografx - fix reference counting

Nandita Dukkipati (1):
      tcp: Bug fix in initialization of receive window.

Neil Brown (1):
      nfsd: Fix possible BUG_ON firing in set_change_info

Neil Horman (1):
      net: Convert netpoll blocking api in bonding driver to be a counter

NeilBrown (6):
      sunrpc: prevent use-after-free on clearing XPT_BUSY
      md: remove handling of flush_pending in md_submit_flush_data
      md: move code in to submit_flushes.
      md: fix possible deadlock in handling flush requests.
      md: fix bug with re-adding of partially recovered device.
      md: protect against NULL reference when waiting to start a raid10.

Nelson Elhage (1):
      econet: Do the correct cleanup after an unprivileged SIOCSIFADDR.

Nicolas Dichtel (1):
      ipv6: fix nl group when advertising a new link

Nicolas Ferre (1):
      dmaengine: at_hdmac: fix buffer transfer size specification

Ohad Ben-Cohen (1):
      omap: zoom: wl1271 slot is MMC_CAP_POWER_OFF_CARD

Paul Mundt (1):
      sh: Enable deprecated IRQ chip APIs for MFD and GPIOLIB drivers.

Paul Walmsley (1):
      OMAP2: PRCM: fix some SHIFT macros that were actually bitmasks

Rafael J. Wysocki (4):
      ACPI / PM: Check device state before refcounting power resources
      ACPI / PM: Do not refcount power resources that can't be turned on
      r8169: Fix runtime power management
      ACPI / PM: Do not save/restore NVS on Sony Vaio VGN-NW130D

Rajkumar Manoharan (2):
      ath9k: Disable SWBA interrupt on remove_interface
      ath9k: fix beacon resource related race condition

Randy Dunlap (2):
      ibm_rtl: fix printk format warning
      crypto: ghash-intel - ghash-clmulni-intel_glue needs err.h

Ron Mercer (1):
      qlge: Fix deadlock when cancelling worker.

Russell King (1):
      ARM: Update mach-types

Sage Weil (3):
      ceph: avoid possible null deref in readdir after dir llseek
      ceph: fix ioctl magic
      Btrfs: fix sync subvol/snapshot creation

Sascha Hauer (1):
      dmaengine i.MX SDMA: initialize on module_init

Saurav Kashyap (1):
      [SCSI] qla2xxx: Properly set the return value in
qla2xxx_eh_abort function.

Sebastian Ott (1):
      [S390] css: fix rsid evaluation for 2nd crw

Senthil Balasubramanian (3):
      mac80211: Fix STA disconnect due to MIC failure
      ath9k: Fix STA disconnect issue due to received MIC failed bcast frames
      ath9k: Fix STA disconnect issue due to received MIC failed bcast frames

Sergey Vlasov (1):
      NFS: Fix fcntl F_GETLK not reporting some conflicts

Stefan Richter (2):
      firewire: ohci: fix regression with VIA VT6315, disable MSI
      firewire: ohci: fix regression with Agere FW643 rev 06, disable MSI

Stefan Seyfried (1):
      Bluetooth: Fix log spamming in btusb due to autosuspend

Stephen Hemminger (1):
      connector: add module alias

Steven Rostedt (1):
      workqueue: It is likely that WORKER_NOT_RUNNING is true

Sujith Manoharan (1):
      ath9k_htc: Fix suspend/resume

Sukumar Ghorai (1):
      omap: nand: remove hardware ECC as default

Suresh Jayaraman (2):
      cifs: add attribute cache timeout (actimeo) tunable
      cifs: remove bogus remapping of error in cifs_filldir()

Sven Neumann (1):
      libertas: fix invalid access

Swen Schillig (4):
      [SCSI] zfcp: Fix common FCP request reception
      [SCSI] zfcp: Correct false abort data assignment.
      [SCSI] zfcp: No ERP escalation on gpn_ft eval
      [SCSI] zfcp: Prevent usage w/o holding a reference

Takashi Iwai (1):
      agp/intel: Fix wrong kunmap in i830_cleanup()

Tavis Ormandy (1):
      install_special_mapping skips security_file_mmap check.

Tejun Heo (1):
      MAINTAINERS: Add workqueue entry

Thadeu Lima de Souza Cascardo (1):
      wmi: use memcmp instead of strncmp to compare GUIDs

Theodore Ts'o (1):
      ext4: Turn off multiple page-io submission by default

Thomas Bogendoerfer (1):
      hso: IP checksuming doesn't work on GE0301 option cards

Thomas Egerer (1):
      xfrm: Fix xfrm_state_migrate leak

Tom Herbert (1):
      tcp: Replace time wait bucket msg by counter

Tomoya MORINAGA (1):
      dma : EG20T PCH: Fix miss-setting DMA descriptor

Tracey Dent (2):
      drivers/dma/: Use the ccflag-y instead of EXTRA_CFLAGS
      drivers/dma/ioat: Use the ccflag-y instead of EXTRA_CFLAGS

Trond Myklebust (5):
      NFS: Ensure we use the correct cookie in nfs_readdir_xdr_filler
      NFS: Fix a memory leak in nfs_readdir
      NFS: nfs_readdir_search_for_cookie() don't mark as eof if cookie not found
      NFS: Readdir cleanups
      nfs: remove extraneous and problematic calls to nfs_clear_request

Uk Kim (2):
      ASoC: Fix off by one error in WM8994 EQ register bank size
      ASoC: Fix swap of left and right channels for WM8993/4 speaker boost gain

Valentine Barshak (1):
      ARM: 6535/1: V6 MPCore v6_dma_inv_range and v6_dma_flush_range RWFO fix

Vasanthakumar Thiagarajan (1):
      ath9k: Fix bug in reading input gpio state for ar9003

Vasanthy Kolluri (1):
      enic: Bug Fix: Pass napi reference to the isr that services receive queue

Vasiliy Kulikov (1):
      arm: plat-omap: counter_32k: use IS_ERR() instead of NULL check

Vasily Khoruzhick (1):
      ARM: S3C24XX: Fix mess with gpio {set,get}_pull callbacks

Vernon Mauery (2):
      ibm_rtl: Loosen the DMI criteria to all IBM machines
      ibm_rtl: _RTL_ is not available in UEFI mode

Vlad Lungu (1):
      stmmac: priv->lock can be used uninitialized

Vladislav Zolotarov (3):
      bnx2x: LSO code was broken on BE platforms
      bnx2x: Fixed a compilation warning
      bnx2x: Advance a version number to 1.60.01-0

Wei Yongjun (1):
      SCTP: Fix SCTP_SET_PEER_PRIMARY_ADDR to accpet v4mapped address

Xin Zhong (1):
      Btrfs: pwrite blocked when writing from the mmaped buffer of the same page

Yan Li (1):
      Input: synaptics - fix handling of 2-button ClickPads

Yan, Zheng (1):
      Btrfs: Fix page leak in compressed writeback path

Yauhen Kharuzhy (3):
      ARM: SMDK2416: Select MACH_SMDK, S3C_DEV_NAND, S3C_DEV_USB_HOST
      ARM: S3C2443: Select properly ARM core type
      ARM: S3C2412: Fix typo in CONFIG_CPU_S3C2412_ONLY definition

Zeng Zhaoming (1):
      ACPI, hp-wmi: Fix memory leak in acpi query

Zhang Rui (4):
      ACPI ac: update AC status upon sysfs query
      ACPI battery: update status upon sysfs query
      ACPI: fix a section mismatch
      ACPI thermal: remove two unused functions
