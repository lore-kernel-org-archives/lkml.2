Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1FMXCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:02:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665Ab1FMXCU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:02:20 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Jun 2011 16:01:26 -0700
Message-ID: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
Subject: Linux 3.0-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. and this time even with a timely tar-ball, since I'm not traveling any more.

What do we have in it? More than in -rc2. I'm clearly not the only one
who was in Japan for LinuxCon, or something else just made people wake
up.

There's a lot of small one-liners, but a few bigger chunks too: Radeon
DRI updates, some btrfs updates, and fixing Sparc LEON support (and
supporting PCI). Smaller updates to nilfs2 and ceph, and s390 and arm.
Other than that, it's mostly random driver updates all over.

I'm including the shortlog, which is fairly self-explanatory: small
random changes, nothing hugely interesting. It will matter to people
only if it happens to fix that one small nagging issue you had.

But as usual, I'll ask people to give it a good testing,

                       Linus

---
Al Viro (4):
      more conservative S_NOSEC handling
      get_net_ns_by_fd() oopses if proc_ns_fget() returns an error
      fix return values of l2tp_dfs_seq_open()
      lmLogOpen() broken failure exit

Alan Stern (3):
      usb-storage: redo incorrect reads
      USB: dummy-hcd needs the has_tt flag
      USB: CONFIG_USB_GADGET_DUALSPEED is not user-configurable

Alex Deucher (13):
      drm/radeon/kms/blit: workaround some hw issues on evergreen+
      drm/radeon/kms: add blit support for cayman (v2)
      drm/radeon/kms: add missing case for cayman thermal sensor
      drm/radeon/kms: fix thermal sensor reading on juniper
      drm/radeon/kms: clean up the radeon kms Kconfig
      drm/radeon/kms: add family ids for llano APUs
      drm/radeon/kms: fill in asic struct for llano
      drm/radeon/kms: add llano pci ids
      drm/radeon/kms: add support for Llano Fusion APUs
      drm/radeon/kms: remove duplicate reg from r600 safe regs
      drm/radeon/kms: viewport height has to be even
      drm/radeon/kms/atom: fix PHY init
      drm/radeon/kms: disable hdmi audio by default

Alexander Holler (2):
      arm: omap3: beagle: Ensure msecure is mux'd to be able to set the RTC
      bridge: provide a cow_metrics method for fake_ops

Alexey Khoroshilov (1):
      usb-gadget: unlock data->lock mutex on error path in ep_write()

Andre Bartke (1):
      staging: iio: error case memory leak fix

Andy Lutomirski (3):
      efifb: Enable write-combining
      efifb: Fix mismatched request/release_mem_region
      efifb: Disallow manual bind and unbind

Anirban Chakraborty (1):
      qlcnic: Fix bug in FW queue dump

Antti Palosaari (1):
      [media] anysee: return EOPNOTSUPP for unsupported I2C messages

Arjan Mels (1):
      staging: usbip: bugfix prevent driver unbind

Arnaldo Carvalho de Melo (3):
      perf evlist: Remove dependency on debug routines
      perf python: Use exception to propagate errors
      perf evlist: Don't die if sample_{id_all|type} is invalid

Arne Jansen (3):
      btrfs: scrub: errors in tree enumeration
      btrfs: reinitialize scrub workers
      btrfs: remove unneeded includes from scrub.c

Axel Lin (1):
      ARM: OMAP2: Add missing include of linux/gpio.h

Balaji T K (2):
      ARM: OMAP4: MMC: no regulator off during probe for eMMC
      ARM: OMAP4: MMC: increase delay for pbias

Ben Skeggs (5):
      drm/nvc0: recognise 0xdX chipsets as NV_C0
      drm/nouveau: don't create accel engine objects when noaccel=1
      drm/nouveau: fix vram page mapping when crossing page table boundaries
      drm/nouveau: fix leak of gart mm node
      drm/nv40: fall back to paged dma object for the moment

