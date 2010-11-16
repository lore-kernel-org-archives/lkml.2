Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab0KPDND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:13:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755508Ab0KPDNA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:13:00 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 19:12:34 -0800
Message-ID: <AANLkTimYevUOSxDm+nGq_ctPEFp_E2zJR7rNGvUi2fWY@mail.gmail.com>
Subject: Linux 2.6.37-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been two weeks since -rc1, largely because one of those weeks was
the kernel summit and plumbers conference, and as a result very quiet
indeed.

And in fact, despite being two weeks, the amount of changes between
-rc1 and -rc2 is pretty normal, both by number of commits (it tends to
be around 500+ commits, although we've had outliers: 2.6.34 was 1700,
2.6.36-rc2 was just 237, and 2.6.32-rc2 was the same as -rc1 because I
screwed up the tagging ;) and by actual size of the diff. In fact,
doing the stats, the diff looks a bit smaller than normal. Which is
all good.

And it all looks the way I like to see my -rc2's: nothing really
interesting there. We had a SCSI calling convention change patch that
got punted due to some discussion about details (and which I'll
probably accept for -rc3 with the fixed model).

In fact, the biggest change in the diffstat is just due to some
staging driver reverts. So hopefully this whole 2.6.37 release cycle
will be as painless as it looks so far.

Or maybe people are still just not very active after the KS. So go out and test,

                                           Linus

---
Aaro Koskinen (1):
      sisfb: limit POST memory test according to PCI resource length

Alan Cox (2):
      tty: Fix formatting in tty.h
      nozomi: Fix warning from the previous TIOCGCOUNT changes

Alex Deucher (5):
      drm/radeon/kms/evergreen: add missing pm.vblank_sync update in vbl handler
      drm/radeon/kms: make the connector code less verbose
      drm/radeon/kms: don't disable shared encoders on pre-DCE3 display blocks
      drm/radeon/kms: add support for clock/data path routers
      drm/radeon/kms: fix thermal sensor reporting on rv6xx

Alexey Khoroshilov (1):
      kernel/range.c: fix clean_sort_range() for the case of full array

Amerigo Wang (1):
      netxen: remove unused firmware exports

Anand Gadiyar (1):
      usb: musb: fail unaligned DMA transfers on v1.8 and above

Andi Kleen (1):
      x86: Address gcc4.6 "set but not used" warnings in apic.h

Andres Salomon (2):
      tty: fix warning in synclink driver
      pcmcia: fix warning in synclink driver

André Carvalho de Matos (1):
      caif: Bugfix for socket priority, bindtodev and dbg channel.

Andy Whitcroft (2):
      kconfig: sym_expand_string_value: allow for string termination
when reallocing
      usb: gadget: goku_udc: add registered flag bit, fixing build

Arnd Bergmann (2):
      preempt: fix kernel build with !CONFIG_BKL
      [media] v4l: kill the BKL

Arun Murthy (1):
      backlight: add low threshold to pwm backlight

Axel Lin (8):
      rtc: rtc-sh - fix a memory leak
      Input: acecad - fix a memory leak in usb_acecad_probe error path
      hwmon: (adt7470) Return proper error code for adt7470_probe()
      hwmon: (ad7414) Return proper error code for ad7414_probe()
      hwmon: (gpio-fan) Fix fan_ctrl_init error path
      drivers/video/backlight/s6e63m0.c: set permissions on
gamma_table file to 0444
      drivers/video/backlight/s6e63m0.c: unregister backlight device
and remove sysfs attribute file in s6e63m0_remove
      drivers/video/backlight/s6e63m0.c: fix section mismatch

Ben Greear (2):
      docs: Add neigh/gc_thresh3 and route/max_size documentation.
      ipv6: Warn users if maximum number of routes is reached.

Ben Hutchings (2):
      Staging: ath6kl: Fix pointer casts on 64-bit architectures
      Staging: Update parameters for cfg80211 key management operation

Benjamin LaHaise (1):
      Input: atkbd - add 'terminal' parameter for IBM Terminal keyboards

Bjorn Helgaas (2):
      x86/PCI: coalesce overlapping host bridge windows
      PCI: fix pci_bus_alloc_resource() hang, prefer positive decode

Bob Liu (4):
      USB: musb: pm: don't rely fully on clock support
      USB: musb: blackfin: pm: make it work
      USB: musb: blackfin: fix dynamic device<->host changing
      USB: musb: blackfin: push clkin value to platform resources

Brett Rudley (1):
      staging: brcm80211: Maintainer change

Brian Cavagnolo (1):
      mac80211: unset SDATA_STATE_OFFCHANNEL when cancelling a scan

Casey Leedom (6):
      cxgb4vf: don't implement trivial (and incorrect) ndo_select_queue()
      cxgb4vf: fix bug in Generic Receive Offload
      cxgb4vf: fix some errors in Gather List to skb conversion
      cxgb4vf: flesh out PCI Device ID Table ...
      cxgb4vf: Fail open if link_start() fails.
      cxgb4vf: add call to Firmware to reset VF State.

Catalin Marinas (1):
      include/linux/highmem.h needs hardirq.h

Chris Lang (1):
      Staging: batman-adv: fix interface alternating and bonding reggression

