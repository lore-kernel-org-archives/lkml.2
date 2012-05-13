Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab2EMCEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 22:04:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54138 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab2EMCE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 22:04:29 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 12 May 2012 19:04:08 -0700
X-Google-Sender-Auth: j02PT5KY12wJx_lJzbrko2V1Psw
Message-ID: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com>
Subject: Linux 3.4-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is almost certainly the last -rc in this series - things really
have calmed down, and I even considered just cutting 3.4 this weekend,
but felt that another week wouldn't hurt.

The appended shortlog gives a good overview - it's mostly random tiny
fixes for very small specific issues. The biggest commit (and the one
that might affect the most people) is likely the Nouveau i2c change,
and that one is really just a revert. It changes nouveau back to use
the generic i2c-algo-bit routines - the problem they had had been
fixed in the meantime, and the specialized i2c nouveau routines had
issues of their own.

The rest is mainly small changes in various areas: drivers
(networking, drm, scsi, sound and md) arch updates (arm, powerpc and
x86) and random other areas - core networking, a compat fix, stuff
like that. No scary changes.

So go forth and test. And don't send me any pull requests unless they
contain *only* regressions or fixes for really nasty bugs. No more of
these silly compiler warning fixes etc any more.

                    Linus

---
Alasdair G Kergon (1):
      dm thin: correct module description

Andre Schramm (1):
      ALSA: hdsp - Provide ioctl_compat

Andrei Emeltchenko (1):
      e1000: Silence sparse warnings by correcting type

Andrew Morton (1):
      xen/Kconfig: fix Kconfig layout

Ansis Atteka (1):
      openvswitch: Release rtnl_lock if ovs_vport_cmd_build_info() failed.

Archit Taneja (1):
      ARM: OMAP: Revert "ARM: OMAP: ctrl: Fix CONTROL_DSIPHY register fields"

Ariel Elior (1):
      bnx2x: bug fix when loading after SAN boot

Arnd Bergmann (1):
      drivers/leds: correct __devexit annotations

Avi Kivity (1):
      KVM: ia64: fix build due to typo

Axel Lin (1):
      regulator: Fix the logic to ensure new voltage setting in valid range

Basil Gor (2):
      vhost-net: fix handle_rx buffer size
      macvtap: restore vlan header on user read

Ben Hutchings (2):
      sfc: Fix division by zero when using one RX channel and no SR-IOV
      ARM: orion5x: Fix GPIO enable bits for MPP9

Ben Skeggs (1):
      drm/nouveau/i2c: resume use of i2c-algo-bit, rather than custom stack

Benjamin Herrenschmidt (3):
      powerpc/irq: Fix bug with new lazy IRQ handling code
      powerpc/irq: Make alignment & program interrupt behave the same
      powerpc/irq: Fix another case of lazy IRQ state getting out of sync

Benjamin Poirier (1):
      igb: fix rtnl race in PM resume path

Bjørn Mork (1):
      cdc_ether: Ignore bogus union descriptor for RNDIS devices

Bryan Wu (1):
      MAINTAINERS: add maintainer for LED subsystem

Catalin Marinas (1):
      kmemleak: Fix the kmemleak tracking of the percpu areas with !SMP

Chad Dupuis (1):
      [SCSI] qla2xxx: Update version number to 8.04.00.03-k.

Chris Metcalf (1):
      hugetlb: prevent BUG_ON in hugetlb_fault() -> hugetlb_cow()

Colin Cross (1):
      ARM: 7414/1: SMP: prevent use of the console when using idmap_pgd

Dan Carpenter (1):
      cifs: fix revalidation test in cifs_llseek()

Daniel Vetter (2):
      drm/i915: disable sdvo hotplug on i945g/gm
      drm/i915: Do no set Stencil Cache eviction LRA w/a on gen7+

David Gibson (1):
      KVM: PPC: Book3S HV: Fix refcounting of hugepages

David Henningsson (1):
      ALSA: HDA: Lessen CPU usage when waiting for chip to respond

David S. Miller (3):
      sparc64: Do not clobber %g2 in xcall_fetch_glob_regs().
      ipv4: Do not use dead fib_info entries.
      Revert "net: maintain namespace isolation between vlan and real device"

David Vrabel (1):
      xen/pci: don't use PCI BIOS service for configuration space accesses

Don Skidmore (1):
      ixgbe: fix race condition with shutdown

Enrico Butera (1):
      ARM: OMAP: igep0020: fix smsc911x dummy regulator id

Eric Dumazet (2):
      iwlwifi: fix skb truesize underestimation
      pktgen: fix crash at module unload

Eric W. Biederman (1):
      connector/userns: replace netlink uses of cap_raised() with capable()

Franky Lin (1):
      brcmfmac: fix a double spin_unlock_irqrestore issue in dpc

Giridhar Malavali (2):
      [SCSI] qla2xxx: Block flash access from application when device
is initialized for ISP82xx.
      [SCSI] qla2xxx: Proper completion to scsi-ml for scsi status
task_set_full and busy.

Gleb Natapov (2):
      KVM: ensure async PF event wakes up vcpu from halt
      KVM: Do not take reference to mm during async #PF

Guennadi Liakhovetski (3):
      ASoC: sh: fix migor.c compilation
      ARM: mach-shmobile: convert mackerel to use the generic MMC GPIO
hotplug helper
      ARM: mach-shmobile: convert ag5evm to use the generic MMC GPIO
hotplug helper

Hugh Dickins (1):
      mm: raise MemFree by reverting percpu_pagelist_fraction to 0

Ian Campbell (1):
      ARM: kirkwood: add missing kexec.h include

