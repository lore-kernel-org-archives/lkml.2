Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1GHWzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 18:55:03 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37550 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377Ab1GHWzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 18:55:01 -0400
X-Sasl-enc: BLYyjHHYUadWBXBGoaiA4fmZWTmjKK4+YHW30lodkonb 1310165700
Date: Fri, 8 Jul 2011 15:53:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/35] 2.6.32.43-longterm review
Message-ID: <20110708225343.GA14402@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.43 release.
There are 35 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday, Jul 10, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.43-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                |    2 +-
 arch/um/kernel/dyn.lds.S                |   14 ++++-
 arch/um/kernel/uml.lds.S                |   17 ++++++
 arch/um/os-Linux/mem.c                  |    1 +
 arch/x86/xen/mmu.c                      |    9 +++-
 block/cfq-iosched.c                     |    8 +++-
 drivers/char/tty_ldisc.c                |    4 +-
 drivers/i2c/busses/i2c-taos-evm.c       |    8 ++--
 drivers/md/md.c                         |    1 +
 drivers/media/video/uvc/uvc_queue.c     |    2 +
 drivers/net/hamradio/6pack.c            |    4 +-
 drivers/net/hamradio/mkiss.c            |    4 +-
 drivers/net/wireless/ath/ath5k/eeprom.c |    8 +--
 drivers/net/wireless/ath/ath9k/pci.c    |    6 ++
 drivers/usb/core/driver.c               |   11 ++++-
 drivers/usb/core/hub.c                  |   13 +++--
 drivers/usb/host/xhci-hcd.c             |   22 ++++++--
 drivers/watchdog/mtx-1_wdt.c            |    8 +++
 fs/inode.c                              |   22 +++++---
 fs/nilfs2/btnode.c                      |   13 -----
 fs/nilfs2/btnode.h                      |    1 -
 fs/nilfs2/super.c                       |    2 +-
 include/asm-generic/bug.h               |   16 ++++++
 include/linux/clocksource.h             |    1 +
 include/linux/fs.h                      |    2 +
 include/linux/if_packet.h               |    2 +
 include/net/netlink.h                   |    2 +-
 kernel/power/snapshot.c                 |   89 ++++++++++++++++++++++++-------
 kernel/power/user.c                     |    4 +-
 kernel/taskstats.c                      |   15 ++++-
 kernel/time/clocksource.c               |   24 +++++----
 lib/debugobjects.c                      |    2 +-
 mm/hugetlb.c                            |    8 +++
 mm/ksm.c                                |    6 ++
 mm/memory.c                             |    2 +
 mm/migrate.c                            |    2 +-
 net/core/filter.c                       |    4 +-
 net/ipv4/af_inet.c                      |    3 +
 net/ipv4/inet_diag.c                    |   14 ++---
 net/ipv4/udp.c                          |    3 +
 net/ipv6/udp.c                          |    5 ++-
 net/packet/af_packet.c                  |    2 +
 net/sunrpc/auth_gss/auth_gss.c          |    4 +-
 net/sunrpc/clnt.c                       |    2 +-
 44 files changed, 290 insertions(+), 102 deletions(-)
