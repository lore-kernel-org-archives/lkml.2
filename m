Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890Ab1GMDri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 23:47:38 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36551 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964880Ab1GMDrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 23:47:36 -0400
X-Sasl-enc: Y0auXL8BmStCdgpZgkX9LUQBUusoTI7Efim/z3lJE2OK 1310528854
Date: Wed, 13 Jul 2011 05:46:39 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.16
Message-ID: <20110713034639.GC16150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.16 kernel.

This is primarily for the use of those people who are stuck using the
.33-rt kernel.  Anyone else who really wants to use the .33 kernel tree
is welcome to use this one as well.

I'll be maintaining it for a while longer as it looks like the -rt tree
isn't moving forward to any newer kernel any time soon.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------


 Makefile                                |    2 
 arch/um/kernel/dyn.lds.S                |   14 ++++-
 arch/um/kernel/uml.lds.S                |   17 ++++++
 arch/um/os-Linux/mem.c                  |    1 
 arch/x86/xen/mmu.c                      |    9 ++-
 block/cfq-iosched.c                     |    8 ++
 drivers/char/tty_ldisc.c                |    4 +
 drivers/i2c/busses/i2c-taos-evm.c       |    8 +-
 drivers/md/md.c                         |    1 
 drivers/media/video/uvc/uvc_queue.c     |    2 
 drivers/net/hamradio/6pack.c            |    4 -
 drivers/net/hamradio/mkiss.c            |    4 -
 drivers/net/wireless/ath/ath5k/eeprom.c |    8 +-
 drivers/usb/core/driver.c               |   11 +++
 drivers/usb/core/hub.c                  |   13 ++--
 drivers/usb/host/xhci-hcd.c             |   22 ++++++-
 drivers/watchdog/mtx-1_wdt.c            |    8 ++
 fs/inode.c                              |   22 +++++--
 fs/nilfs2/btnode.c                      |   13 ----
 fs/nilfs2/btnode.h                      |    1 
 fs/nilfs2/super.c                       |    2 
 include/asm-generic/bug.h               |   16 +++++
 include/linux/clocksource.h             |    1 
 include/linux/fs.h                      |    2 
 include/linux/if_packet.h               |    2 
 include/net/netlink.h                   |    2 
 kernel/power/snapshot.c                 |   89 ++++++++++++++++++++++++--------
 kernel/power/user.c                     |    4 +
 kernel/taskstats.c                      |   15 ++++-
 kernel/time/clocksource.c               |   24 ++++----
 lib/debugobjects.c                      |    2 
 mm/hugetlb.c                            |    8 ++
 mm/ksm.c                                |    6 ++
 mm/memory.c                             |    2 
 mm/migrate.c                            |    2 
 net/core/filter.c                       |    4 +
 net/ipv4/af_inet.c                      |    3 +
 net/ipv4/inet_diag.c                    |   14 ++---
 net/ipv4/udp.c                          |    3 +
 net/ipv6/udp.c                          |    5 +
 net/packet/af_packet.c                  |    2 
 net/sunrpc/auth_gss/auth_gss.c          |    4 -
 net/sunrpc/clnt.c                       |    2 
 43 files changed, 284 insertions(+), 102 deletions(-)

Alan Stern (2):
      USB: don't let errors prevent system sleep
      USB: don't let the hub driver prevent system sleep

Andrea Arcangeli (1):
      migrate: don't account swapcache as shmem

Arnd Bergmann (1):
      6pack,mkiss: fix lock inconsistency

Eric Dumazet (2):
      inet_diag: fix inet_diag_bc_audit()
      af_packet: prevent information leak

Eugene A. Shatokhin (1):
      ath5k: fix memory leak when fewer than N_PD_CURVES are in use

Florian Fainelli (1):
      watchdog: mtx1-wdt: request gpio before using it

Greg Kroah-Hartman (1):
      Linux 2.6.33.16

Hugh Dickins (1):
      ksm: fix NULL pointer dereference in scan_get_next_rmap_item()

Jean Delvare (1):
      i2c-taos-evm: Fix log messages

Jens Axboe (1):
      cfq-iosched: fix locking around ioc->ioc_data assignment

Jiri Slaby (1):
      TTY: ldisc, do not close until there are readers

Joe Perches (2):
      bug.h: Add WARN_RATELIMIT
      net: filter: Use WARN_RATELIMIT

Liu Aleaxander (1):
      um: os-linux/mem.c needs sys/stat.h

Marcin Slusarz (1):
      debugobjects: Fix boot crash when kmemleak and debugobjects enabled

Marcus Meissner (1):
      net/ipv4: Check for mistakenly passed in non-IPv4 address

Michal Kubecek (1):
      PM: Free memory bitmaps if opening /dev/snapshot fails

Miklos Szeredi (1):
      mm: prevent concurrent unmap_mapping_range() on the same inode

NeilBrown (1):
      md: avoid endless recovery loop when waiting for fail device to complete.

Nelson Elhage (1):
      netlink: Make nlmsg_find_attr take a const nlmsghdr*.

Rafael Aquini (1):
      mm: fix negative commitlimit when gigantic hugepages are allocated

Rafael J. Wysocki (2):
      PM / Hibernate: Avoid hitting OOM during preallocation of memory
      PM / Hibernate: Fix free_unnecessary_pages()

Roland McGrath (1):
      uml: fix CONFIG_STATIC_LINK=y build failure with newer glibc

Sarah Sharp (1):
      xhci: Reject double add of active endpoints.

Shaohua Li (1):
      cfq-iosched: fix a rcu warning

Sjoerd Simons (1):
      uvcvideo: Remove buffers from the queues when freeing

Stefano Stabellini (1):
      xen: partially revert "xen: set max_pfn_mapped to the last pfn mapped"

Thomas Gleixner (1):
      clocksource: Make watchdog robust vs. interruption

Trond Myklebust (1):
      SUNRPC: Ensure the RPC client only quits on fatal signals

Vasiliy Kulikov (1):
      taskstats: don't allow duplicate entries in listener mode

Xufeng Zhang (2):
      ipv6/udp: Use the correct variable to determine non-blocking condition
      udp/recvmsg: Clear MSG_TRUNC flag when starting over for a new packet

