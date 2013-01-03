Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3ACDhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 22:37:17 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61677 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3ACDhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 22:37:15 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Jan 2013 19:36:54 -0800
X-Google-Sender-Auth: vY7MaY621pFicHFaGoFrL6b--tE
Message-ID: <CA+55aFxQ9vH70UrqC0ypm-diNbGcZbWbdhYa3FLH+0Vbrk4hUQ@mail.gmail.com>
Subject: Linux 3.8-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a new year, people are getting back to work, and trying
desperately to forget the over-eating that has been going on for the
last two weeks. And hey, to celebrate, here's -rc2!

The patch is fairly small, and largely dominated by the GPU updates
and the trivial removal of __devinit/exit in the i2c layer. But
there's some filesystem work (ext4, ecryptfs, ceph) and some VM fixes
in there to. And some late ARM OMAP cleanups.

The shortlog is appended, my "mergelog" looks like this:

  Wolfram Sang:
      i2c __dev* attribute removal

  David Miller:
      networking fixes

  Eric Biederman:
      namespace fixes

  Guenter Roeck:
      hwmon fixes

  Olof Johansson:
      ARM SoC fixes
      late ARM cleanups for omap

  Dave Airlie:
      DRM update

  Ted Ts'o:
      ext4 bug fixes

  Sage Weil:
      Ceph fixes

  Tyler Hicks:
      ecryptfs fixes

  Bjorn Helgaas:
      PCI updates

  Wim Van Sebroeck:
      watchdog fixes

  Bryan Wu.
      LED fix

Go out and test it,

                Linus

---

Aaro Koskinen (2):
      watchdog: omap_wdt: eliminate unused variable and a compiler warning
      watchdog: twl4030_wdt: add DT support

Akinobu Mita (1):
      batman-adv: fix random jitter calculation

Alex Deucher (1):
      drm/radeon: add WAIT_UNTIL to evergreen VM safe reg list

Alex Elder (3):
      libceph: move linger requests sooner in kick_requests()
      libceph: always reset osds when kicking
      libceph: WARN, don't BUG on unexpected connection states

Andy Lutomirski (2):
      ext4: fix an incorrect comment about i_mutex
      PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz

AnilKumar Chimata (1):
      ARM: OMAP2+: omap2plus_defconfig: Add tps65217 support

Axel Lin (2):
      watchdog: da9055: Fix invalid free of devm_ allocated data
      watchdog: da9055: Don't update wdt_dev->timeout in
da9055_wdt_set_timeout error path

Ben Skeggs (8):
      drm/nouveau: initial support for GK106
      drm/nouveau/bios: update gpio parsing apis to match current design
      drm/nouveau/bios: implement opcode 0xa9
      drm/nouveau/bios: parse/display extra version component
      drm/nouveau/mxm: silence output if no bios data
      drm/nouveau/bios: cache ramcfg strap on later chipsets
      drm/nvc0/graph: fix fuc, and enable acceleration on GF119
      drm/nve0/graph: fix fuc, and enable acceleration on all known chipsets

Bill Pemberton (1):
      i2c: remove __dev* attributes from subsystem

Bjorn Helgaas (2):
      PCI: Remove spurious error for sriov_numvfs store and simplify flow
      PCI: Add PCIe Link Capability link speed and width names

Chris Verges (1):
      hwmon: (lm73} Detect and report i2c bus errors

Chris Wilson (6):
      drm/i915: Fixup cursor latency used for IVB lp3 watermarks
      drm/i915: Double the cursor self-refresh latency on Valleyview
      drm/i915: Clear self-refresh watermarks when disabled
      drm/i915: Prefer CRTC 'active' rather than 'enabled' during WM
computations
      drm: Export routines for inserting preallocated nodes into the mm manager
      drm/i915: Preallocate the drm_mm_node prior to manipulating the
GTT drm_mm manager

Christoffer Dall (1):
      mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED

Cong Ding (1):
      fs/ecryptfs/crypto.c: make ecryptfs_encode_for_filename() static

Cong Wang (1):
      arp: fix a regression in arp_solicit()

Dan Carpenter (1):
      solos-pci: double lock in geos_gpio_store()

Daniel Vetter (6):
      drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled
      drm/i915: Implement WaSetupGtModeTdRowDispatch
      drm/i915: Implement workaround for broken CS tlb on i830/845
      drm/i915: don't disable disconnected outputs
      drm/i915: optionally disable shrinker lock stealing
      drm/i915: disable shrinker lock stealing for create_mmap_offset

Dave Airlie (2):
      drm/i915: fix flags in dma buf exporting
      Revert "drm: tegra: protect DC register access with mutex"

David Howells (2):
      UAPI: Remove empty Kbuild files
      UAPI: Strip _UAPI prefix on header install no matter the whitespace

Eric Dumazet (5):
      ip_gre: fix possible use after free
      net: devnet_rename_seq should be a seqcount
      tuntap: dont use a private kmem_cache
      ipv4: arp: fix a lockdep splat in arp_solicit()
      tcp: should drop incoming frames without ACK flag set

Eric Sandeen (2):
      ext4: remove unaligned AIO warning printk
      ext4: include journal blocks in df overhead calcs