Chris Metcalf (7):
      arch/tile: complete migration to new kmap_atomic scheme
      arch/tile: bomb raw_local_irq_ to arch_local_irq_
      arch/tile: avoid __must_check warning on one strict_strtol check
      arch/tile: correct double syscall restart for nested signals
      arch/tile: don't allow user code to set the PL via ptrace or signal return
      asm-generic/stat.h: support 64-bit file time_t for stat()
      arch/tile: mark "hardwall" device as non-seekable

Chris Wilson (7):
      drm/i915: Flush read-only buffers from the active list upon idle as well
      drm/i915: Apply big hammer to serialise buffer access between rings
      drm/i915: Allow powersave modparam to be adjusted at runtime.
      drm/i915: SNB BLT workaround
      drm/i915: Avoid might_fault during pwrite whilst holding our mutex
      drm/i915/ringbuffer: Use the HEAD auto-reporting mechanism
      drm/i915: Fix LVDS fixed-mode regression from 219adae1

Christian Lamparter (1):
      carl9170: usbid table updates

Christoph Fritz (1):
      drm/i915: opregion_setup: iounmap correct address

Christoph Hellwig (6):
      block: remove REQ_HARDBARRIER
      xfs: remove experimental tag from the delaylog option
      xfs: tell lockdep about parent iolock usage in filestreams
      xfs: fix a few compiler warnings with CONFIG_XFS_QUOTA=n
      xfs: use hlist_add_fake
      xfs: remove incorrect assert in xfs_vm_writepage

Clemens Ladisch (4):
      firewire: ohci: fix buffer overflow in AR split packet handling
      firewire: ohci: fix race in AR split packet handling
      firewire: ohci: avoid reallocation of AR buffers
      firewire: ohci: fix race when reading count in AR descriptor

Corey Ashford (1):
      perf: Fix usages of profile_cpu in builtin-top.c to use cpu_list

Cyrill Gorcunov (1):
      perf, ui: Eliminate stack-smashing protection compiler complaint

Dan Carpenter (12):
      i915: signedness bug in check_overlay_src()
      Staging: sst: dereferencing user pointers
      Staging: sst: more dereferencing user pointers
      Staging: sst: fixups in SNDRV_SST_STREAM_DECODE
      Staging: sst: user pointers in intel_sst_mmap_play_capture()
      Staging: sst: add some __user anotations
      Staging: bcm: use get_user() to access user pointers
      Input: pcf8574_keypad - fix error handling in pcf8574_kp_probe
      rapidio: use resource_size()
      misc/isl29020: signedness bug in als_sensing_range_store()
      memcg: null dereference on allocation failure
      drivers/misc/bh1770glc.c: error handling in bh1770_power_state_store()

Dan Rosenberg (2):
      Restrict unprivileged access to kernel syslog
      x25: Prevent crashing when parsing bad X.25 facilities

Daniel Drake (2):
      libertas: terminate scan when stopping interface
      [media] cafe_ccic: fix subdev configuration

Daniel J Blueman (1):
      ioprio: fix RCU locking around task dereference

Daniel Lichtenberger (1):
      Staging: rtl8192e: fix IOMMU memory leak

Dave Chinner (2):
      xfs: fix per-ag reference counting in inode reclaim tree walking
      xfs: move delayed write buffer trace

Dave Hansen (1):
      mm/vfs: revalidate page->mapping in do_generic_file_read()

Dave Jones (2):
      hugetlbfs: lessen the impact of a deprecation warning
      ACPI: debugfs custom_method open to non-root

David Daney (1):
      watchdog: Fix section mismatch and potential undefined behavior.

David Rientjes (1):
      oom: document obsolete oom_adj tunable

David S. Miller (4):
      ibm_newemac: Remove netif_stop_queue() in emac_probe().
      filter: make sure filters dont read uninitialized memory
      tcp: Increase TCP_MAXSEG socket option minimum.
      tcp: Don't change unlocked socket state in tcp_v4_err().

David Sterba (1):
      USB: xhci: Use GFP_ATOMIC under spin_lock

David Woodhouse (2):
      solos: Add 'Firmware' attribute for Traverse overall firmware version
      solos: Refuse to upgrade firmware with older FPGA. It doesn't work.

Davidlohr Bueso (1):
      drivers/leds/leds-gpio.c: properly initialize return value

Divy Le Ray (3):
      cxgb3: remove call to stop TX queues at load time.
      cxgb4: remove call to stop TX queues at load time.
      cxgb4vf: remove call to stop TX queues at load time.

Dmitri Belimov (1):
      [media] saa7134: Fix autodetect for Behold A7 and H7 TV cards

Dmitry Artamonow (1):
      USB: gadget: fix ethernet gadget crash in gether_setup

Dmitry Monakhov (1):
      ext4: do not try to grab the s_umount semaphore in ext4_quota_off

Dmitry Torokhov (4):
      Input: export input_reset_device() for use in KGDB
      kgdboc: reset input devices (keyboards) when exiting debugger
      NET: pktgen - fix compile warning
      Input: do not pass injected events back to the originating handler

Dr. David Alan Gilbert (1):
      l2tp: kzalloc with swapped params in l2tp_dfs_seq_open

