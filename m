Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2CJWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 17:09:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37664 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2CJWJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 17:09:26 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Mar 2012 14:09:04 -0800
X-Google-Sender-Auth: m6xt6Rz564rFD4sywjxTNMsRJzA
Message-ID: <CA+55aFyfnBqj8CR5W9bkmdrFpW34C9zHT1EGLycQZVh4W88-EA@mail.gmail.com>
Subject: Linux 3.3-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had been hoping that -rc6 would be the last -rc, but no such luck.
Things just haven't calmed down sufficiently for me to feel comfy
doing a final 3.3 release without another -rc, so here we are: 3.3-rc7
is out.

Now, none of the fixes here are all that scary in themselves, but
there were just too many of them, and across various subsystems.
Networking, memory management, drivers, you name it. And instead of
having fewer commits than in -rc6, we have more of them. So my hope
that things would calm down simply just didn't materialize.

I really would prefer not having an -rc8, though. And I do think we're
in fairly good shape, I just didn't think we were quite there yet for
a release. Thus this will hopefully *really* be the final -rc.

                       Linus

---
Adrian Knoth (1):
      ALSA: hdspm - Provide ioctl_compat

Akinobu Mita (1):
      percpu: use bitmap_clear

Akio Idehara (1):
      Input: ALPS - fix touchpad detection when buttons are pressed

Al Viro (5):
      aout: move setup_arg_pages() prior to reading/mapping the binary
      VM_GROWS{UP,DOWN} shouldn't be set on shmem VMAs
      flush_tlb_range() needs ->page_table_lock when ->mmap_sem is not held
      aio: fix io_setup/io_destroy race
      aio: fix the "too late munmap()" race

Alan Cox (1):
      drm, gma500: Fix Cedarview boot failures in 3.3-rc

Alan Stern (1):
      HID: usbhid: Add NOGET quirk for the AIREN Slim+ keyboard

Alex Deucher (1):
      drm/radeon/kms: fix hdmi duallink checks

Alexandre Bounine (1):
      rapidio/tsi721: fix queue wrapping bug in inbound doorbell handler

Amitkumar Karwar (1):
      mwifiex: reset encryption mode flag before association

Anatolij Gustschin (1):
      drivers/rtc/rtc-r9701.c: fix crash in r9701_remove()

Andrea Arcangeli (1):
      mm: thp: fix BUG on mm->nr_ptes

Andrew Morton (1):
      alpha: fix 32/64-bit bug in futex support

Arend van Spriel (2):
      brcm80211: smac: fix endless retry of A-MPDU transmissions
      brcm80211: smac: only print block-ack timeout message at trace level

Arnaldo Carvalho de Melo (1):
      perf tools: Handle kernels that don't support attr.exclude_{guest,host}

Axel Lin (2):
      mfd: Initialize tps65912 irq platform data properly
      regulator: Fix mask parameter in da9052_reg_update calls

Bartlomiej Zolnierkiewicz (1):
      ARM: EXYNOS: fix touchscreen IRQ setup on Universal C210 board

Baruch Siach (1):
      of/mdio: fix fixed link bus name

Ben Pfaff (1):
      openvswitch: Honor dp_ifindex, when specified, for vport lookup by name.

Bjorn Helgaas (1):
      MIPS: PCI: use list_for_each_entry() for bus->devices traversal

Chris Bagwell (1):
      Input: wacom - add missing LEDS_CLASS to Kconfig

Chris Mason (1):
      Btrfs: fix casting error in scrub reada code

Christian König (1):
      drm/radeon: fix a semaphore deadlock on pre cayman asics

Christian Lamparter (1):
      carl9170: fix frame delivery if sta is in powersave mode

Cousson, Benoit (1):
      ARM: OMAP: irqs: Fix NR_IRQS value to handle PRCM interrupts

Dan Carpenter (5):
      pch_gbe: memory corruption calling pch_gbe_validate_option()
      enic: fix an endian bug in enic_probe()
      pps: class_create() returns an ERR_PTR, not NULL
      c2port: class_create() returns an ERR_PTR
      atl1c: set ATL1C_WORK_EVENT_RESET bit correctly

Danny Kukawka (1):
      of/fdt.c: asm/setup.h included twice

Dave Airlie (1):
      drm/radeon: deal with errors from framebuffer init path.

Dave Martin (1):
      ARM: devicetree: Add .dtb files to arch/arm/boot/.gitignore

David Ahern (1):
      perf record: No build id option fails