Eric W. Biederman (4):
      pidns: Outlaw thread creation after unshare(CLONE_NEWPID)
      pidns: Stop pid allocation when init dies
      proc: Allow proc_free_inum to be called from any context
      f2fs: Don't assign e_id in f2fs_acl_from_disk

Eric Wong (1):
      epoll: prevent missed events on EPOLL_CTL_MOD

Forrest Liu (1):
      ext4: fix extent tree corruption caused by hole punch

Gao feng (1):
      bridge: call br_netpoll_disable in br_add_if

Greg KH (2):
      Drivers: network: more __dev* removal
      CONFIG_HOTPLUG removal from networking core

Guenter Roeck (1):
      hwmon: (emc6w201) Fix DIV_ROUND_CLOSEST problem with unsigned divisors

Huang Ying (1):
      PCI/PM: Do not suspend port if any subordinate device needs PME polling

Hugh Dickins (2):
      tmpfs mempolicy: fix /proc/mounts corrupting memory
      mempolicy: remove arg from mpol_parse_str, mpol_to_str

Isaku Yamahata (3):
      ip_gre: make ipgre_tunnel_xmit() not parse network header as IP
unconditionally
      ipv4/ip_gre: set transport header correctly to gre header
      ipv6/ip6_gre: set transport header correctly

Jan Kara (4):
      ext4: check dioread_nolock on remount
      jbd2: fix assertion failure in jbd2_journal_flush()
      ext4: split off ext4_journalled_invalidatepage()
      ext4: fix deadlock in journal_unmap_buffer()

Javier Martinez Canillas (3):
      ARM: OMAP2+: enable devtmpfs and devtmpfs automount
      ARM: OMAP2+: omap2plus_defconfig: enable twl4030 SoC audio
      leds: leds-gpio: set devm_gpio_request_one() flags param correctly

Jerome Glisse (4):
      drm/radeon: don't leave fence blocked process on failed GPU reset
      drm/radeon: avoid deadlock in pm path when waiting for fence
      drm/radeon: restore modeset late in GPU reset path
      drm/radeon: add support for MEM_WRITE packet

Jon Hunter (1):
      ARM: OMAP2+: PMU: Remove unused header

Julia Lawall (1):
      arch/arm/mach-omap2/dpll3xxx.c: drop if around WARN_ON

Krzysztof Mazur (1):
      i915: ensure that VGA plane is disabled

Li Wang (1):
      eCryptfs: Avoid unnecessary disk read and data decryption during writing

Li Zefan (1):
      netprio_cgroup: define sk_cgrp_prioidx only if NETPRIO_CGROUP is enabled

Linus Torvalds (1):
      Linux 3.8-rc2

Lucas Stach (6):
      drm: tegra: fix front_porch <-> back_porch mixup
      drm: tegra: don't leave clients host1x member uninitialized
      drm: tegra: protect DC register access with mutex
      drm: tegra: remove redundant tegra2_tmds_config entry
      drm: tegra: clean out old gem prototypes
      drm: tegra: program only one window during modeset

Marciniszyn, Mike (2):
      IB/rds: Correct ib_api use with gs_dma_address/sg_dma_len
      IB/rds: suppress incompatible protocol when version is known

Maxime Ripard (2):
      ARM: multi_v7_defconfig: Add ARCH_SUNXI
      sunxi: Change the machine compatible string.

Mel Gorman (1):
      mm: mempolicy: Convert shared_policy mutex to spinlock

Michael Tokarev (1):
      ext4: do not try to write superblock on ro remount w/o journal

Myron Stowe (1):
      PCI: Work around Stratus ftServer broken PCIe hierarchy (fix DMI check)

Peter Ujfalusi (1):
      ARM: OMAP2+: omap_twl: Change TWL4030_MODULE_PM_RECEIVER to
TWL_MODULE_PM_RECEIVER

Rafael J. Wysocki (1):
      Partly revert "[media] uvcvideo: Set error_idx properly for
extended controls API failures"

Richard Cochran (2):
      cpts: fix build error by removing useless code.
      cpts: fix a run time warn_on.

Sage Weil (1):
      libceph: fix protocol feature mismatch failure path

Srinivas Kandagatla (1):
      ARM/omap: use module_platform_driver macro

Stefan Hasko (1):
      net: sched: integer overflow fix

Theodore Ts'o (2):
      ext4: lock i_mutex when truncating orphan inodes
      ext4: avoid hang when mounting non-journal filesystems with orphan list

Tony Lindgren (3):
      MAINTAINERS: Add an entry for omap related .dts files
      ARM: OMAP: Split fb.c to remove last remaining cpu_is_omap usage
      ARM: OMAP2+: Drop plat/cpu.h for omap2plus

Wei Yongjun (2):
      ARM: OMAP4: remove duplicated include from omap_hwmod_44xx_data.c
      eCryptfs: fix to use list_for_each_entry_safe() when delete items

YOSHIFUJI Hideaki (1):
      OMAP2: Fix a typo - replace regist with register.

Yan Burman (1):
      net/vxlan: Use the underlying device index when joining/leaving
multicast groups

Zlatko Calusic (2):
      mm: modify pgdat_balanced() so that it also handles order-0
      mm: fix null pointer dereference in wait_iff_congested()
