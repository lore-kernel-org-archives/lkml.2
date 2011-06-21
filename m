Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab1FUEDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 00:03:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787Ab1FUEDt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 00:03:49 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Jun 2011 21:02:56 -0700
Message-ID: <BANLkTimiVpKavmKY=rsJP34dMQSq__Xn7g@mail.gmail.com>
Subject: Linux 3.0-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly the usual small driver one- (or few-) liners, and some bigger
changes to drm (and md). But also two new smallish drivers
(net/usb/kalmia.c, and the ADP8870 backlight driver). Some filesystem
fixes (btrfs, cifs, afs, xfs, nfsd).

And a couple of performance regressions: rcu doesn't need threads (and
avoiding them fixes a performance problem under certain loads) and the
conversion from spinlocks to mutexes for the anon_vma locking ended up
causing a scalability issue that required fixing.

          Linus

---
Adrian Knoth (3):
      ALSA: hdspm - Fix locking in snd_hdspm_midi_input_read
      ALSA: hdspm - Fix jumping external wordclock frequency in AutoSync mode
      ALSA: hdspm - Add firmware revision ID for RME MADI PCI version

Al Viro (18):
      fix leak in proc_set_super()
      ubifs: split allocation of ubifs_info into a separate function
      ubifs: fix sget races
      afs: fix sget() races, close leak on umount
      Delay struct net freeing while there's a sysfs instance refering to it
      xfs: fix ->mknod() return value on xfs_get_acl() failure
      VFS: Fix vfsmount overput on simultaneous automount
      bad_inode_permission() is safe from RCU mode
      cifs_permission() doesn't need to bail out in RCU mode
      coda_ioctl_permission() is safe in RCU mode
      logfs doesn't need ->permission() at all
      nilfs2_permission() doesn't need to bail out in RCU mode
      proc_fd_permission() is doesn't need to bail out in RCU mode
      reiserfs_permission() doesn't need to bail out in RCU mode
      proc_sys_permission() is OK in RCU mode
      kill obsolete comment for follow_down()
      fix comment in generic_permission()
      devcgroup_inode_permission: take "is it a device node" checks to
inlined wrapper

Alex Deucher (18):
      drm/radeon/kms: check modes against max pixel clock
      drm/radeon/kms: fix mac g5 quirk
      drm/radeon/kms: signed fix for evergreen thermal
      drm/radeon/kms: be more pedantic about the g5 quirk (v2)
      drm/radeon/kms: clear wb memory by default
      drm/radeon/kms: fix num crtcs for Cedar and Caicos
      drm/radeon/kms: rework atombios_get_encoder_mode()
      drm/radeon/kms: add missing external encoder action
      drm/radeon/kms: add support for load detection on dp bridges
      drm/radeon/kms: fix support for DDC on dp bridges
      drm/radeon/kms: issue blank/unblank commands for ext encoders
      drm/radeon/kms: fix handling of DP to LVDS bridges
      drm/radeon/kms/atom: AdjustPixelClock fixes for DP bridges
      drm/radeon/kms: set DP link config properly for DP bridges
      drm/radeon/kms: use helper functions for fence read/write
      drm/radeon/kms/atom: fix duallink on some early DCE3.2 cards
      drm/radeon/kms: add missing param for dce3.2 DP transmitter setup
      drm/radeon/kms/r6xx+: voltage fixes

Alexander Stein (1):
      drivers/tty/serial/pch_uart.c: don't oops if dmi_get_system_info
returns NULL

Ambresh K (1):
      gpio/omap4: Fix missing interrupts during device wakeup due to IOPAD.

Andrea Arcangeli (3):
      mm: remove khugepaged double thp vmstat update with CONFIG_NUMA=n
      mm: vmscan: do not use page_count without a page pin
      migrate: don't account swapcache as shmem

Andrew Jones (1):
      xen: support CONFIG_MAXSMP

Andrew Morton (1):
      drivers/video/backlight/adp8870_bl.c: add missed props.type conversion

Andrew Murray (1):
      Documentation: update printk-formats.txt

Andy Whitcroft (2):
      x86 idle: APM requires pm_idle/default_idle unconditionally when a module
      perf: clear out make flags when calling kernel make kernelver

Antoine Reversat (1):
      vlan: don't call ndo_vlan_rx_register on hardware that doesn't
have vlan support

Anton Blanchard (1):
      afs: afs_fill_page reads too much, or wrong data