Benjamin Herrenschmidt (1):
      powerpc: Force page alignment for initrd reserved memory

Bob Peterson (1):
      GFS2: Processes waiting on inode glock that no processes are holding

Bruno Prémont (1):
      video: Fix use-after-free by vga16fb on rmmod

Bryan Wu (1):
      usb: gadget: include <linux/prefetch.h> to fix compiling error

Chris Mason (1):
      Btrfs: make sure to recheck for bitmaps in clusters

Chris Metcalf (1):
      slub: always align cpu_slab to honor cmpxchg_double requirement

Chris Wilson (5):
      drm/i915: s/addr & ~PAGE_MASK/offset_in_page(addr)/
      drm/i915: Replace ironlake_compute_wm0 with g4x_compute_wm0
      drm/i915/crt: Explicitly return false if connected to a digital monitor
      drm/i915: Remove unused enum "chip_family"
      drm/i915: Share the common force-audio property between connectors

Christian Borntraeger (2):
      [S390] kvm-s390: Fix host crash on misbehaving guests
      [S390] kvm-s390: fix stfle facilities numbers >=64

Colin Cross (4):
      ARM: omap2+: mux: Allow board mux settings to be NULL
      ARM: omap4: Pass core and wakeup mux tables to omap4_mux_init
      GPIO: OMAP: fix setting IRQWAKEN bits for OMAP4
      GPIO: OMAP: add locking around calls to _set_gpio_triggering

Connor Hansen (2):
      iscsi_ibft: iscsi_ibft_find unused variable i
      ide-cd: signedness warning fix again

Dan Carpenter (6):
      ptp: Return -EFAULT on copy_to_user() errors
      ptp: Fix some locking bugs in ptp_read()
      xen: off by one errors in multicalls.c
      drm/i915: fix if statement in ivybridge irq handler
      Staging: mei: fix debug code
      netpoll: call dev_put() on error in netpoll_setup()

Dan Williams (3):
      option: add Zoom 4597 modem USB IDs
      option: add Alcatel X200 to sendsetup blacklist
      option: add Prolink PH300 modem IDs

Daniel Drake (1):
      libertas_sdio: handle spurious interrupts

Daniel Haid (1):
      drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu

Daniel Hellstrom (6):
      sparc32: added CONFIG_PCIC_PCI Kconfig setting
      sparc32,leon: added LEON-common low-level PCI routines
      sparc32,leon: add GRPCI2 PCI Host driver
      sparc32, sun4m: bugfix in SMP IPI traphandler
      sparc32, leon: bugfix in LEON SMP interrupt init
      dl2k: EEPROM CRC calculation wrong endianess on bigendian machine

Daniel T Chen (2):
      ALSA: hda: Fix quirk for Dell Inspiron 910
      ALSA: hda: Fix inaudible internal speakers on CyberpowerPC Gamer
Xplorer N57001 laptop

Daniel Vetter (2):
      drm/i915: Only print out the actual number of fences for i915_error_state
      drm/915: fix relaxed tiling on gen2: tile height

Darren Salt (1):
      CIFS ACL support needs CONFIG_KEYS, so depend on it

Dave Airlie (2):
      drm/radeon: fix oops in ttm reserve when pageflipping (v2)
      drm/radeon/kms: set family for use in parser.

Dave Jones (1):
      netfilter: use unsigned variables for packet lengths in ip[6]_queue.

David Howells (4):
      MN10300: Fix one of the kernel debugger cacheflush variants
      MN10300: die_if_no_fixup() shouldn't use get_user() as it
doesn't call set_fs()
      MN10300: Add missing _sdata declaration
      linux/seqlock.h should #include asm/processor.h for cpu_relax()

David S. Miller (3):
      sparc: PCIC_PCI needs SPARC32 dependency
      net: Rework netdev_drivername() to avoid warning.
      irda: iriap: Use seperate lockdep class for irias_objects->hb_spinlock

David Sterba (1):
      btrfs: fix unlocked access of delalloc_inodes