David Brown (1):
      MAINTAINERS: new git entry for arm/mach-msm

Denis 'GNUtoo' Carikli (1):
      ASoC: neo1973: fix neo1973 wm8753 initialization

Dmitry Torokhov (1):
      Input: twl4030-vibra - use proper guard for PM methods

Eric Dumazet (2):
      rtnetlink: fix rtnl_calcit() and rtnl_dump_ifinfo()
      ehea: restore multicast and rx_errors fields

Felix Fietkau (1):
      ath9k_hw: prevent writes to const data on AR9160

Florian Westphal (2):
      netfilter: bridge: fix module autoload in compat case
      bridge: netfilter: don't call iptables on vlan packets if sysctl is off

Gabor Juhos (2):
      MIPS: ATH79: Avoid a kernel bug on AR913X
      rt2x00: fix a possible NULL pointer dereference

Gilles Chanteperdrix (1):
      ARM: 7348/1: arm/spear600: fix one-shot timer

Greg Kroah-Hartman (1):
      Revert "powerpc/usb: fix issue of CPU halt when missing USB PHY clock"

Guennadi Liakhovetski (1):
      mmc: core: fix regression: set default clock gating delay to 0

Guenter Roeck (3):
      hwmon: (pmbus_core) Fix maximum number of POUT alarm attributes
      hwmon: (zl6100) Maintain delay parameter in driver instance data
      hwmon: (jc42) Add support for AT30TS00, TS3000GB2, TSE2002GB2, and MCP9804

Gusakov Andrey (1):
      ARM: S3C24XX: DMA resume regression fix

H Hartley Sweeten (1):
      ARM: ep93xx: convert vision_ep9307 to MULTI_IRQ_HANDLER

Haiyang Zhang (1):
      net/hyperv: Use the built-in macro KBUILD_MODNAME for this driver

Haojian Zhuang (3):
      ARM: pxa: add dummy clock for pxa25x and pxa27x
      ARM: pxa: remove duplicated registeration on pxa-gpio
      ARM: pxa: fix invalid mfp pin issue

Heiko Stuebner (1):
      ARM: S3C24XX: Fix restart on S3C2442

Heiko Stübner (1):
      Input: evdev - fix variable initialisation

Hugh Dickins (5):
      memcg: fix deadlock by inverting lrucare nesting
      memcg: fix GPF when cgroup removal races with last exit
      page_cgroup: fix horrid swap accounting regression
      mmap: EINVAL not ENOMEM when rejecting VM_GROWS
      memcg: revert fix to mapcount check for this release

Jack Morgenstein (1):
      mlx4_core: fix bug in modify_cq wrapper for resize flow.

Jamie Iles (1):
      of: add picochip vendor prefix

Jan Beulich (2):
      vsprintf: make %pV handling compatible with kasprintf()
      x86/amd: iommu_set_device_table() must not be __init

Jason Gerecke (1):
      Input: wacom - fix 3rd-gen Bamboo MT when 4+ fingers are in use

Jean Delvare (2):
      mfd: Fix ACPI conflict check
      hwmon: (jc42) Add support for ST Microelectronics STTS2002 and STTS3000

Jeff Layton (1):
      cifs: fix dentry refcount leak when opening a FIFO on lookup

Jeff Moyer (1):
      aio: wake up waiters when freeing unused kiocbs

Jesper Juhl (2):
      MIPS: BMIPS: smp-bmips.c does not need to include version.h
      dm ioctl: do not leak argv if target message only contains whitespace

Jesse Gross (1):
      openvswitch: Fix checksum update for actions on UDP packets.

Joakim Tjernlund (2):
      bridge: Adjust min age inc for HZ > 256
      bridge: message age needs to increase, not decrease.

Joe Thornber (2):
      dm thin metadata: unlock superblock in init_pmd error path
      dm thin metadata: decrement counter after removing mapped block

Joerg Roedel (1):
      perf tools: Change perf_guest default back to false

Johannes Berg (2):
      iwlwifi: fix key removal
      iwlwifi: fix wowlan suspend

Jonathan E Brassow (2):
      dm raid: set MD_CHANGE_DEVS when rebuilding
      dm raid: fix flush support

Jonathan Nieder (2):
      x86/PCI: use host bridge _CRS info on MSI MS-7253
      x86/PCI: do not tie MSI MS-7253 use_crs quirk to BIOS version

