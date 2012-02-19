Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2BSA1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 19:27:32 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33600 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2BSA1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 19:27:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.109.228 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 18 Feb 2012 16:27:09 -0800
X-Google-Sender-Auth: bRejLEho0MF1k8uEl1J7jwgd_1Y
Message-ID: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
Subject: Linux 3.3-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's almost getting to be a habit: yet another -rc release that is
delayed by a couple of days.

However, this time I actually have an excuse. Well, an excuse other
than my usual "Sue me, I'm disorganized and forgot".

This time the reason for the delay is that we spent several days
chasing down a nasty floating point state corruption that happens on
32-bit x86 - but only if you have a modern CPU (why are you using
32-bit kernels?) that supports the AES-NI instructions. And then you
have to enable support for them *and* use a wireless driver that uses
it. The most likely reason for that is using the mac80211
infrastructure with WPA with AES encryption (ie usually WPA2)

Anyway, if you are using wireless networking, have a modern CPU that
you cripple by running in 32-bit mode, and have seen odd FP-related
crashes with (the usual symptoms seem to be flash problems in the
browser or the mouse in X suddenly moving to a corner or similar, but
anything goes, really), that might be due to this.

The workaround is either to just compile a 64-bit kernel (hey, you can
leave your 32-bit userland alone if you are so emotionally attached to
last century) or upgrade to 3.3-rc4.

Sure, we'll backport the patches to -stable too for the boring people
who don't want to help test development kernels. But wouldn't it be
nice to have the bug fixed *and* feel like you are helping development
by testing shiny new -rc kernels?

You know you want to.

Anyway, while I'm just blathering about the FPU state fix (because
that was what *I* was doing), other people worked on other things too.
So -rc4 also does various other things, like remove the old stale
gma500 staging driver that got properly merged. Or remove the old
pohmelfs staging code, since that will get a complete rewrite.

Or if you're not interested in the big patches, but in the small ones
that actually matter to you, try to find them in the shortlog below.
There are various network driver updates, some ecryptfs and xfs
updates, ARM fixes, sha512 stack usage fixes, yadda yadda. Something
for almost everyone, I'm sure.

Go forth and test.

                  Linus

---
Adrian Hunter (1):
      mmc: sdhci-pci: set Medfield SDIO as non-removable

Al Viro (1):
      CONFIG_TR/CONFIG_LLC: work around the problem with select

Alex Deucher (2):
      drm/radeon/kms/atom: bios scratch reg handling updates
      drm/radeon/kms: fix MSI re-arm on rv370+

Alexander Duyck (1):
      ixgbe: Fix broken dependency on MAX_SKB_FRAGS being related to page size

Alexey Dobriyan (1):
      crypto: sha512 - use standard ror64()

Ameya Palande (1):
      MAINTAINERS: staging: iio: add iio information

Amitkumar Karwar (2):
      mwifiex: handle association failure case correctly
      mwifiex: add NULL checks in driver unload path

Andrew Lunn (2):
      ARM: orion: Fix Orion5x GPIO regression from MPP cleanup
      ARM: orion: Fix USB phy for orion5x.

Anisse Astier (1):
      net: Fix build regression when INET_UDP_DIAG=y and IPV6=m

Anton Blanchard (1):
      powerpc/perf: power_pmu_start restores incorrect values,
breaking frequency events

Anton Vorontsov (2):
      Revert "bq27x00_battery: Fix reporting status value for bq27500 battery"
      staging: android/ram_console: Don't build on arches w/o ioremap

Arun Sharma (1):
      net: Disambiguate kernel message

Arve Hjønnevåg (3):
      Staging: android: binder: Don't call dump_stack in binder_vma_open
      Staging: android: binder: Fix crashes when sharing a binder file
between processes
      staging: android: lowmemorykiller: Don't wait more than one
second for a process to die

Asai Thambi S P (1):
      mtip32xx: removed the irrelevant argument of mtip_hw_submit_io()
and the unused member of struct driver_data

