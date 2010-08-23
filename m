Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab0HWBaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:30:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab0HWB36 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:29:58 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 Aug 2010 18:28:58 -0700
Message-ID: <AANLkTimDb8TnN_bDu-9C51+seppHM9SQhtJUOebZmW4f@mail.gmail.com>
Subject: Linux 2.6.36-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc. I didn't really ever get around to
announcing -rc1 when I released it, and we had enough niggling small
problems (like a memory corruptor in the HID layer that ended up
causing some random problems etc) there that I never got around to
fixing that lack of announcement. And hopefully -rc2 is a good point
to correct the lack of earlier commentary.

The main commentary about it is that I'll be back in "fairly strict"
mode as of -rc2. IOW, send me regression fixes only. Really. I already
dropped some git pull requests that were a bit too obviously new
feature stuff after the merge window closed, but I let some others
through (in some cases because I really wanted the features, like some
of the VFS pulls). But no more. I'm going to be pretty strict about
just taking real fixes. I think it helped during the 2.6.35
stabilization window, and so I think it's worth doing for 2.6.36 too.

Apart from the VFS updates (that bring in just a small part of Nick's
scalability patch, and sadly not the most interesting part), the other
big merge in -rc2 is the intel graphics update. I'm not hugely happy
about the timing of it, but I think I needed to pull it. Apart from
that, there's a number of random fixes all over, the appended shortlog
gives you a taste of it.

Going back to -rc1 - the big "fundamental" things merged this merge
window were likely

 (a) fanotify (and I really am not going to take another notification
rewrite for a couple of _years_ now. Enough is enough. If this isn't
good enough, then the next time around somebody wants to rejigger the
notification layer, they had better have some d*mn strong arguments.)

 (b) the workqueue work. Let's hope this really gets rid of various
ad-hoc subsystem per-CPU threads etc.

 (c) various VM layer updates (writeback and oom) that I hope will be
much less painful than they were for 2.6.35.

but as usual, the bulk of the updates were just all the normal driver
updates. The arch subdirectory shrunk by an appreciable amount due to
continuing defconfig cleanups, but the driver additions more than made
up for the lines deleted in defconfigs.

Go forth and test,

                    Linus

---
Adrian Drzewiecki (1):
      md: Notify sysfs when RAID1/5/10 disk is In_sync.

Al Viro (2):
      hostfs: dumb (and usually harmless) tpyo - strncpy instead of strlcpy
      hostfs ->follow_link() braino

Alexander Shishkin (1):
      cramfs: only unlock new inodes

Andrea Righi (6):
      kfifo: implement missing __kfifo_skip_r()
      kfifo: add kfifo_skip() testcase
      kfifo: add explicit error checking in byte stream example
      kfifo: fix kernel BUG in dma example
      kfifo: fix a memory leak in dma example
      kfifo: add explicit error checking in all the examples

Andreas Gruenbacher (1):
      mbcache: Limit the maximum number of cache entries

Andrew Morton (2):
      revert "hwmon: f71882fg: add support for the Fintek F71808E"
      drivers/scsi/qla4xxx: fix build

Andy Chittenden (1):
      SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)

Anton Vorontsov (1):
      booting-without-of: Remove nonexistent chapters from TOC, fix numbering

Arjan van de Ven (1):
      workqueue: Add basic tracepoints to track workqueue execution

Arnaldo Carvalho de Melo (1):
      perf annotate tui: Fix exit and RIGHT keys handling

Axel Lin (1):
      pxa3xx: fix ns2cycle equation

Bernd Petrovitsch (1):
      perf tools: Fix build on POSIX shells

Borislav Petkov (1):
      x86, hotplug: Serialize CPU hotplug to avoid bringup concurrency issues

Brian Norris (1):
      mtd: nand: Fix regression in BBM detection

Bruno Prémont (1):
      HID: picolcd: correct ordering of framebuffer freeing

Carsten Otte (1):
      slab: fix object alignment

Chris Ball (2):
      HID: hiddev: protect against disconnect/NULL-dereference race
      USB HID: Add ID for eGalax Multitouch used in JooJoo tablet