Jonghwan Choi (2):
      mfd: wm8350 variable dereferenced before check
      mfd: Fix possible s5m null pointer dereference

Joonyoung Shim (1):
      ARM: SAMSUNG: Fix memory size for hsotg

Kailang Yang (1):
      ALSA: hda/realtek - Apply the coef-setup only to ALC269VB

Kautuk Consul (1):
      MIPS: fault.c: Port OOM changes to do_page_fault

Konstantin Khlebnikov (2):
      percpu: fix generic definition of __this_cpu_add_and_return()
      percpu: fix __this_cpu_{sub,inc,dec}_return() definition

Kukjin Kim (1):
      ARM: S3C2440: Fixed build error for s3c244x

Laxman Dewangan (2):
      mfd: Initialize tps65910 irq platform data properly
      regulator: tps65910: Configure correct value for VDDCTRL vout reg

Li Wei (1):
      IPv6: Fix not join all-router mcast group when forwarding set.

Li Zefan (1):
      btrfs: fix locking issues in find_parent_nodes()

Linus Torvalds (5):
      vfs: move dentry_cmp from <linux/dcache.h> to fs/dcache.c
      vm: avoid using find_vma_prev() unnecessarily
      x86: fix typo in recent find_vma_prev purge
      Revert "CPU hotplug, cpusets, suspend: Don't touch cpusets
during suspend/resume"
      Linux 3.3-rc7

Linus Walleij (1):
      mfd: Fix ab8500 error path bug

Lorenzo Pieralisi (1):
      ARM: 7358/1: perf: add PMU hotplug notifier

Ludovic Desroches (1):
      mmc: atmel-mci: don't use dma features when using DMA with no
chan available

Manuel Lauss (2):
      MIPS: Alchemy: Update Au1300 inlined GPIO macros
      MIPS: Alchemy: Increase minimum timeout for 32kHz timer.

Marek Olšák (1):
      drm/radeon/kms: set SX_MISC in the r6xx blit code (v2)

Mark Brown (2):
      mfd: Test for jack detection when deciding if wm8994 should suspend
      mfd: Correct readability of WM8994 DC servo 4E register

Mark Salter (1):
      C6X: fix KSTK_EIP and KSTK_ESP macros

Marton Balint (1):
      ALSA: hda - add quirk to detect CD input on Gigabyte EP45-DS3

Masanari Iida (1):
      MIPS: traps.c: Fix typo

Matt Carlson (1):
      tg3: Fix tg3_get_stats64 for 5700 / 5701 devs

Matthew Garrett (1):
      kmsg_dump: don't run on non-error paths by default

Mike Snitzer (2):
      dm flakey: fix crash on read when corrupt_bio_byte not set
      dm thin metadata: remove incorrect close_device on creation error paths

Mikulas Patocka (1):
      mm: fix find_vma_prev

Milan Broz (1):
      dm io: fix discard support

Ming Lei (1):
      percpu: use raw_local_irq_* in _this_cpu op

Mohammed Shafi Shajakhan (2):
      mac80211: zero initialize count field in ieee80211_tx_rate
      mac80211: Fix a warning on changing to monitor mode from STA

Muthu Kumar (1):
      floppy/scsi: fix setting of BIO flags

Naoya Horiguchi (1):
      memcg: fix mapcount check in move charge code for anonymous page

Neal Cardwell (4):
      tcp: fix comment for tp->highest_sack
      tcp: fix false reordering signal in tcp_shifted_skb
      tcp: don't fragment SACKed skbs in tcp_mark_head_lost()
      tcp: fix tcp_shift_skb_data() to not shift SACKed data below snd_una

NeilBrown (3):
      md/raid1: fix buglet in md_raid1_contested.
      md/raid10: fix handling of error on last working device in array.
      md/raid10: fix assembling of arrays with replacement devices.

Nicolas Cavallari (1):
      carl9170: Fix memory accounting when sta is in power-save mode.

Nicolas Ferre (3):
      ARM: at91/dma: remove platform data from DMA controller
      ARM: at91/dma: DMA controller registering with DT support
      MAINTAINERS: hand over atmel-mci (sd/mmc interface)

Nikolai Kondrashov (1):
      HID: hid-input: allow array fields out of range

Ohad Ben-Cohen (1):
      ARM: OMAP: fix iommu, not mailbox

Oleg Nesterov (5):
      vfork: introduce complete_vfork_done()
      vfork: make it killable
      coredump_wait: don't call complete_vfork_done()
      vfork: kill PF_STARTING
      hung_task: fix the broken rcu_lock_break() logic

