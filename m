Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab0GVT07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:26:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730Ab0GVT04 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:26:56 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Jul 2010 12:26:13 -0700
Message-ID: <AANLkTinJe-oHpgQqnTPQyKUtmKhg2oUJmylkBPALuzGh@mail.gmail.com>
Subject: Linux 2.6.35-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week (and a couple of days), another -rc.

I actually hope/think that this is going to be the last -rc. Things
have been pretty quiet, and while this -rc has more commits than -rc5
had, it's not by a large amount, nor does it look scary to me. So
there doesn't seem to be any point in dragging out the release any
more, unless we find something new that calls for it.

And one of the bugs fixed in -rc6 looks like it might be a biggie: the
"enable low power render writes on GEN3 hardware" commit by Dave
Airlie looks like it could be the fix for the long-standing problems
with some intel GM945 lock-ups. So despite being a one-liner, that
migth be a rather noticeable thing for people.

Other than that, it's probably not that big a deal for most people,
but the Shortlog (appended) gives you some taste of what's up. Please
test,

                              Linus

---
 Abhijith Das (1):
      GFS2: BUG in gfs2_adjust_quota

Alex Deucher (9):
      drm/radeon/kms: fix legacy tv-out pal mode
      drm/radeon/kms: fix possible mis-detection of sideport on rs690/rs740
      drm/radeon/kms: fix gtt MC base alignment on rs4xx/rs690/rs740 asics
      drm/radeon/kms: fix shared ddc harder
      drm/radeon/kms: add quirk for ASUS HD 3600 board
      drm/r600: fix possible NULL pointer derefernce
      drm/radeon/kms: fix legacy LVDS dpms sequence
      drm/radeon/kms: fix RADEON_INFO_CRTC_FROM_ID info ioctl
      drm/radeon/kms: add quirk to make HP DV5000 laptop resume

Andrei Emeltchenko (1):
      Bluetooth: Check L2CAP pending status before sending connect request

Andres Salomon (1):
      Andres has moved

Anton Vorontsov (5):
      powerpc/cpm: Reintroduce global spi_pram struct (fixes build issue)
      powerpc/cpm1: Fix build with various CONFIG_*_UCODE_PATCH combinations
      powerpc/cpm1: Mark micropatch code/data static and __init
      edac: mpc85xx: fix MPC85xx dependency
      edac: mpc85xx: add support for MPC8569 EDAC controllers

Arnaud Ebalard (1):
      IPv6: fix CoA check in RH2 input handler (mip6_rthdr_input())

Avi Kivity (1):
      KVM: VMX: Fix host MSR_KERNEL_GS_BASE corruption

Axel Lin (2):
      ASoC: wm8727: add a missing return in wm8727_platform_probe
      ASoC:: remove a redundant snd_soc_unregister_codec call in wm8988_register

Ben Greear (1):
      ipmr: Don't leak memory if fib lookup fails.

Ben Hutchings (1):
      drm/ttm: Fix build on architectures without AGP

Ben Skeggs (1):
      drm/nouveau: fix pcirom vbios shadow breakage from acpi rom patch

Bjorn Helgaas (1):
      PCI: fall back to original BIOS BAR addresses

Bob Peterson (4):
      GFS2: O_TRUNC not working on stuffed files across cluster
      GFS2: recovery stuck on transaction lock
      GFS2: Fix kernel NULL pointer dereference by dlm_astd
      GFS2: rename causes kernel Oops

Catalin Marinas (2):
      kmemleak: Annotate false positive in init_section_page_cgroup()
      kmemleak: Add support for NO_BOOTMEM configurations

Changli Gao (2):
      act_nat: not all of the ICMP packets need an IP header payload
      rfs: call sock_rps_record_flow() in tcp_splice_read()

Chanwoo Choi (1):
      ASoC: Select wm_hubs automatically for WM8994

Chris Mason (1):
      Btrfs: fix split_leaf double split corner case

Christoph Fritz (1):
      Input: qt2160 - rename kconfig symbol name

Dan Carpenter (4):
      ceph: add kfree() to error path
      ocfs2: tighten up strlen() checking
      fb: handle allocation failure in alloc_apertures()
      vmwgfx: return -EFAULT if copy_to_user fails

Dan Rosenberg (1):
      Btrfs: fix checks in BTRFS_IOC_CLONE_RANGE

Dave Airlie (2):
      drm/i915: enable low power render writes on GEN3 hardware.
      drm/radeon/kms: drop taking lock around crtc lookup.

Dave Chinner (4):
      mm: add context argument to shrinker callback
      xfs: convert inode shrinker to per-filesystem contexts
      xfs: track AGs with reclaimable inodes in per-ag radix tree
      mm: add context argument to shrinker callback to remaining shrinkers

