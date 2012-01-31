Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2AaV7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:59:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42480 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab2AaV7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:59:46 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 31 Jan 2012 13:59:26 -0800
X-Google-Sender-Auth: kwDKyy_vxV17oZvxbjWvQ-qSb7U
Message-ID: <CA+55aFye5iedspjus4YLi+r77Xq74bCq+MqU0HrTmDC5Dveivg@mail.gmail.com>
Subject: Linux 3.3-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so for no real reason at all - except me being disorganized and
just not thinking about it - rc2 is several days delayed. It's closer
to two weeks rather than the standard one week I try to have between
rc's.

So as a result of that, this -rc2 is a bit bigger than the ones
historically, but that's really just because timing-wise it's more
like an -rc3. And for that, it's right in line with normal trends, and
possibly even on the smaller side.

Anyway, apart from that mind-fart, there's nothing particularly odd
here. The diffstat is pretty flat - indicative of mostly small changes
spread out. Which is what I like seeing, and we don't always see at
this point. There's some file movement (8250-based serial and the arm
mx5 -> imx merge), but otherwise really not a lot of excitement. Good.

One thing that has happened is that I've liked seeing the merge
message things that have come in through signed tags so much that I've
decided to try to write more explanations even for the merges that
don't get that kind of love from their subsystem maintainers. Some
subsystem maintainers (David with networking is a good example) have
tended to write nice good explanations in their pull requests, and
I've started to try to make those kinds of things part of my merge
messages.

I'm not sure how many people really look at merges, and maybe it's a
waste of my time, but I thought I'd try it. I've also spent more
effort trying to explain even fairly trivial merge conflicts (although
the truly trivial "touched next to each other" that just aren't
interesting from a code standpoint I generally have left without
explanation).

Of course, if the submaintainer doesn't really give me much to work
with, and the merge was all clean and didn't have any issues, we still
have fairly bare merge messages. But on the whole I'm trying to act as
a good example of what a merge message *should* look like, since I've
been complaining about some submaintainers not doing a particularly
good job at explaining their reverse merges even when they actually
made sense (most of the time, the reverse merge is just ugly and
shouldn't have been done at all, but when the merge makes sense,
please do spend the time explaining it).

Anyway, I'm planning on continuing doing this at least for now,
although see above about the "submaintainer doesn't really give me
much to work with" case. Signed tags are obviously preferred - and
while the signature itself is part of the reason, I think the whole
"you can use them to explain your pull request" should actually be
seen as a bigger part. But I'll try to do it even for the unsigned
case if you just give me something to work with (and if there are
conflicts, I'm hoping that my more verbose explanation of the conflict
resolution is useful too).

Making appreciative noises - if you really do care - may be a good
idea just to convince me that it's worth the effort in the long run,
but I have to say that even just looking at the logs (which is
something I do a fair amount) is what convinced me to start, so I
suspect I'll try to continue doing this even if nobody else cares.

Other comments about -rc2? Not much. I declined one or two pull
requests because they didn't seem to be appropriate for post-merge,
but I'm obviously always up for debate (even if sometimes I just
ignore arguments, and other times it just results in me swearing at
you - neither situation is necessarily an indication of much more than
my mood at the time, of course).

Go forth and test.

                        Linus

---
Alan Cox (4):
      gma500: Fix shmem mapping
      serial: Kill off Moorestown code
      USB: ftdi_sio: Add more identifiers

Alan Stern (2):
      Documentation update for the driver model core
      USB: OHCI: fix new compiler warnings

Albert Pool (1):
      snd-hda-intel: better Alienware M17x R3 quirk

Alessandro Rubini (3):
      stmmac: fix phy naming inconsistency
      stmmac: added PCI identifiers
      usb: add support for STA2X11 host driver

Alex Deucher (7):
      drm/radeon/kms: Add an MSI quirk for Dell RS690
      drm/radeon/kms: add some missing semaphore init
      drm/radeon/kms: move disp eng pll setup to init path
      drm/radeon/kms: move panel mode setup into encoder mode set
      drm/radeon/kms: rework modeset sequence for DCE41 and DCE5
      drm/radeon/kms: use drm_detect_hdmi_monitor for picking encoder mode
      drm/radeon/kms: refine TMDS dual link checks

Alexander Duyck (1):
      ixgbe: Fix register defines to correctly handle complex expressions

Alexander Shishkin (3):
      usb: otg: kill langwell_otg driver
      usb: gadget: langwell: drop langwell_otg support
      usb: gadget: langwell: don't call gadget's disconnect()

Alexey Dobriyan (2):
      crypto: sha512 - make it work, undo percpu message schedule
      crypto: sha512 - reduce stack usage to safe number

