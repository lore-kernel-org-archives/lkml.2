Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab1COBuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 21:50:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893Ab1COBuA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 21:50:00 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Mar 2011 18:49:37 -0700
Message-ID: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com>
Subject: Linux 2.6.38
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not a lot of changes since -rc8. Most notably perhaps some late nfs
and btrfs work, and a mips update. Along with some more vfs RCU lookup
fallout (which would only be noticeable with the filesystem exported
with nfsd, which is why nobody ever noticed).

And the usual driver updates, mostly media and GPU, but some
networking too. The appended shortlog is for the changes since -rc8,
and gives some feel for it. Nothing really too exciting, I think.

As to the "big picture", ie all the changes since 2.6.37, my personal
favorite remains the VFS name lookup changes. They did end up causing
some breakage, and Al has made it clear that he wants more cleanups,
but on the whole I think it was surprisingly smooth. I think we had
more problems with random other components (nasty memory corruption in
networking etc) than with the rather fundamental path lookup change.

So I'm hoping this ends up being a fairly calm release despite some
really deep changes like that.

                     Linus

---

Abhilash K V (1):
      ASoC: AM3517: Update codec name after multi-component update

Al Viro (12):
      minimal fix for do_filp_open() race
      unfuck proc_sysctl ->d_compare()
      nd->inode is not set on the second attempt in path_walk()
      /proc/self is never going to be invalidated...
      reiserfs xattr ->d_revalidate() shouldn't care about RCU
      ceph: fix d_revalidate oopsen on NFS exports
      fuse: fix d_revalidate oopsen on NFS exports
      gfs2: fix d_revalidate oopsen on NFS exports
      ocfs2: fix d_revalidate oopsen on NFS exports
      jfs: fix d_revalidate oopsen on NFS exports
      fat: fix d_revalidate oopsen on NFS exports
      compat breakage in preadv() and pwritev()

Andrea Arcangeli (2):
      x86/mm: Fix pgd_lock deadlock
      thp: fix page_referenced to modify mapcount/vm_flags only if page is found

Andrey Vagin (1):
      x86/mm: Handle mm_fault_error() in kernel space

Andy Adamson (2):
      NFSv4: remove duplicate clientid in struct nfs_client
      NFSv4.1 reclaim complete must wait for completion

Andy Walls (2):
      [media] cx23885: Revert "Check for slave nack on all transactions"
      [media] cx23885: Remove unused 'err:' labels to quiet compiler warning

Anoop P A (2):
      MIPS: Select R4K timer lib for all MSP platforms
      MIPS: MSP: Fix MSP71xx bpci interrupt handler return value

Antony Pavlov (2):
      mtd: jedec_probe: Change variable name from cfi_p to cfi
      mtd: jedec_probe: initialise make sector erase command variable

Antti Seppälä (1):
      [media] Fix sysfs rc protocol lookup for rc-5-sz

Arnaldo Carvalho de Melo (1):
      perf symbols: Fix vmlinux path when not using --symfs

Arnaud Patard (1):
      [media] mantis_pci: remove asm/pgtable.h include

Axel Lin (3):
      mtd: add "platform:" prefix for platform modalias
      gpio: add MODULE_DEVICE_TABLE
      watchdog: hpwdt: eliminate section mismatch warning

Balbir Singh (1):
      sched: Fix sched rt group scheduling when hierachy is enabled

Ben Hutchings (1):
      sunrpc: Propagate errors from xs_bind() through xs_create_sock()

Benjamin Herrenschmidt (2):
      powerpc/iseries: Fix early init access to lppaca
      powerpc/pseries: Disable VPNH feature

Benny Halevy (1):
      NFSD: fix decode_cb_sequence4resok

Chris Mason (4):
      Btrfs: fix regressions in copy_from_user handling
      Btrfs: deal with short returns from copy_from_user
      Btrfs: make sure not to return overlapping extents to fiemap
      Btrfs: break out of shrink_delalloc earlier

Chuck Lever (1):
      NFS: NFSROOT should default to "proto=udp"

Cliff Wickman (1):
      x86, UV: Initialize the broadcast assist unit base destination
node id properly

Dan Carpenter (1):
      watchdog: sch311x_wdt: fix printk condition

Daniel J Blueman (2):
      x86, build: Make sure mkpiggy fails on read error
      btrfs: fix dip leak

Daniel Turull (1):
      pktgen: fix errata in show results

Dave Airlie (3):
      drm/radeon: add pageflip hooks for fusion
      drm/radeon: fix page flipping hangs on r300/r400
      drm/radeon: fix problem with changing active VRAM size. (v2)