Austin Zhang (1):
      HID: hid-multitouch: add support for Chunghwa multi-touch panel

Axel Lin (2):
      drivers/misc/spear13xx_pcie_gadget.c: fix a memory leak in
spear_pcie_gadget_probe error path
      drivers/leds/leds-asic3: make LEDS_ASIC3 depend on LEDS_CLASS

Balbir Singh (1):
      MAINTAINERS: Balbir has moved

Ben Hutchings (1):
      ARM: 6948/1: Fix .size directives for __arm{7,9}tdmi_proc_info

Ben Skeggs (3):
      drm/nouveau: fix big-endian switch
      drm/nv50/disp: fix gamma with page flipping overlay turned on
      drm/nouveau: fix assumption that semaphore dmaobj is valid in x-chan sync

Benjamin Tissoires (1):
      HID: hid-multitouch: fix broken eGalax

Borislav Petkov (2):
      init/calibrate.c: remove annoying printk
      KVM: MMU: Fix build warnings in walk_addr_generic()

Casey Bodley (1):
      nfsd: link returns nfserr_delay when breaking lease

Changli Gao (1):
      ppp: use PPP_TRANS instead of the magic number 0x20

Chris Mason (4):
      Btrfs: check the return value from set_anon_super
      Btrfs: drop the delalloc_bytes check in shrink_delalloc
      Btrfs: fix relocation races
      Btrfs: avoid delayed metadata items during commits

Christian Dietrich (1):
      drivers/gpu/drm: use printk_ratelimited instead of printk_ratelimit

Christian Gmeiner (1):
      drivers/misc/cs5535-mfgpt.c: fix wrong if condition

Christoph Hellwig (1):
      xfs: make log devices with write back caches work

Clemens Ladisch (1):
      ALSA: isight: adjust for new queueing API

Clive Stubbings (1):
      fs_enet: fix freescale FCC ethernet dp buffer alignment

Dan Carpenter (2):
      HID: hiddev: fix use after free in hiddev_release
      ubifs: dereferencing an ERR_PTR in ubifs_mount()

Dan Rosenberg (1):
      alpha: fix several security issues

Daniel J Blueman (1):
      drm/i915: Fix gen6 (SNB) missed BLT ring interrupts.

Dave Airlie (5):
      x86/uv/x2apic: update for change in pci bridge handling.
      drm: make debug levels match in edid failure code.
      drm/radeon: workaround a hw bug on some radeon chipsets with all-0 EDIDs.
      drm/radeon: avoid warnings from r600/eg irq handlers on powered off card.
      drm/nouveau: drop leftover debugging

Dave Jones (1):
      [CPUFREQ] Remove cpufreq_stats sysfs entries on module unload.

David Howells (3):
      AFS: Set s_id in the superblock to the volume name
      AFS: Use i_generation not i_version for the vnode uniquifier
      KEYS/DNS: Fix ____call_usermodehelper() to not lose the session keyring

David Miller (1):
      Bluetooth: Do not ignore errors returned from strict_strtol()

David Sterba (2):
      btrfs: fix dereference of ERR_PTR value
      btrfs: fix uninitialized return value

Dmitry Torokhov (1):
      Input: evdev - try to wake up readers only if we have full packet

Dr. David Alan Gilbert (1):
      BUILD_BUG_ON_ZERO: fix sparse breakage

Emil Velikov (1):
      drm/nouveau/pm: Prevent overflow in nouveau_perf_init()

Eric Dumazet (6):
      net: rfs: enable RFS before first data packet is received
      inet_diag: fix inet_diag_bc_audit()
      ipv4: fix multicast losses
      hp100: fix an skb->len race
      sgi-xp: fix a use after free
      netxen: fix race in skb->len access

Eric Miao (1):
      leds: fix the incorrect display in menuconfig

Eric W. Biederman (1):
      proc: Fix Oops on stat of /proc/<zombie pid>/ns/net

Fabio Estevam (1):
      ARM: mx51/sdma: Check the chip revision in run-time

Fernando Luis Vázquez Cao (2):
      IGMP snooping: set mrouters_only flag for IPv4 traffic properly
      IGMP snooping: set mrouters_only flag for IPv6 traffic properly

Filip Palian (1):
      Bluetooth: l2cap and rfcomm: fix 1 byte infoleak to userspace.