Ananth N Mavinakayanahalli (1):
      kprobes: initialize before using a hlist

Andiry Xu (2):
      usb: gadget: storage: endian fix
      xHCI: Cleanup isoc transfer ring when TD length mismatch found

Andreas Herrmann (2):
      x86/amd: Add missing feature flag for fam15h models 10h-1fh processors
      x86/microcode_amd: Add support for CPU family specific container files

Andreas Schwab (1):
      m68k: Fix assembler constraint to prevent overeager gcc optimisation

Andrew Morton (2):
      mm: fix warnings regarding enum migrate_mode
      drivers/usb/misc/emi26.c & emi62.c: fix warnings

Antti Palosaari (4):
      [media] cxd2820r: fix dvb_frontend_ops
      [media] cxd2820r: remove unused parameter from cxd2820r_attach
      [media] anysee: fix CI init
      [media] cxd2820r: sleep on DVB-T/T2 delivery system switch

Ariel Elior (1):
      bnx2x: handle CHIP_REVISION during init_one

Axel Lin (8):
      drivers/video/backlight/adp88x0_bl.c: fix bit testing logic
      drivers/video/backlight/l4f00242t03.c: return proper error in
l4f00242t03_probe if regulator_get() fails
      watchdog: via_wdt: Staticise wdt_pci_table
      watchdog: Staticise nuc900_wdt
      watchdog: Return proper error in nuc900wdt_probe if misc_register fails
      watchdog: wm8350_wdt: Fix handling
WDIOS_DISABLECARD/WDIOS_ENABLECARD options
      watchdog: wafer5823wdt: Fix handling
WDIOS_DISABLECARD/WDIOS_ENABLECARD options
      watchdog: via_wdt: Set min_timeout and max_timeout for wdt_dev

Ben Skeggs (1):
      drm/ttm: fix two regressions since move_notify changes

Benjamin Herrenschmidt (2):
      powerpc/powernv: Fix PCI resource handling
      powerpc: Fix build on some non-freescale platforms

Bjørn Mork (5):
      USB: cdc-wdm: updating desc->length must be protected by spin_lock
      USB: cdc-wdm: use two mutexes to allow simultaneous read and write
      USB: cdc-wdm: call wake_up_all to allow driver to shutdown on
device removal
      USB: cdc-wdm: better allocate a buffer that is at least as big
as we tell the USB core
      USB: cdc-wdm: Avoid hanging on interface with no USB_CDC_DMM_TYPE

Carolyn Wyborny (1):
      igb: Update Copyright on all Intel copyrighted files.

Catalin Marinas (1):
      ARM: 7301/1: Rename the T() macro to TUSER() to avoid namespace conflicts

Chris Healy (1):
      dsa: Add reporting of silicon revision for Marvell
88E6123/88E6161/88E6165 switches.

Chris Mason (1):
      Btrfs: fix reservations in btrfs_page_mkwrite

Chris Wilson (1):
      drm: Pass the real error code back during GEM bo initialisation

Christian Borntraeger (1):
      [S390] cleanup entry point definition

Christian Kujau (1):
      powerpc/crash: Fix build error without SMP

Cliff Wickman (1):
      x86/uv: Fix uninitialized spinlocks

Dan Carpenter (2):
      cifs: integer overflow in parse_dacl()
      ACPI, APEI, EINJ, cleanup 0 vs NULL confusion

Dan Rosenberg (1):
      score: fix off-by-one index into syscall table

Dan Williams (1):
      qcaux: add more Pantech UML190 and UML290 ports

Daniel Borkmann (1):
      microblaze: generic atomic64 support

Daniel J Blueman (1):
      x86/numachip: Drop unnecessary conflict with EDAC

Daniel Vetter (8):
      drm/i915: convert force_wake_get to func pointer in the gpu reset code
      drm/i915: protect force_wake_(get|put) with the gt_lock
      drm/i915: paper over missed irq issues with force wake voodoo
      drm/i915: rip out the HWSTAM missed irq workaround
      drm/i915: allow userspace forcewake references also on gen7
      drm/i915: debugfs: show semaphore registers also on gen7
      drm/i915: fixup forcewake spinlock fallout in drpc debugfs function
      Revert "drm/i810: cleanup reclaim_buffers"

Darren Hart (1):
      pch_gbe: Do not abort probe on bad MAC

David Henningsson (1):
      ALSA: HDA: Use model=auto for Thinkpad T510

David S. Miller (2):
      bluetooth: hci: Fix type of "enable_hs" to bool.
      rds: Make rds_sock_lock BH rather than IRQ safe.

David Sterba (1):
      btrfs: mask out gfp flags in releasepage

David Vrabel (1):
      x86: xen: size struct xen_spinlock to always fit in arch_spinlock_t

