Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2CSBZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 21:25:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58732 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab2CSBZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 21:25:27 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Mar 2012 18:25:05 -0700
X-Google-Sender-Auth: c5v0bwZVhNl0i3qTedhvuEXVyH8
Message-ID: <CA+55aFyR2TXcKdzXontH8B4Reu40bdY_APhuUJeUxm6D-OuQkg@mail.gmail.com>
Subject: Linux 3.3 release
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So after the extra -rc release last weekend, now the final 3.3 is out
there in the usual locations.

Things did indeed calm down during the last week, and the shortlog
looks pretty boring. The diffstat from -rc7 is dominated by the
arch/tile defconfig changes, the rest is pretty small, although there
are changes spread out in various subsystem s(drivers, filesystem,
networking, perf tools).

The shortlog (from -rc7) is appended, and for a more high-level view
of at least parts of the changes since 3.2 it's probably worth going
to kernelnewbies:

  http://kernelnewbies.org/Linux_3.3

which tends to be pretty good about these kinds of things.

And obviously, the 3.3 release means that the merge window for 3.4 is
now open, although I may keep of pulling stuff for a day or so to
encourage people to test the actual release.

I did want to mention that with spring break for my kids coming up
during this merge window, I will be gone a couple of days to the
Oregon coast, probably without any real internet access. We'll see.
It's mostly during next weekend, so it's probably not that noticeable,
but if it means that I fall behind I might spend a few extra days
doing merging. But even if that means that -rc1 might be slightly
delayed, I'll use the normal two-week cut-off for actual pull
requests.

And who knows - it's entirely possible that it won't be an issue at
all, and everything will be on schedule. But I thought I'd mention the
possibility so that it doesn't take anybody by surprise.

                       Linus

---
Al Viro (1):
      restore smp_mb() in unlock_new_inode()

Alan Cox (1):
      drm/gma500: Fix Cedarview boot failures in 3.3-rc

Alan Stern (1):
      Block: use a freezable workqueue for disk-event polling

Alexandre Bounine (1):
      rapidio/tsi721: fix bug in register offset definitions

Anton Blanchard (3):
      perf tools: Incorrect use of snprintf results in SEGV
      afs: Read of file returns EBADMSG
      afs: Remote abort can cause BUG in rxrpc code

Ariel Elior (1):
      bnx2x: added cpu_to_le16 when preparing ramrod's data

Arnaldo Carvalho de Melo (1):
      perf tools: Use scnprintf where applicable

Axel Lin (3):
      regulator: Fix setting selector in tps6524x set_voltage function
      regulator: Set n_voltages for da9052 regulators
      regulator: da9052: Ensure the selected voltage falls within the
specified range

Ben Hutchings (1):
      x86: Add amilo-rfkill driver for some Fujitsu-Siemens Amilo laptops

Chris Metcalf (3):
      arch/tile: Fix up from commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
      arch/tile: sync up the defconfig files to the tip
      arch/tile/configs: convert to minimal configs via "make savedefconfig"

Cyrill Gorcunov (1):
      prctl: use CAP_SYS_RESOURCE for PR_SET_MM option

Dan Carpenter (2):
      block, sx8: fix pointer math issue getting fw version
      drivers/video/backlight/s6e63m0.c: fix corruption storing gamma mode

Danny Kukawka (2):
      drivers/block/DAC960: fix DAC960_V2_IOCTL_Opcode_T -Wenum-compare warning
      drivers/block/DAC960: fix -Wuninitialized warning

David S. Miller (1):
      sparc32: Add -Av8 to assembler command line.

Donghwa Lee (1):
      MAINTAINERS: add entry for exynos mipi display drivers

Eric Dumazet (6):
      tcp: fix syncookie regression
      ipv6: fix icmp6_dst_alloc()
      sch_sfq: revert dont put new flow at the end of flows
      net/usbnet: reserve headroom on rx skbs
      net/hyperv: fix erroneous NETDEV_TX_BUSY use
      wimax/i2400m: fix erroneous NETDEV_TX_BUSY use

Gianluca Gennari (1):
      [media] smsdvb: fix get_frontend

Guenter Roeck (4):
      hwmon: (w83627ehf) Fix writing into fan_stop_time for NCT6775F/NCT6776F
      hwmon: (w83627ehf) Fix memory leak in probe function
      hwmon: (w83627ehf) Describe undocumented pwm attributes
      hwmon: (zl6100) Enable interval between chip accesses for all chips

Gustavo Padovan (1):
      MAINTAINERS: Gustavo has moved

Haogang Chen (1):
      nilfs2: clamp ns_r_segments_percentage to [1, 99]

Henrique Camargo (1):
      [media] media: davinci: added module.h to resolve unresolved macros

Hugh Dickins (1):
      memcg: free mem_cgroup by RCU to fix oops

Ike Panhc (1):
      acer-wmi: No wifi rfkill on Lenovo machines

Ingo Molnar (1):
      perf tools, x86: Build perf on older user-space as well