Atsushi Nemoto (1):
      net: enable TC35815 for MIPS again

Axel Lin (6):
      power_supply: Fix modalias for charger-manager
      lp8727_charger: Add terminating entry for i2c_device_id table
      mmc: cb710 core: Add missing spin_lock_init for irq_lock of
struct cb710_chip
      regulator: Fix getting voltage in max8649_enable_time()
      mlx4: Fix kcalloc parameters swapped
      RxRPC: Fix kcalloc parameters swapped

Bart Westgeest (1):
      staging: usbip: fix to prevent potentially using uninitialized spinlock

Ben Hutchings (1):
      ethtool: Null-terminate filename passed to ethtool_ops::flash_device

Benjamin Herrenschmidt (5):
      powerpc/wsp: Permanently enable PCI class code workaround
      powerpc/wsp: Fix IRQ affinity setting
      powerpc: Fix WARN_ON in decrementer_check_overflow
      powerpc/fsl/pci: Fix PCIe fixup regression
      powerpc: Disable interrupts early in Program Check

Benoit Cousson (1):
      ARM: OMAP2+: board-generic: Add missing handle_irq callbacks

Brian King (1):
      powerpc/pseries: Fix partition migration hang in stop_topology_update

Chris Wilson (1):
      drm/i915:: Disable FBC on SandyBridge

Christoph Hellwig (1):
      xfs: use a normal shrinker for the dquot freelist

Cong Wang (3):
      usb: musb: fix a build error on mips
      tty: fix a build failure on sparc
      ecryptfs: remove the second argument of k[un]map_atomic()

Cousson, Benoit (1):
      ks8851: Fix NOHZ local_softirq_pending 08 warning

Dan Carpenter (4):
      cdrom: use copy_to_user() without the underscores
      isdn: type bug in isdn_net_header()
      bna: fix error handling of bnad_get_flash_partition_by_offset()
      relay: prevent integer overflow in relay_open()

Dan Magenheimer (2):
      zcache: fix deadlock condition
      zcache: Set SWIZ_BITS to 8 to reduce tmem bucket lock contention.

Daniel T Chen (1):
      ALSA: intel8x0: Fix default inaudible sound on Gateway M520

Daniel Vetter (2):
      drm/i915: fixup interlaced bits clearing in PIPECONF on PCH_SPLIT
      drm/i915: no lvds quirk for AOpen MP45

Danny Kukawka (2):
      vmw_balloon: fix for a -Wuninitialized warning
      cs5535-mfgpt: don't call __init function from __devinit

Dave Airlie (1):
      drm/radeon/kms: drop lock in return path of radeon_fence_count_emitted.

Dave Young (2):
      loop: zero fill bio instead of return -EIO for partial read
      module: make module param bint handle nul value

David Howells (1):
      Reduce the number of expensive division instructions done by
_parse_integer()

David Lv (1):
      via-velocity: S3 resume fix.

David Miller (1):
      regulator: Fix mc13xxx regulator modular build (again)

David S. Miller (1):
      net: Make qdisc_skb_cb upper size bound explicit.

Dean Nelson (1):
      e1000: add dropped DMA receive enable back in for WoL

Dmitry Tarnyagin (1):
      caif: Bugfix double kfree_skb upon xmit failure

Don Skidmore (1):
      ixgbe: update copyright to 2012

Eliad Peller (1):
      mac80211: timeout a single frame in the rx reorder buffer

Emmanuel Grumbach (1):
      iwlwifi: don't mess up QoS counters with non-QoS frames

Eric Dumazet (4):
      gro: more generic L2 header check
      bnx2x: fix bnx2x_storm_stats_update() on big endian
      netpoll: netpoll_poll_dev() should access dev->flags
      3c59x: shorten timer period for slave devices

Eugenia Emantayev (6):
      mlx4_core: fix memory leak at multi_func_cleanup
      mlx4_core: use correct flag for unicast_promisc
      mlx4_core: use correct port for steering
      mlx4: fix buffer overrun
      mlx4: fix QP tree trashing
      mlx4: add unicast steering entries to resource_tracker

