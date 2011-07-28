Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1G1JgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:36:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60398 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1G1Jfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:35:54 -0400
Date: Thu, 28 Jul 2011 02:35:49 -0700 (PDT)
Message-Id: <20110728.023549.1568333335902886028.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 28 Jul 2011 02:35:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6S9a5lD011427


1) GRO fragment handling fix from Herbert Xu.

2) Gratuitout ARP only gets emitted for first address on interface,
   we should emit them for all of them.  From Zoltan Kiss.

3) ipv6 /127 prefix handling needs more checking, from YOSHIFUJI Hideaki.

4) Fix VLAN regressions in gianfar and forcedeth, from Sebastian P√∂hn
   and Jiri Pirko.

5) Fix various corruption bugs in B43 BCMA support, which can now be
   marked non-BROKEN.  From Pavel Roskin and Rafa≈Ç Mi≈Çecki.

6) Not all device types can handle transmitting a shared SKB, as
   pktgen does in certain modes.  Track this capability with a
   flag and check it in pktgen.  Fix from Neil Horman.

7) tg3 driver 5719 4K RDMA limit workaround from Matt Carlson.

8) If cdc-phonet is the only USB net driver enabled, the build won't
   actually traverse down into drivers/net/usb due to a missing
   Makefile line.  Fix from Chris CLayton.

9) Bonding string parsing fix, plus quiet a less-than-useful noisy
   warning log message.  From Andy Gospodarek.

Please pull, thanks a lot!

The following changes since commit 95b6886526bb510b8370b625a49bc0ab3b8ff10f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 (2011-07-27 19:26:38 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net.git master

Andy Gospodarek (2):
      bonding: fix string comparison errors
      bonding: reduce noise during init

Chris Clayton (1):
      Fix cdc-phonet build

Dan Carpenter (1):
      NFC: pn533: use after free in pn533_disconnect()

David S. Miller (1):
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6

Eric Dumazet (1):
      net: sock_sendmsg_nosec() is static

Herbert Xu (1):
      gro: Only reset frag0 when skb can be pulled

Jiri Pirko (1):
      forcedeth: fix vlans

Joe Perches (1):
      net: Convert struct net_device uc_promisc to bool

John W. Linville (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Marek Vasut (2):
      ASIX: Simplify condition in rx_fixup()
      ASIX: Use only 11 bits of header for data size

Matt Carlson (9):
      tg3: Reintroduce tg3_tx_ring_info
      tg3: Simplify tx bd assignments
      tg3: Remove short DMA check for 1st fragment
      tg3: Generalize tg3_skb_error_unmap()
      tg3: Add partial fragment unmapping code
      tg3: Consolidate code that calls tg3_tx_set_bd()
      tg3: Add tx BD budgeting code
      tg3: Break larger frags into 4k chunks for 5719
      tg3: Remove 5719 jumbo frames and TSO blocks

Mihai Moldovan (1):
      wireless: fix a typo in ignore_reg_update

Neil Horman (2):
      net: add IFF_SKB_TX_SHARED flag to priv_flags
      net: Audit drivers to identify those needing IFF_TX_SKB_SHARING cleared

Pavel Roskin (1):
      b43: fix invalid memory access in b43_ssb_remove()

Rafa≈Ç Mi≈Çecki (2):
      b43: bus: fix memory corruption when setting driver's data
      b43: bcma: drop BROKEN

Randy Dunlap (1):
      net: fix eth.c kernel-doc warning

Sebastian P√∂hn (1):
      gianfar: fix bug caused by 87c288c6e9aa31720b72e2bc2d665e24e1653c3e

Sven Neumann (1):
      cfg80211: really ignore the regulatory request

Wanlong Gao (1):
      drivers:connector:remove an unused variable *tracer*

YOSHIFUJI Hideaki (1):
      ipv6: Do not leave router anycast address for /127 prefixes.

Zoltan Kiss (1):
      IPv4: Send gratuitous ARP for secondary IP addresses also

stephen hemminger (1):
      acenic: use netdev_alloc_skb_ip_align

 drivers/connector/cn_proc.c                  |    1 -
 drivers/isdn/i4l/isdn_net.c                  |    3 +
 drivers/net/Makefile                         |    1 +
 drivers/net/acenic.c                         |   45 +++--
 drivers/net/acenic.h                         |    6 +-
 drivers/net/bonding/bond_main.c              |    8 +-
 drivers/net/bonding/bond_sysfs.c             |  133 +++++++------
 drivers/net/forcedeth.c                      |   16 ++-
 drivers/net/gianfar.c                        |    6 +-
 drivers/net/ifb.c                            |    2 +-
 drivers/net/macvlan.c                        |    2 +-
 drivers/net/tg3.c                            |  287 ++++++++++++++++----------
 drivers/net/tg3.h                            |    9 +-
 drivers/net/tun.c                            |    1 +
 drivers/net/usb/asix.c                       |    7 +-
 drivers/net/veth.c                           |    2 +
 drivers/net/wan/hdlc_fr.c                    |    5 +-
 drivers/net/wireless/airo.c                  |    1 +
 drivers/net/wireless/b43/Kconfig             |    2 +-
 drivers/net/wireless/b43/bus.c               |    2 +
 drivers/net/wireless/b43/main.c              |    5 +-
 drivers/net/wireless/hostap/hostap_main.c    |    1 +
 drivers/nfc/pn533.c                          |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    1 +
 include/linux/if.h                           |    2 +
 include/linux/netdevice.h                    |    7 +-
 net/8021q/vlan_dev.c                         |    2 +-
 net/bluetooth/bnep/netdev.c                  |    1 +
 net/core/dev.c                               |    4 +-
 net/core/pktgen.c                            |    8 +-
 net/ethernet/eth.c                           |    2 +
 net/ipv4/devinet.c                           |   16 +-
 net/ipv6/addrconf.c                          |    2 +
 net/l2tp/l2tp_eth.c                          |    2 +-
 net/mac80211/iface.c                         |    1 +
 net/socket.c                                 |    2 +-
 net/wireless/reg.c                           |    7 +-
 37 files changed, 358 insertions(+), 246 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
