Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1ESFFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:05:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104Ab1ESFFR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:05:17 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 May 2011 22:04:53 -0700
Message-ID: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com>
Subject: Linux 2.6.39
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's delayed a few days, and I really was struggling with the
decision of whether I wanted to cut a final release at all: it could
easily have made more sense to just do an -rc8. However, since I'm
going to be at LinuxCon Japan in two weeks, the choice for me ended up
whether I should just release, or drag it out *three* more weeks, or
have some really messy merge window with a break in between.

None of those choices really looked all that great.  There were
certainly more code changes since -rc7 than I really was all that
happy with, and some outstanding discussion. Doing another -rc
wouldn't necessarily have been a bad idea, but then I just decided
that if I held off making the release, next week my timing choices
would have been even worse.

So there it is. The one thing that pushed me over the edge is that
this release window has been fairly "easy". -rc2 was calm, -rc3 was
_really_ calm, and -rc7 was tiny. And while this has more commits than
-rc7 had, I didn't feel like that changed the overall picture much: we
really did have much less churn after the merge window closed than we
usually do. Which actually makes me pretty happy about the state of
2.6.39.

(Just to put that "calm after the merge window" in quantitative
numbers: doing some git statistics, we have fewer commits after -rc1
than any of the last ten releases).

As to the merge window for 2.6.40 (which is obviously open now):
because of the delay, the normal 14 days would be with the last two
days when I'm already in Japan. Which is certainly not unthinkable
(I'll have my laptop and access to wifi, and could do some final
tweaks that way even if I wouldn't want to do a bigger portion of a
merge window while traveling). But I do want to warn that if I get the
feeling that I've merged "enough", I might just make it easier for
myself and cut it two days short and release just before I leave on
Memorial day (which for the non-US based of you is May 30th this
year).

Having a slightly shorter (and actually smaller, not just more
hurried) merge window and release cycle for 2.6.40 might not be a
horrible fate. Of course, I just know that you're all actively trying
to sabotage that dream of mine.

But I can still dream, can't I?

                           Linus

---
Alex Deucher (4):
      drm/radeon/kms: fix cayman acceleration
      drm/radeon/kms: fix tiling reg on fusion
      drm/radeon/kms: fix extended lvds info parsing
      drm/radeon/kms: add some evergreen/ni safe regs

Alexander Stein (2):
      Input: ads7846 - make transfer buffers DMA safe
      Input: ads7846 - remove unused variable from struct ads7845_ser_req

Alexandre Bounine (1):
      rapidio: fix default routing initialization

Andi Kleen (2):
      mm: add alloc_pages_exact_nid()
      memcg: allocate memory cgroup structures in local nodes

Andy Adamson (2):
      NFSv41: Resend on NFS4ERR_RETRY_UNCACHED_REP
      NFSv4.1: remove pnfs_layout_hdr from pnfs_destroy_all_layouts tmp_list

Andy Lutomirski (2):
      drm/i915: Revert i915.semaphore=1 default from i915 merge
      drm/i915: Revert i915.semaphore=1 default from 47ae63e0

Anton Blanchard (1):
      ehea: Fix memory hotplug oops

Arnaldo Carvalho de Melo (2):
      perf tools: Honour the cpu list parameter when also monitoring a
thread list
      perf evlist: Fix per thread mmap setup

Arnd Bergmann (1):
      ARM: 6892/1: handle ptrace requests to change PC during
interrupted system calls

Avinash H.M (1):
      OMAP3: set the core dpll clk rate in its set_rate function

Axel Lin (2):
      mfd: Fix asic3 build error
      drivers/leds/leds-lm3530.c: add MODULE_DEVICE_TABLE

Ben Dooks (1):
      drivers/rtc/rtc-s3c.c: fixup wake support for rtc

Ben Hutchings (3):
      ipheth: Properly distinguish length and alignment in URBs and skbs
      sfc: Always map MCDI shared memory as uncacheable
      sfc: Fix oops in register dump after mapping change

