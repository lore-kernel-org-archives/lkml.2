Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1DFCAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 22:00:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090Ab1DFCAe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 22:00:34 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Apr 2011 19:00:12 -0700
Message-ID: <BANLkTinJZB145o9_g4o=5pFUX39P0tpv-g@mail.gmail.com>
Subject: Linux 2.6.39-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been an uncommonly calm -rc2, which should make me really happy,
but quite honestly just makes me really suspicious.

You guys are up to something, aren't you?

Anyway, 35% arch (ARM and power, some unicore32 cleanups), 35% drivers
(net, input and some drm), and 30% random (doc updates, perf, net,
btrfs). Because it's such a small -rc, I'm appending the shortlog,
something I usually don't get to do until -rc3 or -rc4.

This should hopefully fix up the most annoying -rc1 problems. We had a
couple, like the plugging issues with the IDE layer, causing some
machines to not boot. Or the tty-full-and-hung one. And just the small
fallout from the irq cleanups (which affected a couple of less common
platforms).

But on the whole really not a lot. Which is sincerely _hope_ is a sign
that 2.6.39 is going to be a simple release.

Knock wood. Go out and test,

                          Linus

---

Alex Deucher (3):
      drm/radeon/kms: Add support for tv-out dongle on G5 9600
      drm/radeon/kms: pageflipping cleanup for avivo+
      drm/radeon/kms: add some new ontario pci ids

Alexander Clouter (1):
      ARM: orion5x: replace printk with pr_{err,info,...} in ts78xx-setup.c

Andi Kleen (1):
      oprofile, x86: Allow setting EDGE/INV/CMASK for counter events

Andreas Schwab (1):
      blk-throttle: don't call xchg on bool

Andrei Emeltchenko (1):
      Bluetooth: delete hanging L2CAP channel

Andres Salomon (1):
      ARM: mx51_efika: update platform data for new mfd changes

Andrew Lutomirski (1):
      perf symbols: Fix vsyscall symbol lookup

Andrzej Zaborowski (1):
      net/usb: Ethernet quirks for the LG-VL600 4G modem

Anton Blanchard (3):
      powerpc: Fix accounting of softirq time when idle
      powerpc/pseries: Enable Chelsio network and iWARP drivers
      kdump: Allow shrinking of kdump region to be overridden

Antonio Ospite (1):
      Documentation: consolidate leds files to leds/ subdir

Arnaldo Carvalho de Melo (1):
      perf tools: Fixup exit path when not able to open events

Arnd Bergmann (1):
      usbnet: use eth%d name for known ethernet devices

Axel Lin (5):
      ARM: pxa/am200epd: fix leak in am200_init_gpio_regs error path
      ARM: pxa/am300epd: fix leak in am300_init_gpio_regs error path
      ASoC: twl6040: Return -ENOMEM if create_singlethread_workqueue fails
      hwmon: twl4030-madc-hwmon: add "platform:" prefix for platform modalias
      Input: rpckbd - fix a leak of the IRQ during init failure

Balaji G (1):
      bridge: Fix compilation warning in function br_stp_recalculate_bridge_id()

Ben Hutchings (2):
      via-ircc: Use pci_{get, set}_drvdata() instead of static pointer variable
      via-ircc: Pass PCI device pointer to dma_{alloc, free}_coherent()

Ben Skeggs (1):
      drm: export drm_find_cea_extension to drivers

Benjamin Herrenschmidt (23):
      powerpc: Implement dma_mmap_coherent()
      powerpc/mm: Move the STAB0 location to 0x8000 to make room in low memory
      powerpc/8xx: Fix another breakage from the irq_data conversion
      powerpc/qe_ic: Fix another breakage from the irq_data conversion
      powerpc: Make decrementer interrupt robust against offlined CPUs
      powerpc/smp: soft-replugged CPUs must go back to start_secondary
      powerpc/smp: Fix generic_mach_cpu_die()
      powerpc/smp: Remove unused generic_cpu_enable()
      powerpc/smp: Remove unused smp_ops->cpu_enable()
      powerpc/pmac/smp: Fix 32-bit PowerMac cpu_die
      powerpc/pmac/smp: Rename fixup_irqs() to migrate_irqs() and use
