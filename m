Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2HPWMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:12:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41431 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933359Ab2HPWMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:12:38 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Aug 2012 15:12:16 -0700
X-Google-Sender-Auth: 4iV0vEjFZu86k2WThF4We4sm8eo
Message-ID: <CA+55aFzDpQmE1n__kaW4unfuzhPstKzp41GseL_AwuE-8_bAig@mail.gmail.com>
Subject: Linux 3.6-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, due to travels, the -rc2 release was two weeks instead of the
usual one. But it's out there now.

Also, for the same reason, I rather aggressively ignored pull requests
that looked unnecessarily big and scary, and made me go "Hmm, this
should have been ready for the merge window". So if you sent me a pull
request, and it didn't get merged, ask yourself whether the pull
request looked big and complicated. You can try to re-submit it, but I
would suggest you have some really *good* explanations of why it
should be merged outside the merge window if it isn't clearly just
critical fixes. And if it really *is* just critical fixes, but is very
large despite that, explain so - and why.

Anyway, with all that said, things don't seem too bad. Yes, I ignored
a few pull requests, but I have to say that there weren't all that
many of those, and the rest looked pretty calm. Sure, there's 330+
commits in there, but considering that it's been two weeks, that's
about expected (or even a bit low) for early -rc's. Yes, 3.5 may have
been much less for -rc2, but that was unusual.

The diffstat looks pretty flat, apart from the tcm_vhost part (which
was pending from the merge window). That is also a fairly good sign -
although probably also a sign of my aggressive "no, I won't pull that
outside of the merge window" policy. Anyway, a flat diffstat means
that there weren't huge changes anywhere, just fairly small fixes all
over. The most noticeable areas of change (again, with the exception
of tcm_vhost) are the GPU/DRM updates and the tools/perf updates. But
there are smaller changes pretty much all over.

Shortlog appended, scanning it gives a reasonable feel for the kinds
of things that have happened,

                        Linus

---

Aaro Koskinen (2):
      ARM: dma-mapping: fix atomic allocation alignment
      ARM: dma-mapping: fix incorrect freeing of atomic allocations

Al Viro (1):
      missed mnt_drop_write() in do_dentry_open()

Alan Cox (5):
      x86, nops: Missing break resulting in incorrect selection on Intel
      vlv: it might be wise if we initialised the flag value...
      i915: fix error path leak in intel_sdvo_write_cmd
      i915: Remove silly test
      gpio-sch: Fix leak of resource

Alex Deucher (9):
      drm/radeon: fix handling for ddc type 5 on combios
      drm/radeon/dce4+: set a more reasonable cursor watermark
      drm/radeon: properly handle SS overrides on TN (v2)
      drm/radeon: properly handle crtc powergating
      drm/radeon: fix bank tiling parameters on evergreen
      drm/radeon: fix bank tiling parameters on cayman
      drm/radeon: fix ordering in pll picking on dce4+
      drm/radeon: add some new SI pci ids
      drm/radeon: fix some missing parens in asic macros

Alex Shi (1):
      sched/numa: Add SD_PERFER_SIBLING to CPU domain

Alex Williamson (3):
      iommu/intel: Fix ACS path checking
      iommu/amd: Fix ACS path checking
      vfio: Include vfio.h in installed headers

Alexander Block (1):
      Btrfs: remove mnt_want_write call in btrfs_mksubvol

Alexander Duyck (1):
      igb: Fix register defines for all non-82575 hardware

Alexey Khoroshilov (2):
      net/core: Fix potential memory leak in dev_set_alias()
      drm/edid: Fix potential memory leak in edid_load()

Amir Vadai (1):
      net/mlx4_en: loopbacked packets are dropped when SMAC=DMAC

Andreas Schwab (1):
      m68k: Make sys_atomic_cmpxchg_32 work on classic m68k

Andrew Morton (1):
      perf/x86/intel/uncore: Make UNCORE_PMU_HRTIMER_INTERVAL 64-bit

Andrew Vagin (1):
      perf/trace: Add ability to set a target task for events

Anton Vorontsov (1):
      kernel/debug: Make use of KGDB_REASON_NMI

Arnaldo Carvalho de Melo (7):
      perf evsel: Precalculate the sample size
      perf session: Use perf_evlist__sample_type more extensively
      perf session: Use perf_evlist__sample_id_all more extensively
      perf session: Use perf_evlist__id_hdr_size more extensively
      perf evlist: Introduce perf_evlist__parse_sample
      perf evsel: Adopt parse_sample method from perf_event
      perf session: Remove no longer used synthesize_sample method