Borislav Petkov (2):
      Revert "x86, AMD: Fix APIC timer erratum 400 affecting K8
Rev.A-E processors"
      x86, AMD: Fix ARAT feature setting again

Bruno Prémont (1):
      Further fbcon sanity checking

Catalin Marinas (2):
      MIPS: Rename .data..mostly and properly handle it in linker script
      ARM: 6870/1: The mandatory barrier rmb() must be a dsb() in for
device accesses

Chris Ball (1):
      Revert "mmc: fix a race between card-detect rescan and
clock-gate work instances"

Chris Wilson (1):
      drm: Take lock around probes for drm_fb_helper_hotplug_event

Christian Borntraeger (1):
      [S390] disassembler: handle b280/spp instruction

Cliff Wickman (1):
      x86: Fix UV BAU for non-consecutive nasids

Dan Rosenberg (1):
      dccp: handle invalid feature options length

Dan Williams (1):
      net/usb: mark LG VL600 LTE modem ethernet interface as WWAN

Daniel J Blueman (1):
      Prevent oopsing in posix_acl_valid()

Dave Airlie (2):
      drm/radeon: fix cayman struct accessors.
      drm/radeon/nouveau: fix build regression on alpha due to Xen changes.

Dave Chinner (5):
      xfs: ensure reclaim cursor is reset correctly at end of AG
      xfs: exit AIL push work correctly when AIL is empty
      xfs: always push the AIL to the target
      xfs: make AIL target updates and compares 32bit safe.
      xfs: fix race condition in AIL push trigger

David Daney (4):
      MIPS: Mask jump target in ftrace_dyn_arch_init_insns().
      MIPS: Octeon: Cleanup Kconfig IRQ_CPU* symbols.
      MIPS: Octeon: Guard the Kconfig body with CPU_CAVIUM_OCTEON
      MIPS: Invalidate old TLB mappings when updating huge page PTEs.

David Rientjes (1):
      slub: Revert "[PARISC] slub: fix panic with DISCONTIGMEM"

Eric Dumazet (4):
      net: ip_expire() must revalidate route
      netfilter: fix ebtables compat support
      vlan: fix GVRP at dismantle time
      net: dev_close() should check IFF_UP

Eric Paris (1):
      SELinux: delete debugging printks from filename_trans rule processing

Fernando Luis Vazquez Cao (2):
      netfilter: IPv6: initialize TOS field in REJECT target module
      netfilter: IPv6: fix DSCP mangle code

Florian Fainelli (1):
      MIPS: AR7: Fix GPIO register size for Titan variant.

Florian Mickler (1):
      vga_switcheroo: don't toggle-switch devices

Florian Westphal (1):
      netfilter: ebtables: only call xt_compat_add_offset once per rule

Geert Uytterhoeven (3):
      zorro8390: Fix regression caused during net_device_ops conversion
      hydra: Fix regression caused during net_device_ops conversion
      ne-h8300: Fix regression caused during net_device_ops conversion

Grant Likely (1):
      drivercore: revert addition of of_match to struct device

Hans Schillstrom (3):
      IPVS: Change of socket usage to enable name space exit.
      IPVS: init and cleanup restructuring
      IPVS: fix netns if reading ip_vs_* procfs entries

Hans Verkuil (1):
      [media] v4l2-subdev: fix broken subdev control enumeration

Harry Wei (1):
      MAINTAINERS: fix sorting

Heiko Carstens (1):
      [S390] sclp/memory hotplug: fix initial usecount of increments

Henry C Chang (3):
      ceph: print debug message before put mds session
      ceph: fix list_add in ceph_put_snap_realm
      ceph: do not use i_wrbuffer_ref as refcount for Fb cap

Hugh Dickins (4):
      tmpfs: fix race between umount and writepage
      tmpfs: fix race between umount and swapoff
      tmpfs: fix spurious ENOSPC when racing with unswap
      tmpfs: fix race between swapoff and writepage

Ingo Molnar (1):
      vsprintf: Turn kptr_restrict off by default

