Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2DPBtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 21:49:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33667 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab2DPBth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 21:49:37 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Apr 2012 18:49:16 -0700
X-Google-Sender-Auth: zdBZJCnowsYQSG0Abx_RkP2os5g
Message-ID: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com>
Subject: Linux 3.4-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's been eight days since -rc2, mostly because I spent some time
chasing down two bugs that I could reproduce rather than release it
yesterday. One was an oops in the scsi layer error handling, and the
other was a really odd crash on x86-32 that I had introduced myself
since -rc2. Oops.

Anyway, one day late, but stronger for it - both problems are fixed in
-rc3. Both were obscure enough that it may not be a big deal to most
people, but I hate making even just -rc releases with issues that I
can reproduce personally.

Anyway, the shortlog is appended, but I don't think there really is
anything hugely exciting there.  It's mostly driver updates, with a
smattering of architecture fixes and networking. The diffstat is
almost entirely flat, with the exception of the mtip32xx driver update
and a trivial kyrofb change (replace "unsigned long" to "u32" to make
it work properly on 64-bit) that was just lots of simple replacement.

And a flat diffstat is good. It just means "lots of small things".
Admittedly it would be even better if it was "just a few small
things", but we're *reasonably* early in the -rc sequence, so I
wouldn't worry too much.

                                     Linus

--

AceLan Kao (1):
      Bluetooth: Add support for Atheros [04ca:3005]

Akinobu Mita (1):
      xen-blkfront: use bitmap_set() and bitmap_clear()

Al Viro (6):
      fix breakage in mtdchar_open(), sanitize failure exits
      dentry leak in simple_fill_super() failure exit
      typo fix in Documentation/filesystems/vfs.txt
      um: fix linker script generation
      um: several x86 hw-dependent crypto modules won't build on uml
      um: switch cow_user.h to htobe{32,64}/betoh{32,64}

Alan Cox (1):
      staging: sep: Fix sign of error

Alan Stern (7):
      USB: don't clear urb->dev in scatter-gather library
      USB documentation: explain lifetime rules for unlinking URBs
      USB: fix bug in serial driver unregistration
      USB: don't ignore suspend errors for root hubs
      USB: fix race between root-hub suspend and remote wakeup
      EHCI: keep track of ports being resumed and indicate in hub_status_data
      UHCI: hub_status_data should indicate if ports are resuming

Aleksey Babahin (1):
      USB: serial: metro-usb: Fix idProduct for Uni-Directional mode.

Alex Deucher (2):
      drm/radeon/kms: fix DVO setup on some r4xx chips
      drm/radeon: only add the mm i2c bus if the hw_i2c module param is set

Alex He (2):
      xHCI: correct to print the true HSEE of USBCMD
      xHCI: Correct the #define XHCI_LEGACY_DISABLE_SMI

Andi Kleen (1):
      block: use lockdep_assert_held for queue locking

Andreas Dumberger (1):
      drivers/rtc/rtc-r9701.c: reset registers if invalid values are detected

Andrei Emeltchenko (3):
      Bluetooth: Fix memory leaks due to chan refcnt
      Bluetooth: mgmt: Add missing endian conversion
      Bluetooth: mgmt: Fix timeout type

Andrei Warkentin (1):
      MD: Bitmap version cleanup.

Andrew Jones (1):
      xen/blkfront: don't put bdev right after getting it

Anton Samokhvalov (1):
      USB: sierra: add support for Sierra Wireless MC7710

Arnaldo Carvalho de Melo (3):
      perf top: Add intel_idle to the skip list
      perf annotate: Fix hist decay
      perf annotate: Validate addr in symbol__inc_addr_samples

Arnd Bergmann (2):
      tty/serial/omap: console can only be built-in
      drm/radeon: replace udelay with mdelay for long timeouts

Asai Thambi S P (8):
      mtip32xx: fix incorrect value set for drv_cleanup_done, and