Arnaud Patard (1):
      ixp4xx_eth: fix ptp_ixp46x build failure

Arnd Bergmann (18):
      mfd/asic3: fix asic3_mfd_probe return value
      usb/ohci-omap: remove unused variable
      net/stmmac: mark probe function as __devinit
      ARM: pxa: remove irq_to_gpio from ezx-pcap driver
      Input: eeti_ts: pass gpio value instead of IRQ
      ARM: sa1100: include linux/io.h in hackkit leds code
      ARM: s3c24xx: use new PWM driver
      ARM: integrator: include <linux/export.h>
      ARM: imx: gpmi-nand depends on mxs-dma
      ARM: exynos: exynos_pm_add_dev_to_genpd may be unused
      gpio: em: do not discard em_gio_irq_domain_cleanup
      mtd/omap2: fix dmaengine_slave_config error handling
      spi/s3c64xx: improve error handling
      omap-rng: fix use of SIMPLE_DEV_PM_OPS
      ARM: s3c24xx: enable CONFIG_BUG for tct_hammer
      ARM: davinci: remove broken ntosd2_init_i2c
      leds: renesas: fix error handling
      GPIO: gpio-pxa: fix building without CONFIG_OF

Artem Bityutskiy (16):
      exofs: stop using s_dirt
      vfs: kill write_super and sync_supers
      Documentation: get rid of write_super
      Documentation: fix the VM knobs descritpion WRT pdflush
      ext3: nuke write_super from comments
      ext4: nuke write_super from comments
      ext4: nuke pdflush from comments
      btrfs: nuke write_super from comments
      btrfs: nuke pdflush from comments
      jbd/jbd2: nuke write_super from comments
      vfs: nuke pdflush from comments
      hfs: nuke write_super from comments
      nilfs2: nuke write_super from comments
      drbd: nuke pdflush from comments
      gfs2: nuke pdflush from comments
      UBIFS: nuke pdflush from comments

Avi Kivity (1):
      KVM: VMX: Fix ds/es corruption on i386 with preemption

Axel Lin (2):
      gpio: msic: Fix calculating register address in msic_gpio_to_oreg()
      leds: lp8788: Fix updating scale configuration bits

Ben Hutchings (3):
      net: Allow driver to limit number of GSO segments per skb
      sfc: Fix maximum number of TSO segments and minimum TX queue size
      tcp: Apply device TSO segment limit earlier

Ben Skeggs (2):
      drm/nve0/fifo: add support for the flip completion swmthd
      drm/nouveau/aux: mask off higher bits of auxch index in i2c table entry

Boaz Harrosh (3):
      exofs: Fix __r4w_get_page when offset is beyond i_size
      exofs: Use proper max_IO calculations from ore
      ore: Fix out-of-bounds access in _ios_obj()

Borislav Petkov (1):
      scripts/decodecode: Fixup trapping instruction marker

Brian Foster (3):
      fuse: add FUSE_AUTO_INVAL_DATA init flag
      fuse: invalidate inode mapping if mtime changes
      fuse: update attributes on aio_read

Bruce Rogers (1):
      KVM: x86: apply kvmclock offset to guest wall clock time

Carolyn Wyborny (1):
      igb: Fix for failure to init on some 82576 devices.

Catalin Marinas (1):
      time/jiffies: Allow CLOCK_TICK_RATE to be undefined

Chris Brand (1):
      ARM: mm: fix MMU mapping of CMA regions

Chris Wilson (2):
      drm/i915: Workaround hang with BSD and forcewake on SandyBridge
      drm/i915: Apply post-sync write for pipe control invalidates

Christian König (1):
      drm/radeon: fix bank tiling parameters on SI

Christoph Bumiller (1):
      drm/nvd0/disp: mask off high 16 bit of negative cursor x-coordinate

Colin Ian King (1):
      USB: echi-dbgp: increase the controller wait time to come out of halt.

Dan Williams (1):
      MAINTAINERS: update address for Dan Williams

Daniel Drake (3):
      libertas: don't reset card on error when it is being removed
      libertas: fix two memory leaks
      cfg80211: process pending events when unregistering net device

Daniel Mack (1):
      GPIO: gpio-pxa: fix devicetree functions

Daniel Vetter (4):
      drm/i915: fix forcewake related hangs on snb
      drm/i915: correctly order the ring init sequence
      drm/i915: ignore eDP bpc settings from vbt
      drm/i915: reorder edp disabling to fix ivb MacBook Air