Edgar (gimli) Hucek (3):
      ALSA: hda - MacBookAir3,1(3,2) alsa support
      Bluetooth: Add MacBookAir3,1(2) support
      backlight: MacBookAir3,1(3,2) mbp-nvidia-bl support

Eric Dumazet (11):
      netfilter: nf_conntrack: allow nf_ct_alloc_hashtable() to get
highmem pages
      netfilter: fix nf_conntrack_l4proto_register()
      jme: fix panic on load
      qlcnic: fix panic on load
      atl1 : fix panic on load
      de2104x: fix panic on load
      fib: fib_result_assign() should not change fib refcounts
      inet: fix ip_mc_drop_socket()
      net/dst: dst_dev_event() called after other notifiers
      net: avoid limits overflow
      atomic: add atomic_inc_not_zero_hint()

Eric Miao (3):
      ASoC: fix the building issue of missing codec field in 'struct
snd_soc_card'
      ARM: pxa: fix the missing definition of IRQ_BOARD_END
      ARM: pxa/saar: fix the building failure caused by typo

Eric Paris (2):
      netfilter: NF_HOOK_COND has wrong conditional
      capabilities/syslog: open code cap_syslog logic to fix build failure

Felipe Balbi (1):
      arm: omap1: devices: need to return with a value

Felipe Contreras (14):
      omap: dsp: remove shm from normal memory
      staging: tidspbridge: hardcode SCM macros while fix is upstreamed
      Revert "staging: tidspbridge - update Kconfig to select IOMMU module"
      Revert "staging: tidspbridge - remove dmm custom module"
      Revert "staging: tidspbridge - deprecate
reserve/unreserve_memory funtions"
      Revert "staging: tidspbridge - remove reserved memory clean up"
      Revert "staging: tidspbridge: remove dw_dmmu_base from cfg_hostres struct"
      Revert "staging: tidspbridge - move all iommu related code to a new file"
      Revert "staging: tidspbridge - remove hw directory"
      Revert "staging: tidspbridge - fix mmufault support"
      Revert "staging: tidspbridge - remove custom mmu code from tiomap3430.c"
      Revert "staging: tidspbridge - rename bridge_brd_mem_map/unmap
to a proper name"
      Revert "staging: tidspbridge - move shared memory iommu maps to
tiomap3430.c"
      Revert "staging: tidspbridge: replace iommu custom for
opensource implementation"

Felix Fietkau (2):
      cfg80211: fix a crash in dev lookup on dump commands
      ath9k: check old power mode before clearing cycle counters

Frank Blaschka (1):
      qeth: fix race condition during device startup

Geert Uytterhoeven (2):
      amiserial: Remove unused variable icount
      drivers/macintosh/adb-iop.c: flags should be unsigned long

Grazvydas Ignotas (1):
      usb: musb: don't leave PHY enabled on shutdown()

Greg Kroah-Hartman (9):
      Staging: solo6x10: fix build problem
      TTY: create drivers/tty and move the tty core files there
      TTY: create drivers/tty/vt and move the vt code there
      TTY: move .gitignore from drivers/char/ to drivers/tty/vt/
      Staging: ath6kl: remove empty files that mess with 'distclean'
      USB: the development of the usb tree is now in git
      Staging: the MAINTAINERS git location was incorrect
      tty: the development tree is now done in git
      Revert "USB: xhci: Use GFP_ATOMIC under spin_lock"

Greg Ungerer (1):
      m68knommu: add back in declaration of do_IRQ

Guennadi Liakhovetski (6):
      ARM: mach-shmobile: fix sh7372 after a recent clock framework rework
      sh: add clk_round_parent() to optimize parent clock rate
      sh: make some needlessly global sh7724 clocks static
      fbdev: sh_mobile_hdmi: properly clean up modedb on monitor unplug
      fbdev: sh_mobile_lcdc: use the standard CEA-861 720p timing
      fbdev: sh_mobile_lcdc: use correct number of modes, when using the default

Guenter Roeck (1):
      hwmon: (ltc4261) Add missing newline in debug message

Guillaume Chazarain (2):
      skge: Remove tx queue stopping in skge_devinit()
      net: Detect and ignore netif_stop_queue() calls before register_netdev()

Gustavo F. Padovan (1):
      Bluetooth: fix endianness conversion in L2CAP

Haitao Zhang (1):
      ath9k_htc: Add support for device ID 3346

Hans J. Koch (1):
      hwmon: Change mail address of Hans J. Koch

Hao Zheng (3):
      vlan: Add function to retrieve EtherType from vlan packets.
      bnx2x: Look inside vlan when determining checksum proto.
      ixgbe: Look inside vlan when determining offload protocol.

Haojian Zhuang (1):
      ARM: mmp: fix cpuid detection on mmp2

Hauke Mehrtens (1):
      Staging: ath6kl: Adapt API changes in cfg80211

Heikki Krogerus (1):
      usb: musb: Fix handling of spurious SESSREQ

Herbert Xu (2):
      cls_cgroup: Fix crash on module unload
      crypto: padlock - Fix AES-CBC handling on odd-block-sized input

