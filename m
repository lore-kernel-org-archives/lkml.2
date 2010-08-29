Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab0H2R1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 13:27:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600Ab0H2R1B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 13:27:01 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Aug 2010 10:25:21 -0700
Message-ID: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
Subject: Linux 2.6.36-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You all know the drill by now: another week, another -rc.

Nothing in particular stands out that I can recall. As usual, it's
mostly driver updates (65%), of which a large piece (by line count) is
just the removal of a staging driver that isn't really ready nor
making any progress. But on the "somewhat more likely to cause
excitement" front, there's some radeon/nouveau drm updates too.

Outside of drivers, you have CIFS, ceph and xfs filesystem updates,
and sparc/blackfin on the arch side. And various random noise -
networking, fsnotify, an anonvma locking fix etc. The appended
shortlog gives a fairly good idea of what kinds of things have been
going on.

Anyway, I'm hoping it is going to be an extremely boring -rc, because
I'm just about to leave for LinuxCon Brazil, and while I'll follow
issues over email, I'm not planning to do any pulls for the next week.

                                  Linus

---
Adam Jackson (1):
      drm/modes: Fix CVT-R modeline generation

Akinobu Mita (1):
      sound: oss: fix uninitialized spinlock

Alan Cox (1):
      ceph: Fix warnings

Alex Deucher (17):
      drm/radeon/kms: DCE3/4 AdjustPixelPll updates
      drm/radeon/kms: rework encoder handling
      drm/radeon/kms: DCE3/4 transmitter fixes
      drm/radeon/kms/atom: clean up dig atom handling
      drm/radeon/kms/pm: bail early if nothing's changing
      drm/radeon/kms/DCE3+: switch pads to ddc mode when going i2c
      drm/radeon/kms: add missing asic callback assignment for evergreen
      drm/radeon/kms: rework radeon_dp_detect() logic
      drm/radeon/kms: fix agp mode setup on cards that use pcie bridges
      drm/radeon/kms: don't enable MSIs on AGP boards
      drm/radeon/kms: add back missing break in info ioctl
      drm/radeon/kms: set encoder type to DVI for HDMI on evergreen
      drm/radeon/kms: fix sideport detection on newer rs880 boards
      drm/radeon/kms: try to detect tv vs monitor for underscan
      drm/radeon/kms: fix typo in radeon_compute_pll_gain
      drm/radeon/kms: remove stray radeon_i2c_destroy
      drm/radeon/kms: add missing scratch update in dp_detect

Amerigo Wang (1):
      makefile: not need to regenerate kernel.release file when make
kernelrelease

Amit Kumar Salecha (2):
      netxen: fix inconsistent lock state
      netxen: update version 4.0.74

Anatolij Gustschin (1):
      powerpc: Fix typo in uImage target

Andiry Xu (1):
      USB: xHCI: update ring dequeue pointer when process missed tds

Andre Detsch (1):
      ehea: Fix synchronization between HW and SW send queue

Andreas Gruenbacher (1):
      fanotify: Return EPERM when a process is not privileged

Andreas Herrmann (1):
      hwmon: (k8temp) Differentiate between AM2 and ASB1

Andreas Schwab (3):
      powerpc: Wire up fanotify_init, fanotify_mark, prlimit64 syscalls
      via-pmu: Add compat_pmu_ioctl
      powerpc: Fix config dependency problem with MPIC_U3_HT_IRQS

Anton Blanchard (5):
      powerpc/mm: Fix vsid_scrample typo
      powerpc/kdump: Stop all other CPUs before running crash handlers
      powerpc: Inline ppc64_runlatch_off
      powerpc: Fix bogus it_blocksize in VIO iommu code
      tracing/trace_stack: Fix stack trace on ppc64

Anton Vorontsov (1):
      phylib: Fix race between returning phydev and calling adjust_link

Arjan van de Ven (1):
      tracing: Fix timer tracing

Arnd Bergmann (1):
      drm: fix regression in drm locking since BKL removal.

Axel Lin (4):
      USB: r8a66597-udc: return -ENOMEM if kzalloc() fails
      hwmon: (ads7871) Fix ads7871_probe error paths
      Input: pxa27x_keypad - remove input_free_device() in