Pablo Neira Ayuso (3):
      netfilter: ctnetlink: remove incorrect spin_[un]lock_bh on NAT
module autoload
      netfilter: bridge: fix wrong pointer dereference
      netfilter: nf_conntrack: fix early_drop with reliable event delivery

Paul Gortmaker (1):
      MIPS: Netlogic: Fix defconfigs for coverage builds

Paulius Zaleckas (2):
      bridge: br_log_state() s/entering/entered/
      bridge: fix state reporting when port is disabled

Pavel Shilovsky (1):
      CIFS: Fix mkdir/rmdir bug for the non-POSIX case

Prashanth Nageshappa (1):
      kprobes: return proper error code from register_kprobe()

R Sricharan (1):
      ARM: OMAP2+: Fix module build errors with CONFIG_OMAP4_ERRATA_I688

Rajendra Nayak (1):
      ARM: OMAP2+: Remove apply_uV constraints for fixed regulator

Ralf Baechle (2):
      MIPS: Remove temporary kludge from <asm/page.h>
      MIPS: PowerTV: Fix defconfigs for coverage builds

Russell King (2):
      Fix section mismatch in spi-pl022.c
      ARM: ecard: ensure fake vma vm_flags is setup

Santosh Nayak (2):
      qla3xxx: ethernet: Fix bogus interrupt state flag.
      netfilter: ebtables: fix wrong name length while copying to user-space

Sascha Hauer (1):
      mmc: sdhci-esdhc-imx: fix for mmc cards on i.MX5

Sebastian Siewior (1):
      net/usbnet: avoid recursive locking in usbnet_stop()

Shawn Guo (1):
      dt: add empty of_find_compatible_node function

Shreyas Bhatewara (1):
      vmxnet3: Fix transport header size

Sjur Brændeland (1):
      caif-hsi: Set default MTU to 4096

Steffen Klassert (2):
      inetpeer: Invalidate the inetpeer tree along with the routing cache
      route: Remove redirect_genid

Steffen Maier (1):
      [S390] qdio: fix handler function arguments for zfcp data router

Stephen Boyd (1):
      debugobjects: Fix selftest for static warnings

Stephen Rothwell (1):
      tty/powerpc: early udbg consoles can't be modules

Thomas Gleixner (2):
      genirq: Clear action->thread_mask if IRQ_ONESHOT is not set
      x86: Derandom delay_tsc for 64 bit

Tobias Klauser (1):
      doc: dt: Fix broken reference in gpio-leds documentation

Tom Herbert (1):
      tg3: Fix to use multi queue BQL interfaces

Tony Wu (1):
      MIPS: vmlinux.lds.S: remove duplicate _sdata symbol

Ulf Hansson (1):
      mmc: core: Fixup suspend/resume issues for UHS-I cards

Ulrich Weber (1):
      bridge: check return value of ipv6_dev_get_saddr()

Vaibhav Hiremath (1):
      ARM: OMAP: id: Add missing break statement in omap3xxx_check_revision

Vipul Pandya (2):
      cxgb4: Add support for Chelsio's T480-CR and T440-LP-CR adapters
      cxgb4vf: Add support for Chelsio's T480-CR and T440-LP-CR adapters

Will Deacon (7):
      ARM: 7345/1: errata: update workaround for A9 erratum #743622
      ARM: 7346/1: errata: fix PL310 erratum #753970 workaround selection
      mmc: mmci: reduce max_blk_count to avoid overflowing max_req_size
      ARM: 7354/1: perf: limit sample_period to half max_period in
non-sampling mode
      ARM: 7355/1: perf: clear overflow flag when disabling counter on ARMv7 PMU
      ARM: 7356/1: perf: check that we have an event in the PMU IRQ handlers
      ARM: 7357/1: perf: fix overflow handling for xscale2 PMUs

Yevgeny Petrilin (1):
      mlx4_core: remove buggy sched_queue masking

Yinghai Lu (1):
      PCI: fix memleak when ACPI _CRS is not used.

Yoichi Yuasa (1):
      MIPS: txx9 7segled fix struct device has no member

françois romieu (2):
      r8169: corrupted IP fragments fix for large mtu.
      r8169: runtime resume before shutdown.

stephen hemminger (1):
      packetengines: fix config default

viresh kumar (1):
      ARM: 7339/1: amba/serial.h: Include types.h for resolving
dependency of type bool