David Daney (5):
      MIPS: Add an unreachable return statement to satisfy buggy GCCs.
      MIPS: Fix GCC-4.6 'set but not used' warning in signal*.c
      MIPS: Remove unused code from arch/mips/kernel/syscall.c
      MIPS: Fix GCC-4.6 'set but not used' warning in ieee754int.h
      MIPS: Fix GCC-4.6 'set but not used' warning in arch/mips/mm/init.c

David Howells (2):
      MN10300: The SMP_ICACHE_INV_FLUSH_RANGE IPI command does not exist
      MN10300: atomic_read() should ensure it emits a load

David S. Miller (2):
      ipv4: Fix erroneous uses of ifa_address.
      ipv6: Don't create clones of host routes.

Deng-Cheng Zhu (5):
      MIPS, Perf-events: Work with irq_work
      MIPS, Perf-events: Work with the new PMU interface
      MIPS, Perf-events: Fix event check in validate_event()
      MIPS, Perf-events: Work with the new callchain interface
      MIPS, Perf-events: Use unsigned delta for right shift in event update

Devin Heitmueller (2):
      [media] au0828: fix VBI handling when in V4L2 streaming mode
      [media] cx18: Add support for Hauppauge HVR-1600 models with s5h1411

Dmitry Kravkov (4):
      bnx2x: fix non-pmf device load flow
      bnx2x: fix link notification
      bnx2x: (NPAR) prevent HW access in D3 state
      bnx2x: fix MaxBW configuration

Doe, YiCheng (1):
      ipmi: Fix IPMI errors due to timing problems

Florian Fainelli (3):
      r6040: bump to version 0.27 and date 23Feb2011
      MIPS: MTX-1: Make au1000_eth probe all PHY addresses
      MIPS: Alchemy: Fix reset for MTX-1 and XXS1500

Frank Filz (1):
      (try3-resend) Fix nfs_compat_user_ino64 so it doesn't cause
problems if bit 31 or 63 are set in fileid

Grant Likely (1):
      i2c-ocores: Fix pointer type mismatch error

Göran Weinholt (1):
      net/smsc911x.c: Set the VLAN1 register to fix VLAN MTU problem

Hans de Goede (2):
      hwmon/f71882fg: Fix a typo in a comment
      hwmon/f71882fg: Set platform drvdata to NULL later

Huang Weiyi (1):
      nfs4: remove duplicated #include

Hugh Dickins (1):
      thp+memcg-numa: fix BUG at include/linux/mm.h:370!

J. Bruce Fields (2):
      nfsd4: fix bad pointer on failure to find delegation
      fs/dcache: allow d_obtain_alias() to return unhashed dentries

Jarod Wilson (3):
      [media] nuvoton-cir: fix wake from suspend
      [media] mceusb: don't claim multifunction device non-IR parts
      [media] tda829x: fix regression in probe functions

Jeff Layton (1):
      nfs: close NFSv4 COMMIT vs. CLOSE race

Jesper Juhl (1):
      SUNRPC: Remove resource leak in svc_rdma_send_error()

Jiri Slaby (1):
      watchdog: sbc_fitpc2_wdt, fix crash on systems without DMI_BOARD_NAME

Joakim Tjernlund (1):
      mtd: fix race in cfi_cmdset_0001 driver

Jon Mason (1):
      vxge: update MAINTAINERS

Jovi Zhang (1):
      nfs: fix compilation warning

Lin Ming (1):
      perf symbols: Avoid resolving [kernel.kallsyms] to real path for
buildid cache

Linus Torvalds (2):
      Revert "oom: oom_kill_process: fix the child_points logic"
      Linux 2.6.38

Lukas Czerner (1):
      block: fix mis-synchronisation in blkdev_issue_zeroout()

Maksim Rayskiy (1):
      MIPS: Move idle task creation to work queue

Malcolm Priestley (1):
      [media] DM04/QQBOX memcpy to const char fix

Marco Stornelli (1):
      Check for immutable/append flag in fallocate path

Mark Brown (4):
      ASoC: Fix broken bitfield definitions in WM8978
      ASoC: Use the correct DAPM context when cleaning up final widget set
      ASoC: Fix typo in late revision WM8994 DAC2R name
      ASoC: Ensure WM8958 gets all WM8994 late revision widgets

Matt Turner (1):
      alpha: fix compile error from IRQ clean up