re-initialize and start port in mtip_restart_port()
      mtip32xx: Add new bitwise flag 'dd_flag'
      mtip32xx: make setting comp_time as common
      mtip32xx: Add new sysfs entry 'status'
      mtip32xx: misc changes
      mtip32xx: Shorten macro names
      mtip32xx: fix handling of commands in various scenarios
      mtip32xx: dump tagmap on failure

Axel Lin (3):
      drivers/base: Remove unneeded spin_lock_init call for soc_lock
      Staging: android: timed_gpio: Fix resource leak in
timed_gpio_probe error paths
      gpio: Fix uninitialized variable bit in adp5588_irq_handler

Benjamin Herrenschmidt (2):
      powerpc: Fix page fault with lockdep regression
      powerpc: Fix typo in runlatch code

Benjamin Poirier (1):
      GFS2: use depends instead of select in kconfig

Boaz Harrosh (1):
      um: uml_setup_stubs': warning: unused variable 'pages'

Bob Peterson (3):
      GFS2: put glock reference in error patch of read_rindex_entry
      GFS2: Make sure rindex is uptodate before starting transactions
      GFS2: Allow caching of rindex glock

Brian Gix (1):
      Bluetooth: mgmt: Fix corruption of device_connected pkt

Bruno Prémont (1):
      sysfs: Prevent crash on unset sysfs group attributes

Changli Gao (1):
      netfilter: nf_ct_tcp: don't scale the size of the window up twice

Chen, Chien-Chia (1):
      rt2x00: Fix rfkill_polling register function.

Cho, Yu-Chen (1):
      Bluetooth: Add Atheros maryann PIDVID support

Chris Kelly (1):
      staging: ozwpan: Added new maintainer for ozwpan

Chris Mason (2):
      Revert "Btrfs: increase the global block reserve estimates"
      Btrfs: fix uninit variable in repair_eb_io_failure

Chris Metcalf (3):
      arch/tile: avoid unused variable warning in proc.c for tilegx
      hugetlb: fix race condition in hugetlb_fault()
      irq_work: fix compile failure on tile from missing include

Chris Rankin (1):
      [media] dvb_frontend: regression fix: userspace ABI broken for xine

Chris Wilson (2):
      drm/i915: Finish any pending operations on the framebuffer
before disabling
      drm/i915/ringbuffer: Exclude last 2 cachlines of ring on 845g

Colin Cross (1):
      android: make persistent_ram based drivers depend on HAVE_MEMBLOCK

Dan Carpenter (4):
      block: blk_alloc_queue_node(): use caller's GFP flags instead of
GFP_KERNEL
      Staging: vt6655-6: check keysize before memcpy()
      Staging: rts_pstor: off by one in for loop
      xHCI: use gfp flags from caller instead of GFP_ATOMIC

Dan Magenheimer (1):
      staging: ramster: unbreak my heart

Dan Williams (6):
      ioat: fix size of 'completion' for Xen
      Revert "serial/8250_pci: init-quirk msi support for kt serial controller"
      Revert "serial/8250_pci: setup-quirk workaround for the kt
serial controller"
      serial/8250_pci: add a "force background timer" flag and use it
for the "kt" serial port
      sysfs: handle 'parent deleted before child added'
      kobject: provide more diagnostic info for kobject_add_internal() failures

Daniel De Graaf (2):
      xen/blkback: use grant-table.c hypercall wrappers
      xen/blkback: Enable blkback on HVM guests

Daniel Vetter (4):
      drm/i915: properly compute dp dithering for user-created modes
      Revert "drm/i915: reenable gmbus on gen3+ again"
      drm/i915: implement ColorBlt w/a
      drm/i915: clear fencing tracking state when retiring requests

Daniel Walker (2):
      arm: msm: halibut: remove unneeded fixup
      arm: msm: trout: fix compile failure

Dave Jiang (3):
      ioat: ring size variables need to be 32bit to avoid overflow
      ioatdma: DMA copy alignment needed to address IOAT DMA silicon errata
      netdma: adding alignment check for NETDMA ops

Dave Jones (1):
      Btrfs: fix use-after-free in __btrfs_end_transaction

David Brown (2):
      video: msm: Fix section mismatches in mddi.c
      ARM: msm: Fix section mismatches in proc_comm.c