Ian Campbell (3):
      xen: correct size of level2_kernel_pgt
      xen: events: do not unmask event channels on resume
      xen: do not release any memory under 1M in domain 0

Ian Jeffray (1):
      USB: musb: blackfin: fix musb_read_txhubport() definition

Ingo Molnar (2):
      drm/stub/Kconfig: fix Kconfig for stub driver.
      Revert "8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT) hang"

J. Bruce Fields (4):
      cifs: trivial doc fix: note setlease implemented
      nfsd4: fix 4.1 connection registration race
      locks: fix leak on merging leases
      locks: remove dead lease error-handling code

Jack Steiner (1):
      x86, UV: Update node controller MMRs

Jan Beulich (1):
      x86: Adjust section annotations in AMD Fam10 MMCONF enabling code

Jan Engelhardt (1):
      netfilter: ip6_tables: fix information leak to userspace

Jan Kiszka (1):
      KVM: x86: Issue smp_call_function_many with preemption disabled

Janusz Krzysztofik (5):
      OMAP1: camera.h: add missing include
      [media] SoC Camera: OMAP1: update for recent framework changes
      [media] SoC Camera: OMAP1: update for recent videobuf changes
      [media] SOC Camera: OMAP1: typo fix
      [media] SoC Camera: ov6650: minor cleanups

Jarkko Nikula (4):
      ASoC: tpa6130a2: Fix unbalanced regulator disables
      ASoC: Fix SND_SOC_ALL_CODECS typo for jz4740
      ASoC: Include cx20442 to SND_SOC_ALL_CODECS
      ASoC: tpa6130a2: Get rid of compile warning from tpa6130a2_power

Jason Wang (1):
      virtio-net: init link state correctly

Jean Delvare (15):
      hwmon: (ltc4261) Fix error message format
      [media] BZ#22292: dibx000_common: Restore i2c algo pointer
      include/linux/resource.h needs types.h
      hwmon: (lm95241) Check validity of input values
      hwmon: (w83795) Fix fan control mode attributes
      hwmon: (w83795) Expose fan control method
      hwmon: (w83795) List all usable temperature sources
      hwmon: (w83795) Print the actual temperature channels as sources
      hwmon: (w83795) Read the intrusion state properly
      hwmon: (w83795) Clear intrusion alarm immediately
      hwmon: (w83795) Check for BEEP pin availability
      i2c: Delete unused adapter IDs
      i2c: Drivers shouldn't include <linux/i2c-id.h>
      i2c: Mark i2c_adapter.id as deprecated
      i2c: Sanity checks on adapter registration

Jeff Layton (4):
      cifs: store pointer to master tlink in superblock (try #2)
      cifs: convert tlink_tree to a rbtree
      cifs: dereferencing first then checking
      cifs: make cifs_ioctl handle NULL filp->private_data correctly

Jens Axboe (6):
      block: check for proper length of iov entries in blk_rq_map_user_iov()
      block: take care not to overflow when calculating total iov length
      block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
      bio: take care not overflow page count when mapping/copying user data
      cciss: fix proc warning on attempt to remove non-existant directory
      block: remove unused copy_io_context()

Jesper Juhl (8):
      ALSA: usb - driver neglects kmalloc return value check and may deref NULL
      ALSA: cs46xx memory management fixes for cs46xx_dsp_spos_create()
      ALSA: asihpi - Unsafe memory management when allocating control cache
      Clean up relay_alloc_page_array() slightly by using vzalloc
rather than vmalloc and memset
      xen-pcifront: Remove duplicate inclusion of headers.
      x86: Remove unnecessary casts of void ptr returning alloc
function return values
      x86, apic: Remove double #include
      UWB: Return UWB_RSV_ALLOC_NOT_FOUND rather than crashing on NULL
dereference if kzalloc fails

Jesse Barnes (3):
      drm/i915: Fix the graphics frequency clamping at init and when
IPS is active.
      Input: i8042 - add Sony VAIOs to MUX blacklist
      PCI: read current power state at enable time

Jim Bos (2):
      i8k: Tell gcc that *regs gets clobbered
      Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)

Jim Sung (1):
      usb: subtle increased memory usage in u_serial

Jiri Olsa (1):
      tty: prevent DOS in the flush_to_ldisc

Jiri Slaby (4):
      FS: cifs, remove unneeded NULL tests
      xen: fix memory leak in Xen PCI MSI/MSI-X allocator.
      xen-pcifront: fix PCI reference leak
      TTY: restore tty_ldisc_wait_idle

Joakim Tjernlund (2):
      ucc_geth: Do not bring the whole IF down when TX failure.
      ucc_geth: Fix deadlock

Joe Perches (10):
      ASoC: Update WARN uses in wm_hubs
      ARM: arch/arm/kernel/hw_breakpoint.c: Convert WARN_ON to WARN
      ARM: arch/arm/kernel/traps.c: Convert sprintf_symbol to %pS
      drivers/gpu/drm/vmwgfx: Fix k.alloc switched arguments
      drivers/gpu/drm: Update WARN uses
      drivers/gpu: Use vzalloc
      Staging: udlfb.c: Fix k.alloc switched arguments
      drivers/serial/bfin_5xx.c: Fix line continuation defects
      drivers/pcmcia/soc_common.c: Use printf extension %pV
      MAINTAINERS: Mark XEN lists as moderated