Jack Steiner (1):
      x86, UV: Fix NMI handler for UV platforms

Jeff Layton (2):
      cifs: add fallback in is_path_accessible for old servers
      cifs: fix cifsConvertToUCS() for the mapchars case

Jens Axboe (1):
      scsi: remove performance regression due to async queue run

Jiri Olsa (1):
      kprobes, x86: Disable irqs during optimized callback

Joel Becker (2):
      configfs: Don't try to d_delete() negative dentries.
      configfs: Fix race between configfs_readdir() and configfs_d_iput()

John Stultz (9):
      clocksource: Install completely before selecting
      rtc: ds1286: Initialize drvdata before registering device
      rtc: m41t80: Initialize clientdata before registering device
      rtc: max8925: Initialize drvdata before registering device
      rtc: max8998: Initialize drvdata before registering device
      rtc: msm6242: Initialize drvdata before registering device
      rtc: pcap: Initialize drvdata before registering device
      rtc: rp5c01: Initialize drvdata before registering device
      alpha: convert to clocksource_register_hz

Jonas Gorski (1):
      MIPS: bcm63xx: Fix header_crc comment in bcm963xx_tag.h

Juergen Kilb (1):
      mfd: Fixed gpio polarity of omap-usb gpio USB-phy reset

Julia Lawall (1):
      x86, mce, AMD: Fix leaving freed data in a list

KAMEZAWA Hiroyuki (1):
      memcg: fix zone congestion

Kleber Sacilotto de Souza (1):
      ehea: fix wrongly reported speed and port

Konrad Rzeszutek Wilk (1):
      Revert "xen/mmu: Add workaround "x86-64, mm: Put early page table high""

Kurt Van Dijck (1):
      can: fix SJA1000 dlc for RTR packets

Lars-Peter Clausen (5):
      ASoC: JZ4740: Fix i2s shutdown
      ASoC: SSM2602: Properly annotate i2c probe and remove functions
      ASoC: SSM2602: Fix 'Mic Boost2' control
      ASoC: SSM2602: Fix reg_cache_size
      MIPS: JZ4740: Set one-shot feature flag for the clockevent

Laurent Pinchart (2):
      [media] v4l: Release module if subdev registration fails
      omap: iommu: Return IRQ_HANDLED in fault handler when no fault occured

Lawrence Rust (1):
      [media] Fix cx88 remote control input

Lesly A M (1):
      mfd: Fix for the TWL4030 PM sleep/wakeup sequence

Li Zefan (3):
      fs: remove FS_COW_FL
      Btrfs: fix FS_IOC_GETFLAGS ioctl
      Btrfs: fix FS_IOC_SETFLAGS ioctl

Linus Torvalds (7):
      Revert "Bluetooth: fix shutdown on SCO sockets"
      fbcon: add lifetime refcount to opened frame buffers
      fbmem: make read/write/ioctl use the frame buffer at open time
      Revert "drm/i915: Only enable the plane after setting the fb
base (pre-ILK)"
      vfs: micro-optimize acl_permission_check()
      fbmem: fix remove_conflicting_framebuffers races
      Linux 2.6.39

Luciano Coelho (1):
      mac80211: don't start the dynamic ps timer if not associated

M. Mohan Kumar (1):
      net/9p: Handle get_user_pages_fast return properly

Manuel Lauss (1):
      MIPS: Alchemy: fix xxs1500 build error

Marcus Meissner (1):
      ocfs2: Initialize data_ac (might be used uninitialized)

Marek Belisko (1):
      ASoC: UDA134x: Remove POWER_OFF_ON_STANDBY define.

Mark Brown (1):
      ASoC: Don't crash on PM operations

Martin Schwidefsky (2):
      [S390] oprofile: fix min/max interval query checks
      [S390] fix alloc_pgste check in init_new_context

Matvejchikov Ilya (1):
      NET: slip, fix ldisc->open retval

Mel Gorman (1):
      mm: tracing: add missing GFP flags to tracing