David Daney (2):
      usb: Put USB Kconfig items back under USB.
      irq/irq_domain: Quit ignoring error returns from irq_alloc_desc_from().

David Miller (1):
      perf hists: Catch and handle out-of-date hist entry maps.

David Rientjes (1):
      android, lowmemorykiller: remove task handoff notifier

David S. Miller (2):
      MAINTAINERS: Mark NATSEMI driver as orphan'd.
      sparc64: Fix bootup crash on sun4v.

Dmitry Eremin-Solenikov (1):
      staging/xgifb: fix display on XGI Volari Z11m cards

Don Morris (1):
      iop-adma: Corrected array overflow in RAID6 Xscale(R) test.

Don Zickus (1):
      Bluetooth: btusb: typo in Broadcom SoftSailing id

Eliot Blennerhassett (1):
      ALSA: asihpi - fix return value of hpios_locked_mem_alloc()

Elric Fu (2):
      USB: fix bug of device descriptor got from superspeed device
      xHCI: add XHCI_RESET_ON_RESUME quirk for VIA xHCI host

Emil Goode (1):
      x86: vsyscall: Use NULL instead 0 for a pointer argument

Eric Dumazet (3):
      tcp: restore correct limit
      net: allow pskb_expand_head() to get maximum tailroom
      tcp: avoid order-1 allocations on wifi and tx path

Fabio Estevam (2):
      ASoC: imx-audmux: Fix ssi port numbers in sysfs
      ASoC: imx-audmux: Check for NULL pointer

Felipe Balbi (1):
      xhci: don't re-enable IE constantly

Fengguang Wu (1):
      ALSA: hda - hide HDMI/ELD printks unless snd.debug=2

Frank Rowand (1):
      modpost: Fix modpost license checking of vmlinux.o

Gao feng (1):
      netfilter: nf_conntrack: fix incorrect logic in nf_conntrack_init_net

Gerard Snitselaar (2):
      staging/vme: Fix module parameters
      usb: xhci: fix section mismatch in linux-next

Glauber Costa (1):
      memcg: do not open code accesses to res_counter members

Grant Likely (5):
      gpio/sodaville: Convert sodaville driver to new irqdomain API
      irq: Kill pointless irqd_to_hw export
      irqdomain: Fix debugfs formatting
      irq_domain: Move irq_virq_count into NOMAP revmap
      irq_domain: fix type mismatch in debugfs output format

Greg Kroah-Hartman (1):
      block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy

Guenter Roeck (4):
      hwmon: (smsc47b397) Fix compiler warning
      hwmon: (acpi_power_meter) Fix compiler warning seen in some configurations
      hwmon: (smsc47m1) Fix compiler warning
      hwmon: (pmbus_core) Fix compiler warning

Gustavo Padovan (1):
      Bluetooth: Fix userspace compatibility issue with mgmt interface

H. Peter Anvin (1):
      x86: Use correct byte-sized register constraint in __add()

Hans Petter Selasky (1):
      [media] dvb_frontend: fix compiler warning

Hans Verkuil (2):
      [media] ivtv: Fix AUDIO_(BILINGUAL_)CHANNEL_SELECT regression
      [media] Drivers/media/radio: Fix build error

Hemant Gupta (1):
      Bluetooth: Use correct flags for checking HCI_SSP_ENABLED bit

Herbert Xu (1):
      bridge: Do not send queries on multicast group leaves

Ilya Dryomov (1):
      Btrfs: remove lock assert from get_restripe_target()

Inki Dae (3):
      drm/exynos: fixed page align and code clean.
      drm/exynos: fixed duplicated page allocation bug.
      drm/exynos: fixed exynos broken ioctl

JJ Ding (3):
      Input: elantech - reset touchpad before configuring it
      Input: elantech - v4 is a clickpad, with only one button
      Input: trackpoint - use psmouse_fmt() for messages

Jan Beulich (1):
      drivers/rtc/rtc-efi.c: fix section mismatch warning

Jarkko Nikula (1):
      MAINTAINERS: Add missing ASoC OMAP co-maintainer