Chris Wilson (43):
      drm/i915: Remove useless message when disabling "Big FIFO" on PineView
      drm/i915: Do not clobber the contents of TRANS_DP_CTL when enabling.
      drm/i915: Subclass intel_encoder.
      drm/i915: Subclass intel_connector.
      drm/i915/sdvo: Propagate errors from reading/writing control bus.
      drm/i915/sdvo: Use an integer mapping for supported tv format modes
      drm/i915/sdvo: Check for allocation failure when constructing properties
      drm/i915/sdvo: Add missing TV filters
      drm/i915/sdvo: Add dot crawl property
      drm/i915: Only emit flushes on active rings.
      drm/i915: Mark the static memory latency tables const.
      drm/i915: report all active objects as busy
      drm/i915: Disable the cursor for DPMS_OFF
      drm/i915: Emit a backtrace if we attempt to rebind a pinned buffer
      drm/i915: Unroll wrapping of the ringbuffer.
      drm/i915: Move ringbuffer accounting to begin/advance.
      drm/i915: Inline ringbuffer_emit()
      drm/i915: Use an uncommon name for the local dev_priv in macros
      drm/i915: Capture the overlay status upon a GPU hang.
      drm/i915: Append the object onto the inactive list on binding.
      drm/i915: Use a common seqno for all rings.
      drm/i915: Move the eviction logic to its own file.
      drm/i915: Implement fair lru eviction across both rings. (v2)
      drm/i915: Maintain LRU order of inactive objects upon access by CPU (v2)
      drm/i915: Record error batch buffers using iomem
      drm/i915/sdvo: Markup a few constant strings.
      drm/i915: Enable aspect/centering panel fitting for Ironlake.
      drm/i915: Write to display base last.
      drm/i915: Truncate the shmem backing pages on purge
      drm/i915/display: Add pipe/plane information to dpms debugging
      drm/i915/opregion: Use ASLE response codes defined in 0.1
      drm/i915: Update watermarks for Ironlake after dpms changes
      drm/i915/ringbuffer: Set ring->gem_buffer = NULL on init unwind
      drm/i915: Ensure that while(INREG()) are bounded (v2)
      drm/i915/edp: Flush the write before waiting for PLLs
      drm/i915: FBC is updated within set_base() so remove second call
in mode_set()
      drm/i915: Only update i845/i865 CURBASE when disabled (v2)
      drm/i915: Apply i830 errata for cursor alignment
      drm/i915: Wake-up wait_request() from elapsed hang-check (v2)
      drm/i915/sdvo: Only set is_lvds if we have a valid fixed mode.
      drm/i915/suspend: Flush register writes before busy-waiting.
      drm/i915/suspend: s/IS_IRONLAKE/HAS_PCH_SPLIT/
      drm/i915: Remove the conflicting BUG_ON()

Christoph Hellwig (2):
      kill BH_Ordered flag
      remove SWRITE* I/O types

Dan Carpenter (2):
      HID: picolcd: testing the wrong variable
      intel_ips: potential null dereference

Daniel J Blueman (1):
      Fix unprotected access to task credentials in waitid()

Daniel Kiper (1):
      x86, apic: Fix apic=debug boot crash

Daniel Vetter (3):
      drm/i915: fixup pageflip ringbuffer commands for i8xx
      drm/i915: i8xx also doesn't like multiple oustanding pageflips
      drm/i915: prepare for fair lru eviction

Dave Airlie (1):
      i915: disable DAC on Ironlake also when doing CRT load detection.

David Howells (2):
      Make do_execve() take a const filename pointer
      Fix the declaration of sys_execve() in asm-generic/syscalls.h

David Miller (1):
      arcmsr_hba: Missing slab.h include

David S. Miller (5):
      Revert "netlink: netlink_recvmsg() fix"
      sparc: Really fix "console=" for serial consoles.
      sparc: Hook up new fanotify and prlimit64 syscalls.
      sparc64: Fix rwsem constant bug leading to hangs.
      sparc64: Fix atomic64_t routine return values.

Davidlohr Bueso (1):
      nfs: Remove redundant NULL check upon kfree()

Eric Dumazet (2):
      netfilter: {ip,ip6,arp}_tables: avoid lockdep false positive
      net sched: fix some kernel memory leaks

Eric Miao (1):
      arm,kgdb: fix GDB_MAX_REGS no longer used

Ernst Schwab (1):
      spi.h: missing kernel-doc notation, please fix

Graeme Smecher (1):
      of: fix missing headers for of_address_to_resource() in MTD and
SysACE drivers

Grant Likely (1):
      of: Fix missing includes

Greg Ungerer (1):
      m68knommu: include sched.h in ColdFire/SPI driver

