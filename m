Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab1GLAIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 20:08:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651Ab1GLAIg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 20:08:36 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Jul 2011 17:07:44 -0700
Message-ID: <CA+55aFzd1vUhgxQc5=zjoYyKsPrMVdVEW+_taYSYASn-e4h6vw@mail.gmail.com>
Subject: Linux 3.0-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I said -rc6 might be the last -rc. I lied.

Things have been pretty quiet, but there's enough new stuff here that
I wanted to do another -rc, and we still have some issues with the RCU
changes causing problems when RCU events happen before the scheduler
has been fully initialized etc. So -rc7 is out there, although it
might not have mirrored out to the public sites quite yet.

I also ended up re-generating the -rc6 files (fat-fingered the release
script), so the -rc6 patches and tar-balls look all brand spanking new
too! Two releases for the price of one!

There's not a whole lot to say about it - the appended shortlog gives
a reasonable overview. Random drivers (we're back to the usual "two
thirds drivers" statistics), some media and cifs updates, and some
vmscan corner case improvements.

                Linus

---
Alan Stern (2):
      USB: fix regression occurring during device removal
      USB: additional regression fix for device removal

Alex Deucher (3):
      drm/radeon/kms: fix typo in IH_CNTL swap bitfield
      drm/radeon/kms: fix typo in evergreen disp int status register
      drm/radeon/kms: clean up multiple crtc handling for evergreen+ (v2)

Alexey Khoroshilov (1):
      hfsplus: Fix double iput of the same inode in hfsplus_fill_super()

Anatolij Gustschin (1):
      USB: fsl_udc_core: fix build breakage when building for ARM arch

Andre Bartke (2):
      [media] V4L: mx1-camera: fix uninitialized variable
      drivers/platform/x86: Fix memory leak

Andrea Righi (1):
      Documentation: fix cgroup blkio throttle filenames

Arik Nemtsov (1):
      mac80211: fix rx->key NULL dereference during mic failure

Arnd Bergmann (1):
      6pack,mkiss: fix lock inconsistency

Axel Lin (5):
      mfd: Fix build error for tps65911-comparator.c
      mfd: Add Makefile and Kconfig Entries for tps65911 comparator
      gpio: tps65910: add missing breaks in tps65910_gpio_init
      platform-drivers-x86: set backlight type to BACKLIGHT_PLATFORM
      regulator: db8500-prcmu: small fixes

Ben Skeggs (1):
      drm/kms: allow drm_mode_group with no objects

Bjorn Helgaas (1):
      MAINTAINERS: update Bjorn Helgaas's email address

Bob Liu (1):
      mm/nommu.c: fix remap_pfn_range()

Colin Cross (1):
      PM: Reintroduce dropped call to check_wakeup_irqs

Dave Chinner (1):
      xfs: unpin stale inodes directly in IOP_COMMITTED

David Howells (1):
      FS-Cache: Add a helper to bulk uncache pages on an inode

David S. Miller (2):
      ipv6: Don't change dst->flags using assignments.
      ipv6: Don't put artificial limit on routing table size.

David Sterba (1):
      btrfs: add missing options displayed in mount output

Davidlohr Bueso (1):
      FDPIC: Fix memory leak

Donggeun Kim (1):
      regulator: max8997: Fix setting inappropriate value for
ramp_delay variable

Emmanuel Grumbach (1):
      iwlagn: Fix a bug introduced by the HUGE command removal

Eric Dumazet (2):
      net: refine {udp|tcp|sctp}_mem limits
      hp-wmi: fix use after free

Eugene A. Shatokhin (1):
      ath5k: fix memory leak when fewer than N_PD_CURVES are in use

Evgeni Golov (1):
      iwlagn: fix *_UCODE_API_MAX output in the firmware field

FUJITA Tomonori (1):
      natsemi: silence dma-debug warnings

Guenter Roeck (3):
      hwmon: (lm95241) Fix chip detection code
      hwmon: (lm95241) Fix negative temperature results
      hwmon: (pmbus) Improve auto-detection of temperature status register

Hans Verkuil (14):
      [media] tuner-core: fix s_std and s_tuner
      [media] tuner-core: fix tuner_resume: use t->mode instead of t->type
      [media] v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner
      [media] pvrusb2: fix g/s_tuner support
      [media] bttv: fix s_tuner for radio
      [media] feature-removal-schedule: change in how radio device
nodes are handled
      [media] v4l2-subdev.h: remove unused s_mode tuner op
      [media] tuner-core/v4l2-subdev: document that the type field has
to be filled in
      [media] tuner-core: simplify the standard fixup
      [media] v4l2-ioctl.c: check for valid tuner type in S_HW_FREQ_SEEK
      [media] tuner-core: power up tuner when called with s_power(1)
      [media] cx18/ivtv: fix g_tuner support
      [media] tuner-core.c: don't change type field in g_tuner or g_frequency
      [media] msp3400: fill in v4l2_tuner based on vt->type field

Hans de Goede (1):
      [media] pwc: better usb disconnect handling

Henrique de Moraes Holschuh (2):
      thinkpad-acpi: handle some new HKEY 0x60xx events
      thinkpad-acpi: handle HKEY 0x4010, 0x4011 events

Herbert Xu (1):
      bridge: Always flood broadcast packets

HeungJun, Kim (4):
      [media] m5mols: Fix capture image size register definition
      [media] m5mols: add m5mols_read_u8/u16/u32() according to I2C byte width
      [media] m5mols: remove union in the m5mols_get_version(), and VERSION_SIZE
      [media] m5mols: Use proper email address format

Huisung Kang (1):
      i2c-s3c2410: Fix typo 'i2s' -> 'i2c'

Janusz Krzysztofik (1):
      omap: drop __initdata tags from static struct platform_device declarations

Jarkko Nikula (2):
      ASoC: tlv320aic3x: Don't sync first two registers from register cache
      ASoC: tlv320aic3x: Do soft reset to codec when going to bias off state

Jarod Wilson (20):
      [media] mceusb: add and use mce_dbg printk macro
      [media] mceusb: support I-O Data GV-MC7/RCKIT
      [media] mceusb: mce_sync_in is brain-dead
      [media] [staging] lirc_imon: fix unused-but-set warnings
      [media] [staging] lirc_sir: fix unused-but-set warnings
      [media] lirc_dev: store cdev in irctl, up maxdevs
      [media] fintek-cir: make suspend with active IR more reliable
      [media] nuvoton-cir: in_use isn't actually in use, remove it
      [media] mceusb: plug memory leak on data transmit
      [media] imon: support for 0x46 0xffdc imon vfd
      [media] imon: fix initial panel key repeat suppression
      [media] ite-cir: 8709 needs to use pnp resource 2
      [media] keymaps: fix table for pinnacle pctv hd devices
      [media] lirc_zilog: fix spinning rx thread
      [media] [staging] lirc_serial: allocate irq at init time
      [media] rc: fix ghost keypresses with certain hw
      [media] saa7134: fix raw IR timeout value
      [media] imon: auto-config ffdc 7e device
      [media] imon: allow either proto on unknown 0xffdc
      [media] rc: call input_sync after scancode reports

Jean-François Dagenais (1):
      w1: ds1wm: add a reset recovery parameter

Jeff Layton (7):
      cifs: remove bogus call to cifs_cleanup_volume_info
      cifs: fix build_unc_path_to_root to account for a prefixpath
      cifs: have cifs_cleanup_volume_info not take a double pointer
      cifs: factor smb_vol allocation out of cifs_setup_volume_info
      cifs: move bdi_setup_and_register outside of CONFIG_CIFS_DFS_UPCALL
      cifs: fix expand_dfs_referral
      cifs: drop spinlock before calling cifs_put_tlink

Jerome Glisse (1):
      drm/radeon/kms: free ib pool on module unloading

Jesper Juhl (1):
      Documentation: update CodingStyle memory allocators

Jitendra Kalsaria (3):
      qlge:Fix crash caused by mailbox execution on wedged chip.
      qlge: Fix printk priority so chip fatal errors are always reported.
      qlge:Version change to v1.00.00.29

Joe Perches (1):
      ath5k: Add missing breaks in switch/case

Johannes Berg (3):
      iwlagn: fix change_interface for P2P types
      iwlagn: fix cmd queue unmap
      iwlagn: map command buffers BIDI

John W. Linville (1):
      iwlagn: use PCI_DMA_* for pci_* operations

Jonghwan Choi (2):
      i2c-s3c2410: Remove useless break code
      regulator: max8952 - fix wrong gpio valid check

Jose Alonso (1):
      dell-laptop - using buffer without mutex_lock

Josef Bacik (1):
      Btrfs: don't panic if we get an error while balancing V2

KAMEZAWA Hiroyuki (2):
      memcg: fix reclaimable lru check in memcg
      memcg: fix numa scan information update to be triggered by memory event

Kees Cook (1):
      x86, suspend: Restore MISC_ENABLE MSR in realmode wakeup

Keng-Yu Lin (1):
      Revert: "dell-laptop: Toggle the unsupported hardware killswitch"

Keshava Munegowda (1):
      Revert "mfd: Add omap-usbhs runtime PM support"

Konrad Rzeszutek Wilk (1):
      xen/pci: Move check for acpi_sci_override_gsi to xen_setup_acpi_sci.

Kristoffer Glembo (1):
      greth: greth_set_mac_add would corrupt the MAC address.

Kuninori Morimoto (1):
      ASoC: ak4642: fixup snd_soc_update_bits mask for PW_MGMT2

Lars Ellenberg (6):
      drbd: add missing spinlock to bitmap receive
      drbd: don't cond_resched_lock with IRQs disabled
      drbd: account bitmap IO during resync as resync-(related-)-io
      drbd: when receive times out on meta socket, also check last
receive time on data socket
      drbd: fix limit define, we support 1 PiByte now
      drbd: we should write meta data updates with FLUSH FUA

Laurent Pinchart (2):
      [media] v4l: Don't access media entity after is has been destroyed
      [media] uvcvideo: Ignore entities for terminals with no supported format

Lee, Chun-Yi (1):
      acer-wmi: fix bitwise bug when set device state

Linus Torvalds (2):
      Documentation/Changes: remove some really obsolete text
      Linux 3.0-rc7

Linus Walleij (1):
      ARM: 6980/1: mmci: use StartBitErr to detect bad connections

Luming Yu (1):
      [CPUFREQ] fix cpumask memory leak in acpi-cpufreq on cpu hotplug.

Marcin Slusarz (1):
      debugobjects: Fix boot crash when kmemleak and debugobjects enabled

Marcus Meissner (1):
      net: bind() fix error return on wrong address family

Marek Szyprowski (5):
      [media] MAINTAINERS: Add videobuf2 maintainers
      [media] media: vb2: add __GFP_NOWARN to dma-sg allocator
      [media] Revert "[media] v4l2: vb2: one more fix for REQBUFS()"
      [media] media: vb2: reset queued_count value during queue reinitialization
      [media] media: vb2: fix allocation failure check

Mark Brown (3):
      ASoC: Fix Blackfin I2S _pointer() implementation return in bounds values
      ASoC: Ensure we delay long enough for WM8994 FLL to lock when starting
      ASoC: Manage WM8731 ACTIVE bit as a supply widget

Mathias Nyman (1):
      gpio/langwell_gpio: ack the correct bit for langwell gpio interrupts

Matthew Garrett (1):
      x86: Don't use the EFI reboot method by default

Mel Gorman (4):
      mm: vmscan: correct check for kswapd sleeping in sleeping_prematurely
      mm: vmscan: do not apply pressure to slab if we are not applying
pressure to zone
      mm: vmscan: evaluate the watermarks against the correct classzone
      mm: vmscan: only read new_classzone_idx from pgdat when
reclaiming successfully

Miao Xie (1):
      btrfs: fix oops when doing space balance

Michael Williamson (1):
      audio: tlv320aic26: fix PLL register configuration

Mike Galbraith (1):
      sched, cgroups: Fix MIN_SHARES on 64-bit boxen

Miklos Szeredi (1):
      fs: fix lock initialization

Muthu Kumar (1):
      Documentation/spinlocks.txt: Remove reference to sti()/cli()

MyungJoo Ham (3):
      ARM: SAMSUNG: header file revised to prevent declaring duplicated
      ARM: EXYNOS4: Address a section mismatch w/ suspend issue.
      regulator: max8997: remove dependency on platform_data pointer

Naveen Krishna Chatradhi (1):
      ARM: EXYNOS4: fix improper gpio configuration

Ohad Ben-Cohen (1):
      [media] media: omap3isp: fix a potential NULL deref

Padmavathi Venna (3):
      ARM: SAMSUNG: Add tx_st_done variable
      spi/s3c64xx: Bug fix for SPI with different FIFO level
      ARM: S5PC100: Fix for compilation error

Peter Chubb (1):
      x86, reboot: Acer Aspire One A110 reboot quirk

Peter Zijlstra (1):
      sched: Disable (revert) SCHED_LOAD_SCALE increase

Petr Štetiar (1):
      ARM: 6966/1: ep93xx: fix inverted RTS/DTR signals on uart1

Philipp Reisner (1):
      drbd: Use the correct max_bio_size when creating resync requests

Rafael J. Wysocki (1):
      PM / Hibernate: Fix free_unnecessary_pages()

Rajkumar Manoharan (1):
      ath9k: Fix suspend/resume when no interface is UP

Ram Pai (2):
      resource: ability to resize an allocated resource
      PCI: conditional resource-reallocation through kernel parameter
pci=realloc

Randy Dunlap (1):
      MAINTAINERS: move kernel-doc patches location

Robert Richter (1):
      oprofile, x86: Fix race in nmi handler while starting counters

Russell King (2):
      ARM: dmabounce: fix map_single() error return value
      ARM: move memory layout sanity checking before meminfo initialization

Sage Weil (3):
      ceph: fix page alignment corrections
      libceph: fix page calculation for non-page-aligned io
      ceph: fix sync and dio writes across stripe boundaries

Samuel Ortiz (2):
      input: pmic8xxx-keypad: Do not use mfd_get_data()
      input: pmic8xxx-pwrkey: Do not use mfd_get_data()

Sangbeom Kim (1):
      ARM: S5P: Fix bug on init of PWMTimers for HRTimer

Seth Forshee (2):
      hfsplus: add missing call to bio_put()
      acer-wmi: Only update rfkill status for associated hotkey events

Shan Wei (2):
      net: 8139too: Initial necessary vlan_features to support vlan
      net: vlan: enable soft features regardless of underlying device

Shaohua Li (3):
      cfq-iosched: fix a rcu warning
      cfq-iosched: make code consistent
      mm: __tlb_remove_page() check the correct batch

Shreyas Bhatewara (2):
      vmxnet3: fix starving rx ring whenoc_skb kb fails
      vmxnet3: round down # of queues to power of two

Shyam Iyer (1):
      Fix call trace when interrupts are disabled while sleeping
function kzalloc is called

Sjoerd Simons (2):
      [media] uvcvideo: Remove buffers from the queues when freeing
      [media] uvcvideo: Disable the queue when failing to start

Sonic Zhang (1):
      i2c-bfin-twi: abort transfer is MEM bit is reset unexpectedly

Stefan Richter (1):
      firewire: ohci: do not bind to Pinnacle cards, avert panic

Steffen Klassert (3):
      xfrm: Remove family arg from xfrm_bundle_ok
      ipv4: Don't use ufo handling on later transformed packets
      xfrm4: Don't call icmp_send on local error

Stephen Warren (2):
      i2c: tegra: Assign unused slave address
      ASoC: Tegra: I2S: Ensure clock is enabled when writing regs

Sylwester Nawrocki (8):
      [media] s5p-fimc: Fix possible memory leak during capture
devnode registration
      [media] s5p-fimc: Fix V4L2_PIX_FMT_RGB565X description
      [media] s5p-fimc: Fix data structures documentation and cleanup
debug trace
      [media] s5p-fimc: Fix wrong buffer size in queue_setup
      [media] s5p-fimc: Remove empty buf_init operation
      [media] s5p-fimc: Use pix_mp for the color format lookup
      [media] s5p-fimc: Update copyright notices
      ARM: EXYNOS4: Set appropriate I2C device variant

Takashi Iwai (3):
      ASoC: Don't set invalid name string to snd_card->driver field
      ALSA: hda - Change all ADCs for dual-adc switching mode for Realtek
      ALSA: hda - Fix a copmile warning

Tejun Heo (1):
      x86-32, NUMA: Fix boot regression caused by NUMA init
unification on highmem machines

Thomas Abraham (1):
      ARM: EXYNOS4: Fix card detection for sdhci 0 and 2

Tushar Behera (1):
      regulator: MAX8997: Fix for divide by zero error

Vaibhav Hiremath (2):
      [media] OMAP_VOUT: Change hardcoded device node number to -1
      [media] omap_vout: Added check in reqbuf & mmap for buf_size allocation

Vitaly Kuzmichev (1):
      ARM: 6994/1: smp_twd: Fix typo in 'twd_timer_rate' printing

Vladimir Pantelic (1):
      [media] OMAP_VOUTLIB: Fix wrong resizer calculation

Wei Yongjun (1):
      sctp: fix missing send up SCTP_SENDER_DRY_EVENT when subscribe it

Will Deacon (3):
      ARM: 6989/1: perf: do not start the PMU when no events are present
      ARM: 6990/1: MAINTAINERS: add entry for ARM PMU profiling and debugging
      ARM: 6987/1: l2x0: fix disabling function to avoid deadlock

Wolfram Sang (5):
      ARM: 6979/1: mach-vt8500: add forgotten irq_data conversion
      ARM: S3C24XX: don't use uninitialized variable in dma.c
      ARM: S3C24XX: drop return codes in void function of dma.c
      ARM: S3C2440: fix section mismatch on mini2440
      drivers/leds/leds-pca9532.c: change driver name to be unique

Xiao Guangrong (1):
      jump_label: Fix jump_label update for modules

Yoshihiro Shimoda (2):
      net: sh_eth: fix cannot work half-duplex mode
      net: sh_eth: fix the parameter for the ETHER of SH7757
