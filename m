Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1CYVCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:02:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45558
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074Ab1CYVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:02:03 -0400
Date: Fri, 25 Mar 2011 14:02:41 -0700 (PDT)
Message-Id: <20110325.140241.43053474.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2PL2H9O028454


This should be the final round, and I believe all known major
regressions added by the routing rework are cured now.

1) Route insert compares metrics incorrectly, fix from Eric Dumazet.

2) Cache route source addresses need to rechecked in more circumstances,
   and need to use the correct scope when they are being calculated.
   With help from Julian Anastasov.

3) ip_route_newports() uses the wrong source and destination addresses
   in lookup key.  Fix from Steffen Klassert.

4) Fix race in qdisc throttling, from Eric Dumazet.

5) Fix rmmod crash in myri10ge, NAPI instances are not deleted.  From
   Stanislaw Gruszka.

6) Bonding rx_handle locking still allows races, fix from Jiri Pirko.

7) mlx4 driver updates from Yevgeny Petrilin.

8) iwlwifi forgets mutex unlock on error, from Dan Carpenter.

9) orinoco needs to hold scan_lock over a larger section of code, from
   Joe Gunn.

10) Add some device IDs to rt2x00 wireless driver.  From Peter Lemenkov.

11) rtlwifi uses wrong memset() arg order, fix from Ilia Mirkin.

12) Fix panic on AR2427 ath9k chips when connecting with AP, from
    Mohammed Shafi Shajakhan.

13) When an IP address is assigned multiple times to an interface,
    using different prefixes, we sometimes leave stale subnet routes
    in the routing table when those addresses are deleted.  Fix from
    Julian Anastasov.

14) Bridge ipv6 multicast code needs to set destination address before
    using it.  Fix from Linus L√ºssing.

15) TCP moderates congestion window during undo when it need not do
    so, since undo means that recovery was false.  Fix from Yuchung
    Cheng.

16) __ip_dev_find() needs to handle to obscure case of allowing any
    IP address on a loopback device subnet, fix by adding fallback
    code which searches the local FIB table when an explicit device
    address is not found in the hash table.

17) ip_rt_update_pmtu() does one too many inet_putpeer()'s resulting
    in memory corruption and other problems.  Fix from Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 40471856f2e38e9bfa8d605295e8234421110dd6:

  Merge branch 'nfs-for-2.6.39' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-03-25 10:03:28 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Dan Carpenter (1):
      iwlwifi: missing unlock on error path

David S. Miller (7):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      tcp: Make undo_ssthresh arg to tcp_undo_cwr() a bool.
      ipv4: Fallback to FIB local table in __ip_dev_find().
      Merge branch 'sfc-2.6.39' of git://git.kernel.org/.../bwh/sfc-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      ipv4: Invalidate nexthop cache nh_saddr more correctly.
      ipv4: Fix nexthop caching wrt. scoping.

Eli Cohen (3):
      mlx4: Add blue flame support for kernel consumers
      mlx4_core: maintain available field in bitmap allocator
      mlx4_core: reserve UARs for userspace consumers

Eric Dumazet (3):
      ipv4: fix ip_rt_update_pmtu()
      net_sched: fix THROTTLED/RUNNING race
      ipv4: fix fib metrics

Felix Fietkau (1):
      mac80211: initialize sta->last_rx in sta_info_alloc

Florian Westphal (1):
      ipv6: ip6_route_output does not modify sk parameter, so make it const

Ilia Mirkin (1):
      rtlwifi: Fix memset argument order

Jiri Pirko (1):
      bonding: fix rx_handler locking

Joe Gunn (1):
      orinoco: Maintain lock until entry removed from list

Johannes Berg (1):
      iwlagn: fix error in command waiting

Julia Lawall (2):
      drivers/net/ariadne.c: Convert release_resource to release_region/release_mem_region
      drivers/net/a2065.c: Convert release_resource to release_region/release_mem_region

Julian Anastasov (4):
      ipv4: match prefsrc when deleting routes
      ipv4: fix route deletion for IPs on many subnets
      ipv4: remove the routes on secondary promotion
      ipv4: optimize route adding on secondary promotion

Linus L√ºssing (1):
      bridge: Fix possibly wrong MLD queries' ethernet source address

Marc Zyngier (1):
      NET: smsc95xx: don't use stack for async writes to the device

Micha≈Ç Miros≈Çaw (1):
      net: implement dev_disable_lro() hw_features compatibility

Mohammed Shafi Shajakhan (1):
      ath9k: Fix kernel panic in AR2427

Peter Lemenkov (4):
      rt2x00: Add rt2870 device id
      rt2x00: Add Planex Communications, Inc. RT8070
      rt2x00: Add 2L Central Europe BV 8070
      rt2x00: Add unknown Toshiba device

Randy Dunlap (2):
      wireless: fix 80211 kernel-doc warnings
      net: fix pch_gbe section mismatch warning

Senthil Balasubramanian (2):
      ath9k: Fix kernel panic caused by invalid rate index access.
      ath9k: Fix TX queue stuck issue.

Sriram (1):
      net: davinci_emac:Fix translation logic for buffer descriptor

Stanislaw Gruszka (1):
      myri10ge: fix rmmod crash