H. Peter Anvin (1):
      x86-32: Fix dummy trampoline-related inline stubs

Hans Rosenfeld (1):
      x86, cpu: Fix regression in AMD errata checking code

Henrique de Moraes Holschuh (4):
      thinkpad-acpi: find ACPI video device by synthetic HID
      thinkpad-acpi: untangle ACPI/vendor backlight selection
      thinkpad-acpi: lock down size of hotkey keymap
      thinkpad-acpi: add support for model-specific keymaps

Herbert Xu (1):
      xfrm: Use GFP_ATOMIC in xfrm_compile_policy

Huang Ying (1):
      tracing: Fix ring_buffer_read_page reading out of page boundary

Hugh Dickins (1):
      shmem: put_super must percpu_counter_destroy

J. R. Okajima (1):
      NFS: fix the return value of nfs_file_fsync()

Jan Kara (2):
      vfs: update ctime when changing the file's permission by setfacl
      lib/radix-tree.c: fix overflow in radix_tree_range_tag_if_tagged()

Jarek Poplawski (1):
      net: Fix a memmove bug in dev_gro_receive()

Jaroslav Kysela (1):
      ALSA: emu10k1 - delay the PCM interrupts (add pcm_irq_delay parameter)

Jason Wessel (3):
      kdb: fix compile error without CONFIG_KALLSYMS
      vt: fix regression warnings from KMS merge
      vt,console,kdb: preserve console_blanked while in kdb

Jate Sujjavanich (1):
      m68knommu: arch/m68k/include/asm/ide.h fix for nommu

Jens Taprogge (1):
      thinkpad-acpi: Add KEY_CAMERA (Fn-F6) for Lenovo keyboards

Jesse Barnes (5):
      drm/i915: add panel reset workaround
      drm/i915: eDP mode set sequence corrections
      drm/i915: fix VGA plane disable for Ironlake+
      drm/i915: make sure eDP PLL is enabled at the right time
      drm/i915: wait for actual vblank, not just 20ms

Jiri Kosina (1):
      HID: hiddev: fix memory corruption due to invalid intfdata

Jiri Slaby (1):
      AppArmor: fix task_setrlimit prototype

Joerg Roedel (1):
      x86-32: Separate 1:1 pagetables from swapper_pg_dir

John W. Linville (1):
      ipw2100: register pm_qos request before registering pci driver

Julia Lawall (1):
      drivers/platform/x86: Adjust confusing if indentation

KOSAKI Motohiro (3):
      oom: fix NULL pointer dereference
      oom: fix tasklist_lock leak
      oom: __task_cred() need rcu_read_lock()

KUMANO Syuhei (1):
      kprobes/x86: Fix the return address of multiple kretprobes

Kailang Yang (1):
      ALSA: hda - Fix ALC680 base model capture

Kulikov Vasiliy (2):
      x86: intel_ips: do not use PCI resources before pci_enable_device()
      m68knommu: formatting of pointers in printk()

Kusanagi Kouichi (1):
      perf tools: Fix build error on read only source.

Kyungmin Park (4):
      s5pc110: SDHCI-s3c can override host capabilities
      s5pc110: SDHCI-s3c support on s5pc110
      sdhci: add no hi-speed bit quirk support
      drivers/mmc/host/sdhci-s3c.c: use the correct mutex and card
detect function

Linus Torvalds (4):
      mm: make the vma list be doubly linked
      mm: make the mlock() stack guard page checks stricter
      mm: make stack guard page logic use vm_prev pointer
      Linux 2.6.36-rc2

Marcin Slusarz (1):
      tracing: Sanitize value returned from write(trace_marker, "...", len)

Mark Brown (1):
      ASoC: Remove DSP mode support for WM8776

Maxim Levitsky (1):
      ath5k: disable ASPM L0s for all cards

Michal Marek (1):
      ARM: 6328/1: Build with -fno-dwarf2-cfi-asm

Michal Simek (2):
      microblaze: Fix of/address: Merge all of the bus translation code
      microblaze: Fix of: eliminate of_device->node and
dev_archdata->{of,prom}_node

Mikael Pettersson (1):
      ARM: 6329/1: wire up sys_accept4() on ARM

Mike Frysinger (1):
      tracing: Extend recordmcount to better support Blackfin mcount

Miklos Szeredi (1):
      uml: fix compile error in dma_get_cache_alignment()