Florian Zeitz (1):
      ALSA: emu10k1: Add details for E-mu 0404 PCIe version

Francois Romieu (1):
      r8169: fix static initializers.

Geert Uytterhoeven (4):
      net/hplance: hplance_init() should be __devinit
      fbdev/atyfb: Fix 2 defined-but-not-used warnings
      w1: W1_MASTER_DS1WM should depend on GENERIC_HARDIRQS
      drivers/misc/apds990x.c: apds990x_chip_on() should depend on
CONFIG_PM || CONFIG_PM_RUNTIME

Grazvydas Ignotas (1):
      omap: pandora: fix NAND support

Greg Dietsche (1):
      savage: remove unnecessary if statement

Greg Ungerer (3):
      m68knommu: fix linker script exported name sections
      m68knommu: create config options for CPU classes
      m68k: use kernel processor defines for conditional optimizations

Guennadi Liakhovetski (1):
      fbdev: sh_mobile_hdmi: fix regression: statically enable RTPM

Guenter Roeck (4):
      hwmon: (asus_atk0110) Consolidate sysfs attribute initialization
      hwmon: (ibmaem) Initialize sysfs attributes
      hwmon: (ibmpex) Initialize sysfs attributes
      hwmon: (s3c) Initialize sysfs attributes

Hans Petter Selasky (1):
      Input: properly assign return value of clamp() macro.

Hans Schillstrom (1):
      IPVS netns exit causes crash in conntrack

Hans-Christian Egtvedt (4):
      avr32: fix use of non-existing portnr variable in at32_map_usart()
      avr32/at32ap: fix mapping of platform device id for USART
      avr32: set CONFIG_CC_OPTIMIZE_FOR_SIZE=y for all defconfigs
      avr32: make intc_resume() return void to conform to syscore_ops

Hillf Danton (1):
      sched: Fix need_resched() when checking peempt

Hugh Dickins (1):
      ksm: fix NULL pointer dereference in scan_get_next_rmap_item()

Ilija Hadzic (1):
      drm/radeon: fix GUI idle IH debug statements

Ingo Molnar (1):
      x86, MAINTAINERS: Add x86 MCE people

J. Bruce Fields (2):
      nfsd: fix dependency of nfsd on auth_rpcgss
      nfsd4: fix break_lease flags on nfsd open

Jan Kara (1):
      vfs: Fix data corruption after failed write in __block_write_begin()

Janusz Krzysztofik (1):
      Input: omap-keypad - add missing input_sync()

Jay Estabrook (2):
      alpha/drm: Cleanup Alpha support in DRM generic code
      alpha, drm: Remove obsolete Alpha support in MGA DRM code

Jean Delvare (3):
      MAINTAINERS: add entry for legacy eeprom driver
      Revert "drm/i915: Enable GMBUS for post-gen2 chipsets"
      hwmon: (coretemp) Drop unused struct members

Jeff Layton (3):
      cifs: don't allow cifs_reconnect to exit with NULL socket pointer
      cifs: show sec= option in /proc/mounts
      cifs: correctly handle NULL tcon pointer in CIFSTCon

Jeff Ohlstein (1):
      msm: timer: compensate for timer shift in msm_read_timer_count

Jesper Juhl (4):
      ieee802154: Don't leak memory in ieee802154_nl_fill_phy
      drm/i915: Don't leak in i915_gem_shmem_pread_slow()
      ALSA: 6fire: Fix double-free bug in usb6fire_fw_ezusb_upload()
      ipv4, ping: Remove duplicate icmp.h include

Jimmy Hon (1):
      HID: add quirk for HyperPen 10000U

Jingoo Han (3):
      video: s3c-fb: fix misleading kfree in remove function
      video: s3c-fb: fix virtual resolution checking
      video: s3c-fb: move enabling channel for window

Jiri Kosina (2):
      HID: hiddev: fix potential use-after-free
      Revert "HID: magicmouse: ignore 'ivalid report id' while switching modes"

Joe Perches (5):
      HID: MAINTAINERS: Update USB HID/HIDBP DRIVERS pattern
      MAINTAINERS: Update CPU FREQUENCY patterns
      ALSA: hda - Fix beep_device compilation warnings
      checkpatch: add warning for uses of printk_ratelimit
      MAINTAINERS: Update EBTABLES mailing list