it on ppc32
      powerpc/pmac/smp: Fixup smp_core99_cpu_disable() and use it on 64-bit
      powerpc/pmac/smp: Consolidate 32-bit and 64-bit PowerMac cpu_die
in one file
      powerpc/pmac/smp: Remove HMT changes for PowerMac offline code
      powerpc/pmac/smp: Properly NAP offlined CPU on G5
      powerpc/pmac: Rename cpu_state in therm_pm72 to avoid collision
      powerpc/smp: Add a smp_ops->bringup_up() done callback
      powerpc/pmac/smp: Fix CPU hotplug crashes on some machines
      powerpc/smp: Don't expose per-cpu "cpu_state" array
      powerpc/smp: Create idle threads on demand and properly reset them
      powerpc/smp: Increase vdso_data->processorCount, not just decrease it
      powerpc/pmac/smp: Remove no-longer needed preempt workaround
      powerpc/pseries: Don't register global initcall

Boris Ostrovsky (1):
      ipv6: Don't pass invalid dst_entry pointer to dst_release().

Borislav Petkov (2):
      x86, amd-nb: Rename CPU PCI id define for F4
      sched, doc: Beef up load balancing description

Chris Wilson (5):
      drm/i915/lvds: Always return connected in the absence of better
information
      drm/i915: Busy-spin wait_for condition in atomic contexts
      drm/i915: Reset GMBUS controller after NAK
      drm/i915/crt: Remove 0xa0 probe for VGA
      drm/i915/lvds: Remove 0xa0 DDC probe for LVDS

Christian Lamparter (1):
      carl9170: Fix tx aggregation problems with some clients

Christoph Hellwig (1):
      ufs: remove unessecary blk_flush_plug

Clemens Ladisch (2):
      ALSA: firewire-speakers: fix hang when unplugging a running device
      ALSA: ens1371: fix Creative Ectiva support

Cliff Wickman (1):
      x86, UV: Fix kdump reboot

Colin Cross (1):
      ARM: 6837/1: remove unused pci_fixup_prpmc1100

Dan Carpenter (1):
      ceph: unlock on error in ceph_osdc_start_request()

Daniel Baluta (2):
      Documentation: update kmemleak arch. info
      kemleak-test: build as module only

Daniel Halperin (1):
      mac80211: fix aggregation frame release during timeout

Daniel Hellstrom (2):
      sparc32, leon: APBUART driver must use archdata to get IRQ number
      sparc32,leon: Fixed APBUART frequency detection

Daniel Lezcano (1):
      netdev: fix mtu check when TSO is enabled

Dario Faggioli (1):
      sched: Leave sched_setscheduler() earlier if possible, do not
disturb SCHED_FIFO tasks

David Ahern (1):
      perf tools: Emit clearer message for sys_perf_event_open ENOENT return

David Henningsson (1):
      ALSA: HDA: Add dock mic quirk for Lenovo Thinkpad X220

David S. Miller (7):
      perf symbols: Properly align symbol_conf.priv_size
      sparc: Hook up syncfs system call.
      net: Fix warnings caused by MAX_SKB_FRAGS change.
      sparc64: Fix section mis-match errors.
      sctp: Pass __GFP_NOWARN to hash table allocation attempts.
      apbuart: Depend upon sparc.
      appletalk: Fix OOPS in atalk_release().

Dinh Nguyen (3):
      ARM: mx50: Add support to get the silicon revision
      ARM: mx51: Add entry for gpc_dvfs_clk
      ARM: mx51: Implement code to allow mx51 to enter WFI

Dmitry Eremin-Solenikov (5):
      ARM: pxa/eseries: switch to using gpio-vbus transceiver
      ARM: pxa/gumstix: switch to using gpio-vbus transceiver
      ARM: pxa/tosa: switch to using gpio-vbus transceiver
      ARM: pxa25x_udc: stop handling gpio-vbus internally
      ARM: pxa: drop gpio_vbus field from pxa2xx_udc_mach_info