Dmitry Torokhov (1):
      USB: xhci - fix interval calculation for FS isoc endpoints

Eric Dumazet (3):
      netfilter: add more values to enum ip_conntrack_info
      af_packet: prevent information leak
      net: pmtu_expires fixes

FUJITA Tomonori (1):
      swiotlb: Export swioltb_nr_tbl and utilize it as appropiate.

Felipe Balbi (1):
      MAINTAINERS: add a maintainer to Gadget Framework

Florian Fainelli (1):
      x86: devicetree: Add missing early_init_dt_setup_initrd_arch stub

Francisco Jerez (1):
      drm/nv17-nv40: Fix modesetting failure when pitch == 4096px (fdo
bug 35901).

Frederic Weisbecker (1):
      perf python: Fix argument name list of read_on_cpu()

Geert Uytterhoeven (2):
      sparc: Do not select GENERIC_HARDIRQS_NO_DEPRECATED
      spi/rtc-m41t93: Use spi_get_drvdata() for SPI devices

Govindraj.R (2):
      OMAP2+: mux: fix compilation warnings
      spi/omap2: fix uninitialized variable

Grant Likely (2):
      net: fix smc91x.c device tree support
      MAINTAINERS: Saying goodbye to David Brownell

Greg Kroah-Hartman (4):
      Staging: altera: move .h file to proper place
      Staging: remove STAGING_EXCLUDE_BUILD option
      Revert "USB: option: add ID for ZTE MF 330"
      Staging: cx23885: fix include of altera.h

Guan Xuetao (5):
      unicore32: move rtc-puv3.c to drivers/rtc directory
      unicore32: change zImage physical address, though it's PIC codes
      unicore32: add KBUILD_DEFCONFIG with unicore32_defconfig (old
debug_defconfig)
      unicore32: change PERCPU to PERCPU_SECTION
      unicore32: using generic-y format for one line asm-generic files

GuoWen Li (1):
      ftrace: Fix possible undefined return code

H Hartley Sweeten (2):
      gpio/samsung: make Kconfig options def_bool
      ep93xx_eth: Update MAINTAINERS

Hans Petter Selasky (1):
      [media] Make nchg variable signed because the code compares this
variable against negative values

Hans de Goede (1):
      drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007

Heiko Carstens (2):
      KVM: add missing void __user * cast to access_ok() call
      net: cpu offline cause napi stall

Heiko Stuebner (3):
      ARM: S3C24xx: Fix missing struct for s3c2410_dma_chan
      ARM: S3C24XX: Move s3c24xx_irq_syscore_ops to plat-s3c24xx/irq.c
      ARM: S3C2410: remove the now empty mach-s3c2410/irq.c

Ian Armstrong (3):
      [media] ivtv: Make two ivtv_msleep_timeout calls uninterruptable
      [media] ivtvfb: Add sanity check to ivtvfb_pan_display()
      [media] ivtv: Internally separate encoder & decoder standard setting

Igor Grinberg (3):
      arm: omap3: cm-t3517: fix section mismatch warning
      arm: omap2plus: fix ads7846 pendown gpio request
      arm: omap2plus: move NAND_BLOCK_SIZE out of boards

Ilya Dryomov (1):
      Btrfs - use %pU to print fsid

Jamie Iles (1):
      gpio/basic_mmio: add missing include of spinlock_types.h

Jan Glauber (1):
      [S390] qdio: Split SBAL entry flags

Jan Schmidt (1):
      Btrfs: fix extent state leak on failed nodatasum reads

Janusz Krzysztofik (1):
      OMAP: fix compilation error

Jarkko Nikula (2):
      omap: rx51: Set regulator V28_A always on
      omap: rx51: Don't power up speaker amplifier at bootup

Jason Stubbs (1):
      drm/i915: fix regression after clock gating init split

