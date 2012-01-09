Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab2AIWUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:20:42 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36649 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2AIWUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:20:40 -0500
Date: Mon, 09 Jan 2012 14:20:33 -0800 (PST)
Message-Id: <20120109.142033.306265625914792958.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 09 Jan 2012 14:20:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Make the new socket diag bits default to 'n'.

2) Fix assertion triggers by adding a missing napi_gro_flush() call to
   the 8139cp driver, from Francois Romieu.

3) The IGMP delay zero fix from Ben Hutchings.

4) Fix endless loop in asix driver's SKB fixup handler, from Aurelien
   Jacobs.

5) Silence lockdep warnings when we take the netdevice address list lock
   for child and parent device at the same time, which is common for
   nested devices (f.e. bonding, vlan, bridge, teaming).  From Jiri Pirko.

6) Fix socket refcounting when tcp cgroup memcontrol is enabled/disabled.
   From Glauber Costa.

7) Fix regression in r6040 driver wherein the wrong register bits were
   used.  From Cesar Eduardo Barros.

8) device ops constifications from Stephen Hemminger.

9) pktgen setting validation from the eagle eyed Dan Carpenter.

Please pull, thanks a lot!

The following changes since commit 6b3da11b3c36fdafce3a72e0e90d6c4e99e9aad5:

  Merge branch 'for-3.3' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu (2012-01-09 13:08:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

Aurelien Jacobs (1):
      asix: fix infinite loop in rx_fixup()

Ben Hutchings (1):
      igmp: Avoid zero delay when receiving odd mixture of IGMP queries

Cesar Eduardo Barros (1):
      r6040: fix typo in use of MCR0 register bits

Dan Carpenter (1):
      pktgen: set correct max and min in pktgen_setup_inject()

David S. Miller (3):
      net: Default UDP and UNIX diag to 'n'.
      smsc911x: Unconditionally include linux/smscphy.h in smsc911x.h
      net: Fix build with INET disabled.

Glauber Costa (1):
      net: fix sock_clone reference mismatch with tcp memcontrol

Jiri Pirko (2):
      net: correct lock name in dev_[uc/mc]_sync documentations.
      net: introduce netif_addr_lock_nested() and call if when appropriate

Stephen Rothwell (1):
      net: sk_update_clone is only used in net/core/sock.c

françois romieu (1):
      8139cp: fix missing napi_gro_flush.

stephen hemminger (3):
      usbnet: make ethtool_ops const
      bcm63xx: make ethtool_ops const
      netdev: make net_device_ops const

 drivers/net/ethernet/broadcom/bcm63xx_enet.c |    2 +-
 drivers/net/ethernet/emulex/benet/be_main.c  |    2 +-
 drivers/net/ethernet/rdc/r6040.c             |    2 +-
 drivers/net/ethernet/realtek/8139cp.c        |    1 +
 drivers/net/ethernet/smsc/smsc911x.h         |    2 --
 drivers/net/ethernet/tile/tilepro.c          |    3 +--
 drivers/net/usb/asix.c                       |    4 ++--
 drivers/net/usb/cdc_ncm.c                    |    4 ++--
 drivers/net/usb/ipheth.c                     |    2 +-
 drivers/net/usb/sierra_net.c                 |    2 +-
 include/linux/memcontrol.h                   |    2 --
 include/linux/netdevice.h                    |    5 +++++
 mm/memcontrol.c                              |   19 ++++++++++++++-----
 net/core/dev_addr_lists.c                    |   16 ++++++++--------
 net/core/pktgen.c                            |    4 ++--
 net/core/sock.c                              |    9 +++++++++
 net/ipv4/Kconfig                             |    6 +++++-
 net/ipv4/igmp.c                              |    2 ++
 net/unix/Kconfig                             |    2 +-
 19 files changed, 57 insertions(+), 32 deletions(-)