Min Zhang (1):
      ipv6: remove sysctl jiffies conversion on gc_elasticity and min_adv_mss

Namhyung Kim (2):
      slub: add missing __percpu markup in mm/slub_def.h
      kgdb: add missing __percpu markup in arch/x86/kernel/kgdb.c

Neil Brown (1):
      NFS: allow close-to-open cache semantics to apply to root of NFS
filesystem

NeilBrown (3):
      Update recovery_offset even when external metadata is used.
      md: provide appropriate return value for spare_active functions.
      md raid-1/10 Fix bio_rw bit manipulations again

Nick Piggin (10):
      fs: fix do_lookup false negative
      fs: dentry allocation consolidation
      apparmor: use task path helpers
      fs: fs_struct rwlock to spinlock
      fs: remove extra lookup in __lookup_hash
      fs: cleanup files_lock locking
      tty: fix fu_list abuse
      lglock: introduce special lglock and brlock spin locks
      fs: scale files_lock
      fs: brlock vfsmount_lock

Ondrej Zary (1):
      matroxfb: fix incorrect use of memcpy_toio()

Patrick J. LoPresti (1):
      nfs: Add "lookupcache" to displayed mount options

Rajkumar Manoharan (2):
      ath9k_htc: fix panic on packet injection using airbase-ng tool.
      ath9k_htc: load proper firmware for device ID 7015

Randy Dunlap (1):
      latencytop: Fix kconfig dependency warnings

Russell King (2):
      ARM: Tighten check for allowable CPSR values
      VIDEO: amba clcd: don't disable an already disabled clock

Ryusuke Konishi (3):
      nilfs2: fix list corruption after ifile creation failure
      nilfs2: fix false warning saying one of two super blocks is broken
      nilfs2: wait for discard to finish

Samuel Thibault (1):
      Replace Configure with Enable in description of MAXSMP

Sergey Senozhatsky (1):
      fix reiserfs_evict_inode end_writeback second call

Shaohua Li (1):
      tracing: Fix an unallocated memory access in function_graph

Stefan Richter (1):
      Documentation: kernel-locking: mutex_trylock cannot be used in
interrupt context

Stephen Rothwell (3):
      ata: update for of_device to platform_device replacement
      MAINTAINERS: Fix ozlabs.org mailing list addresses
      Documentation: fix ozlabs.org mailing list address

Steve Wise (1):
      xprtrdma: Do not truncate iova_start values in frmr registrations.

Steven Rostedt (1):
      tracing/events: Convert format output to seq_file

Takashi Iwai (2):
      ALSA: riptide - Fix detection / load of firmware files
      ALSA: hda - Add quirk for Dell Vostro 1220

Tilman Sauerbeck (1):
      mtd: nand: Fix probe of Samsung NAND chips

Tom Tucker (1):
      rpcrdma: Fix SQ size calculation when memreg is FRMR

Tony Luck (1):
      [IA64] Fix build error: conflicting types for ‘sys_execve’

Trond Myklebust (2):
      NFS: Fix the selection of security flavours in Kconfig
      NFS: Fix an Oops in the NFSv4 atomic open code

Uwe Kleine-König (1):
      mmc: build fix: mmc_pm_notify is only available with CONFIG_PM=y

Victor van den Elzen (1):
      platform/x86: move rfkill for Dell Mini 1012 to compal-laptop

Vivek Natarajan (1):
      ath9k_htc: Fix disconnect issue in HT40 mode.

Xiao Guangrong (1):
      KVM: PIT: free irq source id in handling error path

Xiaotian Feng (2):
      KVM: fix poison overwritten caused by using wrong xstate size
      KVM: destroy workqueue on kvm_create_pit() failures

Yuri Kululin (1):
      wl1251: fix trigger scan timeout usage

Zhang, Yanmin (1):
      perf, x86: Fix Intel-nhm PMU programming errata workaround

Zhenyu Wang (3):
      agp/intel: set 40-bit dma mask on Sandybridge
      drm/i915: fix render pipe control notify on sandybridge
      drm/i915,intel_agp: Add support for Sandybridge D0

Zou Nan hai (3):
      drm/i915 invalidate indirect state pointers at end of ring exec
      drm/i915: Set up a render context on Ironlake
      drm/i915: Enable RC6 on Ironlake.

eric miao (1):
      ARM: 6326/1: kgdb: fix GDB_MAX_REGS no longer used