David Howells (1):
      CIFS: Fix a malicious redirect problem in the DNS lookup code

David S. Miller (8):
      sparc32: Kill none_mask, it's bogus.
      sunserial: Don't call add_preferred_console() when console= is specified.
      sunsu: Fix use after free in su_remove().
      sparc64: Update defconfig.
      sparc64: Fix maybe_change_configuration() PCR setting.
      dsa: Fix Kconfig dependencies.
      MAINTAINERS: Add SBUS driver path to sparc entry.
      perf: Add DWARF register lookup for sparc

Dmitry Torokhov (4):
      Input: gamecon - reference correct input device in NES mode
      Input: gamecon - reference correct pad in gc_psx_command()
      Input: twl40300-keypad - fix handling of "all ground" rows
      Input: synaptics - relax capability ID checks on newer hardware

Dongdong Deng (1):
      sparc64: fix the build error due to smp_kgdb_capture_client()

Doug Goldstein (1):
      include/linux/vgaarb.h: add missing part of include guard

Doug Kehn (1):
      net/core: neighbour update Oops

Eric Dumazet (1):
      net: skb_tx_hash() fix relative to skb_orphan_try()

FUJITA Tomonori (1):
      sparc: remove homegrown L1_CACHE_ALIGN macro

Feng Tang (6):
      Input: i8042 - mark stubs in i8042.h "static inline"
      x86: Add i8042 pre-detection hook to x86_platform_ops
      x86, mrst: Add i8042_detect API for Moorestwon platform
      Revert "Input: do not force selecting i8042 on Moorestown"
      Revert "Input: fixup X86_MRST selects"
      input: i8042 - add runtime check in x86's i8042_platform_init

Francisco Jerez (1):
      drm/nouveau: Fix crashes during fbcon init on single head cards.

Francois Romieu (1):
      r8169: incorrect identifier for a 8168dp

Frederic Weisbecker (2):
      perf: Resurrect flat callchains
      perf: Sync callchains with period based hits

H. Peter Anvin (1):
      x86, platform: Export x86_platform to modules

Herbert Xu (1):
      bridge: Partially disable netpoll support

Ilpo Järvinen (1):
      tcp: fix crash in tcp_xmit_retransmit_queue

Jacob Pan (1):
      x86, pci, mrst: Add extra sanity check in walking the PCI
extended cap chain

Jan Kara (1):
      jbd2/ocfs2: Fix block checksumming when a buffer is used in
several transactions

Jason Wessel (4):
      repair gdbstub to match the gdbserial protocol specification
      Fix merge regression from external kdb to upstream kdb
      debug_core,kdb: fix kgdb_connected bit set in the wrong place
      sysrq,kdb: Use __handle_sysrq() for kdb's sysrq function

Jiri Slaby (1):
      crypto: skcipher - avoid NULL dereference

Joe Perches (1):
      drivers/sbus: Remove unnecessary casts of private_data

Joel Becker (4):
      ocfs2: When zero extending, do it by page.
      ocfs2: Zero the tail cluster when extending past i_size.
      ocfs2: No need to zero pages past i_size.
      ocfs2: Silence gcc warning in ocfs2_write_zero_page().

Johan Hedberg (1):
      Bluetooth: Reset the security level after an authentication failure

John W. Linville (1):
      hostap_pci: set dev->base_addr during probe

Julia Lawall (2):
      arch/sparc/kernel: Eliminate what looks like a NULL pointer dereference
      fs/ocfs2/dlm: Add missing spin_unlock

Kamal Mostafa (1):
      Input: i8042 - add Gigabyte Spring Peak to dmi_noloop_table

Keith Packard (1):
      drm/i915: Define MI_ARB_STATE bits

Ken Kawasaki (1):
      axnet_cs: use spin_lock_irqsave in ax_interrupt

Kulikov Vasiliy (1):
      drm: radeon: check kzalloc() result

Kuninori Morimoto (2):
      ASoC: fsi: fixup clock inversion operation
      ASoC: fsi: fixup wrong value setting order of TDM

Lee Nipper (1):
      crypto: talitos - fix bug in sg_copy_end_to_buffer

Linus Torvalds (3):
      drm/i915: add 'reclaimable' to i915 self-reclaimable page allocations
      Fix up trivial spelling errors ('taht' -> 'that')
      Linux 2.6.35-rc6

Linus Walleij (1):
      ARM: 6184/2: ux500: use neutral PRCMU base

Manfred Spraul (1):
      ipc/sem.c: bugfix for semop() not reporting successful operation

Marek Szyprowski (1):
      sdhci-s3c: add missing remove function