Evgeniy Polyakov (1):
      staging: pohmelfs: remove drivers/staging/pohmelfs

Fabio Estevam (2):
      drivers: misc: Remove MISC_DEVICES config option
      usb: host: Distinguish Kconfig text for Freescale controllers

Felix Fietkau (2):
      ath9k: fix a WEP crypto related regression
      ath9k_hw: fix a RTS/CTS timeout regression

Florian Fainelli (5):
      cpmac: fix PHY name to match MDIO bus name
      bcm63xx-enet: fix PHY name to match MDIO bus name
      fec: fix PHY name to match fixed MDIO bus name
      octeon: fix PHY name to match MDIO bus name
      ixp4xx-eth: fix PHY name to match MDIO bus name

Francesco Virlinzi (1):
      stmmac: request_irq when use an ext wake irq line (v2)

Girish K S (2):
      mmc: core: Fix low speed mmc card detection failure
      mmc: core: Fix PowerOff Notify suspend/resume

Giuseppe CAVALLARO (3):
      stmmac: do not discard frame on dribbling bit assert
      stmmac: move hw init in the probe (v2)
      stmmac: update the driver version to Feb 2012 (v2)

Grazvydas Ignotas (1):
      bq27x00_battery: Fix flag register read

Greg Kroah-Hartman (3):
      driver core: cpu: remove kernel warning when removing a cpu
      staging: delete gma500 driver
      driver-core: cpu: fix kobject warning when hotplugging a cpu

Greg Rose (6):
      ixgbe: Add warning when no space left for more MAC filters
      ixgbevf: Fix mailbox interrupt ack bug
      ixgbevf: Update copyright notices
      igb: fix vf lookup
      ixgbe: fix vf lookup
      ixgbe: Fix case of Tx Hang in PF with 32 VFs

Guennadi Liakhovetski (2):
      mmc: tmio_mmc: fix card eject during IO with DMA
      mmc: sh_mmcif: fix late delayed work initialisation

Guenter Roeck (1):
      hwmon: (w83627ehf) Remove duplicate code

H Hartley Sweeten (1):
      ep93xx: fix build of vision_ep93xx.c

Haiyang Zhang (2):
      net/hyperv: Use netif_tx_disable() instead of netif_stop_queue()
when necessary
      net/hyperv: Fix the page buffer when an RNDIS message goes
beyond page boundary

Hauke Mehrtens (1):
      ssb: fix cardbus slot in hostmode

Heiko Stuebner (1):
      ARM: SAMSUNG: Fix missing api-change from subsys_interface change

Henrik Rydberg (1):
      bcma: don't fail for bad SPROM CRC

Herbert Xu (2):
      crypto: sha512 - Use binary and instead of modulus
      crypto: sha512 - Avoid stack bloat on i386

Igor Grinberg (1):
      ARM: OMAP3: cm-t35: fix section mismatch warning

Ira Snyder (1):
      powerpc: Fix kernel log of oops/panic instruction dump

Jaehoon Chung (1):
      mmc: core: add the capability for broken voltage

Jan Beulich (1):
      xenbus_dev: add missing error check to watch handling

Jan Weitzel (1):
      net/ethernet: ks8851_mll fix irq handling

Jason Wang (1):
      tcp: properly initialize tcp memory limits

Jayachandran C (1):
      usb: Skip PCI USB quirk handling for Netlogic XLP

Jean-Christophe PLAGNIOL-VILLARD (5):
      ARM: at91:rtc/rtc-at91sam9: ioremap register bank
      ARM: at91: add accessor to manage SMC
      pata/at91: use newly introduced SMC accessors
      ARM: at91: drop ide driver in favor of the pata one
      mmc: of_mmc_spi: fix little endian support

Jeff Layton (3):
      cifs: fix error handling when cifscreds key payload is an error
      cifs: request oplock when doing open on lookup
      cifs: don't return error from standard_receive3 after marking
response malformed