Mauro Carvalho Chehab (1):
      [media] ir-raw: Properly initialize the IR event (BZ#27202)

Maurus Cuelenaere (1):
      MIPS: Jz4740: Add HAVE_CLK

Maxim Levitsky (1):
      mtd: mtd_blkdevs: fix double free on error path

Miao Xie (1):
      btrfs: fix not enough reserved space

Michael (1):
      [media] ivtv: Fix corrective action taken upon DMA ERR interrupt
to avoid hang

Michal Marek (1):
      kbuild: Fix computing srcversion for modules

Naga Chumbalkar (2):
      x86: Don't check for BIOS corruption in first 64K when there's no need to
      [CPUFREQ] pcc-cpufreq: don't load driver if get_freq fails during init.

Neil Horman (1):
      rds: prevent BUG_ON triggering on congestion map updates

Nicholas Bellinger (1):
      [SCSI] target: Fix t_transport_aborted handling in LUN_RESET +
active I/O shutdown

Nicolas Kaiser (1):
      drivers/net/macvtap: fix error check

Nils Carlson (2):
      bonding 802.3ad: Fix the state machine locking v2
      bonding 802.3ad: Rename rx_machine_lock to state_machine_lock

Ohad Ben-Cohen (1):
      mmc: fix CONFIG_MMC_UNSAFE_RESUME regression

Oleg Nesterov (1):
      oom: oom_kill_process: fix the child_points logic

Olivier Grenie (1):
      [media] DiB7000M: add pid filtering

Pawel Osciak (1):
      [media] Fix double free of video_device in mem2mem_testdev

Rainer Weikusat (1):
      net: fix multithreaded signal handling in unix recv routines

Rajendra Nayak (1):
      i2c-omap: Program I2C_WE on OMAP4 to enable i2c wakeup

Randy Dunlap (1):
      net: bridge builtin vs. ipv6 modular

Ricardo Labiaga (1):
      NFSv4.1: Retry CREATE_SESSION on NFS4ERR_DELAY

Robert Millan (1):
      MIPS: Loongson: Remove ad-hoc cmdline default

Sebastian Andrzej Siewior (1):
      x86: ce4100: Set pci ops via callback instead of module init

Shawn Lin (1):
      r6040: fix multicast operations

Stanislav Fomichev (1):
      nfs: add kmalloc return value check in decode_and_add_ds

Stanislaw Gruszka (1):
      mtd: amd76xrom: fix oops at boot when resources are not available

Stefan Oberhumer (1):
      MIPS: Clear the correct flag in sysmips(MIPS_FIXADE, ...).

Stefan Weil (1):
      MIPS: Loongson: Fix potentially wrong string handling

Stephen Rothwell (2):
      sysctl: the include of rcupdate.h is only needed in the kernel
      sysctl: the include of rcupdate.h is only needed in the kernel

Sven Barth (1):
      [media] cx25840: fix probing of cx2583x chips

Takashi Iwai (1):
      drm/i915: Revive combination mode for backlight control

Thomas Gleixner (1):
      MIPS: Replace deprecated spinlock initialization

Thomas Graf (1):
      net: Enter net/ipv6/ even if CONFIG_IPV6=n

Timo Warns (1):
      Fix corrupted OSF partition table parsing

Tkhai Kirill (1):
      MN10300: Proper use of macros get_user() in the case of
incremented pointers

Trond Myklebust (5):
      SUNRPC: Close a race in __rpc_wait_for_completion_task()
      NFSv4/4.1: Fix nfs4_schedule_state_recovery abuses
      NFSv4.1: Fix the handling of the SEQUENCE status bits
      NFSv4: Fix the setlk error handler
      NFSv4: nfs4_state_mark_reclaim_nograce() should be static

Vasiliy Kulikov (1):
      net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules

Wim Van Sebroeck (3):
      watchdog: cpwd: Fix buffer-overflow
      watchdog: sch311x_wdt: Fix LDN active check
      watchdog: w83697ug_wdt: Fix set bit 0 to activate GPIO2

Wolfram Sang (1):
      i2c-eg20t: include slab.h for memory allocations

Wu Zhangjin (5):
      MIPS, Tracing: Speed up function graph tracer
      MIPS, Tracing: Substitute in_kernel_space() for in_module()
      MIPS, Tracing: Clean up prepare_ftrace_return()
      MIPS, Tracing: Clean up ftrace_make_nop()
      MIPS, Tracing: Fix set_graph_function of function graph tracer

Yinghai Lu (1):
      x86, numa: Fix numa_emulation code with memory-less node0

Yoichi Yuasa (1):
      MIPS: Fix always CONFIG_LOONGSON_UART_BASE=y

j223yang@asset.uwaterloo.ca (1):
      ariadne: remove redundant NULL check

roel (1):
      nfsd: wrong index used in inner loop

sensoray-dev (1):
      [media] s2255drv: firmware re-loading changes

stephen hemminger (1):
      ip6ip6: autoload ip6 tunnel
