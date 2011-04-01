Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1DAGcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:32:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58029
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142Ab1DAGcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:32:01 -0400
Date: Thu, 31 Mar 2011 23:31:22 -0700 (PDT)
Message-Id: <20110331.233122.193724953.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p316WB3c000953


1) Regression, GRE tunnels stopped working properly with multicast.
   Fix from Timo TerÃ¤s.

2) Fix DMA mapping bugs in via-ircc IRDA driver, from Ben Hutchings.

3) Header length calc wrong in br_multicast_ipv6_rcv(), from Linus
   LÃ¼ssing.

4) phy_init_hw() failures not handled, from Marc Kleine-Budde.

5) Support LG-VL600 4G modems properly, from Andrzej Zaborowski.

6) dev_forward_skb() needs to take TSO into account, from Daniel
   Lezcano and Eric W. Biederman.

7) Memory leaks in atl2 driver, from Jesper Juhl.

8) Solos-PCI ATM driver fixes from Philip A. Prindeville

9) Missing RTNL locking in ip_fib_net_exit(), from Eric Dumazet.

10) Regression in connector, all netlink requests must be processed
    synchronously now.  From Patrick McHardy.

11) Fix erroneous memory failure kernel messages in SCTP hash table
    allocation, reported by Dave Jones.

12) MLX4 driver use-after-free and event queue sizing fix from
    Yevgeny Petrilin.

13) Fix another regression in atalk_release() added by the kernel
    lock removal.  Reported by Dave Jones.

The following changes since commit ecb78ab6f30106ab72a575a25b1cdfd1633b7ca2:

  Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6 (2011-03-30 12:22:15 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Andrzej Zaborowski (1):
      net/usb: Ethernet quirks for the LG-VL600 4G modem

Balaji G (1):
      bridge: Fix compilation warning in function br_stp_recalculate_bridge_id()

Ben Hutchings (2):
      via-ircc: Use pci_{get, set}_drvdata() instead of static pointer variable
      via-ircc: Pass PCI device pointer to dma_{alloc, free}_coherent()

Daniel Lezcano (1):
      netdev: fix mtu check when TSO is enabled

David S. Miller (3):
      net: Fix warnings caused by MAX_SKB_FRAGS change.
      sctp: Pass __GFP_NOWARN to hash table allocation attempts.
      appletalk: Fix OOPS in atalk_release().

Eric Dumazet (1):
      fib: add rtnl locking in ip_fib_net_exit

Jesper Juhl (1):
      Atheros, atl2: Fix mem leaks in error paths of atl2_set_eeprom

Linus LÃ¼ssing (1):
      bridge: mcast snooping, fix length check of snooped MLDv1/2

Marc Kleine-Budde (1):
      phylib: phy_attach_direct: phy_init_hw can fail, add cleanup

Patrick McHardy (1):
      connector: convert to synchronous netlink message processing

Peter Pan(æ½˜å«å¹³) (1):
      bonding:typo in comment

Philip A. Prindeville (3):
      atm/solos-pci: Use VPI.VCI notation uniformly.
      atm/solos-pci: Don't include frame pseudo-header on transmit hex-dump
      atm/solos-pci: Don't flap VCs when carrier state changes

Timo TerÃ¤s (1):
      net: gre: provide multicast mappings for ipv4 and ipv6

Yevgeny Petrilin (2):
      mlx4: Fixing use after free
      mlx4: Fixing bad size of event queue buffer

 drivers/atm/solos-pci.c        |   39 ++----
 drivers/connector/cn_queue.c   |   58 ++-----
 drivers/connector/connector.c  |   47 ++----
 drivers/net/atlx/atl2.c        |   22 ++-
 drivers/net/bonding/bond_alb.h |    2 +-
 drivers/net/irda/via-ircc.c    |   94 +++---------
 drivers/net/mlx4/eq.c          |    4 +-
 drivers/net/mlx4/mcg.c         |    3 +-
 drivers/net/phy/phy_device.c   |    8 +-
 drivers/net/usb/Kconfig        |   15 ++
 drivers/net/usb/Makefile       |    1 +
 drivers/net/usb/cdc_ether.c    |   21 ++-
 drivers/net/usb/lg-vl600.c     |  346 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/usb/usbnet.c       |   10 +-
 include/linux/atmdev.h         |    1 +
 include/linux/connector.h      |   16 +--
 include/linux/skbuff.h         |    2 +-
 include/linux/usb/usbnet.h     |    3 +
 include/net/if_inet6.h         |   16 ++
 include/net/ip.h               |    8 +
 net/appletalk/ddp.c            |   11 +-
 net/atm/common.c               |    1 +
 net/bridge/br_multicast.c      |    2 +-
 net/bridge/br_stp_if.c         |    2 +-
 net/core/dev.c                 |   24 +++-
 net/ipv4/arp.c                 |    3 +
 net/ipv4/fib_frontend.c        |    2 +
 net/ipv6/ndisc.c               |    2 +
 net/sctp/protocol.c            |    4 +-
 29 files changed, 543 insertions(+), 224 deletions(-)
 create mode 100644 drivers/net/usb/lg-vl600.c
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
