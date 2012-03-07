Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab2CGFWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:22:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43185 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2CGFWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:22:16 -0500
Date: Wed, 07 Mar 2012 00:22:11 -0500 (EST)
Message-Id: <20120307.002211.1109938489960237946.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 06 Mar 2012 21:22:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) TCP can chop up SACK'd SKBs below below the unacked send
   sequence and that breaks lots of stuff.  Fix from Neal Cardwell.

2) There is code in ipv6 to properly join and leave the all-routers
   multicast code when the forwarding setting is changed, but once
   forwarding is turned on, we don't do the join for newly registered
   devices.  Fix from Li Wei.

3) Netfilter's NAT module autoload in ctnetlink drops a spinlock around
   a sleeping call, problem is this code path doesn't actually hold that
   lock.  Fix from Pablo Neira Ayuso.

4) TG3 uses the wrong interfaces to hook into the new byte queue limit
   support.  It uses the device level interfaces, which is fine for
   single queue devices, but on more recent chips this driver supports
   multiqueue so we have to use the multiqueue BQL APIs.  Fix from Tom
   Herbert.

5) r8169 resume fix from Francois Romieu.

6) Add some cxgb4 device IDs, from Vipul Pandya.

Please pull, thanks a lot!

The following changes since commit 55062d061790b43aee01ab3f9ac57b8596254f19:

  x86: fix typo in recent find_vma_prev purge (2012-03-06 18:48:13 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

Florian Westphal (1):
      bridge: netfilter: don't call iptables on vlan packets if sysctl is off

Li Wei (1):
      IPv6: Fix not join all-router mcast group when forwarding set.

Neal Cardwell (1):
      tcp: fix tcp_shift_skb_data() to not shift SACKed data below snd_una

Pablo Neira Ayuso (3):
      netfilter: ctnetlink: remove incorrect spin_[un]lock_bh on NAT module autoload
      netfilter: bridge: fix wrong pointer dereference
      netfilter: nf_conntrack: fix early_drop with reliable event delivery

Santosh Nayak (1):
      netfilter: ebtables: fix wrong name length while copying to user-space

Sjur Brændeland (1):
      caif-hsi: Set default MTU to 4096

Tom Herbert (1):
      tg3: Fix to use multi queue BQL interfaces

Vipul Pandya (2):
      cxgb4: Add support for Chelsio's T480-CR and T440-LP-CR adapters
      cxgb4vf: Add support for Chelsio's T480-CR and T440-LP-CR adapters

Yevgeny Petrilin (1):
      mlx4_core: remove buggy sched_queue masking

françois romieu (1):
      r8169: runtime resume before shutdown.

 drivers/net/caif/caif_hsi.c                        |    2 +-
 drivers/net/ethernet/broadcom/tg3.c                |    6 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    2 +
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |    2 +
 drivers/net/ethernet/mellanox/mlx4/qp.c            |    5 ---
 drivers/net/ethernet/realtek/r8169.c               |    5 +++
 net/bridge/br_netfilter.c                          |   32 +++++++++++--------
 net/bridge/netfilter/ebtables.c                    |   16 ++++++++--
 net/ipv4/tcp_input.c                               |    4 ++
 net/ipv6/addrconf.c                                |    4 ++
 net/netfilter/nf_conntrack_core.c                  |    8 ++++-
 net/netfilter/nf_conntrack_netlink.c               |    3 --
 12 files changed, 58 insertions(+), 31 deletions(-)