Jerry Huang (2):
      mmc: esdhc: add PIO mode support
      mmc: esdhc: set the timeout to the max value

Jesper Juhl (2):
      bcma: Fix mem leak in bcma_bus_scan()
      bnx2x: Fix mem leak in bnx2x_tpa_stop() if build_skb() fails.

Jiri Olsa (2):
      perf tools: Fix perf stack to non executable on x86_64
      perf tools: Fix prefix matching for kernel maps

John Fastabend (2):
      ixgbe: dcb: up2tc mapping lost on disable/enable CEE DCB state
      ixgbe: ethtool: stats user buffer overrun

John W. Linville (2):
      iwlwifi: make "Tx aggregation enabled on ra =" be at DEBUG level
      ath9k: use WARN_ON_ONCE in ath_rc_get_highest_rix

Jonghwan Choi (1):
      ARM: EXYNOS: Fix "warning: initialization from incompatible pointer type"

Julia Lawall (3):
      drivers/net/ethernet/ti: Move call to PTR_ERR after reassignment
      drivers/gpu/drm/drm_ioc32.c: initialize all fields
      drivers/staging/omapdrm/omap_fbdev.c: move free after uses

Julian Anastasov (1):
      ipv4: reset flowi parameters on route connect

Jurgen Heeks (1):
      mmc: core: Fix comparison issue in mmc_compare_ext_csds

Karol Lewandowski (1):
      ARM: EXYNOS: Bring exynos4-dt up to date

Keith Packard (2):
      drm/i915: Force explicit bpp selection for intel_dp_link_required
      drm/i915: fixup interlaced bits clearing in PIPECONF on PCH_SPLIT (v2)

Kent Overstreet (1):
      bio: don't overflow in bio_get_nr_vecs()

Kim, Milo (1):
      lp8727_chager: Fix permissions on a header file

Konrad Rzeszutek Wilk (3):
      xen/bootup: During bootup suppress XENBUS: Unable to read cpu state
      xen/smp: Fix CPU online/offline bug triggering a BUG: scheduling
while atomic.
      xen/pci[front|back]: Use %d instead of %1x for displaying PCI devfn.

Kukjin Kim (4):
      ARM: EXYNOS: Remove build warning without enabling PM
      ARM: S5PV210: Fix the name of exynos4_clk_hdmiphy_ctrl() for S5PV210
      serial: samsung: Add support for EXYNOS4212 and EXYNOS4412
      serial: samsung: Add support for EXYNOS5250

Kuninori Morimoto (3):
      usb: ch9.h: usb_endpoint_maxp() uses __le16_to_cpu()
      usb: ch9.h: usb_endpoint_maxp() uses __le16_to_cpu()
      ASoC: fsi: fixup fsi_pointer() calculation method

Larry Finger (3):
      staging: r8712u: Add new Sitecom UsB ID
      staging: r8712u: Fix problem when CONFIG_R8712_AP is set
      staging: r8712u: Use asynchronous firmware loading

Lars-Peter Clausen (1):
      regmap: Fix cache defaults initialization from raw cache defaults

Li Wei (1):
      ipv4: Fix wrong order of ip_rt_get_source() and update iph->daddr.

Linus Torvalds (11):
      i387: math_state_restore() isn't called from asm
      i387: make irq_fpu_usable() tests more robust
      i387: fix sense of sanity check
      i387: fix x86-64 preemption-unsafe user stack save/restore
      i387: move TS_USEDFPU clearing out of __save_init_fpu and into callers
      i387: don't ever touch TS_USEDFPU directly, use helper functions
      i387: do not preload FPU state at task switch time
      i387: move AMD K7/K8 fpu fxsave/fxrstor workaround from save to restore
      i387: move TS_USEDFPU flag from thread_info to task_struct
      i387: re-introduce FPU state preloading at context switch time
      Linux 3.3-rc4

Linus Walleij (1):
      pinctrl: restore pin naming

Ludovic Desroches (1):
      mmc: atmel-mci: save and restore sdioirq when soft reset is performed