Jonathan Brassow (9):
      MD: no integrity register if no gendisk
      MD: no sync IO while suspended
      MD: possible typo
      MD: move thread wakeups into resume
      MD: raid1 changes to allow use by device mapper
      MD: add sync_super to mddev_t struct
      MD: support initial bitmap creation in-kernel
      MD: raid5 do not set fullsync
      MD: use is_power_of_2 macro

Josef Bacik (3):
      Btrfs: fix path leakage on subvol deletion
      Btrfs: protect the pending_snapshots list with trans_lock
      Btrfs: set no_trans_join after trying to expand the transaction

Josh Triplett (2):
      uts: make default hostname configurable, rather than always using "(none)"
      gcov: disable CONFIG_CONSTRUCTORS when not needed by CONFIG_GCOV_KERNEL

Julian Anastasov (1):
      netfilter: nf_nat: avoid double seq_adjust for loopback

Jörg Sommer (2):
      Documentation: update cgroupfs mount point
      Documentation: fix cgroup typos and formatting

KAMEZAWA Hiroyuki (7):
      mm/memory_hotplug.c: fix building of node hotplug zonelist
      mm: memory.numa_stat: fix file permission
      memcg: fix init_page_cgroup nid with sparsemem
      memcg: clear mm->owner when last possible owner leaves
      memcg: fix wrong check of noswap with softlimit
      memcg: fix percpu cached charge draining frequency
      memcg: avoid percpu cached charge draining at softlimit

KOSAKI Motohiro (4):
      vmscan,memcg: memcg aware swap token
      vmscan: implement swap token trace
      vmscan: implement swap token priority aging
      mm: increase RECLAIM_DISTANCE to 30

Kevin Hilman (2):
      OMAP: PM: omap_device: fix device power domain callbacks
      OMAP1: PM: register notifiers with generic clock ops even when !PM_RUNTIME

Kohei Kaigai (1):
      selinux: fix case of names with whitespace/multibytes on /selinux/create

Konrad Rzeszutek Wilk (5):
      xen: Fix compile warning when CONFIG_SMP is not defined.
      xen/setup: Fix for incorrect xen_extra_mem_start.
      [CPUFREQ] Don't set stat->last_index to -1 if the pol->cur has
incorrect value.
      [CPUFREQ] powernow-k8: Don't notify of successful transition if
we failed (vid case).
      [CPUFREQ] powernow-k8: Don't try to transition if the pstate is incorrect

Kuninori Morimoto (3):
      ARM: mach-shmobile: mackerel: tidyup usbhs driver settings
      sh: ecovec: Add renesas_usbhs support
      sh: sh7724: Add USBHS DMAEngine support

Linus Torvalds (7):
      Revert "fs/exec.c: use BUILD_BUG_ON for VM_STACK_FLAGS &
VM_STACK_INCOMPLETE_SETUP"
      mm: get rid of the most spurious find_vma_prev() users
      mm: avoid repeated anon_vma lock/unlock sequences in anon_vma_clone()
      mm: avoid anon_vma_chain allocation under anon_vma lock
      isofs: fix bh leak in isofs_fill_super() error case
      vfs: i_state needs to be 'unsigned long' for now
      Linux 3.0-rc4

Linus Walleij (3):
      ARM: 6947/2: mach-u300: fix compilation error in timer
      ARM: 6894/1: mmci: trigger card detect IRQs on falling and rising edges
      ARM: 6949/2: mach-u300: fix compilaton warning in IO accessors

Luiz Augusto von Dentz (1):
      Bluetooth: fix shutdown on SCO sockets

Maarten Lankhorst (2):
      btrfs: Remove unused sysfs code
      x86, efi: Do not reserve boot services regions within reserved areas

Magnus Damm (6):
      dmaengine: shdma: SH_DMAC_MAX_CHANNELS message fix
      ARM: mach-shmobile: AG5EVM SDHI1 platform data update
      ARM: mach-shmobile: Mackerel USB platform data update
      ARM: mach-shmobile: sh73a0 gic_arch_extn.irq_set_wake() fix
      drivers: sh: resume enabled clocks fix
      Input: sh_keysc - 8x8 MODE_6 fix

Marcelo Tosatti (1):
      KVM: VMX: do not overwrite uptodate vcpu->arch.cr3 on KVM_SET_SREGS

Marek Olšák (1):
      drm/radeon/kms: do bounds checking for 3D_LOAD_VBPNTR and bump array limit

Marius B. Kotsbak (1):
      net/usb: Add Samsung Kalmia driver for Samsung GT-B3730