James Morris (1):
      MAINTAINERS: Add Serge as maintainer of capabilities

Jan Kara (1):
      udf: Fix deadlock in udf_release_file()

Jason Baron (1):
      Don't limit non-nested epoll paths

Jean Delvare (1):
      hwmon: (w83627ehf) Fix temp2 source for W83627UHG

Jesse Barnes (2):
      drm/i915: fix color order for BGR formats on SNB
      drm/i915: support 32 bit BGR formats in sprite planes

Joerg Neikes (1):
      usb: asix: Patch for Sitecom LN-031

Johan Hedberg (2):
      MAINTAINERS: add Johan to Bluetooth maintainers
      MAINTAINERS: fix link to Gustavo Padovans tree

Jun'ichi Nomura (1):
      block: Fix NULL pointer dereference in sd_revalidate_disk

Kuninori Morimoto (1):
      ARM: mach-shmobile: ap4evb: fixup fsi2_ak4643_info typo

Laurent Pinchart (4):
      [media] [FOR,v3.3] uvcvideo: Avoid division by 0 in timestamp calculation
      ARM: mach-shmobile: Fix ag5evm compilation by including linux/videodev2.h
      ARM: mach-shmobile: mackerel: Reserve DMA memory for the frame buffer
      drm/exynos: Fix fb_videomode <-> drm_mode_modeinfo conversion

Linus Torvalds (1):
      Linux 3.3

Marek Szyprowski (2):
      drm/exynos: use correct 'exynos-drm' name for platform device
      drm/exynos: fix runtime_pm fimd device state on probe

Mark Salter (1):
      C6X: remove dead code from entry.S

Matt Fleming (1):
      tile: Use set_current_blocked() and block_sigmask()

Matthew Garrett (1):
      PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled

Mauro Carvalho Chehab (1):
      [media] smsusb: fix the default delivery system setting

Michal Schmidt (2):
      bnx2x: fix a crash on corrupt firmware file
      bnx2x: fix memory leak in bnx2x_init_firmware()

Miklos Szeredi (2):
      vfs: fix double put after complete_walk()
      vfs: fix return value from do_last()

Muthukumar R (1):
      block: Fix setting bio flags in drivers (sd_dif/floppy)

Nicholas Bellinger (2):
      target: Fix compatible reservation handling (CRH=1) with legacy
RESERVE/RELEASE
      iscsi-target: Fix reservation conflict -EBUSY response handling bug

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix race between delete and timeout expiration

Pavel Shilovsky (1):
      CIFS: Do not kmalloc under the flocks spinlock

Peter Zijlstra (1):
      perf/x86: Fix local vs remote memory events for NHM/WSM

Phil Edworthy (2):
      sh: Fix sh2a vbr table for more than 255 irqs
      ARM: mach-shmobile: Fix bonito compile breakage

Rafael J. Wysocki (1):
      sh-sci / PM: Avoid deadlocking runtime PM

Robert Gerlach (1):
      Fujitsu tablet extras driver

RongQing.Li (1):
      ipv6: Don't dev_hold(dev) in ip6_mc_find_dev_rcu.

Ryusuke Konishi (1):
      nilfs2: fix NULL pointer dereference in nilfs_load_super_block()

Santosh Nayak (1):
      cifs: possible memory leak in xattr.

Sascha Hauer (1):
      drm exynos: use drm_fb_helper_set_par directly

Shimoda, Yoshihiro (1):
      sh: add parameter for RSPI in clock-sh7757

Stanislav Kinsbursky (1):
      tun: don't hold network namespace by tun sockets

Stanislaw Gruszka (3):
      block: fix __blkdev_get and add_disk race condition
      iwl3945: fix possible il->txq NULL pointer dereference in delayed works
      rt2x00: fix random stalls

Stephane Eranian (1):
      perf record: Fix buffer overrun bug in tracepoint_id_to_path()

Tejun Heo (3):
      block: replace icq->changed with icq->flags
      block: simplify ioc_release_fn()
      block: exit_io_context() should call elevator_exit_icq_fn()

Thomas Schwinge (1):
      sh: fix up the ubc clock definition for sh7785.

Tom Herbert (1):
      dql: Fix undefined jiffies

Tyler Hicks (1):
      vfs: Correctly set the dir i_mutex lockdep class

Ville Syrjala (1):
      i2c-algo-bit: Fix spurious SCL timeouts under heavy load

Viresh Kumar (1):
      MAINTAINERS: update ST's Mailing list for SPEAr

Wolfram Sang (1):
      i2c-core: Comment says "transmitted" but means "received"

Xi Wang (1):
      panasonic-laptop: avoid overflow in acpi_pcc_hotkey_add()

Xiaotian Feng (1):
      block: fix ioc leak in put_io_context

Yuval Mintz (3):
      bnx2x: pfc statistics counts pfc events twice
      bnx2x: dcb bit indices flags used as bits
      bnx2x: FCoE statistics id fixed

roel (1):
      arch/tile: misplaced parens near likely