Jason Wessel (1):
      panic: fix stack dump print on direct call to panic()

Jeremy Fitzhardinge (1):
      x86: Use correct byte-sized register constraint in __xchg_op()

Jesper Juhl (5):
      staging/media/as102: Don't call release_firmware() on
uninitialized variable
      Input: da9052 - fix memory leak in da9052_onkey_probe()
      staging: vt6656: Don't leak memory in
drivers/staging/vt6656/ioctl.c::private_ioctl()
      staging: android: fix mem leaks in __persistent_ram_init()
      ALSA: hda/realtek - Fix mem leak (and rid us of trailing whitespace).

Jesse Barnes (1):
      drm/i915: make rc6 module parameter read-only

Jiri Olsa (1):
      perf hists browser: Fix NULL deref in hists browsing code

Johan Hedberg (2):
      Bluetooth: Don't increment twice in eir_has_data_type()
      Bluetooth: Check for minimum data length in eir_has_data_type()

Johan Hovold (4):
      Bluetooth: hci_ldisc: fix NULL-pointer dereference on tty_close
      Bluetooth: hci_core: fix NULL-pointer dereference at unregister
      USB: pl2303: fix DTR/RTS being raised on baud rate change
      USB: serial: fix race between probe and open

Johannes Berg (2):
      mac80211: fix association beacon wait timeout
      nl80211: ensure interface is up in various APIs

Jonathan Austin (1):
      ARM: 7384/1: ThumbEE: Disable userspace TEEHBR access for
!CONFIG_ARM_THUMBEE

Jonghwan Choi (1):
      ARM: EXYNOS: Fix compile error in exynos5250-cpufreq.c

Joonyoung Shim (6):
      drm/exynos: remove unnecessary type conversion of hdmi and mixer
      drm/exynos: remove unused codes in hdmi and mixer
      drm/exynos: rename s/HDMI_OVERLAY_NUMBER/MIXER_WIN_NR
      drm/exynos: use define instead of default_win member in struct
mixer_context
      drm/exynos: fix struct for operation callback functions to driver name
      drm/exynos: fix to pointer manager member of struct exynos_drm_subdrv

Josef Bacik (1):
      Btrfs: use commit root when loading free space cache

Josh Boyer (1):
      ALSA: hda/realtek - Add quirk for Mac Pro 5,1 machines

Jozsef Kadlecsik (2):
      netfilter: nf_ct_ipv4: handle invalid IPv4 and IPv6 packets consistently
      netfilter: nf_ct_ipv4: packets with wrong ihl are invalid

João Paulo Rechi Vita (1):
      Bluetooth: btusb: Add USB device ID "0a5c 21e8"

Julia Lawall (3):
      net/wireless/wext-core.c: add missing kfree
      sound: sound/oss/msnd_pinnacle.c: add vfrees
      ALSA: sound/isa/sscape.c: add missing resource-release code

Kautuk Consul (3):
      sparc/mm/fault_64.c: Port OOM changes to do_sparc64_fault
      sparc/mm/fault_32.c: Port OOM changes to do_sparc_fault
      ARM: 7368/1: fault.c: correct how the tsk->[maj|min]_flt gets incremented

Kay Sievers (1):
      printk(): add KERN_CONT where needed in hpet and vt code

Kees Cook (1):
      Smack: build when CONFIG_AUDIT not defined

Kenth Eriksson (1):
      spi/mpc83xx: fix NULL pdata dereference bug

Kevin Hilman (2):
      cpufreq: OMAP: fix build errors: depends on ARCH_OMAP2PLUS
      ARM: OMAP: clock: cleanup CPUfreq leftovers, fix build errors

Khalid Aziz (1):
      MAINTAINERS: add PCDP console maintainer

Kirill A. Shutemov (1):
      memcg: fix broken boolen expression

Konrad Rzeszutek Wilk (2):
      xen/blkback: Squash the discard support for 'file' and 'phy' type.
      xen/blkback: Make optional features be really optional.

Konstantin Shlyakhovoy (1):
      drivers/rtc/rtc-twl.c: use static register while reading time