Johan Hedberg (1):
      Bluetooth: Fix non-SSP auth request for HIGH security level sockets

Johannes Berg (1):
      led-class: always implement blinking

John Faith (1):
      smsc911x: Set Ethernet EEPROM size to supported device's size

Julia Lawall (3):
      drivers/staging: delete double assignment
      drivers/staging/brcm80211/brcmfmac/dhd_linux.c: delete double assignment
      drivers/ata/pata_octeon_cf.c: delete double assignment

Junchang Wang (1):
      pktgen: correct uninitialized queue_map

Ken Chen (1):
      latencytop: fix per task accumulator

Ken Kawasaki (1):
      axnet_cs: fix resume problem for some Ax88790 chip

Ken Mills (2):
      n_gsm: Copy n2 over when configuring via ioctl interface
      n_gsm: Fix length handling

Komuro (1):
      pd6729: Coding Style fixes

Konrad Rzeszutek Wilk (1):
      MAINTAINERS: Update mailing list name for Xen pieces.

Konstantin Katuev (1):
      Staging: keucr driver: fix uninitialized variable & proper memset length

Kukjin Kim (2):
      ARM: SAMSUNG: Fix HAVE_S3C2410_I2C warnings
      ARM: SAMSUNG: Fix HAVE_S3C_RTC warnings

Kulikov Vasiliy (3):
      drm: vmwgfx: fix information leak to userland
      net: tipc: fix information leak to userland
      xfs: xfs_ioctl: fix information leak to userland

Kuninori Morimoto (3):
      ARM: mach-shmobile: clock-sh7372: Add FSIDIV clock support
      ARM: mach-shmobile: ap4evb: Add HDMI sound support
      ARM: mach-shmobile: ap4evb: add fsib 44100Hz rate

Kusanagi Kouichi (1):
      x86, pvclock: Remove leftover scale_delta() function

Kyle McMartin (1):
      i915: reprogram power monitoring registers on resume

Kyungmin Park (1):
      ARM: SAMSUNG: Fix HAVE_S3C2410_WATCHDOG warnings

Larry Finger (1):
      staging: rt2870: Add new USB ID for Belkin F6D4050 v1

Lars Ellenberg (6):
      drbd: consolidate explicit drbd_md_sync into drbd_create_new_uuid
      drbd: tag a few error messages with "assert failed"
      drbd: fix potential deadlock on detach
      drbd: fix potential data divergence after multiple failures
      drbd: fix a misleading printk
      drbd: rate limit an error message

Lawrence Rust (1):
      8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT) hang

Linus Torvalds (5):
      floppy: fix use-after-free in module load failure path
      ipw2x00: remove the right /proc/net entry
      libipw: fix proc entry removal
      include/linux/kernel.h: Move logging bits to include/linux/printk.h
      Linux 2.6.37-rc2

Lorenzo Colitti (1):
      ipv6: addrconf: don't remove address state on ifdown if the
address is being kept

Luiz Augusto von Dentz (1):
      Bluetooth: fix not setting security level when creating a rfcomm session

Lukas Czerner (1):
      ext4: fix lazyinit hang after removing request

Maciej Szmigiero (1):
      SERIAL: blacklist si3052 chip

Magnus Damm (1):
      ARM: shmobile: remove sh_timer_config clk member

Mandar Joshi (1):
      ALSA: usb-audio - Support for Power/Status LED on Creative USB X-Fi S51

Marc Kleine-Budde (1):
      USB: Fix FSL USB driver on non Open Firmware systems

Marcelo Tosatti (1):
      KVM: MMU: fix rmap_remove on non present sptes

Marek Lindner (1):
      Staging: batman-adv: suppress false warning when changing the mac address

Marek Vasut (2):
      backlight: fix blanking for LMS283GF05 LCD
      backlight: fix blanking for L4F00242T03 LCD

Mariusz Kozlowski (1):
      net: Fix header size check for GSO case in recvmsg (af_packet)

Mark Brown (2):
      ASoC: Check return value of struct_strtoul() in pmdown_time_set()
      ASoC: Remove volatility from WM8900 POWER1 register

Martin Wilck (1):
      PCI: fix size checks for mmap() on /proc/bus/pci files

Mathias Nyman (1):
      omap: dma: Add read-back to DMA interrupt handler to avoid
spuriousinterrupts

Matthew Garrett (1):
      Bluetooth: Enable USB autosuspend by default on btusb

Maximiliano David Bustos (1):
      Staging: wlan-ng: Fix wrong #ifdef #endif sequence

Meelis Roos (1):
      sparc: fix openpromfs compile

Michael Hennerich (3):
      Input: adp5588-keys - unify common header defines
      drivers/video/backlight/adp8860_bl.c: fix ambient light zone
overwrite handling
      drivers/video/backlight/adp8860_bl.c: check strict_strtoul() return value

Michael S. Tsirkin (1):
      KVM: Write protect memory after slot swap

Michael Spang (1):
      [ARM] TS-78xxx NAND resource type should be IORESOURCE_MEM