pxa27x_keypad_remove()
      ASoC: soc-core: fix debugfs_pop_time file permissions

Barry Song (1):
      Blackfin: bf52x/bf54x boards: drop unused nand page size

Bartlomiej Zolnierkiewicz (1):
      libata: remove no longer needed pata_winbond driver

Ben Skeggs (11):
      drm/nv50: fix minor thinko from nvc0 changes
      drm/nouveau: fix race condition when under memory pressure
      drm/nouveau: check for error when allocating/mapping dummy page
      drm/nouveau: remove warning about unknown tmds table revisions
      drm/nouveau: punt some more log messages to debug level
      drm/nv50-nvc0: ramht_size is meant to be in bytes, not entries
      drm/nvc0: fix thinko in instmem suspend/resume
      drm/nouveau: fix earlier mistake when fixing merge conflict
      drm/nv50: add dcb type 14 to enum to prevent compiler complaint
      drm: export drm_global_mutex for drivers to use
      drm/nouveau: drop drm_global_mutex before sleeping in submission path

Benjamin Herrenschmidt (1):
      powerpc: Make rwsem use "long" type

Bernard Pidoux F6BVP (1):
      ax25: misplaced sock_put(sk)

Bill Pemberton (8):
      USB: ssu100: add locking for port private data in ssu100
      USB: ssu100: refine process_packet in ssu100
      USB: ssu100: remove duplicate #defines in ssu100
      USB: ssu100: add register parameter to ssu100_setregister
      USB: ssu100: rework logic for TIOCMIWAIT
      USB: serial: export symbol usb_serial_generic_disconnect
      USB: ssu100: add disconnect function for ssu100
      USB: ssu100: set tty_flags in ssu100_process_packet

Borislav Petkov (2):
      MCE, AMD: Limit MCE decoding to current families for now
      amd64_edac: Do not report error overflow as a separate error

Breno Leitao (1):
      qlge: reset the chip before freeing the buffers

Bruce Allan (2):
      e1000e: disable ASPM L1 on 82573
      e1000e: don't check for alternate MAC addr on parts that don't support it

Changhwan Youn (1):
      ARM: S5PV310: Fix on Secondary CPU startup

Changli Gao (2):
      header: fix broken headers for user space
      bridge: netfilter: fix a memory leak

Charles Chin (1):
      ALSA: hda - Add support for IDT 92HD89XX codecs

Chris Wilson (1):
      vgaarb: Wrap vga_(get|put) in CONFIG_VGA_ARB

Christoph Fritz (1):
      Input: mousedev - fix regression of inverting axes

Christoph Hellwig (1):
      xfs: do not discard page cache data on EAGAIN

Clemens Ladisch (1):
      firewire: core: do not use del_timer_sync() in interrupt context

Craig Shelley (1):
      USB: CP210x Fix Break On/Off

Dan Carpenter (16):
      drm: fix end of loop test
      drm: move dereference below check
      ip2: remove unneeded NULL check
      ip2: return -EFAULT on copy_to_user errors
      rocket: add a mutex_unlock()
      synclink: add mutex_unlock() on error path
      USB: uvc_v4l2: cleanup test for end of loop
      pxa168_eth: remove unneeded null check
      pxa168_eth: fix error handling in prope
      pxa168_eth: update call to phy_mii_ioctl()
      pxa168_eth: silence gcc warnings
      ceph: ceph_get_inode() returns an ERR_PTR
      [libata] sata_dwc_460ex: signdness bug
      ceph: ceph_mdsc_build_path() returns an ERR_PTR
      ceph: fix get_ticket_handler() error handling
      ALSA: pcm: add more format names

Daniel T Chen (1):
      ALSA: intel8x0: Mute External Amplifier by default for ThinkPad X31

Daniel Vetter (1):
      drm: mm: fix range restricted allocations

Dave Airlie (3):
      drm: stop information leak of old kernel stack.
      drm: block userspace under allocating buffer and having drivers
overwrite it (v2)
      drm/radeon: fix passing wrong type to gem object create.

