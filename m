Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab2JAAjH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 20:39:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34846 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2JAAjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 20:39:05 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 30 Sep 2012 17:38:42 -0700
X-Google-Sender-Auth: RKYxYZrgDfHzbf7sDVcsSDya4N8
Message-ID: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
Subject: Linux 3.6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I did the -rc7 announcement a week ago, I said I might have to do
an -rc8, but a week passed, and things have been calm, and I honestly
cannot see a major reason to do another rc.

So here it is, 3.6 final. Sure, I'd have been happier with even fewer
changes, but that just never happens. And holding off the release
until people get too bored to send me the small stuff just makes the
next merge window more painful.

The changes that got merged this week were generally pretty tiny, but
more importantly, they tend to be small or very unlikely/special
things. Famous last words.

The shortlog below is obviously just the log since -rc7, the changes
in 3.6 since 3.5 are too many to list. There haven't been any huge new
architectures or filesystems, it's all "solid progress". That may not
sound all that exciting, but the devil is in the details, and there's
a lot of small fixes all over.

Anyway, this obviously means that the merge window for 3.7 is open,
and on that subject I do want to note that I'm going to travel much of
this merge window. Let's see how much that impacts my merging, but I
hope that it won't be *that* noticeable. But in case it results in any
problems, I'll just give a heads-up, and if worst comes to worst I'll
just extend the merge window to give myself more time for merging. I
aim to avoid it, but I'll note it here just in case it happens.

Steven Rothwell already noted during the -rc7 release that people
should have the stuff for 3.7 in linux-next, and I hope that is true.
Guys and gals, please behave, ok?

                 Linus

---
Al Viro (6):
      do_add_mount()/umount -l races
      close the race in nlmsvc_free_block()
      um: take cleaning singlestep to start_thread()
      um: don't leak floating point state and segment registers on execve()
      um: let signal_delivered() do SIGTRAP on singlestepping into handler
      um: kill thread->forking

Alan Stern (1):
      USB: Fix race condition when removing host controllers

Alex Elder (2):
      rbd: drop dev reference on error in rbd_open()
      libceph: only kunmap kmapped pages

Alex Williamson (3):
      vfio: Trivial Documentation correction
      vfio: Fix virqfd release race
      iommu: static inline iommu group stub functions

Andrea Arcangeli (1):
      thp: avoid VM_BUG_ON page_count(page) false positives in
__collapse_huge_page_copy

Andrei Emeltchenko (1):
      Bluetooth: Fix freeing uninitialized delayed works

Andrew Lunn (1):
      ARM: Orion5x: Fix too small coherent pool.

Andrzej Kaczmarek (2):
      Bluetooth: mgmt: Fix enabling SSP while powered off
      Bluetooth: mgmt: Fix enabling LE while powered off

Ben Skeggs (3):
      drm/nouveau: silence a debug message triggered by newer userspace
      drm/nvc0/ltcg: mask off intr 0x10
      drm/nvc0/fifo: ignore bits in PFIFO_INTR that aren't set in PFIFO_INTR_EN

Chris Metcalf (1):
      tile: gxio iorpc numbering change for TRIO interface

Dan Carpenter (2):
      NVMe: handle allocation failure in nvme_map_user_pages()
      vmwgfx: corruption in vmw_event_fence_action_create()

Daniel Mack (1):
      ALSA: snd-usb: fix next_packet_size calls for pause case

Dave Airlie (1):
      drm/udl: limit modes to the sku pixel limits.

Dave Jiang (1):
      MAINTAINERS: update Intel C600 SAS driver maintainers

Def (1):
      batman-adv: Fix change mac address of soft iface.

Emmanuel Grumbach (1):
      iwlwifi: don't double free the interrupt in failure path

Eric Dumazet (4):
      ipv4: raw: fix icmp_filter()
      net: guard tcp_set_keepalive() to tcp sockets
      ipv6: raw: fix icmpv6_filter()
      ipv6: mip6: fix mip6_mh_filter()

Geert Uytterhoeven (1):
      um: Preinclude include/linux/kern_levels.h

Heiko Carstens (1):
      checksyscalls: fix "here document" handling

J. Bruce Fields (1):
      trivial select_parent documentation fix