Davidlohr Bueso (1):
      ipc/mqueue: simplify reading msgqueue limit

Deepthi Dharwar (1):
      powerpc/cpuidle: Make it a bool, not a tristate

Djalal Harouni (1):
      ext2: protect inode changes in the SETVERSION and SETFLAGS ioctls

Dmitry Kravkov (2):
      bnx2x: fix Big-Endianess in ethtool -t
      bnx2x: allow user to change ring size in ISCSI SD mode

Duncan Laurie (1):
      CHROMIUM: i915: Add DMI override to skip CRT initialization on ZGB

Dustin Kirkland (1):
      MAINTAINERS: Update eCryptfs maintainer address

Eliad Peller (2):
      mac80211: update oper_channel on ibss join
      mac80211: set bss_conf.idle when vif is connected

Eric Anholt (3):
      drm/i915: Print debugfs object list sizes in KiB instead of bytes.
      drm/i915: Correct debugfs printout for RC1e.
      drm/i915: Re-enable gen7 RC6 and GPU turbo after resume.

Eric Dumazet (5):
      net: bpf_jit: fix divide by 0 generation
      macvlan: fix a possible use after free
      tg3: fix ipv6 header length computation
      netns: fix net_alloc_generic()
      af_unix: fix EPOLLET regression for stream sockets

Eric W. Biederman (4):
      usb: io_ti: Make edge_remove_sysfs_attrs the port_remove method.
      sysfs: Complain bitterly about attempts to remove files from
nonexistent directories.
      netns: Fail conspicously if someone uses net_generic at an
inappropriate time.
      net caif: Register properly as a pernet subsystem.

Eugeni Dodonov (2):
      drm/i915: simplify pipe checking
      drm/i915: handle 3rd pipe

Eugenia Emantayev (3):
      mlx4_en: clear all eth statistics when port goes up
      mlx4: VF is not allowed to perform dump stats
      mlx4_en: eth statistics modification

Fabio Estevam (6):
      ARM: 7277/1: setup.c: Fix build warning by removing unneeded header file
      ASoC: mxs: Fix mxs-saif timeout
      drivers: usb: otg: Fix dependencies for some OTG drivers
      usb: gadget: f_mass_storage: Use "bool" instead of "int" in
fsg_module_parameters
      drivers: usb: Fix dependency for USB_HWA_HCD
      ARM: imx: iomux-v1.h: Fix build error due to __init annotation

Felipe Balbi (3):
      usb: dwc3: ep0: tidy up Pending Request handling
      usb: dwc3: ep0: fix compile warning
      usb: serial: kobil_sct: fix compile warning:

Finn Thain (3):
      macfb: fix black and white modes
      mac_scsi: dont enable mac_scsi irq before requesting it
      mac_esp: rename irq

Flavio Leitner (2):
      tcp: bind() fix autoselection to share ports
      tcp: bind() optimize port allocation

Francesco Ruggeri (1):
      net: race condition in ipv6 forwarding and disable_ipv6 parameters

Geert Uytterhoeven (2):
      m68k/irq: Remove obsolete IRQ_FLG_* definitions
      usb: mv-otg - Fix build if CONFIG_USB is not set

Glauber Costa (5):
      net: fix socket memcg build with !CONFIG_NET
      cgroup: make sure memcg margin is 0 when over limit
      net: introduce res_counter_charge_nofail() for socket allocations
      net: explicitly add jump_label.h header to sock.h
      net/tcp: Fix tcp memory limits initialization when !CONFIG_SYSCTL

Grazvydas Ignotas (1):
      usb: musb: fix shutdown while usb gadget is in use

Greg Kroah-Hartman (6):
      driver core: remove drivers/base/sys.c and include/linux/sysdev.h
      stable: update documentation to ask for kernel version
      Revert "USB: usb-skeleton.c: fix open/disconnect race"
      Revert "drivers: usb: Fix dependency for USB_HWA_HCD"
      Revert "tty: serial: OMAP: transmit FIFO threshold interrupts
don't wake the chip"
      Revert "tty: serial: OMAP: ensure FIFO levels are set correctly
in non-DMA mode"

Greg Rose (1):
      ixgbevf: Prevent possible race condition by checking for message

Guenter Roeck (2):
      MAINTAINERS: Drop maintainer for MAX1668 hwmon driver
      hwmon: (w83627ehf) Disable setting DC mode for pwm2, pwm3 on NCT6776F

Gustavo Maciel Dias Vieira (1):
      ALSA: hda: set mute led polarity for laptops with buggy BIOS based on SSID

Harrison Metzger (1):
      USB: usbsevseg: fix max length

Heiko Carstens (1):
      rcu: Add missing __cpuinit annotation in rcutorture code