Eric Bénard (4):
      mx3/eukrea_mbimxsd-baseboard: fix gpio request
      mx3/eukrea_mbimxsd-baseboard: add SD card detect support
      eukrea_mbimxsd25-baseboard: add SD card detect
      eukrea_mbimxsd51: add SD Card detect

Eric Dumazet (1):
      fib: add rtnl locking in ip_fib_net_exit

Eric Paris (1):
      inotify: fix double free/corruption of stuct user

FUJITA Tomonori (1):
      starfire: clean up dma_addr_t size test

Fabio Estevam (4):
      ARM: mx51: Print silicon revision on boot
      ARM: mx5/babbage: Use gpio_request_one in babbage_fec_reset
      ARM: mx5/mx53_evk: Use gpio_request_one in mx53_evk_fec_reset
      ARM: mx5/mx53_evk: Make the reset pin name more meaningful

Felix Fietkau (2):
      mac80211: fix a crash in minstrel_ht in HT mode with no
supported MCS rates
      ath9k: fix a chip wakeup related crash in ath9k_start

Frank Li (1):
      ARM: mx53_loco: Add GPIO Keypad support

Frederic Weisbecker (2):
      perf: Rebase max unprivileged mlock threshold on top of page size
      perf: mmap 512 kiB by default

Geunsik Lim (1):
      Documentation: update cgroups info user groups names

Grant Likely (1):
      arm: versatile : Fix typo introduced in irq namespace cleanup

Guan Xuetao (4):
      unicore32 ldscript fix: add cacheline parameter to PERCPU() macro
      unicore32 fix: remove arch-specific futex support
      unicore32 rtc driver fix: cleanup irq_set_freq and irq_set_state
      unicore32 framebuffer fix: get videomemory by __get_free_pages()
and make it floatable

Gustavo F. Padovan (1):
      Bluetooth: Fix HCI_RESET command synchronization

Haojian Zhuang (1):
      ARM: pxa: auto compute shift and mult of timer

Huang Weiyi (2):
      ARM i.MX: remove duplicated #include
      unicore32 core architecture: remove duplicated #include

Ilpo Järvinen (1):
      tcp: len check is unnecessarily devastating, change to WARN_ON

Ingo Molnar (1):
      sound: Add delay.h to sound/soc/codecs/sn95031.c

Jan Beulich (1):
      Input: synaptics - fix crash in synaptics_module_init()

Jan Engelhardt (1):
      drm: fix "persistant" typo

Jan Weitzel (2):
      ARM: mxc: Add dummy_get_cycles to avoid access before init is done
      ARM: mxc: Add sched_clock to mxc platform

Jean Delvare (1):
      x86: Stop including <linux/delay.h> in two asm header files

Jens Axboe (6):
      block: dump request state on seeing a corrupted request completion
      block: get rid of elv_insert() interface
      block: make the flush insertion use the tail of the dispatch list
      ide: ide_requeue_and_plug() reinstate "always plug" behaviour
      fs: export empty_aops
      ide: always ensure that blk_delay_queue() is called if we have pending IO

Jesper Juhl (1):
      Atheros, atl2: Fix mem leaks in error paths of atl2_set_eeprom

Jim Keniston (1):
      powerpc/nvram: Don't overwrite oops/panic report on normal shutdown

Joe Perches (1):
      Blackfin: use more standard pr_fmt in the module loader

Johan Hedberg (1):
      Bluetooth: Fix missing hci_dev_lock_bh in user_confirm_reply

Johann Lombardi (1):
      Btrfs: fix subvol_sem leak in btrfs_rename()

Johannes Berg (1):
      iwlegacy: fix bugs in change_interface

John Lindgren (1):
      drm/radeon/kms: add some sanity checks to obj info record parsingi (v2)