Dave Chinner (10):
      radix-tree: clear all tags in radix_tree_node_rcu_free
      radix-tree: radix_tree_range_tag_if_tagged() can set incorrect tags
      xfs: unlock items before allowing the CIL to commit
      xfs: ensure we mark all inodes in a freed cluster XFS_ISTALE
      xfs: fix untrusted inode number lookup
      writeback: write_cache_pages doesn't terminate at nr_to_write <= 0
      xfs: handle negative wbc->nr_to_write during sync writeback
      xfs: dummy transactions should not dirty VFS state
      xfs: Reduce log force overhead for delayed logging
      xfs: don't do memory allocation under the CIL context lock

Dave Kleikamp (4):
      powerpc/47x: Make sure mcsr is cleared before enabling machine
check interrupts
      powerpc/47x: Remove redundant line from cputable.c
      powerpc/4xx: Index interrupt stacks by physical cpu
      powerpc/47x: Add an isync before the tlbivax instruction

David Alan Gilbert (1):
      PM QoS: Fix kzalloc() parameters swapped in pm_qos_power_open()

David Henningsson (1):
      ALSA: hda - Add Sony VAIO quirk for ALC269

David Howells (3):
      kobject: Break the kobject namespace defs into their own header
      NOMMU: Stub out vm_get_page_prot() if there's no MMU
      Alpha: Fix a missing comma in sys_osf_statfs()

David S. Miller (5):
      sparc64: Really fix atomic64_t interface types.
      sparc64: Make rwsems 64-bit.
      sparc64: Make lock backoff really a NOP on UP builds.
      sparc64: Get rid of indirect p1275 PROM call buffer.
      tcp: Combat per-cpu skew in orphan tests.

Denis Kirjanov (1):
      powerpc: Use is_32bit_task() helper to test 32 bit binary

Dmitry Torokhov (4):
      Input: sysrq - drop tty argument from sysrq ops handlers
      Input: sysrq - drop tty argument form handle_sysrq()
      USB: drop tty argument from usb_serial_handle_sysrq_char()
      Input: hil_kbd - fix compile error

Eliot Blennerhassett (1):
      ALSA: asihpi - Return hw error directly from oustream_write.

Eric Dumazet (6):
      rds: fix a leak of kernel memory
      irda: fix a race in irlan_eth_xmit()
      qlnic: fix a race in qlcnic_get_stats()
      netxen: fix a race in netxen_nic_get_stats()
      tcp: fix three tcp sysctls tuning
      l2tp: test for ethernet header in l2tp_eth_dev_recv()

Eric Paris (7):
      fanotify: do not dereference inode_mark when it is unset
      fsnotify: reset used_inode and used_vfsmount on each pass
      fanotify: add MAINTAINERS entry
      fsnotify: fix ignored mask handling between inode and vfsmount marks
      fanotify: flush outstanding perm requests on group destroy
      fsnotify: fix list walk order
      fsnotify: drop two useless bools in the fnsotify main loop

Felipe Balbi (1):
      USB: otg: twl4030: fix wrong assumption of starting state

Fenghua Yu (1):
      MAINTAINERS: hwmon/coretemp: Change maintainers

Florian Westphal (1):
      netfilter: fix CONFIG_COMPAT support

Francisco Jerez (7):
      drm/nouveau: Don't try DDC on the dummy I2C channel.
      drm/nouveau: Add TV-out quirk for an MSI nForce2 IGP.
      drm/nouveau: Workaround missing GPIO tables on an Apple iMac G4 NV18.
      drm/nouveau: Use a helper function to match PCI device/subsystem IDs.
      drm/nouveau: Fix backlight control on PPC machines with an
internal TMDS panel.
      drm/nouveau: Fix TMDS on some DCB1.5 boards.
      drm/nv20: Don't use pushbuf calls on the original nv20.

Galen Seitz (1):
      USB: ftdi_sio: add product ID for Lenz LI-USB

Grant Likely (1):
      powerpc/pci: Fix checking for child bridges in PCI code.

Greg Kroah-Hartman (2):
      Staging: sep: remove driver
      USB: io_ti: check firmware version before updating

Heiko Carstens (1):
      caif-driver: add HAS_DMA dependency

Henry C Chang (1):
      ceph: fix osd request lru adjustment when sending request