Mathias Krause (3):
      sh, exec: remove redundant set_fs(USER_DS)
      avr32, exec: remove redundant set_fs(USER_DS)
      tools/perf: Fix static build of perf tool

Max Asbock (1):
      timerfd: Fix wakeup of processes when timer is cancelled on clock change

Maxin B. John (1):
      Documentation: update kmemleak supported archs

Mel Gorman (2):
      mm: compaction: ensure that the compaction free scanner does not
move to the next zone
      mm: compaction: abort compaction if too many pages are isolated
and caller is asynchronous V2

Miao Xie (1):
      btrfs: fix wrong reservation when doing delayed inode operations

Michael Hennerich (1):
      backlight: new driver for the ADP8870 backlight devices

Michal Hocko (2):
      fs/exec.c: use BUILD_BUG_ON for VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP
      mm: compaction: fix special case -1 order checks

Michal Marek (1):
      kbuild: Call depmod.sh via shell

Mike Frysinger (1):
      spi/bfin_spi: fix handling of default bits per word setting

Minchan Kim (1):
      mm/memory-failure.c: fix page isolated count mismatch

Ming Lei (1):
      ARM: 6952/1: fix lockdep warning of "unannotated irqs-off"

Namhyung Kim (6):
      md: check ->hot_remove_disk when removing disk
      md/bitmap: use proper accessor macro
      md/bitmap: remove unused fields from struct bitmap
      md/raid5: fix raid5_set_bi_hw_segments
      md/raid5: fix FUA request handling in ops_run_io()
      md/raid5: remove unusual use of bio_iovec_idx()

Neil Horman (1):
      tun: teach the tun/tap driver to support netpoll

NeilBrown (1):
      md:Documentation/md.txt - fix typo

Nicolas Cavallari (1):
      netfilter: fix looped (broad|multi)cast's MAC handling

Nicolas Ferre (1):
      avr32: add some more at91 to cpu.h definition

Nicolas Kaiser (1):
      include/asm-generic/pgtable.h: fix unbalanced parenthesis

Nicolas Pitre (2):
      ARM: 6953/1: DT: don't try to access physical address zero
      ARM: 6954/1: zImage: fix Thumb2 breakage

Nils Carlson (1):
      drivers/char/hpet.c: fix periodic-emulation for delayed interrupts

Nishant Sarmukadam (1):
      mwl8k: Tell firmware to generate CCMP header

Ondrej Zary (1):
      3c503: fix broken IRQ autoprobing

Patrick McHardy (2):
      netfilter: ipt_ecn: fix protocol check in ecn_mt_check()
      netfilter: ipt_ecn: fix inversion for IP header ECN match

Paul E. McKenney (3):
      rcu: Simplify curing of load woes
      rcu: use softirq instead of kthreads except when RCU_BOOST=y
      rcu: Move RCU_BOOST #ifdefs to header file

Paul Mundt (2):
      sh: Remove compressed kernel libgcc dependency.
      ARM: mach-shmobile: Correct SCIF port types for SH7367.

Pavel Shilovsky (1):
      CIFS: Fix sparse error

Pavel Shved (2):
      farsync: add module_put to error path in fst_open()
      gigaset: call module_put before restart of if_open()

Pawel Osciak (1):
      MAINTAINERS: add videobuf2 maintainers

Peter Zijlstra (1):
      mm: avoid repeated anon_vma lock/unlock sequences in unlink_anon_vmas()

Po-Yu Chuang (1):
      ARM: 6955/1: cmpxchg syscall should data abort if page not write

Rabin Vincent (1):
      ARM: 6951/1: include .bss in memory layout information

Rafael Aquini (1):
      mm: fix negative commitlimit when gigantic hugepages are allocated

Ralf Baechle (1):
      phylib: Allow BCM63XX PHY to be selected only on BCM63XX.

Randy Dunlap (8):
      nfsd: v4 support requires CRYPTO
      signal.c: fix kernel-doc notation
      mm/memory.c: fix kernel-doc notation
      lib/bitmap.c: fix kernel-doc notation
      kmsg_dump.h: fix build when CONFIG_PRINTK is disabled
      gpio: include linux/gpio.h where needed
      gpio: add GPIOF_ values regardless on kconfig settings
      staging: fix iio builds when IIO_RING_BUFFER is not enabled