Josef Bacik (2):
      Btrfs: fix free space cache when there are pinned extents and clusters V2
      Btrfs: don't warn in btrfs_add_orphan

Julien Boibessot (2):
      MX51: Add AUDMUX ports definitions
      mx2/iomux: Set direction for CSPI2 pins

Juuso Oikarinen (1):
      cfg80211: fix BSS double-unlinking (continued)

Kelly Anderson (1):
      ALSA: pcm: fix infinite loop in snd_pcm_update_hw_ptr0()

Konstantin Khlebnikov (1):
      block: fix request sorting at unplug

Konstantin Porotchkin (1):
      Fix the broken build for Marvell Dove platform.

Kumar Gala (1):
      edac/mpc85xx: Limit setting/clearing of HID1[RFXE] to e500v1/v2 cores

Li Zefan (2):
      Btrfs: Fix oops for defrag with compression turned on
      Btrfs: Fix uninitialized root flags for subvolumes

Linus Lüssing (1):
      bridge: mcast snooping, fix length check of snooped MLDv1/2

Linus Torvalds (2):
      tty: fix endless work loop when the buffer fills up
      Linux 2.6.39-rc2

Lothar Waßmann (1):
      ARM: mxs: configure and register the second FEC device on TX28/STK5-V4

Major Lee (1):
      rtc-mrst: Fix section types

Manjunatha Halli (1):
      [media] radio: wl128x: Update registration process with ST

Manoj Iyer (1):
      Input: wacom - add support for Lenovo tablet ID (0xE6)

Marc Kleine-Budde (1):
      phylib: phy_attach_direct: phy_init_hw can fail, add cleanup

Marc-Antoine Perennou (1):
      Bluetooth: add support for Apple MacBook Pro 8,2

Marek Vasut (9):
      ARM: pxa: PalmTE2: Use gpio arrays in backlight init
      ARM: pxa: Use gpio arrays in colibri_pcmcia driver
      ARM: pxa: Use gpio arrays in palmld_pcmcia driver
      ARM: pxa: Use gpio arrays in palmtc_pcmcia driver
      ARM: pxa: Use gpio arrays in palmtx_pcmcia driver
      ARM: pxa: Use gpio arrays in vpac270_pcmcia driver
      ARM: pxa: Use gpio arrays in palmld_hdd driver
      ARM: pxa: Update copyright notices for Palm devices
      ARM: pxa: PalmZ72: Add OV9640 camera support

Mariusz Kozlowski (4):
      ceph: fix possible NULL pointer dereference
      mac80211: fix possible NULL pointer dereference
      cfg80211:: fix possible NULL pointer dereference
      mlx4: fix kfree on error path in new_steering_entry()

Mark Brown (2):
      ASoC: Explicitly say registerless widgets have no register
      ASoC: Fix CODEC device name for Corgi

Matt Evans (1):
      powerpc/pseries: Fix build without CONFIG_HOTPLUG_CPU

Miao Xie (1):
      btrfs: clear __GFP_FS flag in the space cache inode

Michal Simek (3):
      microblaze: Fix level/edge irq sensibility
      microblaze: Wire up new syscalls
      microblaze: Fix ftrace

Michał Mirosław (1):
      net: Fix dev dev_ethtool_get_rx_csum() for forced NETIF_F_RXCSUM

Mike Frysinger (2):
      Blackfin: defconfigs: update after misc devices defaulted to N
      Blackfin: bitops: fix include order after little endian inclusion

Mike Snitzer (1):
      dm: improve block integrity support

Milton Miller (3):
      powerpc/xics: Fix numberspace mismatch from irq_desc conversion
      powerpc/xics: Use hwirq for xics domain irq number
      powerpc/pseries/smp: query-cpu-stopped-state support won't change

Ming Lei (1):
      ARM: 6838/1: etm: fix section mismatch warning

Nicolas Kaiser (1):
      nilfs2: fix whitespace coding style issues

Nicolas Pitre (1):
      ARM: 6825/1: kernel/sleep.S: fix Thumb2 compilation issues