Darren Hart (3):
      futex: Test for pi_mutex on fault in futex_wait_requeue_pi()
      futex: Fix bug in WARN_ON for NULL q.pi_state
      futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()

Dave Airlie (2):
      i915: don't map imported dma-bufs for dmar.
      drm/mgag200: fix G200ER pll picking algorithm

David Ahern (7):
      perf top: Error handling for counter creation should parallel perf-record
      perf tool: Save cmdline from user in file header vs what is
passed to record
      perf kvm: Use strtol for walking guestmount directory
      perf tools: Introducing rblist
      perf tools: Change strlist to use the new rblist
      perf tools: Introduce intlist
      perf kvm top: Limit guest kernel info message to once

David Henningsson (3):
      ALSA: hda - remove quirk for Dell Vostro 1015
      ALSA: hda - remove redundant auto quirks for conexant 506x
      ALSA: hda - Fix double quirk for Quanta FL1 / Lenovo Ideapad

David S. Miller (1):
      sparc64: Be less verbose during vmemmap population.

Denis Efremov (1):
      macvtap: rcu_dereference outside read-lock section

Devendra Naga (3):
      pinctrl/pinctrl-u300: remove unneeded devm_kfree call
      drm/i915: remove unused variable
      pinctrl-sirf: remove devm_kfree at error path

Dmitrii Cherkasov (1):
      drm/radeon: fix typo in function header comment

Dong Aisheng (4):
      ASoC: mxs-saif: fix clock prepare and enable unbalance issue
      ASoC: mxs-saif: set a base clock rate for EXTMASTER mode work
      ASoC: sgtl5000: remove unneeded snd_soc_dapm_new_widgets in probe
      ASoC: sgtl5000: enable VAG_POWER for LINE_IN

Eliad Peller (1):
      mac80211: don't clear sched_scan_sdata on sched scan stop request

Emil Tantilov (3):
      igb: fix panic while dumping packets on Tx hang with IOMMU
      e1000e: fix panic while dumping packets on Tx hang with IOMMU
      ixgbe: add missing braces

Eric Anholt (1):
      drm/i915: Don't forget to apply SNB PIPE_CONTROL GTT workaround.

Eric Dumazet (9):
      ipv4: route.c cleanup
      net: ipv6: fix TCP early demux
      net: fib: fix incorrect call_rcu_bh()
      net: force dst_default_metrics to const section
      tcp: must free metrics at net dismantle
      ipv4: tcp: unicast_sock should not land outside of TCP stack
      net: tcp: ipv6_mapped needs sk_rx_dst_set method
      ipv4: fix ip_send_skb()
      codel: refine one condition to avoid a nul rec_inv_sqrt

Fabio Baltieri (1):
      Revert "leds: use led_set_brightness in led_trigger_event"

Fabio Estevam (7):
      ASoC: mc13783: Provide codec->control_data
      dma: imx-dma: Fix kernel crash due to missing clock conversion
      ARM: dts: imx27-3ds.dts: Fix serial console node
      ARM: imx6q-sabrelite: Setup CLKO IOMUX
      ARM: mx23: Fix registers range
      ARM: mx28: Fix registers range
      ARM: clk-imx31: Fix the keypad clock name

Fan Du (1):
      Fix unexpected SA hard expiration after changing date

Felix Kaechele (1):
      ALSA: hda - add dock support for Thinkpad X230

Feng Tang (1):
      ACPI processor: Fix tick_broadcast_mask online/offline regression

Gao feng (1):
      pptp: lookup route with the proper net namespace

Geert Uytterhoeven (14):
      m68k: Use Kbuild logic to import asm-generic headers
      m68k: Use asm-generic version of <asm/types.h>
      m68knommu: Clean up printing of sections
      m68k: Remove duplicate FPU config option
      m68k: Move CPU_HAS_* config options
      m68k: delay, muldi3 - Use CONFIG_CPU_HAS_NO_MULDIV64
      m68k: Introduce config option CPU_HAS_NO_UNALIGNED
      m68k: CPU32 does not support unaligned accesses
      mtd/uclinux: Use generic __bss_stop instead of _ebss
      m68k: Replace m68k-specific _[se]bss by generic __bss_{start,stop}
      m68k: Use asm-generic version of <asm/sections.h>
      m68k/sun3: Remove unselectable code in prom_init()
      zorro: Remove unused zorro_bus.devices
      m68k/apollo: Rename "timer" to "apollo_timer"

