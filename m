Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2LMUIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 15:08:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40799 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab2LMUIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 15:08:16 -0500
Date: Thu, 13 Dec 2012 15:08:14 -0500 (EST)
Message-Id: <20121213.150814.688860800059241558.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A pile of fixes in response to yesterday's big merge.  The SCTP
HMAC thing hasn't been addressed yet, I'll take care of that
myself if Neil and Vlad don't show signs of life by tomorrow.

1) Use after free of SKB in tuntap code.  Fix by Eric Dumazet, reported
   by Dave Jones.

2) NFC LLCP code emits annoying kernel log message, triggerable
   by the user.  From Dave Jones.

3) Fix several endianness bugs noticed by sparse in the bridging code,
   from Stephen Hemminger.

4) Ipv6 NDISC code doesn't take padding into account properly, fix from
   YOSHIFUJI Hideaki.

5) Add missing docs to ethtool_flow_ext struct, from Yan Burman.

Please pull, thanks.

The following changes since commit 6be35c700f742e911ecedd07fcc43d4439922334:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2012-12-12 18:07:07 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to eca2a43bb0d2c6ebd528be6acb30a88435abe307:

  bridge: fix icmpv6 endian bug and other sparse warnings (2012-12-13 12:58:11 -0500)

----------------------------------------------------------------
Dave Jones (1):
      nfc: remove noisy message from llcp_sock_sendmsg

Eric Dumazet (1):
      tuntap: dont use skb after netif_rx_ni(skb)

YOSHIFUJI Hideaki / 吉藤英明 (1):
      ndisc: Fix padding error in link-layer address option.

Yan Burman (1):
      net: ethool: Document struct ethtool_flow_ext

stephen hemminger (1):
      bridge: fix icmpv6 endian bug and other sparse warnings

 drivers/net/tun.c            |  7 ++++---
 include/uapi/linux/ethtool.h | 16 ++++++++++++++--
 net/bridge/br_multicast.c    | 10 ++++++----
 net/ipv6/ndisc.c             |  2 +-
 net/nfc/llcp/sock.c          |  4 ----
 5 files changed, 25 insertions(+), 14 deletions(-)