Luigi Tarenga (1):
      rt2800lib: fix wrong -128dBm when signal is stronger than -12dBm

Marc Dietrich (2):
      ARM: tegra: paz00: fix wrong SD1 power gpio
      ARM: tegra: paz00: fix wrong UART port on mini-pcie plug

Marc Zyngier (1):
      ARM: 7320/1: Fix proc_info table alignment

Marek Szyprowski (1):
      ARM: EXYNOS: fix non-SMP builds for EXYNOS4

Mark Brown (2):
      ARM: S3C64XX: Make s3c64xx_init_uarts() static
      ARM: S3C6410: Use device names for both I2C clocks

Masanari Iida (1):
      ixgbe: Fix typo in ixgbe_common.h

Matthijs Kooijman (1):
      drm/radeon: do not continue after error from r600_ib_test

Michael Ellerman (1):
      powerpc/powernv: Disable interrupts while taking phb->lock

Michal Schmidt (1):
      bnx2x: remove the 'poll' module option

Milan Kocian (1):
      USB: usbserial: add new PID number (0xa951) to the ftdi driver

Mitch A Williams (1):
      igbvf: change copyright date

Mitsuo Hayasaka (1):
      xfs: pass KM_SLEEP flag to kmem_realloc() in
xlog_recover_add_to_cnt_trans()

Mohammed Shafi Shajakhan (2):
      ath9k: Fix kernel panic during driver initilization
      mac80211: Fix a rwlock bad magic bug

Naveen N. Rao (1):
      perf evsel: Fix an issue where perf report fails to show the
proper percentage

Neal Cardwell (3):
      tcp: allow tcp_sacktag_one() to tag ranges not aligned with skbs
      tcp: fix range tcp_shifted_skb() passes to tcp_sacktag_one()
      tcp: fix tcp_shifted_skb() adjustment of lost_cnt_hint for FACK

Neil Horman (4):
      netprio_cgroup: Fix obo in get_prioidx
      netprio_cgroup: fix an off-by-one bug
      netprio_cgroup: don't allocate prio table when a device is registered
      netprio_cgroup: fix wrong memory access when NETPRIO_CGROUP=m

Neil Zhang (2):
      usb: otg: mv_otg: Add dependence
      usb: otg: mv_otg: Add dependence

Nicolas Ferre (1):
      ARM: at91: USB AT91 gadget registration for module

Nikolaus Schulz (4):
      hwmon: (f75375s) Fix automatic pwm mode setting for F75373 & F75375
      hwmon: (f75375s) Fix reading of wrong register when initializing
the F75387
      hwmon: (f75375s) Fix bit shifting in f75375_write16
      hwmon: (f75375s) Let f75375_update_device treat pwmX as a measured value

Olof Johansson (1):
      ARM: tegra: dma: fix buildbreak for !CONFIG_TEGRA_SYSTEM_DMA

Omar Ramirez Luna (2):
      staging: tidspbridge: fix bridge_open memory leaks
      staging: tidspbridge: fix incorrect free to drv_datap

Ondrej Zary (1):
      module: fix broken isapnp handling in file2alias

Paolo Bonzini (1):
      cdrom: move shared static to cdrom_device_info

Paul Gortmaker (2):
      c2port: fix build error for duramar2150 due to missing header.
      m32r: relocate drivers back out of 8250 dir

Paul Walmsley (4):
      tty: serial: OMAP: use a 1-byte RX FIFO threshold in PIO mode
      tty: serial: OMAP: block idle while the UART is transferring
data in PIO mode
      tty: serial: omap-serial: wakeup latency constraint is in
microseconds, not milliseconds
      ARM: OMAP2xxx: PM: fix OMAP2xxx-specific UART idle bug in v3.3

Pekka Paalanen (2):
      Staging: asus_oled: fix image processing
      Staging: asus_oled: fix NULL-ptr crash on unloading

Philip Rakity (1):
      mmc: core: UHS sdio card that fails should not exceed 50MHz