Hillf Danton (1):
      mm/hugetlb.c: undo change to page mapcount in fault handler

Hugh Dickins (2):
      SHM_UNLOCK: fix long unpreemptible section
      SHM_UNLOCK: fix Unevictable pages stranded after swap

Igor Murzov (2):
      drm/radeon: fix invalid memory access in radeon_atrm_get_bios()
      drm/radeon: finish getting bios earlier

Inki Dae (3):
      drm/exynos: fixed build dependency for DRM_EXYNOS_FIMD
      MAINTAINERS: added maintainer entry for Exynos DRM Driver.
      drm/exynos: fixed pm feature for fimd module.

James Chapman (1):
      l2tp: l2tp_ip - fix possible oops on packet receive

Jan Kara (4):
      jbd: Issue cache flush after checkpointing
      quota: Pass information that quota is stored in system file to userspace
      xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()
      btrfs: Fix busyloops in transaction waiting code

Jan Schmidt (1):
      Btrfs: fix uninit warning in backref.c

Jason Wang (2):
      virtio: fix typos of memory barriers
      virtio: correct the memory barrier in virtqueue_kick_prepare()

Javier Cardona (1):
      mac80211: Use the right headroom size for mesh mgmt frames

Jean Delvare (3):
      hwmon: (f71805f) Fix clamping of temperature limits
      thermal: Rename generate_netlink_event
      drm/radeon/kms: Fix device tree linkage of i2c buses

Jean-Christophe PLAGNIOL-VILLARD (7):
      USB: at91: fix clk_get error handling
      ARM/USB: at91/ohci-at91: rename vbus_pin_inverted to vbus_pin_active_low
      ARM: at91: fix cap9 ddrsdr register
      ARM: at91: merge at91cap9_ddrsdr.h in at91sam9_ddrsdr.h
      ARM: at91: introduce AT91_SAM9_ALT_RESET to select the at91sam9
alternative reset
      ARM: at91: make rstc soc independent
      ARM: at91: Fix at91sam9g45 and at91cap9 reset

Jeff Layton (6):
      cifs: better instrumentation for coalesce_t2
      cifs: lower default wsize when unix extensions are not used
      keys: add a "logon" key type
      cifs: sanitize username handling
      cifs: fetch credentials out of keyring for non-krb5 auth multiuser mounts
      cifs: warn about impending deprecation of legacy MultiuserMount code

Jerome Glisse (2):
      drm/radeon: silence out possible lock dependency warning
      drm/radeon: avoid deadlock if GPU lockup is detected in ib_pool_get

Jerry Huang (1):
      powerpc/85xx: Fix cmd12 bug and add the chip compatible for eSDHC

Jesper Dangaard Brouer (1):
      net: flow_dissector.c missing include linux/export.h

Jesper Juhl (6):
      gpu, drm, sis: Don't return uninitialized variable from sis_driver_load()
      ASoC: wm8958: Use correct format string in dev_err() call
      ASoC: wm2000: Fix use-after-free - don't release_firmware() twice on error
      usb: renesas: silence uninitialized variable report in
usbhsg_recip_run_handle()
      ALSA: Fix memory leak on error in snd_compr_set_params()
      x86/boot-image: Don't leak phdrs in
arch/x86/boot/compressed/misc.c::Parse_elf()

Jesse Barnes (2):
      drm/i915: mask transcoder select bits before setting them on LVDS
      drm/i915: sprite init failure on pre-SNB is not a failure

Jiri Bohac (1):
      bonding: fix enslaving in alb mode when link down

Jiri Pirko (1):
      team: send only changed options/ports via netlink

Jiri Slaby (1):
      TTY: fix UV serial console regression

Joel Sass (1):
      drm/i915: Add Clientron E830 to the ignore LVDS list

Joern Engel (5):
      logfs: Prevent memory corruption
      logfs: remove useless BUG_ON
      logfs: Free areas before calling generic_shutdown_super()
      logfs: Grow inode in delete path
      Logfs: Allow NULL block_isbad() methods

Johan Hovold (8):
      USB: ftdi_sio: fix TIOCSSERIAL baud_base handling
      USB: ftdi_sio: fix initial baud rate
      USB: cp210x: call generic open last in open
      USB: cp210x: fix up set_termios variables
      USB: cp210x: do not map baud rates to B0
      USB: cp210x: clean up, refactor and document speed handling
      USB: cp210x: initialise baud rate at open
      USB: cp210x: allow more baud rates above 1Mbaud

Johannes Berg (3):
      mac80211: fix debugfs key->station symlink
      mac80211: fix work removal on deauth request
      iwlwifi: fix PCI-E transport "inta" race