Jean-François Moine (5):
      [media] gspca - ov519: Fix a regression for ovfx2 webcams
      [media] gspca - ov519: Change the ovfx2 bulk transfer size
      [media] gspca: Remove coarse_expo_autogain.h
      [media] gspca - stv06xx: Set a lower default value of gain for
hdcs sensors
      [media] gspca - ov519: Set the default frame rate to 15 fps

Jeff Layton (2):
      cifs: silence printk when establishing first session on socket
      cifs: trivial: add space in fsc error message

Jesper Juhl (2):
      genirq: Prevent potential NULL dereference in irq_set_irq_wake()
      ISDN, hfcsusb: Don't leak in hfcsusb_ph_info()

Jiri Pirko (1):
      vlan: Fix the ingress VLAN_FLAG_REORDER_HDR check

Joachim Eastwood (1):
      ASoC: atmel_ssc: Don't try to free ssc if request failed

Joe Perches (3):
      video: Convert vmalloc/memset to vzalloc
      sparc: Remove unnecessary semicolons
      vsprintf: Update %pI6c to not compress a single 0

Joerg Roedel (3):
      x86/amd-iommu: Fix 3 possible endless loops
      x86/amd-iommu: Use only per-device dma_ops
      x86/amd-iommu: Fix boot crash with hidden PCI devices

Johannes Berg (1):
      mac80211: fix IBSS teardown race

John Johansen (1):
      AppArmor: Fix sleep in invalid context from task_setrlimit

John Stultz (1):
      rtc: Fix ioctl error path return

John W. Linville (2):
      Revert "mac80211: Skip tailroom reservation for full HW-crypto devices"
      Revert "mac80211: stop queues before rate control updation"

Jonghwan Choi (1):
      ARM: S5PV210: Fix possible null pointer dereference

Josef Bacik (9):
      Btrfs: cache bitmaps when searching for a cluster
      Btrfs: noinline the cluster searching functions
      Btrfs: don't commit the transaction if we dont have enough pinned bytes
      Btrfs: fix bitmap regression
      Btrfs: fix the allocator loop logic
      Btrfs: fix duplicate checking logic
      Btrfs: don't map extent buffer if path->skip_locking is set
      Btrfs: unlock the trans lock properly
      Btrfs: don't map extent buffer if path->skip_locking is set

Jozsef Kadlecsik (2):
      netfilter: ipset: Fix return code for destroy when sets are in use
      netfilter: ipset: Use the stored first cidr value instead of '1'

Julia Lawall (4):
      arch/arm/mach-omap1/dma.c: Invert calls to platform_device_put
and platform_device_del
      drivers/video/imxfb.c: add missing clk_put
      drivers/video/pxa168fb.c: add missing clk_put
      drivers/usb/host/ohci-pxa27x.c: add missing clk_put

Julian Anastasov (2):
      ipvs: restore support for iptables SNAT
      netfilter: nf_nat: fix crash in nf_nat_csum

Kukjin Kim (1):
      ARM: S5P: Should be S3C_VA_USB_HSPHY instead of S5P_VA_XX

Kumar Gala (2):
      powerpc/fsl_rio: Fix compile error when CONFIG_FSL_RIO not set
      powerpc/book3e: Fix CPU feature handling on e5500 in 32-bit mode

Kyungmin Park (3):
      gpio: Fix gpio-exynos4 build fails in mainline
      ARM: EXYNOS4: Remove compiler warning on exynos4_pwm4_resume
      ARM: SAMSUNG: Remove unused onenand plat functions

Lars-Peter Clausen (3):
      ASoC: AD1836: Fix setting the PCM format
      ASoC: Blackfin: bf5xx-ad1836: Fix codec device name
      ASoC: snd_soc_new_{mixer,mux,pga} make sure to use right DAPM context

Laurent Pinchart (3):
      [media] ivtvfb: use display information in info not in var for panning
      [media] v4l: Fix media_entity_to_video_device macro argument name
      [media] media: Fix media device minor registration