Mark Brown (1):
      ASoC: Remove duplicate AUX definition from WM8776

Martin Hicks (1):
      kdb: break out of kdb_ll() when command is terminated

Matthew McClintock (1):
      powerpc/fsl-booke: Fix address issue when using relocatable kernels

Michael S. Tsirkin (2):
      vhost-net: avoid flush under lock
      vhost: avoid pr_err on condition guest can trigger

Mikael Pettersson (1):
      math-emu: correct test for downshifting fraction in _FP_FROM_INT()

Nick Piggin (1):
      mm/vmscan.c: fix mapping use after free

Nicolas Pitre (1):
      ARM: 6226/1: fix kprobe bug in ldr instruction emulation

Patrick McHardy (1):
      pcmcia: fix 'driver ... did not release config properly' warning

Paul E. McKenney (1):
      vfs: fix RCU-lockdep false positive due to /proc

Peter Oberparleiter (1):
      [S390] dasd: use correct label location for diag fba disks

Rajkumar Manoharan (1):
      ath9k_htc: fix memory leak in ath9k_hif_usb_alloc_urbs

Randy Dunlap (1):
      documentation: fix almost duplicate filenames (IO/io-mapping.txt)

Reinette Chatre (1):
      iwlwifi: remove key information during device restart

Robert Jennings (1):
      ibmveth: lost IRQ while closing/opening device leads to service loss

Roland McGrath (2):
      x86: kprobes: fix swapped segment registers in kretprobe
      x86: auditsyscall: fix fastpath return value after reschedule

Russell King (2):
      ARM: lockdep: fix unannotated irqs-on
      ARM: Update mach-types

Ryan Mallon (1):
      ds2782_battery: Fix ds2782_get_capacity return value

Rémi Denis-Courmont (1):
      Phonet: fix skb leak in pipe endpoint accept()

Sage Weil (8):
      ceph: fix message revocation
      ceph: fix leak of mon authorizer
      ceph: fix printing of ipv6 addrs
      ceph: fix parsing of ipv6 addresses
      ceph: fix creation of ipv6 sockets
      ceph: reuse request message when replaying against recovering mds
      ceph: do not include cap/dentry releases in replayed messages
      Btrfs: fix CLONE ioctl destination file size expansion to block boundary

Sascha Hauer (1):
      ARM: 6210/1: Do not rely on reset defaults of L2X0_AUX_CTRL

Sebastian Ott (1):
      [S390] cio: fix potential overflow in chpid descriptor

Sreedhara DS (1):
      intel_scu_ipc: Oops/crash fixes

Stefan Haberland (1):
      [S390] add missing device put

Stephen Boyd (1):
      rt2x00: Fix lockdep warning in rt2x00lib_probe_dev()

Steven Rostedt (1):
      tracing: Add alignment to syscall metadata declarations

Takashi Iwai (1):
      Input: synaptics - fix wrong dimensions check

Tao Ma (6):
      ocfs2: Move orphan scan work to ocfs2_wq.
      ocfs2: Limit default local alloc size within bitmap range.
      ocfs2: Remove the redundant cpu_to_le64.
      ocfs2: make xattr extension work with new local alloc reservation.
      ocfs2: Make xattr reflink work with new local alloc reservation.
      ocfs2: Don't duplicate pages past i_size during CoW.

Thavidu Ranatunga (2):
      perf: Version String fix, using kernel version
      perf: Version String fix, for fallback if not from git

Thomas Gleixner (1):
      x86: Force HPET readback_cmp for all ATI chipsets

Timo Teräs (1):
      xfrm: do not assume that template resolving always returns xfrms

Tom Herbert (1):
      net: fix problem in reading sock TX queue

Tony Luck (1):
      Fix ttm_page_alloc.c build breakage

Ville Tervo (1):
      Bluetooth: Update sec_level/auth_type for already existing connections

Wan ZongShun (2):
      Input: w90p910_ts - fix call to setup_timer()
      Input: w90p910_keypad - change platfrom driver name to 'nuc900-kpi'

Wengang Wang (2):
      ocfs2/dlm: don't access beyond bitmap size
      ocfs2/dlm: Remove BUG_ON from migration in the rare case of a down node

Will Deacon (2):
      ARM: 6211/1: atomic ops: fix register constraints for atomic64_add_unless
      ARM: 6212/1: atomic ops: add memory constraints to inline asm

Xiao Guangrong (1):
      KVM: MMU: flush remote tlbs when overwriting spte with different pfn

Yinghai Lu (4):
      lmb: rename to memblock
      x86: Fix x2apic preenabled system with kexec
      x86, numa: fix boot without RAM on node0 again
      x86,nobootmem: make alloc_bootmem_node fall back to other node
when 32bit numa is used