Hugh Dickins (1):
      mm: fix hang on anon_vma->root->lock

Ian Campbell (3):
      xen: pvhvm: allow user to request no emulated device unplug
      xen: pvhvm: rename xen_emul_unplug=ignore to =unnnecessary
      xen: pvhvm: make it clearer that XEN_UNPLUG_* define bits in a bitfield

Igor Druzhinin (1):
      cifs: correction of unicode header files

Ingo Molnar (1):
      V4L/DVB: mantis: Fix IR_CORE dependency

J. Bruce Fields (3):
      nfsd4: bad BUG() in preprocess_stateid_op
      nfsd4: typo fix in find_any_file
      nfsd4: fix downgrade/lock logic

Jan Beulich (1):
      fixes for using make 3.82

Javier Martinez Canillas (7):
      Staging: spectra: removes q->prepare_flush_fn, fix build breakage
      Staging: use new REQ_FLUSH flag, fix build breakage
      Staging: spectra: don't use locked_ioctl, fix build
      Staging: spectra: remove duplicate GLOB_VERSION definition
      Staging: spectra: removes unused variable
      Staging: spectra: initializa lblk variable
      Staging: spectra: removes unused functions

Jean Delvare (2):
      drm/radeon: Fix stack data leak
      hwmon: (coretemp) Fix harmless build warning

Jef Driesen (1):
      USB: pl2303: New vendor and product id

Jeff Layton (4):
      cifs: clean up error handling in cifs_mknod
      cifs: consolidate error handling in several functions
      cifs: fix NULL pointer dereference in cifs_find_smb_ses
      cifs: check for NULL session password

Jeff Mahoney (1):
      net/caif/cfrfml.c: use asm/unaligned.h

Jens Axboe (1):
      ipheth: add support for iPhone 4

Jeremy Fitzhardinge (2):
      xen: use percpu interrupts for IPIs and VIRQs
      xen: handle events as edge-triggered

Jerome Glisse (1):
      drm/radeon/kms: fix GTT/VRAM overlapping test

Jerome Marchand (1):
      ecryptfs: properly mark init functions

Jerone Young (1):
      ALSA: hda - Add support for Lenovo S10-3t

Jesse Barnes (1):
      drm/i915: fix vblank wait test condition

Jianwei Yang (1):
      intel_scu_ipc: fix IPC i2c write bug

Joe Perches (1):
      drivers/net/wireless: Restore upper case words in wiphy_<level> messages

Johannes Berg (3):
      iwlwifi: fix 3945 filter flags
      netlink: fix compat recvmsg
      firmware_class: fix typo in error path

John W. Linville (1):
      ipw2100: don't sync status queue entries

John Youn (1):
      USB: xhci: Remove buggy assignment in next_trb()

Jonathan Corbet (1):
      ACPI_TOSHIBA needs LEDS support

Jongpill Lee (4):
      ARM: S5PV310: Fix on PLL setting for S5PV310
      ARM: S5PV310: Should be clk_sclk_apll not clk_mout_apll
      ARM: S5PV310: Fix missed uart clocks
      ARM: S5PV310: Bug fix on uclk1 and sclk_pwm

Julia Lawall (8):
      ieee1394: Adjust confusing if indentation
      arch/mn10300/mm: eliminate NULL dereference
      USB: gadget: Return -ENOMEM on memory allocation failure
      powerpc/powermac: Drop unnecessary of_node_put
      powerpc/powermac: Drop unnecessary null test
      powerpc/pci: Drop unnecessary null test
      fs/ecryptfs: Return -ENOMEM on memory allocation failure
      net/ipv4: Eliminate kstrdup memory leak

KOSAKI Motohiro (1):
      tcp: select(writefds) don't hang up when a peer close connection

Kay Sievers (1):
      Input: uinput - add devname alias to allow module on-demand load

Kevin Hilman (1):
      OMAP3: PM: ensure IO wakeups are properly disabled

Kukjin Kim (4):
      ARM: SAMSUNG: Fix on build warning regarding VMALLOC_END type
      ARM: S5PV310: Fix on default ZRELADDR of ARCH_S5PV310
      ARM: S5PV310: Fix on typo irqs.h of S5PV310
      ARM: S5PV310: Add CMU block for S5PV310 Clock