Richard Cochran (3):
      dp83640: fix phy status frame event parsing
      dp83640: drop PHY status frames in the driver.
      pxa168_eth: fix race in transmit path.

Rob Herring (1):
      ARM: 6946/1: vexpress: move v2m clock init to init_early

Roy.Li (1):
      SELinux: skip file_name_trans_write() when policy downgraded.

Russell King (7):
      OMAP: PM debug: fix section mismatch warnings
      Revert "ARM: 6943/1: mm: use TTBR1 instead of reserved context ID"
      Revert "ARM: 6944/1: mm: allow ASID 0 to be allocated to tasks"
      ARM: extend Code: line by one 16-bit quantity for Thumb instructions
      ARM: initrd: disable initrds outside of memory
      ARM: footbridge: fix debug macros
      ARM: footbridge: fix clock event support

Sascha Hauer (1):
      drm: fix fbs in DRM_IOCTL_MODE_GETRESOURCES ioctl

Sebastian Andrzej Siewior (1):
      netfilter: ip_tables: fix compile with debug

Sekhar Nori (1):
      davinci: make PCM platform devices static

Shaohua Li (2):
      rcu: Use softirq to address performance regression
      compaction: checks correct fragmentation index

Sonic Zhang (1):
      netdev: bfin_mac: fix memory leak when freeing dma descriptors

Srinivas KANDAGATLA (2):
      sh: fix wrong icache/dcache address-array start addr in cache-debugfs.
      sh: Fix up xchg/cmpxchg corruption with gUSA RB.

Stefano Stabellini (1):
      xen: partially revert "xen: set max_pfn_mapped to the last pfn mapped"

Stephen Boyd (2):
      msm: timer: Fix SMP build error
      msm: timer: Fix DGT rate on 8960 and 8660

Steve (1):
      KVM: MMU: fix opposite condition in mapping_level_dirty_bitmap

Steve French (2):
      [CIFS] trivial cleanup fscache cFYI and cERROR messages
      [CIFS] update cifs version to 1.73

Steven Rostedt (3):
      tracing: Fix regression in printk_formats file
      sched: Check if lowest_mask is initialized in find_lowest_rq()
      mm: fix wrong kunmap_atomic() pointer

Takao Indoh (1):
      generic-ipi: Fix kexec boot crash by initializing
call_single_queue before enabling interrupts

Takashi Iwai (4):
      ALSA: hda - Fix wrong auto-mute type for Acer Aspire-one
      ALSA: hda - Fix missing static inline to beep dummy function
      ALSA: lola - Fix section mismatch
      ALSA: hda - Fix no NID error with VIA codecs

Tetsuo Handa (1):
      TOMOYO: Fix oops in tomoyo_mount_acl().

Thomas Gleixner (2):
      arm: davinci: Fix fallout from generic irq chip conversion
      clocksource: Make watchdog robust vs. interruption

Tom Goetz (1):
      xen: When calling power_off, don't call the halt function.

Tormod Volden (1):
      drm: Compare only lower 32 bits of framebuffer map offsets

Torsten Schenk (1):
      ALSA: 6fire - Fix signedness bug

Török Edwin (1):
      fix wrong iput on d_inode introduced by e6bc45d65d

Uwe Kleine-König (1):
      leds: move LEDS_GPIO_REGISTER out of menuconfig NEW_LEDS

Ville Tervo (1):
      Bluetooth: Do not send SET_EVENT_MASK for 1.1 and earlier devices

WANG Cong (1):
      netpoll: copy dev name of slaves to struct netpoll

Wanlong Gao (2):
      efifb: Fix call to wrong unregister function
      rtc: fix build warnings in defconfigs

Wolfram Sang (2):
      arm: mxs: include asm/processor.h for cpu_relax()
      drm: populate irq_by_busid-member for pci

Ying Han (1):
      memcg: add documentation for the memory.numastat API

Yogesh Ashok Powar (1):
      mwifiex: Fixing NULL pointer dereference

Zachary Amsden (1):
      KVM: Fix register corruption in pvclock_scale_delta

akpm@linux-foundation.org (1):
      Documentation/feature-removal-schedule.txt: remove ns_cgroup
from feature-removal-schedule.txt

sjur.brandeland@stericsson.com (1):
      caif: Bugfix - XOFF removed channel from caif-mux

马建朋 (1):
      md: Using poll  /proc/mdstat can monitor the events of adding a
spare disks