Gleb Natapov (1):
      KVM: PIC: call ack notifiers for irqs that are dropped form irr

Greg Ungerer (1):
      m68knommu: Allow ColdFire CPUs to use unaligned accesses

Guillaume Gardet (1):
      ASoC: omap: Add missing modules aliases to get sound working on
omap devices

H. Peter Anvin (1):
      x86-64, kcmp: The kcmp system call can be common

Haiyang Zhang (1):
      hyperv: Move wait completion msg code into rndis_filter_halt_device()

Heiko Carstens (4):
      s390/mm: remove MAX_PHYSADDR_BITS define
      s390/seccomp: add support for system call filtering using BPF
      s390/compat: fix compat wrappers for process_vm system calls
      s390/compat: fix mmap compat system calls

Henrik Rydberg (1):
      drm/nouveau: disable copy engine on NVAF

Hiroaki SHIMODA (2):
      net_sched: gact: Fix potential panic in tcf_gact().
      net_sched: act: Delete estimator in error path.

Hiroshi Doyu (2):
      iommu/tegra: smmu: Cleanup with lesser nest
      iommu/tegra: smmu: Fix error initial value at domain_init

Hunt Xu (1):
      drm/i915: make rc6 in sysfs functions conditional

Ian Kent (1):
      autofs4 - fix get_next_positive_subdir()

Ingo Molnar (1):
      time: Fix adjustment cleanup bug in timekeeping_adjust()

Jani Nikula (1):
      drm/i915: ensure i2c adapter is all set before adding it

Jason Wessel (2):
      kdb: Remove unused KDB_FLAG_ONLY_DO_DUMP
      kdb: Remove cpu from the more prompt

Javier Martin (1):
      i.MX27: Fix emma-prp and csi clocks.

Jean Delvare (1):
      x86: CONFIG_CC_STACKPROTECTOR=y is no longer experimental

Jeff Mahoney (1):
      printk: Fix calculation of length used to discard records

Jerome Glisse (2):
      drm/radeon: do not reenable crtc after moving vram start address
      drm/radeon: fence virtual address and free it once idle v4

Jesper Juhl (5):
      bnx2x: fix mem leak when command is unknown
      igb: correct hardware type (i210/i211) check in igb_loopback_test()
      igb: don't break user visible strings over multiple lines in igb_ethtool.c
      batman-adv: Fix mem leak in the batadv_tt_local_event() function
      cdc-phonet: Don't leak in usbpn_open

Jiri Kosina (2):
      sparc64: do not clobber personality flags in sys_sparc64_personality()
      s390: do not clobber personality flags in sys_32_personality()

Jiri Olsa (2):
      perf test: Fix parse events automated tests
      perf symbols: Fix array sizes for binary types arrays

Joerg Roedel (2):
      iommu: Add missing forward declaration in include file
      iommu/amd: Fix pci_request_acs() call-place

Johannes Berg (4):
      mac80211: fix scan_sdata assignment
      mac80211: clear timer bits when disconnecting
      mac80211: cancel mesh path timer
      iwlwifi: disable greenfield transmissions as a workaround

John Stultz (5):
      time: Fix casting issue in tk_set_xtime and tk_xtime_add
      time/jiffies: Rename ACTHZ to SHIFTED_HZ
      time: Clean up stray newlines
      time: Clean up offs_real/wall_to_mono and
offs_boot/total_sleep_time updates
      time: Remove all direct references to timekeeper

Joren Van Onder (1):
      bnx2x: Fix compiler warnings

Julia Lawall (8):
      arch/x86/kernel/kdebugfs.c: Ensure a consistent return value in error case
      iommu/tegra: remove invalid reference to list iterator variable
      iommu/intel: add missing free_domain_mem
      drivers/net/phy/mdio-mux-gpio.c: drop devm_kfree of devm_kzalloc'd data
      drivers/atm/iphase.c: fix error return code
      drivers/gpio/gpio-langwell.c: fix error return code
      drivers/pinctrl/pinctrl-nomadik.c: drop devm_kfree of devm_kzalloc'd data
      drivers/cpufreq/pcc-cpufreq.c: fix error return code

Karsten Keil (1):
      mISDN: Bugfix for layer2 fixed TEI mode

Kautuk Consul (1):
      exofs: readpage_strip: Add a BUG_ON to check for PageLocked(page)

Kees Cook (1):
      Yama: higher restrictions should block PTRACE_TRACEME

Konrad Rzeszutek Wilk (1):
      xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back.