Johannes Weiner (1):
      mm: memcg: update the correct soft limit tree during migration

John W. Linville (1):
      b43: add option to avoid duplicating device support with brcmsmac

Josef Bacik (3):
      Btrfs: make sure a bitmap has enough bytes
      Btrfs: use cluster->window_start when allocating from a cluster bitmap
      Btrfs: advance window_start if we're using a bitmap

Josh Wu (1):
      [media] V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions

Julia Lawall (5):
      arch/powerpc/sysdev/fsl_pci.c: add missing iounmap
      drivers/usb/host/ehci-fsl.c: add missing iounmap
      arch/arm/mach-imx/mach-mx53_ard.c: add missing iounmap
      watchdog: imx2_wdt.c: use devm_request_and_ioremap
      watchdog: dw_wdt.c: use devm_request_and_ioremap

Karol Lewandowski (1):
      regulator: Set apply_uV only when min and max voltages are defined

Kees Cook (1):
      ARM: 7279/1: standardize /proc/iomem "Kernel code" name

Keith Packard (4):
      drm/i915: Move reset forcewake processing to gen6_do_reset
      drm/i915: Hold gt_lock during reset
      drm/i915: Hold gt_lock across forcewake register reads
      Revert "drm/i915: Work around gen7 BLT ring synchronization issues."

Kentaro Matsuyama (1):
      USB: option: Add LG docomo L-02C

Konrad Rzeszutek Wilk (1):
      xen/granttable: Disable grant v2 for HVM domains.

Konstantin Khlebnikov (1):
      mm: fix rss count leakage during migration

Lan Tianyu (1):
      ACPI / PM: Add Sony Vaio VPCCW29FX to nonvs blacklist.

Li Wang (2):
      eCryptfs: Infinite loop due to overflow in ecryptfs_write()
      eCryptfs: move misleading function comments

Linus Torvalds (1):
      Linux 3.3-rc2

Linus Walleij (1):
      ARM: 7288/1: mach-sa1100: add missing module_init() call

Liu Bo (1):
      Btrfs: do not defrag a file partially

Lucas Kannebley Tavares (2):
      Updated TTY MAINTAINERS info
      jsm: Fixed EEH recovery error

Marc Zyngier (2):
      ARM: 7297/1: smp_twd: make sure timer is stopped before registering it
      ARM: 7298/1: realview: fix mapping of MPCore private memory region

Marcel Apfelbaum (3):
      mlx4_core: removed function index from vf.
      mlx4_core: Fix mtt profile issue
      mlx4_core: map async events to arbitrary slave eqs

Mark Brown (7):
      regmap: Reset cache status when reinitialsing the cache
      ASoC: Mark WM5100 register map cache only when going into BIAS_OFF
      ASoC: Don't go through cache when applying WM5100 rev A updates
      ASoC: Disable register synchronisation for low frequency WM8996 SYSCLK
      ASoC: wm8996: Call _POST_PMU callback for CPVDD
      regulator: Fix documentation for of_node parameter of regulator_register()
      MAINTAINERS: Add hwmon entries for Wolfson

Masanari Iida (1):
      watchdog: Fix typo "unexpectdly"

Mauro Carvalho Chehab (1):
      [media] cinergyT2-fe: Fix bandwdith settings

Miao Xie (1):
      Btrfs: fix enospc error caused by wrong checks of the chunk

Michael Holzheu (1):
      kdump: define KEXEC_NOTE_BYTES arch specific for s390x

Michael Neuling (1):
      powerpc: fix compile error with 85xx/p1022_ds.c

Michal Hocko (2):
      mm: fix NULL ptr dereference in __count_immobile_pages
      mm: __count_immobile_pages(): make sure the node is online

Michal Kubecek (1):
      agp: fix scratch page cleanup

Michał Mirosław (1):
      ethtool: allow ETHTOOL_GSSET_INFO for users

Mitch A Williams (1):
      igbvf: Remove unnecessary irq disable/enable

Mitch Harder (1):
      Btrfs: Check for NULL page in extent_range_uptodate

Myron Stowe (3):
      ACPI, APEI: Add 64-bit read/write support for APEI on i386
      ACPI, APEI: Add RAM mapping support to ACPI
      ACPI: Remove ./drivers/acpi/atomicio.[ch]

Namhyung Kim (3):
      PM / Hibernate: Correct additional pages number calculation
      perf: Don't call release_callchain_buffers() if allocation fails
      perf: Call perf_cgroup_event_time() directly

Neal Cardwell (3):
      tcp: fix undo after RTO for BIC
      tcp: fix undo after RTO for CUBIC
      tcp: fix tcp_trim_head() to adjust segment count with skb MSS