Li Zefan (2):
      Btrfs: avoid stack bloat in btrfs_ioctl_fs_info()
      Btrfs: use join_transaction in btrfs_evict_inode()

Libor Pechacek (1):
      USB: core: Tolerate protocol stall during hub and port status read

Linus Torvalds (4):
      tty_buffer: get rid of 'seen_tail' logic in flush_to_ldisc
      selinux: simplify and clean up inode_has_perm()
      vfs: reorganize 'struct inode' layout a bit
      Linux 3.0-rc3

Linus Walleij (2):
      genirq: Fix descriptor init on non-sparse IRQs
      gpio/nomadik: fix sleepmode for elder Nomadik

Luciano Coelho (1):
      nl80211: fix overflow in ssid_len

Maarten Lankhorst (2):
      xhci: Add defines for hardcoded slot states
      xhci: Do not issue device reset when device is not setup

Marcelo Tosatti (1):
      KVM: x86: use proper port value when checking io instruction permission

Marcus Meissner (1):
      net/ipv6: check for mistakenly passed in non-AF_INET6 sockaddrs

Marek Olšák (1):
      drm/radeon/kms: add missing Evergreen texture formats to the CS parser

Mark Brown (8):
      rtc: Staticize non-exported __rtc_set_alarm()
      genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
      ASoC: Only update SYSCLK_ENA when pausing WM8915 SYSCLK
      ASoC: Add missing break in WM8915 FLL source selection
      ASoC: Check for NULL register bank in snd_soc_get_cache_val()
      USB: s3c-hsotg: Tone down debugging
      ASoC: Fix WM8962 headphone volume update for use of advanced caches
      ASoC: WM8804 does not support sample rates below 32kHz

Martin Schwidefsky (2):
      [S390] use generic RCU page-table freeing code
      [S390] fix kvm defines for 31 bit compile

Mathias Krause (1):
      exec: delay address limit change until point of no return

Matt Evans (2):
      xhci: Bigendian fix for skip_isoc_td()
      xhci: Bigendian fix for xhci_check_bandwidth()

Mauro Carvalho Chehab (2):
      [media] uvc_entity: initialize return value
      [media] soc_camera: preserve const attribute

Michael Chang (1):
      staging: gma500: get control from firmware framebuffer if conflicts

Michael Hennerich (1):
      staging: iio: industrialio-trigger: set iio_poll_func private_data

Michal Marek (5):
      kbuild: Fix KERNELVERSION for empty SUBLEVEL or PATCHLEVEL
      kbuild: Fix <linux/version.h> for empty SUBLEVEL or PATCHLEVEL
      kbuild: Move depmod call to a separate script
      kbuild: Hack for depmod not handling X.Y versions
      perf: Use make kernelversion instead of parsing the Makefile

Mika Westerberg (5):
      ep93xx: set DMA masks for the ep93xx_eth
      net: ep93xx_eth: pass struct device to DMA API functions
      net: ep93xx_eth: allocate buffers using kmalloc()
      net: ep93xx_eth: drop GFP_DMA from call to dma_alloc_coherent()
      net: ep93xx_eth: fix DMA API violations

Mike Frysinger (1):
      musb: fix prefetch build failure

Mike McCormack (2):
      rtlwifi: Fix logic in rx_interrupt
      rtlwifi: Avoid modifying skbs that are resubmitted

Mike Waychison (1):
      KVM: Initialize kvm before registering the mmu notifier

Neil Horman (1):
      bonding: reset queue mapping prior to transmission to physical device (v5)

Nick Kossifidis (1):
      ath5k: Disable fast channel switching by default

Nicolas Kaiser (2):
      drm: i915: correct return status in intel_hdmi_mode_valid()
      staging: rts_pstor: use bitwise operator instead of logical one

OGAWA Hirofumi (1):
      fat: Fix corrupt inode flags when remove ATTR_SYS flag

Omar Ramirez Luna (1):
      OMAP: iovmm: fix SW flags passed by user

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack: fix ct refcount leak in l4proto->error()