Michael Cree (1):
      alpha: Wire up syscalls new to 2.6.39

Michael Holzheu (2):
      [S390] kernel: Initialize register 14 when starting new CPU
      [S390] replace diag10() with diag10_range() function

Michał Mirosław (1):
      net: Change netdev_fix_features messages loglevel

Miklos Szeredi (1):
      fuse: fix oops in revalidate when called with NULL nameidata

Milton Miller (1):
      of: fix race when matching drivers

Minchan Kim (1):
      mm: check PageUnevictable in lru_deactivate_fn()

Ming Lei (1):
      usbnet: runtime pm: fix out of memory

Mohammed Shafi Shajakhan (1):
      ath9k: Fix a warning due to a queued work during S3 state

Nicolas Pitre (3):
      ARM: zImage: make sure the stack is 64-bit aligned
      ARM: zImage: make sure not to relocate on top of the relocation code
      ARM: zImage: the page table memory must be considered before relocation

Oliver Hartkopp (1):
      slcan: fix ldisc->open retval

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: fix timestamp support for new conntracks
      netfilter: revert a2361c8735e07322023aedc36e4938b35af31eb0

Paul Fox (1):
      libertas: fix cmdpendingq locking

Pedro Scarapicchia Junior (1):
      net/9p/protocol.c: Fix a memory leak

Rafael J. Wysocki (3):
      PM: Fix warning in pm_restrict_gfp_mask() during SNAPSHOT_S2RAM ioctl
      PM / Hibernate: Make snapshot_release() restore GFP mask
      PM / Hibernate: Fix ioctl SNAPSHOT_S2RAM

Ralf Baechle (21):
      MIPS: c-r4k: Fix GCC 4.6.0 build error
      MIPS: tlbex: Fix GCC 4.6.0 build error
      MIPS: IP22: Fix GCC 4.6.0 build error
      MIPS: IP22: Fix GCC 4.6.0 build error
      MIPS: Malta: Fix GCC 4.6.0 build error
      MIPS: Malta: Fix GCC 4.6.0 build error
      MIPS: SNI: Fix GCC 4.6.0 build error
      MIPS: Jazz: Fix GCC 4.6.0 build error
      MIPS: Loongson: Fix GCC 2.6.0 build error.
      MIPS: MSP: Fix build error
      MIPS: IP27: Fix GCC 4.6.0 build error.
      MIPS: IP27: Fix GCC 4.6.0 build error.
      MIPS: Document former use of timerfd(2) syscall number.
      MIPS: Alchemy: Fix GCC 4.6.0 build error.
      MIPS: Fix calc_vmlinuz_load_addr build warnings.
      MIPS: Audit: Fix success success argument pass to audit_syscall_exit
      MIPS: JZ4740: Fix GCC 4.6.0 build error.
      MIPS: JZ4740: Export symbols to the watchdog driver module
      MIPS: RB532: Fix iomap resource size miscalculation.
      MIPS: Fix duplicate invocation of notify_die.
      MIPS: Kludge IP27 build for 2.6.39.

Randy Dunlap (2):
      mm: fix kernel-doc warning in page_alloc.c
      procfs: add stub for proc_mkdir_mode()

Richard Weinberger (1):
      um: fix abort

Roland Dreier (1):
      vmxnet3: Consistently disable irqs when taking adapter->cmd_lock

Russell King (2):
      ARM: RiscPC: etherh: fix section mismatches
      ARM: RiscPC: acornfb: fix section mismatches

Ryusuke Konishi (1):
      nilfs2: fix infinite loop in nilfs_palloc_freev function

Sage Weil (1):
      rbd: fix leak of ops struct

Sam Ravnborg (2):
      sparc32: fix section mismatch warnings in apc, pmc and time_32
      sparc32: fix sparcstation 5 boot

Sedat Dilek (1):
      x86/mm: Fix section mismatch derived from native_pagetable_reserve()

Serge E. Hallyn (1):
      Cache user_ns in struct cred