NeilBrown (1):
      usb: musb: omap2430: minor cleanups.

Nicolas Ferre (2):
      ARM: at91: fix at91rm9200 soc subtype handling
      ARM: at91: removal of CAP9 SoC family

Niklas Söderlund (1):
      ACPI, APEI, EINJ Allow empty Trigger Error Action Table

Paul E. McKenney (1):
      sched: Add "const" to is_idle_task() parameter

Paul Gortmaker (4):
      pktgen: Fix unsigned function that is returning negative vals
      serial: group all the 8250 related code together
      drivers/net: dsa/mv88e6xxx.c files need linux/module.h
      netprio_cgroup.h: dont include module.h from other includes

Paul Walmsley (2):
      tty: serial: OMAP: ensure FIFO levels are set correctly in non-DMA mode
      tty: serial: OMAP: transmit FIFO threshold interrupts don't wake the chip

Paul Zimmerman (1):
      usb: gadget: SS Isoc endpoints use comp_desc->bMaxBurst too

Paulius Zaleckas (1):
      mv643xx_eth: Add Rx Discard and Rx Overrun statistics

Paulo Zanoni (1):
      drm/i915/sdvo: always set positive sync polarity

Pavel Shilovsky (1):
      CIFS: Add descriptions to the brlock cache functions

Pawel Moll (1):
      ARM: 7304/1: ioremap: fix boundary check when reusing static mapping

Peter Chen (1):
      usb: gadget: fsl_udc: fix the usage of udc->max_ep

Peter Korsgaard (1):
      USB: ftdi_sio: add PID for TI XDS100v2 / BeagleBone A3

Peter Naulls (1):
      USB: serial: ftdi additional IDs

Philippe Langlais (2):
      mach-ux500: musb: now musb is always in OTG mode
      mach-ux500: no MMC_CAP_SD_HIGHSPEED on Snowball

Prasad Joshi (5):
      logfs: update page reference count for pined pages
      logfs: take write mutex lock during fsync and sync
      logfs: set superblock shutdown flag after generic sb shutdown
      logfs: Propagate page parameter to __logfs_write_inode
      MAINTAINERS: Add Prasad Joshi in LogFS maintiners

Preston Fick (1):
      USB: cp210x: fix CP2104 baudrate usage

Rabin Vincent (2):
      serial: amba-pl011: lock console writes against interrupts
      ARM: 7299/1: ftrace: clear zero bit in reported IPs for Thumb-2

Radu Iliescu (1):
      llc: Fix race condition in llc_ui_recvmsg

Rafael J. Wysocki (1):
      PM / Hibernate: Fix s2disk regression related to freezing workqueues

Ramneek Mehresh (2):
      powerpc/85xx: Enable USB2 controller node for P1020RDB
      powerpc/85xx: Add dr_mode property in USB nodes

Randy Dunlap (21):
      kernel-doc: fix new warning in net/phy/mdio_bus.c
      kernel-doc: fix new warning in net/sock.h
      scripts/kernel-doc: fix fatal error caused by cfg80211.h
      kernel-doc: fix new warnings in auditsc.c
      kernel-doc: fix new warnings in driver-core
      kernel-doc: fix new warnings in pci
      kernel-doc: fix new warning in regulator core
      kernel-doc: fix new warnings in debugfs
      kernel-doc: fix new warnings in device.h
      kernel-doc: fix new warning in usb.h
      kernel-doc: fix new warnings in cfg80211.h
      kernel-doc: fix kernel-doc warnings in sched
      docbook: don't use serial_core.h in device-drivers book
      docbook: change iomap source filename in deviceiobook
      docbook: fix sched source file names in device-drivers book
      kernel-doc: fix new warnings in device.h
      kernel-doc: fix new warnings in debugfs
      kernel-doc: fix new warnings in driver-core
      kernel-doc: fix new warning in usb.h
      docbook: don't use serial_core.h in device-drivers book
      uwb & wusb: fix kconfig error

Raymond Yau (1):
      ALSA: ymfpci - Don't create invalid PCM & mixers when AC97 doesn't support

Renato Caldas (1):
      USB: serial: CP210x: Added USB-ID for the Link Instruments MSO-19

Rodrigo Vivi (2):
      drm/i915: Fix TV Out refresh rate.
      drm/i915: Removing TV Out modes.

Rohit Jain (1):
      drm/i915: VBT Parser cleanup for eDP block

Roopa Prabhu (5):
      enic: This patch adds pci id 0x71 for SRIOV VF's
      enic: Add sriov vf device id checks in port profile code
      enic: rearrange some of the port profile code
      enic: fix location of vnic dev unregister in enic_probe cleanup code
      enic: fix compile when CONFIG_PCI_IOV is not enabled