Patrick McHardy (1):
      connector: convert to synchronous netlink message processing

Paul Bolle (1):
      Input: i8042 - downgrade selftest error message to dbg()

Paul E. McKenney (1):
      rcu: create new rcu_access_index() and use in mce

Paul Gortmaker (1):
      powerpc/kexec: Fix mismatched ifdefs for PPC64/SMP.

Pawel Moll (1):
      ARM: 6807/1: realview: Fix secondary GIC initialisation for EB
with MPCore tile

Peter Hutterer (1):
      Input: uinput - allow for 0/0 min/max on absolute axes.

Peter Pan(潘卫平) (1):
      bonding:typo in comment

Peter Ujfalusi (2):
      ASoC: tlv320dac33: Fix inconsistent spinlock usage
      ASoC: tlv320dac33: Restore L/R DAC power control register

Peter Zijlstra (2):
      perf: Fix task context scheduling
      perf: Fix task_struct reference leak

Petr Štetiar (1):
      mac80211: fix NULL pointer dereference in ieee80211_key_alloc()

Philip A. Prindeville (3):
      atm/solos-pci: Use VPI.VCI notation uniformly.
      atm/solos-pci: Don't include frame pseudo-header on transmit hex-dump
      atm/solos-pci: Don't flap VCs when carrier state changes

Ping Cheng (2):
      Input: wacom - constify wacom_features for a new missed Bamboo models
      Input: wacom - report resolution for pen devices

Prabhakar Kushwaha (1):
      powerpc/85xx: Update dts for PCIe memory maps to match u-boot of Px020RDB

Rajeev Kumar (1):
      Input: spear-keyboard - fix inverted condition in interrupt handler

Randy Dunlap (5):
      [media] staging: altera-jtag needs delay.h
      usb/serial: fix function args warnings, dropping *filp
      kernel/signal.c: fix typos and coding style
      kernel/signal.c: add kernel-doc notation to syscalls
      Documentation: update panic parameter info

Richard Cochran (2):
      powerpc: qe_ic: Rename get_irq_desc_data and get_irq_desc_chip
      ntp: fix non privileged system time shifting

Robert Richter (1):
      perf tools: Fix NO_NEWT=1 python build error

Robin Becker (1):
      arm: mach-kirkwood: add led in sheevaplug-setup.c

Russell King - ARM Linux (1):
      ARM: pxa: clean up set_pxa_fb_info

Ryan Grimm (1):
      powerpc: Set nr_cpu_ids early and use it to free PACAs

Ryusuke Konishi (2):
      nilfs2: fix data loss in mmap page write for hole blocks
      nilfs2: fix oops due to a bad aops initialization

Sage Weil (2):
      ceph: flush msgr_wq during mds_client shutdown
      libceph: fix null dereference when unregistering linger requests

Scott Wood (1):
      powerpc: ARCH_PFN_OFFSET should be unsigned long

Seth Forshee (2):
      Input: sparse-keymap - report scancodes with key events
      Input: sparse-keymap - report KEY_UNKNOWN for unknown scan codes

Shawn Guo (4):
      ARM: mxc: fix buggy '.end' of IORESOURCE_MEM in device codes
      ARM: mxs: dynamically allocate mmc device
      ARM: mxs/mx23evk: add mmc device
      ARM: mxs/mx28evk: add mmc device

Sisir Koppaka (1):
      sched: Fix rebalance interval calculation

Stanislaw Gruszka (2):
      iwl3945: do not deprecate software scan
      iwl3945: disable hw scan by default

Stephen Boyd (1):
      ARM: 6826/1: Merge v6 and v7 DEBUG_LL DCC support

Stephen Rothwell (4):
      powerpc: Restore some misc devices to our configs
      powerpc: Wire up new syscalls
      genirq: fix CONFIG_IRQ_EDGE_EOI_HANDLER build
      powerpc/cell: fixup for removal of handle_iic_irq

Steven Rostedt (1):
      WARN_ON_SMP(): Add comment to explain ({0;})