Padmavathi Venna (1):
      ARM: S5P64X0: Fix SPI platform device name

Patrik Jakobsson (1):
      staging: gma500: Skip bogus LVDS VBT mode and check for LVDS
before adding backlight

Paul Mundt (1):
      fbdev: sh_mobile_lcdcfb: Fix up fallout from MERAM changes.

Peter Foley (1):
      kbuild: silence Nothing to be done for 'all' message

Peter Zijlstra (5):
      sched: Fix cross-cpu clock sync on remote wakeups
      sched: Fix schedstat.nr_wakeups_migrate
      perf, cgroups: Fix up for new API
      lockdep: Fix lock_is_held() on recursion
      sched: Fix/clarify set_task_cpu() locking rules

Rabin Vincent (1):
      OMAP4: fix return value of omap4_l3_init

Rafael J. Wysocki (2):
      PM / Intel IOMMU: Fix init_iommu_pm_ops() for CONFIG_PM unset
      PM / Runtime: Fix loops in pm_runtime_clk_notify()

Rafał Miłecki (1):
      ssb: fix PCI(e) driver regression causing oops on PCI cards

Randy Dunlap (2):
      staging: fix olpc_dcon build, needs BACKLIGHT_CLASS_DEVICE
      staging: fix ath6kl build when CFG80211 is not enabled

Robert Richter (4):
      oprofile, x86: Add comments to IBS LVT offset initialization
      oprofile: Free potentially owned tasks in case of errors
      oprofile: Fix locking dependency in sync_start()
      oprofile, dcookies: Fix possible circular locking dependency

Roland Stigge (1):
      staging: iio: max517: Fix iio_info changes

Roland Vossen (1):
      staging: brcm80211: fix for 'multiple definition of
wl_msg_level' build err

Russell King (1):
      GPIO: OMAP: fix section mismatch warnings

Russell King - ARM Linux (3):
      NET: am79c961: ensure asm() statements are marked volatile
      NET: am79c961: ensure multicast filter is correctly set at open
      NET: am79c961: fix assembler warnings

Ryusuke Konishi (3):
      nilfs2: fix incorrect block address termination in node concatenation
      nilfs2: fix missing block address termination in btree node shrinking
      nilfs2: fix problem in setting checkpoint interval

Sage Weil (8):
      usb: remove bad dput after dentry_unhash
      usb: remove bad dput after dentry_unhash
      ceph: use ihold when we already have an inode ref
      ceph: fix sync vs canceled write
      ceph: fix short sync reads from the OSD
      ceph: fix ENOENT logic in striped_read
      ceph: unwind canceled flock state
      Btrfs: clear current->journal_info on async transaction commit

Sangbeom Kim (1):
      ASoC: SAMSUNG: Fix the incorrect referencing of I2SCON register

Sanjeev Premi (1):
      [media] omap3isp: fix compiler warning

Santosh Shilimkar (2):
      OMAP2+: Fix 9 section mismatch(es) warnings from mach-omap2/built-in.o
      OMAP: SRAM: Fix warning: format '%08lx' expects type 'long unsigned int'

Sarah Sharp (1):
      xhci: Disable MSI for some Fresco Logic hosts.

Sebastian Andrzej Siewior (7):
      genirq: Print threaded handler in spurious debug output
      irq: Handle spurios irq detection for threaded irqs
      timers: Consider slack value in mod_timer()
      usb/mv_udc_core: fix compile
      usb/pxa25x_udc: cleanup the LUBBOCK err path
      usb/s3c-hsudc: fix error path
      usb/renesas_usbhs: free uep on removal

Shaohui Xie (1):
      powerpc/85xx: fix race bug of calling request_irq after enable
elbc interrupts

Shubhrajyoti D (1):
      omap4: hwmod: Enable the keypad

Stanislaw Gruszka (5):
      iwlagn: fix channel switch locking
      iwlagn: use cts-to-self protection on 5000 adapters series
      rt2x00: fix rmmod crash
      iwl4965: set tx power after rxon_assoc
      iwlegacy: fix channel switch locking

