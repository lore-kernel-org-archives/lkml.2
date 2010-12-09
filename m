Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0LIWv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:51:57 -0500
Received: from kroah.org ([198.145.64.141]:45700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0LIWvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:51:53 -0500
Date: Thu, 9 Dec 2010 14:49:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.57
Message-ID: <20101209224902.GA2777@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.57 kernel.

All users of the 2.6.27 kernel series must upgrade.

Note, this is my LAST release of the 2.6.27 kernel series.  I will be
passing this on to someone else, but I can't guarantee any release cycle
of it anymore, that is up to the new maintainer, not I.  Also note that
I can't help out with any .27 kernel bugs anymore either as I will be
officially retiring my only .27 machine now as well.

It was a good run, encompasing 57 releases, over 791 days, and included
1596 patches (not the largest of any stable release series, .32 has that
beat already).

Speaking of .32, I'd _strongly_ encourage all existing .27 users to
seriously look into migrating to the .32 kernel tree at this point in
time as well.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

Also, this is the last .27 release in the stable/ directory, all future
ones will be in the longterm/ directory, so please anticipate that for
any scripts you might have in place right now.

thanks,

greg k-h

------------

 Makefile                                   |    2 -
 arch/arm/lib/findbit.S                     |    6 ++-
 arch/um/os-Linux/time.c                    |    2 -
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    1 
 block/blk-map.c                            |    2 +
 drivers/ata/libata-scsi.c                  |    5 ++-
 drivers/char/vt_ioctl.c                    |   11 +++---
 drivers/media/video/ivtv/ivtvfb.c          |    2 +
 drivers/usb/atm/ueagle-atm.c               |    6 +--
 drivers/usb/core/devio.c                   |    7 ++--
 drivers/usb/host/ehci-hcd.c                |   10 +++---
 drivers/usb/misc/cypress_cy7c63.c          |    6 +--
 drivers/usb/misc/iowarrior.c               |    1 
 drivers/usb/misc/sisusbvga/sisusb.c        |    1 
 drivers/usb/misc/trancevibrator.c          |    2 -
 drivers/usb/misc/usbled.c                  |    2 -
 drivers/usb/storage/sierra_ms.c            |    2 -
 fs/bio.c                                   |   14 ++++++++
 fs/ecryptfs/inode.c                        |    4 ++
 include/net/x25.h                          |    4 ++
 ipc/compat.c                               |    6 +++
 ipc/compat_mq.c                            |    5 +++
 ipc/sem.c                                  |    2 +
 ipc/shm.c                                  |    1 
 kernel/exit.c                              |    9 +++++
 lib/percpu_counter.c                       |    1 
 mm/internal.h                              |    2 -
 mm/memory_hotplug.c                        |    2 -
 mm/mempolicy.c                             |    2 -
 net/can/bcm.c                              |    2 -
 net/core/ethtool.c                         |    2 -
 net/core/stream.c                          |    8 ++--
 net/decnet/af_decnet.c                     |    2 +
 net/econet/af_econet.c                     |   29 ++++++-----------
 net/ipv4/tcp.c                             |   11 ++++--
 net/ipv4/tcp_input.c                       |    2 +
 net/ipv4/udp.c                             |    4 +-
 net/ipv4/xfrm4_policy.c                    |    4 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c    |    1 
 net/ipv6/route.c                           |   28 ++++++++++++++---
 net/irda/iriap.c                           |    3 +
 net/irda/parameters.c                      |    4 +-
 net/rose/af_rose.c                         |    4 +-
 net/sctp/protocol.c                        |    4 +-
 net/socket.c                               |    4 ++
 net/x25/af_x25.c                           |   47 ++++++++++++++++++++++++++++-
 net/x25/x25_facilities.c                   |   32 ++++++++++++++-----
 net/x25/x25_in.c                           |   17 ++++++++--
 48 files changed, 244 insertions(+), 84 deletions(-)

Alan Stern (1):
      USB: EHCI: fix obscure race in ehci_endpoint_disable

Dan Rosenberg (5):
      ipc: initialize structure memory to zero for compat functions
      sys_semctl: fix kernel stack leakage
      DECnet: don't leak uninitialized stack byte
      V4L/DVB: ivtvfb: prevent reading uninitialized stack memory
      x25: Prevent crashing when parsing bad X.25 facilities

David S. Miller (1):
      rose: Fix signedness issues wrt. digi count.

Eric Dumazet (1):
      numa: fix slab_node(MPOL_BIND)

Graham Gower (1):
      drivers/char/vt_ioctl.c: fix VT_OPENQRY error value

Greg Kroah-Hartman (6):
      USB: storage: sierra_ms: fix sysfs file attribute
      USB: atm: ueagle-atm: fix up some permissions on the sysfs files
      USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
      USB: misc: usbled: fix up some sysfs attribute permissions
      USB: misc: trancevibrator: fix up a sysfs attribute permission
      Linux 2.6.27.57

James Jones (1):
      ARM: 6482/2: Fix find_next_zero_bit and related assembly

Jens Axboe (2):
      block: check for proper length of iov entries in blk_rq_map_user_iov()
      bio: take care not overflow page count when mapping/copying user data

John Hughes (1):
      x25: Patch to fix bug 15678 - x25 accesses fields beyond end of packet.

KAMEZAWA Hiroyuki (2):
      mm: fix return value of scan_lru_pages in memory unplug
      mm: fix is_mem_section_removable() page_order BUG_ON check

Kees Cook (1):
      net: clear heap allocations for privileged ethtool actions

Linus Torvalds (1):
      net: Truncate recvfrom and sendto length to INT_MAX.

Maciej Żenczykowski (1):
      net: Fix IPv6 PMTU disc. w/ asymmetric routes

Masanori ITOH (1):
      percpu: fix list_head init bug in __percpu_counter_init()

Nagendra Tomar (1):
      net: Fix the condition passed to sk_wait_event()

Nelson Elhage (1):
      do_exit(): make sure that we run with get_fs() == USER_DS

Oliver Hartkopp (1):
      can-bcm: fix minor heap overflow

Phil Blundell (2):
      econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
      econet: fix CVE-2010-3850

Richard Weinberger (1):
      um: fix global timer issue when using CONFIG_NO_HZ

Robin Holt (1):
      Limit sysctl_tcp_mem and sysctl_udp_mem initializers to prevent integer overflows.

Samuel Ortiz (2):
      irda: Fix parameter extraction stack overflow
      irda: Fix heap memory corruption in iriap.c

Shan Wei (1):
      ipv6: conntrack: Add member of user to nf_ct_frag6_queue structure

Tejun Heo (1):
      libata: fix NULL sdev dereference race in atapi_qc_complete()

Tom Marshall (1):
      tcp: Fix race in tcp_poll

Tyler Hicks (1):
      eCryptfs: Clear LOOKUP_OPEN flag when creating lower file

Ulrich Weber (1):
      xfrm4: strip ECN and IP Precedence bits in policy lookup

Vasiliy Kulikov (4):
      ipc: shm: fix information leak to userland
      usb: misc: sisusbvga: fix information leak to userland
      usb: misc: iowarrior: fix information leak to userland
      usb: core: fix information leak to userland

Zhang Rui (1):
      acpi-cpufreq: fix a memleak when unloading driver

andrew hendry (1):
      memory corruption in X.25 facilities parsing