Kristen Carlson Accardi (1):
      i2c: prevent spurious interrupt on Designware controllers

Kukjin Kim (2):
      ARM: S5PV210: fix unused LDO supply field from wm8994_pdata
      serial: samsung: fix omission initialize ulcon in reset port fn()

Kuninori Morimoto (1):
      ASoC: ak4642: fixup: mute needs +1 step

Larry Finger (5):
      rtlwifi: rtl8192de: Fix firmware initialization
      mac80211: Convert WARN_ON to WARN_ON_ONCE
      rtlwifi: Fix oops on rate-control failure
      rtlwifi: Preallocate USB read buffers and eliminate kalloc in read routine
      rtlwifi: Add missing DMA buffer unmapping for PCI drivers

Laurent Pinchart (1):
      [media] uvcvideo: Fix race-related crash in uvc_video_clock_update()

Lee Jones (1):
      drivers/base: fix compiler warning in SoC export driver - idr
should be ida

Linus Torvalds (3):
      x86: merge 32/64-bit versions of 'strncpy_from_user()' and speed it up
      x86-32: fix up strncpy_from_user() sign error
      Linux 3.4-rc3

Linus Walleij (3):
      serial: PL011: move interrupt clearing
      drivers/rtc/rtc-pl031.c: enable clock on all ST variants
      ARM: 7359/2: smp_twd: Only wait for reprogramming on active cpus

Liu Bo (1):
      Btrfs: fix eof while discarding extents

Lothar Waßmann (2):
      staging:iio:core add missing increment of loop index in
iio_map_array_unregister()
      spi/imx: prevent NULL pointer dereference in spi_imx_probe()

Lubos Lunak (1):
      do not export kernel's NULL #define to userspace

Malcolm Priestley (1):
      [media] it913x: fix firmware loading errors

Manuel Lauss (1):
      fbdev: fix au1*fb builds

Marc Zyngier (2):
      ARM: 7379/1: DT: fix atags_to_fdt() second call site
      ARM: 7380/1: DT: do not add a zero-sized memory property

Marcel Holtmann (1):
      MAINTAINERS: update Bluetooth tree locations

Marek Belisko (1):
      staging: iio: hmc5843: Fix crash in probe function.

Marek Szyprowski (3):
      ARM: EXYNOS: fix regulator name for NURI board
      ARM: EXYNOS: set fix xusbxti clock for NURI and Universal210 boards
      ARM: EXYNOS: Remove broken config values for touchscren for NURI board

Mark Brown (3):
      MAINTAINERS: Don't list everyone working on Wolfson drivers
      Input: gpio_mouse - use linux/gpio.h rather than asm/gpio.h
      ARM: 7366/3: amba: Remove AMBA level regulator support

Markus Trippelsdorf (1):
      perf tools: Fix getrusage() related build failure on glibc trunk

Martin Jansa (1):
      ASoC: pxa: pxa2xx-i2s: add io.h for IOMEM macro

Martin K. Petersen (1):
      SCSI: Fix error handling when no ULD is attached

Martin Schwidefsky (1):
      proc: stats: Use arch_idle_time for idle and iowait times if available

Mathieu Desnoyers (1):
      drivers/char/random.c: fix boot id uniqueness race

Maurus Cuelenaere (1):
      ARM: SAMSUNG: make SAMSUNG_PM_DEBUG select DEBUG_LL

Michael BRIGHT (1):
      USB: remove compile warning on gadget/inode.c

Michael Brunner (1):
      pch_uart: Add Kontron COMe-mTT10 uart clock quirk

Michael Karcher (6):
      ALSA: hda - Fix proc output for ADC amp values of CX20549
      ALSA: hda - Rename capture sources of CX20549 to match common conventions
      ALSA: hda - fix record volume controls of CX20459 ("Venice")
      ALSA: hda - Remove CD control from model=benq for CX20549
      ALSA: hda - CX20549 doesn't need pin_amp_workaround.
      ALSA: hda - clean up CX20549 test mixer setup

Mika Westerberg (1):
      irq_domain: correct the debugfs file name