Stefano Stabellini (1):
      xen: use the trigger info we already have to choose the irq handler

Steffen Klassert (2):
      xfrm: Fix off by one in the replay advance functions
      ipv4: Fix packet size calculation for raw IPsec packets in
__ip_append_data

Steffen Sledz (1):
      USB: serial: add another 4N-GALAXY.DE PID to ftdi_sio driver

Steven Miao (1):
      fbdev: bf537-lq035: add missing blacklight properties type

Steven Rostedt (2):
      kprobes/trace: Fix kprobe selftest for gcc 4.6
      ftrace: Revert 8ab2b7efd ftrace: Remove unnecessary disabling of irqs

Sucheta Chakraborty (1):
      qlcnic: Avoid double free of skb in tx path

Suleiman Souhlal (1):
      SLAB: Record actual last user of freed objects.

Suresh Jayaraman (2):
      cifs: fix the kernel release version in the default security
warning message
      cifs: make CIFS depend on CRYPTO_ECB

Takashi Iwai (3):
      ALSA: hda - Fix invalid unsol tag for some alc262 model quirks
      ALSA: hda - Fix initialization of hp pins with master_mute in Realtek
      ALSA: Use %pV for snd_printk()

Tasslehoff Kjappfot (1):
      omap3: Free Beagle rev gpios when they are read, so others can
read them later

Tejun Heo (1):
      libata: fix unexpectedly frozen port after ata_eh_reset()

Thadeu Lima de Souza Cascardo (1):
      mac80211: call dev_alloc_name before copying name to sdata

Theodore Ts'o (1):
      vfs: make unlink() and rmdir() return ENOENT in preference to EROFS

Thomas Abraham (1):
      gpio/exynos4: Fix incorrect mapping of gpio pull-up macro to
register setting

Thomas Gleixner (2):
      clockevents: Handle empty cpumask gracefully
      x86: cpu-hotplug: Prevent softirq wakeup on wrong CPU

Timur Tabi (1):
      ASoC: fsl: fix initialization of DMA buffers

Toby Gray (1):
      USB: cdc-acm: Adding second ACM channel support for Nokia E7 and C7

Todd Poynor (1):
      ARM: OMAP2: Add missing iounmap in omap4430_phy_init

Tormod Volden (1):
      savagefb: Use panel CVT mode as default

Torsten Hilbrich (1):
      USB: option Add blacklist for ZTE K3765-Z (19d2:2002)

Tushar Behera (1):
      ARM: S5P: Fix compilation error for exynos4_defconfig

Vasanthakumar Thiagarajan (1):
      staging: ath6kl: Fix a kernel panic during suspend/resume

Vasily Averin (1):
      possible memory corruption in cifs_parse_mount_options()

Vince Weaver (2):
      perf: Comment /proc/sys/kernel/perf_event_paranoid to be part of user ABI
      perf: Fix comments in include/linux/perf_event.h

Virupax Sadashivpetimath (1):
      spi-pl022: Add missing return value update

WANG Cong (1):
      netpoll: prevent netpoll setup on slave devices

Wey-Yi Guy (1):
      iwlagn: send tx power command if defer cause by RXON not match

Williams, Mitch A (1):
      igb: fix i350 SR-IOV failture

Wolfram Sang (1):
      dtc/powerpc: remove obsolete .gitignore entries

Wu Jiajun-B06378 (1):
      gianfar:localized filer table

Yegor Yefremov (1):
      ethtool.h: fix typos

oftedal (3):
      Restructure sun4d_build_device_irq so that timer interrupts can
be allocated
      Do not skip interrupt sources in sun4d interrupt handler and
acknowledge interrupts correctly
      Add support for allocating irqs for bootbus devices

richard kennedy (1):
      btrfs: remove 64bit alignment padding to allow extent_buffer to
fit into one fewer cacheline