Suraj Sumangala (1):
      Bluetooth: Increment unacked_frames count only the first transmit

Suresh Siddha (1):
      x86, mtrr, pat: Fix one cpu getting out of sync during resume

Sylvestre Ledru (2):
      Input: h3600_ts_input - fix a spelling error
      Documentation: fix minor typos/spelling

Takashi Iwai (1):
      ALSA: hda - Fix pin-config of Gigabyte mobo

Thomas Gleixner (10):
      Bluetooth: Fix warning with hci_cmd_timer
      genirq: Fix misnamed label in handle_edge_eoi_irq
      x86: apb_timer: Fixup genirq fallout
      sh: Fix irq cleanup fallout
      genirq: Remove now obsolete set_irq_wake()
      genirq: Remove obsolete comment
      sound: Fixup the last user of the old irq functions
      powerpc/cell: Use handle_edge_eoi_irq for real
      genirq: Remove the now obsolete config options and select statements
      avr32: Fix missing irq namespace conversion

Timo Teräs (1):
      net: gre: provide multicast mappings for ipv4 and ipv6

Tkhai Kirill (1):
      sparc32: Pass task_struct to schedule_tail() in ret_from_fork

Tommi Virtanen (3):
      ceph: Move secret key parsing earlier.
      libceph: Get secret from the kernel keys api when mounting with key=NAME.
      libceph: Create a new key type "ceph".

Tony Luck (2):
      [IA64] Fix build breakage - sn_force_interrupt_flag: undefined
      [IA64] fix build warning: argument 1 of 'irqd_irq_disabled'

Tsutomu Itoh (3):
      Btrfs: fix compiler warning in file.c
      Btrfs: fix /proc/mounts info.
      Btrfs: fix memory leak in btrfs_ioctl_start_sync()

Uwe Kleine-König (1):
      ARM: imx: let MACH_IMX27_VISSTRIM_M10 select IMX_HAVE_PLATFORM_IMX_SSI

Varun Sethi (1):
      powerpc/booke: Correct the SPRN_MAS5 definition.

Vasily Khoruzhick (10):
      ARM: pxafb: rework pxafb overlay memory management
      ARM: pxafb: fix plane Z-ordering problem
      ARM: pxafb: fix typo in ypos assignment
      ARM: pxafb: don't disable controller on cpufreq transition if
overlay in use
      ARM: PXA: Z2: Use only power button as wake source
      ARM: PXA: Z2: Fix battery pdata
      ARM: PXA: Z2: Fix libertas init/tear down sequences
      ARM: PXA: Z2: Keep kbd backlight disabled by default
      ARM: PXA: Z2: Add default triggers for LEDs
      ARM: PXA: Z2: Use switch event for lid

Viktor Rosendahl (1):
      ARM: 6836/1: kprobes/fix emulation of LDR/STR instruction when Rn == PC

Vinicius Costa Gomes (1):
      Bluetooth: Fix sending LE data over USB

Wei Yongjun (2):
      sctp: fix auth_hmacs field's length of struct sctp_cookie
      sctp: malloc enough room for asconf-ack chunk

Will Deacon (3):
      ARM: 6833/1: perf: add required isbs() to ARMv7 backend
      ARM: 6834/1: perf: reset counters on all CPUs during initialisation
      ARM: 6835/1: perf: ensure overflows aren't missed due to IRQ latency

Wolfram Sang (3):
      arm: mach-mx3: pcm043: add write-protect and card-detect for SD1
      ASoC: imx: set watermarks for mx2-dma
      ASoC: imx: fix burstsize for DMA

Xiaotian Feng (1):
      x86, microcode: Unregister syscore_ops after microcode unloaded

Xose Vazquez Perez (1):
      wireless: rt2x00: rt2800usb.c add and identify ids

Yevgeny Petrilin (2):
      mlx4: Fixing use after free
      mlx4: Fixing bad size of event queue buffer

Yoshinori Sano (1):
      Btrfs: fix memory leak in start_transaction()