Kulikov Vasiliy (3):
      68328serial: check return value of copy_*_user() instead of access_ok()
      USB: iowarrior: fix misuse of return value of copy_to_user()
      USB: adutux: fix misuse of return value of copy_to_user()

Kuninori Morimoto (1):
      net: sh_eth: remove unused variable

Kyungmin Park (2):
      ARM: S5P: VMALLOC_END should be unsigned long
      ARM: S5PV310: Fix on GPIO base addresses

Lin Ming (1):
      perf, x86, Pentium4: Clear the P4_CCCR_FORCE_OVF flag

Linus Torvalds (1):
      Linux 2.6.36-rc3

Marek Lindner (4):
      Staging: batman-adv: unify orig_hash_lock spinlock handling to
avoid deadlocks
      Staging: batman-adv: fix batman icmp originating from secondary interface
      Staging: batman-adv: always reply batman icmp packets with primary mac
      Staging: batman-adv: fix own mac address detection

Mark Lord (2):
      sata_mv: fix broken DSM/TRIM support (v2)
      libata-sff: remove harmful BUG_ON from ata_bmdma_qc_issue

Martin Michlmayr (1):
      USB: ftdi_sio: Add ID for Ionics PlugComputer

Martin Schwidefsky (1):
      [S390] fix tlb flushing vs. concurrent /proc accesses

Matt Evans (1):
      powerpc: Initialise paca->kstack before early_setup_secondary

Matthew Garrett (1):
      hp-wmi: Fix query interface

Michael Hennerich (1):
      USB: isp1760: use a write barrier to ensure proper ndelay timing

Michael Rubin (1):
      mm: exporting account_page_dirty

Michael Tokarev (1):
      USB: option: add Celot CT-650

Michael Wileczka (1):
      USB: ftdi_sio: fix endianess of max packet size

Michal Marek (1):
      setlocalversion: Ignote SCMs above the linux source tree

Michal Simek (1):
      ll_temac: Fix poll implementation

Mike Frysinger (4):
      Blackfin: fix hweight breakage
      ADI/ASoC: add MAINTAINERS entries
      Blackfin: wire up new fanotify/prlimit64 syscalls
      Blackfin: punt duplicate SPORT MMR defines

Mikulas Patocka (2):
      sparc64: simple microoptimizations for atomic functions
      sparc64: Fill a missing delay slot.

Ming Lei (1):
      USB: serial: fix leak of usb serial module refrence count

Nathan Fontenot (1):
      powerpc: Correct smt_enabled=X boot option for > 2 threads per core

Neil Horman (1):
      3c59x: Fix deadlock between boomerang_interrupt and boomerang_start_tx

Nishanth Menon (1):
      omap3: id: fix 3630 rev detection

Olof Johansson (2):
      arm: tegra: fix compilation of board-harmony.c
      arm: tegra: VMALLOC_END should be unsigned long

Ossama Othman (1):
      rar: Fix off by one error

Patrice Mandin (1):
      drm/nv30: Apply modesetting to the correct slave encoder

Peter Zijlstra (2):
      sched: Fix rq->clock synchronization when migrating tasks
      watchdog: Don't throttle the watchdog

Phil Oester (1):
      vlan: Match underlying dev carrier on vlan add

Randy Dunlap (2):
      isdn/avm: fix build when PCMCIA is not enabled
      USB: gadget: fix composite kernel-doc warnings

Robert Jennings (1):
      ibmveth: Fix opps during MTU change on an active device

Roel Kluin (1):
      USB: serial: io_ti.c: don't return 0 if writing the download record failed

Ross Burton (1):
      USB: add device IDs for igotu to navman

Rupjyoti Sarmah (1):
      powerpc/4xx: Device tree update for the 460ex DWC SATA

Rusty Russell (2):
      lguest: clean up warnings in demonstration launcher.
      lguest: Odd Fixes

Sachin Sanap (1):
      net: add Fast Ethernet driver for PXA168.