Rabin Vincent (2):
      backing-dev: fix wakeup timer races with bdi_unregister()
      mmc: block: Init ro_lock sysfs attr to fix lockdep warnings

Randy Dunlap (3):
      uwb & wusb & usb wireless controllers: fix kconfig error & build errors
      docbook: fix fatal errors in device-drivers docbook and add DMA
Management section
      staging: fix go7007-usb license

Richard Zhao (1):
      net: fec: correct phy_name buffer length when init phy_name

Rob Clark (7):
      staging: drm/omap: drm API update: make fops struct const
      staging: drm/omap: drm API update: addfb2
      staging: drm/omap: add drm_plane support
      staging: drm/omap: multiplanar and YUV support
      staging: drm/omap: updates for DSS fifomerge API changes
      staging: drm/omap: fix minimum width/height
      staging: drm/omap: fix locking issue

Roland Dreier (1):
      IPoIB: Stop lying about hard_header_len and use skb->cb to stash
LL addresses

Roy Zang (1):
      mmc: esdhc: fix errors when booting kernel on Freescale eSDHC version 2.3

Rui li (1):
      USB: add new zte 3g-dongle's pid to option.c

Russell King (15):
      ARM: omap: fix oops in arch/arm/mach-omap2/vp.c when pmic is not found
      ARM: omap: fix oops in drivers/video/omap2/dss/dpi.c
      ARM: omap: fix broken twl-core dependencies and ifdefs
      ARM: omap: fix prm44xx.c OMAP44XX_IRQ_PRCM build error
      ARM: omap: fix vc.c PMIC error message
      ARM: omap: fix uninformative vc/i2c configuration error message
      ARM: omap: fix section mismatch errors in TWL PMIC driver
      ARM: omap: fix section mismatch warning in mux.c
      ARM: omap: preemptively fix section mismatch in
omap4_sdp4430_wifi_mux_init()
      ARM: omap: fix section mismatch warning for omap_secondary_startup()
      ARM: omap: fix section mismatch error for omap_4430sdp_display_init()
      ARM: omap: fix section mismatch warning for sdp3430_twl_gpio_setup()
      ARM: omap: fix section mismatch warnings in mux.c caused by hsmmc.c
      ARM: omap: fix wrapped error messages in omap_hwmod.c
      ARM: omap: resolve nebulous 'Error setting wl12xx data'

Samuel Thibault (1):
      drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer

Santosh Shilimkar (1):
      ARM: OMAP2: Fix the OMAP2 only build break seen with 2011+ ARM tool-chains

Sebastian Haas (1):
      can: ems_usb: Removed double netif_device_detach

Seth Jennings (1):
      staging: zcache: fix serialization bug in zv stats

Seungwon Jeon (1):
      mmc: dw_mmc: Fix PIO mode with support of highmem

Shaohua Li (3):
      block,cfq: change code order
      block: fix NULL icq_cache reference
      block: fix ioc locking warning

Shawn Lu (1):
      tcp_v4_send_reset: binding oif to iif in no sock case

Shengzhou Liu (1):
      powerpc/usb: fix issue of CPU halt when missing USB PHY clock

Shuah Khan (1):
      Staging: android: Remove pmem driver

Shubhrajyoti Datta (1):
      i2c: tegra: Add devexit_p() for remove

Simon Graham (1):
      rtlwifi: Modify rtl_pci_init to return 0 on success

Srikar Dronamraju (1):
      powerpc: Implement GET_IP/SET_IP

Stanislaw Gruszka (1):
      bsg: fix sysfs link remove warning

Stefano Stabellini (1):
      xen pvhvm: do not remap pirqs onto evtchns if !xen_have_vector_callback

Stephane Eranian (2):
      perf: Remove deprecated WARN_ON_ONCE()
      perf: Fix double start/stop in x86_pmu_start()

Stephane Grosjean (1):
      can: peak_pci: Fix the way channels are linked together