Russ Anderson (1):
      x86/uv: Fix uv_gpa_to_soc_phys_ram() shift

Russell King (17):
      Revert "ARM: sa1100: clean up of the clock support"
      Revert "ARM: pxa: add dummy clock for sa1100-rtc"
      Revert "RTC: sa1100: support sa1100, pxa and mmp soc families"
      Revert "RTC: sa1100: remove redundant code of setting alarm"
      ARM: sa11x0: fix collie build error
      ARM: sa11x0: fix section mismatch in cpu-sa1100.c
      ARM: fix a section mismatch warning with our use of memblock
      ARM: vexpress: fix two section mismatch warnings
      ARM: fix rcu stalls on SMP platforms
      Revert "ARM: sa1100: Refactor mcp-sa11x0 to use platform resources."
      Revert "ARM: sa11x0: Implement autoloading of codec and codec
pdata for mcp bus."
      MFD: mcp-core: fix complaints from the genirq layer
      MFD: mcp-core: fix mcp_priv() to be more type safe
      MFD: ucb1x00-core: fix missing restore of io output data on resume
      MFD: ucb1x00-core: fix gpiolib direction_output handling
      MFD: ucb1x00-ts: fix resume failure
      PCMCIA: fix sa1111 oops on remove

Rusty Russell (2):
      rcu: Make rcutorture bool parameters really bool (core code)
      lguest: remove reference from Documentation/virtual/00-INDEX

Ryan Mallon (2):
      gma500: Fix suspend/resume functions
      vmwgfx: Fix assignment in vmw_framebuffer_create_handle

Sarah Sharp (1):
      xhci: Fix USB 3.0 device restart on resume.

Sascha Hauer (3):
      ARM i.MX5: remove unnecessary includes from board files
      ARM i.MX: Merge i.MX5 support into mach-imx
      ARM i.MX: Update defconfig

Sathya Perla (1):
      be2net: create RSS rings even in multi-channel configs

Sebastian Andrzej Siewior (3):
      leds: add led driver for Bachmann's ot200
      usb: gadget: check for streams only for SS udcs
      usb: dwc3: unmap the proper number of sg entries

Sekhar Nori (1):
      usb: musb: davinci: fix build breakage

Seth Heasley (1):
      watchdog: iTCO_wdt: add Intel Lynx Point DeviceIDs

Seung-Woo Kim (2):
      drm/exynos: use release_mem_region instead of release_resource
      drm/exynos: fix build dependency for DRM_EXYNOS_HDMI

Shawn Guo (1):
      ARM: imx6: add missing twd_clk for imx6q clock

Shreshtha Kumar Sahu (1):
      amba-pl011: do not disable RTS during shutdown

Shubhrajyoti D (3):
      omap-serial :Make the suspend/resume functions depend on CONFIG_PM_SLEEP.
      omap-serial: make serial_omap_restore_context depend on CONFIG_PM_RUNTIME
      watchdog: omap_wdt.c: Fix the mismatch of pm_runtime enable and disable

Simon Glass (1):
      serial: Fix wakeup init logic to speed up startup

Srinidhi KASAGAR (1):
      mach-ux500: enable ARM errata 764369

Srivatsa S. Bhat (1):
      PM / Hibernate: Rewrite unlock_system_sleep() to fix s2disk regression

Stanislaw Gruszka (2):
      brcmsmac: fix tx queue flush infinite loop
      USB: Realtek cr: fix autopm scheduling while atomic

Stefan Behrens (1):
      Btrfs: fix warning for 32-bit build of fs/btrfs/check-integrity.c

Stefan Gula (1):
      net: RTNETLINK adjusting values of min_ifinfo_dump_size

Stefan Haberland (2):
      [S390] dasd: revert LCU optimization
      [S390] dasd: revalidate server for new pathgroup

Stephen Hemminger (5):
      igb: make local functions static
      igbvf: remove unneeded cast
      ixgbevf: make ethtool ops and strings const
      ixgbevf: fix sparse warnings
      ixgbevf: make operations tables const

Stephen Rothwell (1):
      migrate_mode.h is not exported to user mode

Stephen Warren (1):
      pinctrl: fix pinconf_pins_show iteration

Steve French (4):
      cifs: Fix sparse warning when calling cifs_strtoUCS
      [CIFS] Fix build break with multiuser patch when LANMAN disabled
      [CIFS] ACL and FSCACHE support no longer EXPERIMENTAL
      CIFS: Rename *UCS* functions to *UTF16*

Sumit Semwal (1):
      MAINTAINERS: Add dma-buf sharing framework maintainer