Michel Dänzer (1):
      drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once.

Michel Lespinasse (1):
      Release page reference during page fault retry

Mike Frysinger (1):
      fsl-diu-fb: drop dead ioctl define

Mike Rapoport (2):
      ARM: pxa/cm-x2xx: remove duplicate call to pxa27x_init_irq
      ARM: orion5x/kirkwood/mv78xx0: fix MPP configuration corner cases

Mike Snitzer (1):
      block: read i_size with i_size_read()

Mikulas Patocka (1):
      8250: add support for Kouwell KW-L221N-2

Ming Lei (4):
      usbnet: fix usb_autopm_get_interface failure(v1)
      usb: musb: gadget: fix dma mode 0 in double buffer Rx case
      USB: musb: gadget: fix MUSB_TXMAXP and MUSB_RXMAXP configuration
      usb: musb: fix kernel oops when loading musb_hdrc module for the 2nd time

Nelson Elhage (2):
      netlink: Make nlmsg_find_attr take a const nlmsghdr*.
      inet_diag: Make sure we actually run the same bytecode we audited.

Nick Piggin (1):
      radix-tree: fix RCU bug

Nicolas Kaiser (2):
      crypto: n2 - dubious error check
      pcmcia/cm4000: fix error code

Nicolas Pitre (2):
      [ARM] Kirkwood: restrict the scope of the PCIe reset workaround
      vcs: make proper usage of the poll flags

Oleg Nesterov (1):
      posix-cpu-timers: workaround to suppress the problems with mt exec

Oliver Hartkopp (1):
      can-bcm: fix minor heap overflow

Patrick McHardy (1):
      netfilter: nf_nat: fix compiler warning with CONFIG_NF_CT_NETLINK=n

Paul Mundt (27):
      sh: mach-microdev: SuperIO-relative ioport mapping.
      sh: mach-snapgear: Rip out superfluous PIO routines.
      sh: mach-snapgear: Kill off machtype, consolidate board def.
      sh: mach-systemh: Kill off dead board.
      sh: mach-se: Rip out superfluous 7206 PIO routines.
      sh: mach-edosk7705: update for this century, kill off PIO trapping.
      sh: mach-edosk7705: Kill off machtype, consolidate board def.
      sh: mach-se: Rip out superfluous 770x PIO routines.
      sh: mach-se: Rip out superfluous 7751 PIO routines.
      ARM: mach-shmobile: include drivers/sh/Kconfig
      sh: clkfwk: Fix up rate rounding error handling.
      sh: intc: Update for single IRQ reservation helper.
      fs: logfs: Fix up MTD=y build.
      ARM: mach-shmobile: Allow GPIO chips to register IRQ mappings.
      mmc: sh_mmcif: Convert extern inline to static inline.
      sh: mach-se: Fix up SE7206 no ioport build.
      sh: nommu: use 32-bit phys mode.
      sh: nommu: Support building without an uncached mapping.
      sh: Simplify phys_addr_mask()/PTE_PHYS_MASK for 29/32-bit.
      sh: clkfwk: Fix up checkpatch warnings.
      net dst: need linux/cache.h for ____cacheline_aligned_in_smp.
      sh: intc: Fix up initializers for gcc 4.5.
      sh: clkfwk: fix up compiler warnings.
      MAINTAINERS: update the sh git tree entry.
      MAINTAINERS: update the ARM SH-Mobile git tree entry.
      MAINTAINERS: Add an fbdev git tree entry.
      sh: intc: Fix up build failure introduced by radix tree changes.

Pavel Emelyanov (4):
      rds: Lost locking in loop connection freeing
      rds: Remove kfreed tcp conn from list
      rds: Fix rds message leak in rds_message_map_pages
      slub: Fix slub_lock down/up imbalance

Pavel Shilovsky (2):
      CIFS: Add cifs_set_oplock_level
      cifs: make cifs_set_oplock_level() take a cifsInodeInfo pointer

Pekka Enberg (1):
      perf_events: Fix perf_counter_mmap() hook in mprotect()

Peter Ujfalusi (3):
      ASoC: tlv320dac33: Error handling for broken chip
      ASoC: tlv320dac33: Limit the US_TO_SAMPLES macro
      ASoC: tlv320dac33: Mode1 FIFO auto configuration fix

Peter Zijlstra (1):
      perf, amd: Use kmalloc_node(,__GFP_ZERO) for northbridge
structure allocation

Philipp Reisner (4):
      drbd: Silenced an assert
      drbd: Removed the BIO_RW_BARRIER support form the receiver/epoch code
      drbd: REQ_HARDBARRIER -> REQ_FUA transition for meta data accesses
      drbd: Removed checks for REQ_HARDBARRIER on incomming BIOs

Philippe De Muyter (1):
      m68k, m68knommu: Do not include linux/hardirq.h in asm/irqflags.h

Philippe Rétornaz (1):
      tty_ldisc: Fix BUG() on hangup

Rafael J. Wysocki (1):
      gianfar: Do not call device_set_wakeup_enable() under a spinlock

Rahul Ruikar (1):
      usb: musb: musb_gadget: fix resource leakage in error path