Steffen Klassert (1):
      route: Take the right src and dst addresses in ip_route_newports

Steve Hodgson (1):
      sfc: Siena: Disable write-combining when SR-IOV is enabled

T√µnu Samuel (1):
      zd1211rw: TrendNet TEW-509UB id added

Yevgeny Petrilin (14):
      mlx4_en: going out of range of TX rings when reporting stats
      mlx4_en: moderation parameters are not reseted.
      mlx4_en: optimize adaptive moderation algorithm for better latency
      mlx4_en: bringing link up when registering netdevice
      mlx4: Changing interrupt scheme
      mlx4_en: using new mlx4 interrupt scheme
      mlx4: Wake on LAN support
      mlx4_en: Reporting HW revision in ethtool -i
      mlx4: generalization of multicast steering.
      mlx4: Add support for promiscuous mode in the new steering model.
      mlx4_en: Enabling new steering
      mlx4_en: Using blue flame support
      mlx4_en: updated driver version to 1.5.4.1
      mlx4_en: Removing HW info from ethtool -i report.

Yuchung Cheng (1):
      tcp: avoid cwnd moderation in undo

armadefuego@gmail.com (1):
      orinoco: Clear dangling pointer on hardware busy

 drivers/infiniband/hw/mlx4/main.c          |   11 +-
 drivers/net/a2065.c                        |   10 +-
 drivers/net/ariadne.c                      |   10 +-
 drivers/net/bonding/bond_main.c            |   56 ++--
 drivers/net/bonding/bonding.h              |    1 +
 drivers/net/davinci_cpdma.c                |   11 +-
 drivers/net/davinci_cpdma.h                |    1 +
 drivers/net/davinci_emac.c                 |    5 +-
 drivers/net/mlx4/alloc.c                   |   13 +
 drivers/net/mlx4/cq.c                      |    2 +-
 drivers/net/mlx4/en_cq.c                   |   38 ++-
 drivers/net/mlx4/en_ethtool.c              |   66 +++-
 drivers/net/mlx4/en_main.c                 |   22 +-
 drivers/net/mlx4/en_netdev.c               |  199 +++++++--
 drivers/net/mlx4/en_port.c                 |   13 +-
 drivers/net/mlx4/en_port.h                 |   19 +-
 drivers/net/mlx4/en_rx.c                   |   11 +-
 drivers/net/mlx4/en_tx.c                   |   72 +++-
 drivers/net/mlx4/eq.c                      |  107 +++++-
 drivers/net/mlx4/fw.c                      |   25 ++
 drivers/net/mlx4/fw.h                      |    3 +
 drivers/net/mlx4/main.c                    |  119 +++++-
 drivers/net/mlx4/mcg.c                     |  646 ++++++++++++++++++++++++++--
 drivers/net/mlx4/mlx4.h                    |   50 +++
 drivers/net/mlx4/mlx4_en.h                 |   27 +-
 drivers/net/mlx4/pd.c                      |  102 +++++
 drivers/net/mlx4/port.c                    |  165 +++++++-
 drivers/net/mlx4/profile.c                 |    4 +-
 drivers/net/myri10ge/myri10ge.c            |    1 +
 drivers/net/pch_gbe/pch_gbe_main.c         |    6 +-
 drivers/net/sfc/efx.c                      |   18 +-
 drivers/net/sfc/workarounds.h              |    2 +
 drivers/net/usb/smsc95xx.c                 |   17 +-
 drivers/net/wireless/ath/ath9k/main.c      |    2 +
 drivers/net/wireless/ath/ath9k/rc.c        |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    7 +-
 drivers/net/wireless/orinoco/cfg.c         |    3 +
 drivers/net/wireless/orinoco/main.c        |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c    |    7 +-
 drivers/net/wireless/rtlwifi/efuse.c       |   31 +-
 drivers/net/wireless/zd1211rw/zd_usb.c     |    1 +
 include/linux/davinci_emac.h               |    1 +
 include/linux/ethtool.h                    |    3 +
 include/linux/mlx4/device.h                |   51 ++-
 include/linux/mlx4/qp.h                    |    1 +
 include/net/cfg80211.h                     |    3 +-
 include/net/ip6_route.h                    |    2 +-
 include/net/ip_fib.h                       |   18 +-
 include/net/mac80211.h                     |    2 +-
 include/net/netns/ipv4.h                   |    1 +
 include/net/route.h                        |    5 +-
 include/net/sch_generic.h                  |    8 +-
 net/bridge/br_multicast.c                  |    2 +-
 net/core/dev.c                             |   19 +-
 net/core/ethtool.c                         |    2 +-
 net/ipv4/devinet.c                         |   30 ++-
 net/ipv4/fib_frontend.c                    |  112 ++++-
 net/ipv4/fib_lookup.h                      |    3 +-
 net/ipv4/fib_semantics.c                   |   47 +--
 net/ipv4/fib_trie.c                        |   14 +-
 net/ipv4/route.c                           |    8 +-
 net/ipv4/tcp_input.c                       |   22 +-
 net/ipv6/route.c                           |    2 +-
 net/mac80211/sta_info.c                    |    1 +
 66 files changed, 1906 insertions(+), 364 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