Sage Weil (9):
      ceph: fix multiple mds session shutdown
      ceph: fix xattr cap writeback
      ceph: include dirty xattrs state in snapped caps
      ceph: queue cap snap writeback for realm children on snap update
      ceph: direct requests in snapped namespace based on nonsnap parent
      ceph: don't improperly set dir complete when holding EXCL cap
      ceph: maintain i_head_snapc when any caps are dirty, not just for data
      ceph: initialize fields on new dentry_infos
      ceph: don't BUG on ENOMEM during mds reconnect

Sam Ravnborg (3):
      kconfig: fix savedefconfig with choice marked optional
      kconfig: fix segfault when detecting recursive dependency
      netfilter: fix userspace header warning

Saravana Kannan (1):
      PM QoS: Fix inline documentation.

Sascha Hauer (1):
      ASoC: i.MX ssi: use SSI_STCCR in synchronous mode

Sebastian Ott (1):
      [S390] s390: fix build error (sys_execve)

Shirish Pargaonkar (1):
      missing changes during ntlmv2/ntlmssp auth and sign

Signed-off-by: Darren Hart (3):
      powerpc: Re-enable preemption before cpu_die()
      powerpc: Silence __cpu_up() under normal operation
      powerpc: Silence xics_migrate_irqs_away() during cpu offline

Sonny Rao (1):
      powerpc: Export memstart_addr and kernstart_addr on ppc64

Stefan Richter (4):
      firewire: sbp2: fix memory leak in sbp2_cancel_orbs or at send error
      firewire: sbp2: fix stall with "Unsolicited response"
      firewire: net: fix unicast reception RCODE in failure paths
      firewire: ohci: work around VIA and NEC PHY packet reception bug

Steve French (2):
      [CIFS] Fix ntlmv2 auth with ntlmssp
      [CIFS] Eliminate unused variable warning

Stuart Brodsky (1):
      xfs: ensure f_ffree returned by statfs() is non-negative

Suresh Jayaraman (1):
      Cannot allocate memory error on mount

Suresh Siddha (1):
      x86, tsc, sched: Recompute cyc2ns_offset's during resume from sleep states

Sven Eckelmann (4):
      Staging: batman-adv: Fix merge of linus tree
      Staging: batman-adv: Create batman_if only on register event
      Staging: batman-adv: Don't use net_dev after dev_put
      Staging: batman-adv: Don't write in not allocated packet_buff

Takashi Iwai (4):
      ALSA: hda - Fix build error with CONFIG_PROC_FS=n
      ALSA: hda - Fix conflict of sticky PCM parameter in HDMI codecs
      ALSA: hda - Fix stream and channel-ids codec-bus wide
      nfsd: fix NULL dereference in nfsd_statfs()

Tejun Heo (3):
      pata_cmd64x: revert commit d62f5576
      ahci: add HFLAG_YES_FBS and apply it to 88SE9128
      libata: be less of a drama queen on empty data commands

Tim Chen (1):
      mutex: Improve the scalability of optimistic spinning

Tony Lindgren (3):
      omap: Fix sev instruction usage for multi-omap
      omap: Use CONFIG_SMP for test_for_ipi and test_for_ltirq
      omap: Fix omap_4430sdp_defconfig for make oldconfig

Tony Luck (2):
      serial: print early console device address in hex
      guard page for stacks that grow upwards

Tvrtko Ursulin (2):
      fanotify: drop duplicate pr_debug statement
      fanotify: resize pid and reorder structure

Tyler Hicks (1):
      eCryptfs: Fix encrypted file name lookup regression

Uwe Kleine-König (1):
      ARM: imx: fix build failure concerning otg/ulpi

Wey-Yi Guy (3):
      iwlwifi: long monitor timer
      iwlwifi: use long monitor timer to avoid un-necessary reload
      iwlwifi: use long monitor timer for 5300 series

Xiaotian Feng (1):
      kobject_uevent: fix typo in comments

Yaniv Rosner (2):
      bnx2x: Fix PHY locking problem
      bnx2x: Update bnx2x version to 1.52.53-4

Yinglin Luan (2):
      netxen: fix poll implementation
      qlcnic: fix poll implementation

shirishpargaonkar@gmail.com (1):
      Eliminate sparse warning - bad constant expression

stanley.miao (1):
      OMAP3: Fix a cpu type check problem