Rajkumar Manoharan (3):
      ath9k: Avoid HW opmode overridden on monitor mode changes
      ath9k_htc: Fix probe failure if CONFIG_USB_DEBUG enabled
      ath9k_hw: Fix memory leak on ath9k_hw_rf_alloc_ext_banks failure

Rakib Mullick (1):
      x86, mm: Fix section mismatch in tlb.c

Randy Dunlap (6):
      leds-net5501: taints kernel, add license
      usb.h: fix ioctl kernel-doc info
      Bluetooth: fix hidp kconfig dependency warning
      Staging: ath6kl: ATH6KL_CFG80211 depends on CFG80211
      Documentation: remove anticipatory scheduler info
      PCI: sysfs: fix printk warnings

Richard Weinberger (1):
      um: fix ptrace build error

Russell King (2):
      ARM: Fix DMA coherent allocator alignment
      ARM: GIC: don't disable software generated interrupts

Ryan Mallon (1):
      ARM: 6462/1: EP93xx: Document DMA M2P API

Sam Tygier (1):
      DRM: ignore invalid EDID extensions

Samu Onkalo (4):
      leds: driver for National Semiconductor LP5521 chip
      leds: driver for National Semiconductors LP5523 chip
      leds: update LP552x support Kconfig and Makefile
      Documentation: led drivers lp5521 and lp5523

Sascha Hauer (2):
      [media] ARM mx3_camera: check for DMA engine type
      [media] soc-camera: Compile fixes for mx2-camera

Scott Wood (4):
      PPC: KVM: Book E doesn't have __end_interrupts.
      KVM: PPC: e500: Call kvm_vcpu_uninit() before kvmppc_e500_tlb_uninit().
      KVM: PPC: BookE: fix sleep with interrupts disabled
      KVM: PPC: BookE: Load the lower half of MSR

Sebastien Bourdeauducq (1):
      USB: ftdi_sio: add device IDs for Milkymist One JTAG/serial

Sergei Shtylyov (1):
      usb: musb: gadget: kill duplicate code in musb_gadget_queue()

Sergey Senozhatsky (1):
      ioprio: rcu_read_lock/unlock protect find_task_by_vpid call (V2)

Shan Wei (2):
      ipv6: fix overlap check for fragments
      netfilter: ipv6: fix overlap check for fragments

Shaohua Li (1):
      vmscan: avoid setting zone congested if no page dirty

Simon Guinot (2):
      [ARM] Kirkwood: enhance TCLK detection
      [ARM] Kirkwood: fix timer initialization for LaCie boards

Sjur Brændeland (1):
      caif: SPI-driver bugfix - incorrect padding.

Sonic Zhang (4):
      serial: bfin_5xx: always include DMA headers
      serial: bfin_5xx: remove redundant SSYNC to improve TX speed
      serial: bfin_5xx: disable CON_PRINTBUFFER for consoles
      serial: bfin_5xx: grab port lock before making port termios changes

Stefan Ringel (1):
      [media] tm6000: bugfix set tv standards

Stefan Weil (1):
      USB: ohci-jz4740: Fix spelling in MODULE_ALIAS

Steffen Klassert (1):
      crypto: pcrypt - Fix use after free on padata_free

Stephane Eranian (1):
      perf_events: Fix time tracking in samples

Stephen M. Cameron (5):
      cciss: fix board status waiting code
      cciss: Use kernel provided PCI state save and restore functions
      cciss: limit commands allocated on reset_devices
      cciss: use usleep_range not msleep for small sleeps
      cciss: remove controllers supported by hpsa

Steve French (1):
      [CIFS] Cleanup unused variable build warning

Steven Rostedt (1):
      PCI hotplug: ibmphp: Add check to prevent reading beyond mapped area

Steven Whitehouse (1):
      GFS2: Fix inode deallocation race

Suresh Jayaraman (2):
      cifs: trivial comment fix: tlink_tree is now a rbtree
      cifs: fix a memleak in cifs_setattr_nounix()

Takashi Iwai (1):
      drm/i915: Fix typo from "Enable DisplayPort Audio"

Tao Ma (1):
      ocfs2: Change some lock status member in ocfs2_lock_res to char.

Tejun Heo (2):
      libata: fix NULL sdev dereference race in atapi_qc_complete()
      pata_legacy: fix CONFIG_PATA_WINBOND_VLB_MODULE test

Tetsuo Handa (1):
      kernel: Constify temporary variable in roundup()

Theodore Ts'o (7):
      ext4: Remove useless spinlock in ext4_getattr()
      ext4: "ret" may be used uninitialized in ext4_lazyinit_thread()
      ext4: initialize the percpu counters before replaying the journal
      ext4: handle writeback of inodes which are being freed
      ext4: fix potential race when freeing ext4_io_page structures
      ext4: Don't call sb_issue_discard() in ext4_free_blocks()
      ext4: Add new ext4 inode tracepoints

Thomas Graf (2):
      text ematch: check for NULL pointer before destroying textsearch config
      rtnetlink: Fix message size calculation for link messages