Ming Lei (1):
      usb: storage: fix lockdep warning inside usb_stor_pre_reset(v2)

Neal Cardwell (2):
      nohz: Fix stale jiffies update in tick_nohz_restart()
      tcp: fix tcp_rcv_rtt_update() use of an unscaled RTT sample

NeilBrown (1):
      md/bitmap: prevent bitmap_daemon_work running while initialising bitmap

Nikunj A. Dadhania (1):
      perf kvm: Finding struct machine fails for PERF_RECORD_MMAP

Nitin Gupta (1):
      staging: zsmalloc: fix memory leak

Oleg Nesterov (1):
      cred: copy_process() should clear child->replacement_session_keyring

Ondrej Zary (1):
      kyrofb: fix on x86_64

Or Gerlitz (1):
      IB/mlx4: Don't return an invalid speed when a port is down

Oskari Saarenmaa (1):
      Input: sentelic - filter taps in absolute mode

Pablo Neira Ayuso (1):
      netfilter: ip6_tables: ip6t_ext_hdr is now static inline

Paul E. McKenney (1):
      sparc64: Eliminate obsolete __handle_softirq() function

Paul Gortmaker (6):
      bcma: fix build error on MIPS; implicit pcibios_enable_device
      kconfig: fix IS_ENABLED to not require all options to be defined
      Revert "kconfig: fix __enabled_ macros definition for invisible
and un-selected symbols"
      kconfig: delete last traces of __enabled_ from autoconf.h
      alpha: fix build failures from system.h dismemberment
      ia64: populate the cmpxchg header with appropriate code

Preetham Chandru (1):
      staging: iio: ak8975: Remove i2c client data corruption

Rabin Vincent (1):
      ARM: 7386/1: jump_label: fixup for rename to static_key

Rafael J. Wysocki (1):
      PCI: Fix regression in pci_restore_state(), v3

Randy Dunlap (1):
      vgaarb.h: fix build warnings

Richard Weinberger (2):
      um: Disintegrate asm/system.h
      um: Use asm-generic/switch_to.h

Rob Clark (1):
      staging: drm/omap: move where DMM driver is registered

Rob Herring (1):
      ARM: dts: remove blank interrupt-parent properties

Roland Dreier (2):
      IB/core: Don't return EINVAL from sysfs rate attribute for invalid speeds
      IB/srpt: Set srq_type to IB_SRQT_BASIC

Roland Stigge (1):
      gpio: Fix range check in of_gpio_simple_xlate()

Ryosuke Saito (1):
      mtip32xx: fix error handling in mtip_init()

Sachin Kamat (3):
      ARM: S5PV210: Fix compiler warning in dma.c file
      gpio/exynos: Fix compiler warning in gpio-samsung.c file
      ARM: EXYNOS: Fix Kconfig dependencies for device tree enabled
machine files

Sam Ravnborg (1):
      sparc32,leon: fix leon build

Samuel Ortiz (1):
      NFC: Fix the LLCP Tx fragmentation loop

Santiago Garcia Mantinan (1):
      USB: option: re-add NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED to
option_id array

Santosh Nayak (1):
      Bluetooth: Fix Endian Bug.

Sarah Sharp (4):
      xhci: Warn when hosts don't halt.
      xhci: Don't write zeroed pointers to xHC registers.
      xhci: Restore event ring dequeue pointer on resume.
      xhci: Fix register save/restore order.

Sasikantha babu (1):
      itimer: Schedule silent NULL pointer fixup in setitimer() for removal

Sebastian Andrzej Siewior (1):
      usb/usbmon: correct the data interpretation of usbmon's output

Seung-Woo Kim (1):
      drm/exynos: add format list of plane

Shaohua Li (1):
      block: make auto block plug flush threshold per-disk based

Shawn Guo (1):
      regulator: anatop: fix 'anatop_regulator' name collision

Shubhrajyoti D (2):
      spi/davinci: Fix DMA API usage in davinci
      omap-serial: Fix the error handling in the omap_serial probe

Siftar, Gabe (1):
      tty/serial: atmel_serial: fix RS485 half-duplex problem