Takashi Iwai (8):
      ALSA: hda/realtek - Avoid multi-ios conflicting with multi-speakers
      ALSA: hda/realtek - Avoid conflict of unsol-events with static quirks
      ALSA: hda/realtek - Remove use_jack_tbl field
      ALSA: hda - Fix a unused variable warning
      ALSA: hda - Fix buffer-alignment regression with Nvidia HDMI
      ALSA: hda - Fix silent outputs from docking-station jacks of Dell laptops
      ALSA: hda - Fix silent output on ASUS A6Rp
      ALSA: hda - Fix silent output on Haier W18 laptop

Tejun Heo (1):
      memblock: Fix alloc failure due to dumb underflow protection in
memblock_find_in_range_node()

Tetsuo Handa (1):
      PM / Sleep: Fix read_unlock_usermodehelper() call.

Thomas Faber (1):
      net: ftgmac100/ftmac100: add missing interrupt.h include

Thomas Hellstrom (1):
      drm: Fix authentication kernel crash

Thomas Renninger (2):
      ACPI processor hotplug: Split up acpi_processor_add
      ACPI processor hotplug: Delay acpi_processor_start() call for
hotplugged cores

Tim Gardner (2):
      ecryptfs: Improve metadata read failure logging
      ecryptfs: Remove unnecessary variable initialization

Tkhai Kirill (1):
      sparc32: forced setting of mode of sun4m per-cpu timers

Tony Lindgren (4):
      pinctrl: free debugfs entries when unloading a pinmux driver
      pinctrl: fix some pinmux typos
      pinctrl: fix pinmux_hog_maps when ctrl_dev_name is not set
      pinctrl: add checks for empty function names

Tony Luck (1):
      Use acpi_os_map_memory() instead of ioremap() in einj driver

Trond Myklebust (1):
      SUNRPC: Fix machine creds in generic_create_cred and generic_match

Tyler Hicks (7):
      eCryptfs: Sanitize write counts of /dev/ecryptfs
      eCryptfs: Report errors in writes to /dev/ecryptfs
      eCryptfs: Replace miscdev read/write magic numbers
      eCryptfs: Make truncate path killable
      eCryptfs: Check inode changes in setattr
      eCryptfs: Remove unused ecryptfs_read()
      eCryptfs: Fix oops when printing debug info in extent crypto functions

Uwe Kleine-König (2):
      Documentation/pinctrl: fix a few syntax errors in code examples
      pinctrl: unbreak error messages

Vijay Subramanian (1):
      netem: Fix off-by-one bug in reordering

Viresh Kumar (2):
      PM / Documentation: Fix spelling mistake in basic-pm-debugging.txt
      PM / Documentation: Fix minor issue in freezing_of_tasks.txt

Vivien Didelot (1):
      hwmon: (sht15) fix bad error code

Wei Liu (1):
      xen-netfront: correct MAX_TX_TARGET calculation.

Wei Yongjun (1):
      net/hyperv: fix possible memory leak in do_set_multicast()

Will Deacon (7):
      ARM: 7289/1: vmlinux.lds.S: do not hardcode cacheline size as 32 bytes
      ARM: 7290/1: vmlinux.lds.S: align the exception fixup table to a
4-byte boundary
      ARM: 7291/1: cache: assume 64-byte L1 cachelines for ARMv7 CPUs
      ARM: 7293/1: logical_cpu_map: decouple CPU mapping from SMP
      ARM: 7295/1: cortex-a7: move proc_info out of !CONFIG_ARM_LPAE block
      ARM: 7296/1: proc-v7.S: remove HARVARD_CACHE preprocessor guards
      proc: clear_refs: do not clear reserved pages

Willem de Bruijn (1):
      ipv6: Fix ip_gre lockless xmits.

Wolfram Sang (3):
      ASoC: tlv320aic32x4: always enable dividers
      ASoC: tlv320aic32x4: always enable analouge block
      Documentation: devres: add allocation functions to list of supported calls

Yevgeny Petrilin (1):
      mlx4_en: set number of rx rings used by RSS using ethtool

Yuchung Cheng (1):
      tcp: detect loss above high_seq in recovery

Yuval Mintz (3):
      bnx2x: credit-leakage fixup on vlan_mac_del_all
      bnx2x: fixed ethtool statistics for MF modes
      bnx2x: fix compilation error with SOE in fw_dump

Zeng Zhaoming (1):
      ASoC: sgtl5000: Fix wrong register name in restore

majianpeng (1):
      base/core.c:fix typo in comment in function device_add

shawnlu (1):
      tcp: md5: using remote adress for md5 lookup in rst packet

srinidhi kasagar (1):
      mach-ux500: do not override outer.inv_all

stephen hemminger (3):
      skge: don't assert carrier until link is up
      skge: check for PCI dma mapping errors
      skge: add byte queue limit support