Jan Engelhardt (1):
      netfilter: xt_limit: have r->cost != 0 case work

Jan Kara (1):
      lib/flex_proportions.c: fix corruption of denominator in
flexible proportions

Jiri Pirko (1):
      team: send port changed when added

Joachim Eastwood (1):
      USB: ohci-at91: fix null pointer in ohci_hcd_at91_overcurrent_irq

Joerg Roedel (1):
      iommu/amd: Fix wrong assumption in iommu-group specific code

Keith Busch (7):
      NVMe: Set request queue logical block size
      NVMe: Fix nvme module init when nvme_major is set
      NVMe: replace nvme_ns with nvme_dev for user admin
      NVMe: use namespace id for nvme_get_features
      NVMe: Set block queue max sectors
      NVMe: Do not set IO queue depth beyond device max
      NVMe: Fix uninitialized iod compiler warning

Konrad Rzeszutek Wilk (1):
      xen/boot: Disable NUMA for PV guests.

Linus Lüssing (1):
      batman-adv: Fix symmetry check / route flapping in multi interface setups

Linus Torvalds (2):
      mtdchar: fix offset overflow detection
      Linux 3.6

Luis R. Rodriguez (1):
      cfg80211: fix possible circular lock on reg_regdb_search()

Marek Vasut (4):
      phy/micrel: Implement support for KSZ8021
      phy/micrel: Rename KS80xx to KSZ80xx
      phy/micrel: Add missing header to micrel_phy.h
      net: phy: smsc: Implement PHY config_init for LAN87xx

Mark Brown (1):
      ASoC: wm2000: Correct register size

Mark Salter (3):
      c6x: use asm-generic/barrier.h
      c/r: prctl: fix build error for no-MMU case
      syscalls: add __NR_kcmp syscall to generic unistd.h

Matthew Wilcox (3):
      NVMe: Fix whitespace damage in nvme_init
      NVMe: Free admin queue memory on initialisation failure
      NVMe: Cancel outstanding IOs on queue deletion

Mauro Carvalho Chehab (3):
      i3200_edac: Fix memory rank size
      i5000: Fix the memory size calculation with 2R memories
      sb_edac: Avoid overflow errors at memory size calculation

Mike Snitzer (6):
      dm thin: do not set discard_zeroes_data
      dm mpath: only retry ioctl when no paths if queue_if_no_path set
      dm: handle requests beyond end of device instead of using BUG_ON
      dm: retain table limits when swapping to new table with no devices
      dm thin: tidy discard support
      dm thin: fix discard support for data devices

Miklos Szeredi (1):
      vfs: dcache: fix deadlock in tree traversal

Mikulas Patocka (1):
      dm verity: fix overflow check

Milan Broz (1):
      dm table: clear add_random unless all devices have it set

Narendra K (1):
      qlcnic: Fix scheduling while atomic bug

Neil Horman (1):
      bnx2: Clean up remaining iounmap

NeilBrown (2):
      md/raid5: add missing spin_lock_init.
      md/raid10: fix "enough" function for detecting if array is failed.

Nicolas Dichtel (1):
      inetpeer: fix token initialization

Paul Mundt (1):
      sh: pfc: Fix up GPIO mux type reconfig case.

Peter Hüwe (1):
      net/phy/bcm87xx: Add MODULE_LICENSE("GPL") to GPL driver

Quoc-Son Anh (1):
      NVMe: Use ida for nvme device instance

Richard Weinberger (1):
      um: Fix IPC on um

Roland Stigge (1):
      gpio-lpc32xx: Fix value handling of gpio_direction_output()

Sachin Kamat (1):
      ARM: dma-mapping: Fix potential memory leak in atomic_pool_init()

Steve Glendinning (1):
      smsc75xx: fix resume after device reset

Thierry Reding (1):
      pwm-backlight: take over maintenance

Vinicius Costa Gomes (1):
      Bluetooth: Fix not removing power_off delayed work

Wei Yongjun (4):
      l2tp: fix return value check
      team: fix return value check
      netdev: pasemi: fix return value check in pasemi_mac_phy_init()
      netdev: octeon: fix return value check in octeon_mgmt_init_phy()

Xiaodong Xu (1):
      pppoe: drop PPPOX_ZOMBIEs in pppoe_release