Sergio Aguirre (1):
      [media] V4L: soc-camera: regression fix: calculate .sizeimage in
soc_camera.c

Shaohua Li (1):
      block: don't delay blk_run_queue_async

Somnath Kotur (1):
      be2net: Fixed bugs related to PVID.

Stanislaw Gruszka (1):
      iwlegacy: fix IBSS mode crashes

Stefan Haberland (1):
      [S390] dasd: prevent IO error during reserve/release loop

Stefano Stabellini (1):
      x86,xen: introduce x86_init.mapping.pagetable_reserve

Steffen Klassert (2):
      xfrm: Assign the inner mode output function to the dst entry
      xfrm: Don't allow esn with disabled anti replay detection

Steinar H. Gunderson (1):
      ipv6: restore correct ECN handling on TCP xmit

Stephen Hemminger (2):
      bridge: fix forwarding of IPv6
      bridge: fix forwarding of IPv6

Stephen Warren (1):
      ASoC: WM8903: Fix Digital Capture Volume range

Sunil Mushran (5):
      ocfs2/dlm: Use negotiated o2dlm protocol version
      ocfs2/cluster: Increase the live threshold for global heartbeat
      ocfs2/cluster: Heartbeat mismatch message improved
      ocfs2: Skip mount recovery for hard-ro mounts
      ocfs2/dlm: Target node death during resource migration leads to
thread spin

Tejun Heo (5):
      block: unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe drivers
      cdrom: always check_disk_change() on open
      block: rescan partitions on invalidated devices on -ENOMEDIA too
      Revert "libata: ahci_start_engine compliant to AHCI spec"
      libata: fix oops when LPM is used with PMP

Thomas Gleixner (1):
      tick: Clear broadcast active bit when switching to oneshot

Thomas Jarosch (1):
      vmxnet3: Fix inconsistent LRO state after initialization

Tkhai Kirill (1):
      sparc32: Fixed unaligned memory copying in function
__csum_partial_copy_sparc_generic

Tomoya (1):
      pch_gbe: support ML7223 IOH

Tony Lindgren (1):
      ARM: zImage: Fix bad SP address after relocating kernel

Toshiharu Okada (2):
      PCH_GbE : Fixed the issue of collision detection
      PCH_GbE : Fixed the issue of checksum judgment

Tristan Ye (1):
      ocfs2: skip existing hole when removing the last extent_rec in
punching-hole codes.

Trond Myklebust (1):
      NFSv4.1: Ensure that layoutget uses the correct gfp modes

Uwe Kleine-König (1):
      rtc: mc13xxx: Don't call rtc_device_register while holding lock

Vitalii Demianets (1):
      bonding,llc: Fix structure sizeof incompatibility for some PDUs

Vivek Goyal (1):
      blk-throttle: Use task_subsys_state() to determine a task's blkio_cgroup

Will Deacon (1):
      ARM: 6890/1: memmap: only free allocated memmap entries when
using SPARSEMEM

Wolfram Sang (4):
      rtc: mxc: Initialize drvdata before registering device
      rtc: davinci: Initialize drvdata before registering device
      rtc: ep93xx: Initialize drvdata before registering device
      i2c: pnx: Fix crash due to wrong init of timer->data

Wu Zhangjin (1):
      MIPS: Hibernation: Fixes for PAGE_SIZE >= 64kb

Yehuda Sadeh (1):
      rbd: fix split bio handling

Yinghai Lu (2):
      mm: use alloc_bootmem_node_nopanic() on really needed path
      PCI: Clear bridge resource flags if requested size is 0

Yoichi Yuasa (1):
      MIPS: MSP71xx: Fix typo in msp_per_irq_controller

Youquan Song (1):
      x86, apic: Fix spurious error interrupts triggering on all non-boot APs

liubo (1):
      Btrfs: fix easily get into ENOSPC in mixed case

stephen hemminger (1):
      tcp_cubic: limit delayed_ack ratio to prevent divide error

xingchao (1):
      ASoC: sst_platform: add hw_free callback to fix resource leak