Stephen Boyd (2):
      ARM: 7321/1: cache-v7: Disable preemption when reading CCSIDR
      ARM: 7322/1: Print BUG instead of undefined instruction on BUG_ON()

Stephen Hemminger (1):
      ixgbe: make ethtool strings table const

Stephen Rothwell (1):
      powerpc: Remove legacy iSeries from ppc64_defconfig

Sujit Reddy Thumma (1):
      mmc: core: Ensure clocks are always enabled before host interaction

Sylwester Nawrocki (3):
      ARM: SAMSUNG: Fix platform data setup for I2C adapter 0
      ARM: EXYNOS: Correct framebuffer window size on Nuri board
      ARM: EXYNOS: Correct M-5MOLS sensor clock frequency on Universal
C210 board

Takashi Iwai (3):
      ALSA: hda - Fix mute-LED VREF value for new HP laptops
      ALSA: hda - Fix initialization of secondary capture source on VT1705
      ALSA: hda - Fix silent speaker output on Acer Aspire 6935

Tejun Heo (4):
      block: strip out locking optimization in put_io_context()
      block: separate out blk_rq_merge_ok() and blk_try_merge() from
elevator functions
      block: don't call elevator callbacks for plug merges
      block: fix lockdep warning on io_context release put_io_context()

Thadeu Lima de Souza Cascardo (3):
      mlx4: allow device removal by fixing dma unmap size
      mlx4: fix DMA mapping leak when allocation fails
      powerpc/pseries/eeh: Fix crash when error happens during device probe

Thomas Abraham (1):
      ARM: EXYNOS: Add cpu-offset property in gic device tree node

Thomas Graf (2):
      net: Don't proxy arp respond if iif == rt->dst.dev if private
VLAN is disabled
      veth: Enforce minimum size of VETH_INFO_PEER

Thomas Tuttle (2):
      USB: qcserial: add several new serial devices
      USB: qcserial: don't enable autosuspend

Tim Gardner (1):
      ipheth: Add iPhone 4S

Timo Juhani Lindfors (1):
      usb: gadget: zero: fix bug in loopback autoresume handling

Tomas Vanek (1):
      zd1211rw: firmware needs duration_id set to zero for non-pspoll frames

Tyler Hicks (2):
      eCryptfs: Improve statfs reporting
      eCryptfs: Copy up lower inode attrs after setting lower xattr

Vaidyanathan Srinivasan (1):
      PCI: set pci sriov page size before reading SRIOV BAR

Vivek Goyal (2):
      floppy: Cleanup disk->queue before caling put_disk() if
add_disk() was never called
      floppy: Fix a crash during rmmod

Wei Yongjun (2):
      net/hyperv: rx_bytes should account the ether header size
      net/hyperv: fix the issue that large packets be dropped under bridge

Wolfgang Grandegger (3):
      can: flexcan: fix irq flooding by clearing all interrupt sources
      can: cc770: store echo skb before starting the transfer
      can: ti_hecc: use netif_rx in the interrupt

Wolfgang Zarre (1):
      can: cc770: Fix indirect access deadlock on ISA cards

Wu Fengguang (3):
      writeback: fix NULL bdi->dev in trace writeback_single_inode
      lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit kernel
      writeback: fix dereferencing NULL bdi->dev on trace_writeback_queue

Xi Wang (1):
      can: pch_can: fix error passive level test

Yi Zou (1):
      ixgbe: do not update real num queues when netdev is going away

Yinghai Lu (4):
      drivers/base/memory.c: fix memory_dev_init() long delay
      ACPI: remove duplicated lines of merging problems with acpi_processor_add
      PCI: workaround hard-wired bus number V2
      PCI: Fix pci cardbus removal

Yoshihiro Shimoda (1):
      net: sh_eth: fix skb_over_panic happen

majianpeng (1):
      powerpc/adb: Use set_current_state()

sjur.brandeland@stericsson.com (1):
      caif: Bugfix list_del_rcu race in cfmuxl_ctrlcmd.

stephen hemminger (1):
      Revert "skge: check for PCI dma mapping errors"