Simon Arlott (2):
      USB: ftdi_sio: fix status line change handling for TIOCMIWAIT
and TIOCGICOUNT
      USB: ftdi_sio: fix race condition in TIOCMIWAIT, and abort of
TIOCMIWAIT when the device is removed

Srivatsa S. Bhat (1):
      tile/CPU hotplug: Add missing call to notify_cpu_starting()

Stephen Lewis (1):
      USB: update usbtmc api documentation

Stephen M. Cameron (2):
      cciss: Initialize scsi host max_sectors for tape drive support
      cciss: Fix scsi tape io with more than 255 scatter gather elements

Stephen Warren (3):
      ASoC: tegra: ensure clocks are enabled when touching registers
      ASoC: set idle_bias_off=1 for all platform DAPM contexts
      ASoC: tegra: fix i2s compilation when !CONFIG_DEBUG_FS

Steven Noonan (1):
      xen-blkfront: make blkif_io_lock spinlock per-device

Sujith Manoharan (1):
      Revert "ath9k: fix going to full-sleep on PS idle"

Suresh Siddha (1):
      clockevents: tTack broadcast device mode change in
tick_broadcast_switch_to_oneshot()

Takashi Iwai (3):
      ALSA: hda/realtek - Add a few ALC882 model strings back
      ALSA: hda/realtek - Fix GPIO1 setup for Acer Aspire 4930 & co
      ALSA: hda/realtek - Add a fixup entry for Acer Aspire 8940G

Tao Ma (2):
      block: Make cfq_target_latency tunable through sysfs.
      Documentation: Add sysfs ABI change for cfq's target latency.

Thomas Abraham (1):
      ARM: EXYNOS: Add PDMA and MDMA physical base address defines

Thomas Gleixner (3):
      tick: Document TICK_ONESHOT config option
      itimer: Use printk_once instead of WARN_ONCE
      Revert "clocksource: Load the ACPI PM clocksource asynchronously"

Tilman Schmidt (1):
      isdn/gigaset: use gig_dbg() for debugging output

Tom Goff (1):
      sysfs: Update the name hash for an entry after changing the namespace

Tomoya MORINAGA (1):
      pch_uart: Fix MSI setting issue

Tsutomu Itoh (1):
      Btrfs: check return value of bio_alloc() properly

Tushar Behera (3):
      ARM: EXYNOS: Add missing definition for IRQ_I2S0
      drivers/rtc/rtc-s3c.c: fix compilation error
      drivers/rtc/rtc-s3c.c: add placeholder for driver private data

Uwe Kleine-König (2):
      spi/imx: mark base member in spi_imx_data as __iomem
      Input: tps6507x-ts - fix MODULE_ALIAS to match driver name

Viresh Kumar (1):
      spi/pL022: include types.h to remove compilation warnings

Vivek Goyal (1):
      virtio-blk: Call revalidate_disk() upon online disk resize

Wang YanQing (1):
      video:uvesafb: Fix oops that uvesafb try to execute NX-protected page

Will Deacon (4):
      ARM: 7377/1: vic: re-read status register before dispatching
each IRQ handler
      ARM: 7381/1: nommu: fix typo in mm/Kconfig
      ARM: 7383/1: nommu: populate vectors page from paging_init
      ARM: 7382/1: mm: truncate memory banks to fit in 4GB space for classic MMU

Xi Wang (1):
      drm/savage: fix integer overflows in savage_bci_cmdbuf()

Ying Han (2):
      memcg: fix up documentation on global LRU
      Revert "mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()"

Yuriy Kozlov (1):
      tty: serial: altera_uart: Check for NULL platform_data in probe.

Zeng Zhaoming (1):
      ASoC: sgtl5000: Enable VAG when DAC/ADC up

acreese (1):
      drm/i915: Removed IVB forced enable of sprite dest key.

majianpeng (1):
      md/raid1,raid10: Fix calculation of 'vcnt' when processing error recovery.

wwang (2):
      staging:rts_pstor:Fix possible panic by NULL pointer dereference
      staging:rts_pstor:Avoid "Bad target number" message when probing driver