James Bottomley (1):
      [SCSI] fix oops in all legacy host adapters caused by 6f381fa

Jan Kiszka (1):
      compat: Fix RT signal mask corruption via sigprocmask

Janusz Krzysztofik (1):
      ARM: OMAP1: Amstrad Delta: Fix wrong IRQ base in FIQ handler

Jesse Gross (1):
      openvswitch: Add length check when retrieving TCP flags.

Jiri Bohac (1):
      bonding: don't increase rx_dropped after processing LACPDUs

Johannes Berg (1):
      net: compare_ether_addr[_64bits]() has no ordering

John Fastabend (2):
      ixgbe: dcb: BIT_APP_UPCHG not set by ixgbe_copy_dcb_cfg()
      igb, ixgbe: netdev_tx_reset_queue incorrectly called from tx init path

Julia Lawall (1):
      drivers/video/xen-fbfront.c: add missing cleanup code

Julien Ducourthial (1):
      r8169: fix unsigned int wraparound with TSO

Konrad Rzeszutek Wilk (2):
      xen/apic: Return the APIC ID (and version) for CPU 0.
      xen/pte: Fix crashes when trying to see non-existent PGD/PMD/PUD/PTEs

Konstantin Khlebnikov (1):
      proc/pid/pagemap: correctly report non-present ptes and holes between vmas

Kukjin Kim (1):
      ARM: EXYNOS: fix ctrlbit for exynos5_clk_pdma1

Kuninori Morimoto (1):
      ARM / mach-shmobile: sh73a0 SMP TWD boot regression fix

Larry Finger (1):
      IA32 emulation: Fix build problem for modular ia32 a.out support

Laxman Dewangan (1):
      regmap: fix possible memory corruption in regmap_bulk_read()

Linus Torvalds (1):
      Linux 3.4-rc7

Magnus Damm (2):
      ARM / mach-shmobile: r8a7779 SMP TWD boot regression fix
      ARM / mach-shmobile: Invalidate caches when booting secondary cores

Marek Szyprowski (1):
      ARM: EXYNOS: use s5p-timer for UniversalC210 board

Mark Brown (1):
      regulator: Actually free the regulator in devm_regulator_put()

Mark Hills (1):
      ALSA: echoaudio: Remove incorrect part of assertion

Mike Galbraith (1):
      namespaces, pid_ns: fix leakage on fork() failure

Mike Snitzer (3):
      dm thin: reinstate missing mempool_free in cell_release_singleton
      dm thin: fix unprotected use of prepared_discards list
      dm mpath: check if scsi_dh module already loaded before trying to load

Nicholas Bellinger (1):
      target: Drop incorrect se_lun_acl release for dynamic -> explict
ACL conversion

Nicolas Dichtel (1):
      sctp: check cached dst before using it

Paolo Bonzini (1):
      [SCSI] virtio_scsi: fix TMF use-after-free

Pravin B Shelar (1):
      openvswitch: Validation of IPv6 set port action uses IPv4 header

Rafael J. Wysocki (1):
      MAINTAINERS: Add myself as the cpufreq maintainer

Rajkumar Manoharan (1):
      Revert "ath9k_hw: Fix incorrect spur_freq_sd for AR9003"

Rolf Eike Beer (5):
      parisc: add missing includes in asm/spinlock.h
      parisc: add missing forward declarations in asm/hardware.h
      parisc: drop include of asm/pdc.h from asm/hardware.h
      parisc: add missing include of asm/page.h to asm/pgtable.h
      parisc: move definition of PAGE0 to asm/page.h

Russ Anderson (1):
      mm: nobootmem: fix sign extend problem in __free_pages_memory()

Sachin Kamat (1):
      gpio/exynos: Fix compiler warnings when non-exynos machines are selected

Sasha Levin (1):
      mm: fix division by 0 in percpu_pagelist_fraction()

Saurav Kashyap (1):
      [SCSI] qla2xxx: Properly check for current state after the
fabric-login request.

Sha Zhengju (1):
      memcg: free spare array to avoid memory leak

Stephen Boyd (1):
      ks8851: Update link status during link change interrupt

Steve Dickson (1):
      auth_gss: the list of pseudoflavors not being parsed correctly

Steven King (1):
      m68knommu: enable qspi support when SPI_COLDFIRE_QSPI = m

Takashi Iwai (4):
      ALSA: hda/realtek - Add a fixup for Acer Aspire 5739G
      ALSA: hda/realtek - Add missing CD-input pin for MSI-7350 mobo
      ALSA: hda/realtek - Call alc_auto_parse_customize_define()
always after fixup
      Revert "ALSA: hda - Set codec to D3 forcibly even if not used"

Tarun Kanti DebBarma (1):
      gpio/omap: fix incorrect initialization of omap_gpio_mod_init

Tejun Heo (3):
      percpu: use KERN_CONT in pcpu_dump_alloc_info()
      percpu, x86: don't use PMD_SIZE as embedded atom_size on 32bit
      percpu: pcpu_embed_first_chunk() should free unused parts after
all allocs are complete

Thadeu Lima de Souza Cascardo (1):
      ehea: fix losing of NEQ events when one event occurred early

Thomas Gleixner (1):
      gpio: pch9: Use proper flow type handlers

Tim Bird (1):
      ARM: 7410/1: Add extra clobber registers for assembly in kernel_execve

Vikas Chaudhary (1):
      [SCSI] qla2xxx: Fix reset time out as qla2xxx not ack to reset request.

Will Deacon (2):
      ARM: 7411/1: audit: fix treatment of saved ip register during
syscall tracing
      ARM: 7412/1: audit: use only AUDIT_ARCH_ARM regardless of endianness