Laxman Dewangan (1):
      dma: tegra: enable/disable dma clock

Lee Jones (2):
      ASoC: ux500: Include the correct header files
      ASoC: ab8500: Inform SoC Core that we have our own I/O arrangements

Len Brown (3):
      ACPI: replace strlen("string") with sizeof("string") -1
      ACPI/x86: revert 'x86, acpi: Call acpi_enter_sleep_state via an
asmlinkage C function from assembler'
      ACPI: delete _GTS/_BFS support

Linus Torvalds (1):
      Linux 3.6-rc2

Linus Walleij (2):
      MAINTAINERS: update entry for Linus Walleij
      ARM: integrator: use clk_prepare_enable() for timer

Maarten Lankhorst (1):
      nouveau: fixup scanout enable in nvc0_pm

Manuel Lauss (1):
      ASoC: AC97 doesn't use regmap by default

Marc Kleine-Budde (1):
      ARM: mxs: always build ocotp

Marek Lindner (1):
      batman-adv: select an internet gateway if none was chosen

Marek Olšák (4):
      drm/radeon/kms: allow "invalid" DB formats as a means to disable DB
      drm/radeon/kms: reorder code in r600_check_texture_resource
      drm/radeon/kms: add MSAA texture support for r600-evergreen
      drm/radeon/kms: implement timestamp userspace query (v2)

Marek Vasut (1):
      ARM: mxs: Remove MMAP_MIN_ADDR setting from mxs_defconfig

Mark Brown (4):
      ASoC: wm8994: Ensure there are enough BCLKs for four channels
      ASoC: wm8994: Hold runtime PM reference while handling mic and jack IRQs
      ASoC: wm8962: Allow VMID time to fully ramp
      ASoC: core: Fix check before defaulting to regmap

Masanari Iida (1):
      emulex: benet: Add a missing CR in the end of message

Maxim Levitsky (1):
      drm/nv86/fifo: suspend fix

Michael Holzheu (1):
      s390/sclp_sdias: Add missing break and "fall through"

Michael Wang (1):
      sched/cleanups: Add load balance cpumask pointer to 'struct lb_env'

Mike Frysinger (1):
      sh: dma: fix request_irq usage

Miklos Szeredi (2):
      fuse: add missing INIT flags
      fuse: add missing INIT flag descriptions

Mohammed Shafi Shajakhan (1):
      ath9k: Add PID/VID support for AR1111

Namhyung Kim (2):
      sched: Use task_rq_unlock() in __sched_setscheduler()
      perf target: Fix check on buffer size

NeilBrown (1):
      RTC: Avoid races between RTC alarm wakeup and suspend.

Nicholas Bellinger (1):
      tcm_vhost: Initial merge for vhost level target fabric driver

Oliver Hartkopp (1):
      canfd: remove redundant CAN FD flag

Palmer Cox (1):
      perf tools: Remove brace expansion from clean target

Paolo Valente (1):
      sched: add missing group change to qfq_change_class

Patrice Chotard (1):
      pinctrl/nomadik: fix hsi function group list

Paul Bolle (2):
      m68k: Remove five unused headers
      m68k: Remove never used asm/shm.h

Paul Mundt (1):
      sh: intc: Handle domain association for sparseirq pre-allocated vectors.

Paul Stewart (1):
      cfg80211: Clear "beacon_found" on regulatory restore

Paulo Zanoni (1):
      drm/i915: add more Haswell PCI IDs

Peter Meiser (1):
      cdc-ncm: tag Ericsson WWAN devices (eg F5521gw) with FLAG_WWAN

Peter Zijlstra (1):
      perf/x86: Fix USER/KERNEL tagging of samples properly

Phil Edworthy (1):
      sh: sh7269: Fix LCD pinmux

Philipp A. Mohrenweiser (1):
      ALSA: hda - add dock support for Thinkpad T430s

Rafael J. Wysocki (7):
      ACPI / PM: Fix build warning in sleep.c for CONFIG_ACPI_SLEEP unset
      ACPI / PCI: Do not try to acquire _OSC control if that is hopeless
      PM: Make dev_pm_get_subsys_data() always return 0 on success
      Revert "NMI watchdog: fix for lockup detector breakage on resume"
      ACPI / PM: Fix unused function warnings for CONFIG_PM_SLEEP
      platform / x86 / PM: Fix unused function warnings for CONFIG_PM_SLEEP
      tpm_tis / PM: Fix unused function warning for CONFIG_PM_SLEEP