Thomas Hellstrom (10):
      drm/ttm: Documentation update
      drm/ttm: Use private locks for the default bo range manager
      drm/ttm: Remove pointless list_empty check
      drm/ttm: Remove mm init error printouts and checks
      drm/ttm: Add a barrier when unreserving
      drm/ttm: remove failed ttm binding error printout
      drm/ttm: Make sure a sync object doesn't disappear while we use it
      drm/ttm: Remove the CAP_SYS_ADMIN requirement for bo pinning
      drm/vmwgfx: Fix oops on failing bo pin
      drm/ttm: Be consistent on ttm_bo_init() failures

Thomas Weber (1):
      OMAP2: Devkit8000: Fix mmc regulator failure

Tim Blechmann (1):
      ALSA: lx6464es - make 1 bit signed bitfield unsigned

Tom Herbert (1):
      net: check queue_index from sock is valid for device

Tom Zanussi (7):
      perf trace scripting: fix some small memory leaks and missing error checks
      perf trace scripting: remove system-wide param from shell scripts
      perf record: make the record options available outside perf record
      perf trace record: handle commands correctly
      perf trace: live-mode command-line cleanup
      perf trace: update Documentation with new perf trace variants
      perf trace: update usage

Tomi Valkeinen (3):
      OMAP: VRAM: improve VRAM error prints
      OMAP: VRAM: Fix boot-time memory allocation
      OMAP: DSS: Fix documentation regarding 'vram' kernel parameter

Tony SIM (1):
      ARM: mach-shmobile: intc-sh7372: fix interrupt number

Tyson Whitehead (1):
      drm/radeon/kms: fix bugs in ddc and cd path router code

Ursula Braun (1):
      qeth: remove dev_queue_xmit invocation

Uwe Kleine-König (3):
      trivial: fix typos concerning "function"
      pcmcia/sa1100: don't put machine specific init functions in .init.text
      USB: ehci/mxc: compile fix

Vasanthakumar Thiagarajan (1):
      ath9k_hw: Fix AR9280 surprise removal during frequent idle on/off

Vasiliy Kulikov (14):
      ipv4: netfilter: arp_tables: fix information leak to userland
      ipv4: netfilter: ip_tables: fix information leak to userland
      KVM: PPC: fix information leak to userland
      KVM: x86: fix information leak to userland
      staging: cpia: fix camera file owner in cpia_open()
      staging: stradis: fix error handling and information leak to userland
      staging: vt6656: implement missing brackets
      block: ioctl: fix information leak to userland
      net: ax25: fix information leak to userland
      net: packet: fix information leak to userland
      usb: misc: sisusbvga: fix information leak to userland
      usb: misc: iowarrior: fix information leak to userland
      usb: core: fix information leak to userland
      drivers/misc/apds9802als.c: fix signedness bug

Vipin Mehta (1):
      staging: ath6kl: Fixing the driver to use modified mmc_host structure

Vivek Goyal (1):
      floppy: fix another use-after-free

Vivek Natarajan (1):
      ath9k: Fix a DMA latency issue for Intel Pinetrail platforms.

Wey-Yi Guy (1):
      iwlwifi: dont use pci_dev before it being assign

Will Deacon (4):
      ARM: 6468/1: backtrace: fix calculation of thread stack base
      ARM: 6469/1: perf-events: squash compiler warning
      ARM: 6470/1: atomic64: use generic implementation for OABI configurations
      ARM: 6472/1: vexpress ct-ca9x4: only set twd_base if local
timers are being used

Wolfram Sang (1):
      i2c: Remove obsolete cleanup for clientdata

Wu Fengguang (1):
      vmstat: fix offset calculation on void*

Xiaotian Feng (1):
      net dst: fix percpu_counter list corruption and poison overwritten

Yaniv Rosner (8):
      bnx2x: Restore appropriate delay during BMAC reset
      bnx2x: Fix waiting for reset complete on BCM848x3 PHYs
      bnx2x: Fix port selection in case of E2
      bnx2x: Clear latch indication on link reset
      bnx2x: Fix resetting BCM8726 PHY during common init
      bnx2x: Do not enable CL37 BAM unless it is explicitly enabled
      bnx2x: Reset 8073 phy during common init
      bnx2x: Update version number

Yusuke Goda (1):
      ARM: mach-shmobile: ap4evb: Mark NOR boot loader partitions read-only.

Zhenyu Wang (4):
      drm/i915: Fix KMS regression on Sandybridge/CPT
      drm/i915; Don't apply Ironlake FDI clock workaround to Sandybridge
      agp/intel: restore cache behavior on sandybridge
      agp/intel: fix cache control for sandybridge

andrew hendry (1):
      memory corruption in X.25 facilities parsing

françois romieu (2):
      r8169: revert "Handle rxfifo errors on 8168 chips"
      r8169: fix sleeping while holding spinlock.

ma rui (1):
      USB: option: fix when the driver is loaded incorrectly for some
Huawei devices.

sjur.brandeland@stericsson.com (1):
      caif: Remove noisy printout when disconnecting caif socket

stephen hemminger (1):
      classifier: report statistics for basic classifier

steven miao (1):
      Bluetooth: fix unaligned access to l2cap conf data

wzt.wzt@gmail.com (2):
      APPARMOR: Fix memory leak of alloc_namespace()
      APPARMOR: Fix memory leak of apparmor_init()