Rafał Miłecki (2):
      bcma: BCM43228 support
      b43: fix logic in GPIO init

Randy Dunlap (1):
      cris: fix eth_v10.c build error

Roland Stigge (2):
      sound: tegra_wm8903: Adjust to of_get_named_gpio() change
      sound: tegra_alc5632: Adjust to of_get_named_gpio() change

Sachin Kamat (1):
      iommu/exynos: Fix build error

Sean Paul (1):
      gpio: samsung: Fix off-by-one bug in gpio addresses

Sebastian Hesselbarth (1):
      ARM: kirkwood: fix typo in Makefile.boot

Seth Forshee (2):
      cfg80211: add channel flag to prohibit OFDM operation
      brcmsmac: use channel flags to restrict OFDM

Shawn Guo (7):
      ARM: imx: enable emi_slow_gate clock for imx5
      ARM: dts: imx53-ard: add regulators for lan9220
      ARM: dts: imx: fix gpio interrupts property
      pinctrl: mxs: register driver at postcore_initcall time
      gpio/mxc: remove redundant shadow variables initialization
      gpio/mxc: specify gpio base for device tree probe
      ARM: dts: imx: add alias for gpio

Silviu-Mihai Popescu (1):
      tcp_output: fix sparse warning for tcp_wfree

Sonic Zhang (1):
      drivers: net: irda: bfin_sir: fix compile error

Sorin Dumitru (1):
      llc: free the right skb

Srivatsa S. Bhat (1):
      sched: Fix comment about PREEMPT_ACTIVE bit location

Stanislav Kinsbursky (1):
      tun: don't zeroize sock->file on detach

Stanislaw Gruszka (2):
      wireless: reg: restore previous behaviour of chan->max_power calculations
      rt61pci: fix NULL pointer dereference in config_lna_gain

Stefan Assmann (1):
      igb: add delay to allow igb loopback test to succeed on 8086:10c9

Stephen Warren (1):
      ARM: tegra: more regulator fixes for Harmony

Stéphane Marchesin (1):
      drm/i915: Make intel_panel_get_backlight static.

Takashi Iwai (6):
      ALSA: hda - Support dock on Lenovo Thinkpad T530 with ALC269VC
      ALSA: PCM: Fix possible memory leaks in the error path
      ALSA: emu10k1: Avoid access to invalid pages when period=1
      ALSA: hda - Fix regression of HDMI codec probing
      ALSA: hda - Fix ugly debug prints with CONFIG_SND_VERBOSE_PRINTK=y
      drm/i915: Fix blank panel at reopening lid

Thierry Reding (1):
      iommu: Include linux/types.h

Thomas Gleixner (1):
      genirq: Allow irq chips to mark themself oneshot safe

Thomas Meyer (2):
      net: Use PTR_RET rather than if(IS_ERR(.. [1]
      drm/udl: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(.. [1]

Thomas Renninger (2):
      ACPI: Untangle a return statement for better readability
      ACPI: Only count valid srat memory structures

Tomoki Sekiyama (1):
      x86/ioapic: Fix NULL pointer dereference on CPU hotplug after
disabling irqs

Tony Luck (2):
      x86/mce: Move MCACOD defines from mce-severity.c to <asm/mce.h>
      x86/mce: Add quirk for instruction recovery on Sandy Bridge processors

Tushar Dave (2):
      e1000e: NIC goes up and immediately goes down
      e1000e: 82571 Tx Data Corruption during Tx hang recovery

Uwe Kleine-König (1):
      MAINTAINERS: fix a few pinctrl related entries

Vasiliy Kulikov (1):
      ip: fix error handling in ip_finish_output2()

Woody Hung (1):
      rt2x00 : fix rt3290 resuming failed.

Wu Fengguang (1):
      isdnloop: fix and simplify isdnloop_init()

Yevgeny Petrilin (2):
      net/mlx4_en: Fixing TX queue stop/wake flow
      net/mlx4_core: Remove port type restrictions

Ying Xue (2):
      sched: Fix minor code style issues
      af_packet: Quiet sparse noise about using plain integer as NULL pointer

Yuval Mintz (2):
      bnx2x: fix unload previous driver flow when flr-capable
      bnx2x: Fix recovery flow cleanup during probe

Zach Brown (1):
      fuse: verify all ioctl retry iov elements

danborkmann@iogearbox.net (1):
      af_packet: remove BUG statement in tpacket_destruct_skb

stigge@antcom.de (1):
      lpc_eth: remove obsolete ifdefs
