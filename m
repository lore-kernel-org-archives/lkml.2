Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1L1DuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 22:50:17 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51784 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1L1DuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 22:50:14 -0500
Date: Tue, 27 Dec 2011 22:50:11 -0500 (EST)
Message-Id: <20111227.225011.2200443449958204960.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 27 Dec 2011 19:50:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) AF_PACKET bind() can leak a netdevice reference, from Wei Yongjun.

2) netem erroneously calls vfree() under spinlock and soft interrupt
   disable, fix from Eric Dumazet.

3) ctnetlink_get_expect() can make nfnetlink loop forever when it
   returns -EAGAIN in situations where it should not, fix from
   Pablo Neira Ayuso.

4) Autoloading connection tracking helpers cannot be done with
   spinlocks held because that operation sleeps, fix also from Pablo.

Please pull, thanks a lot!

The following changes since commit 6fd8fb7f55cb6d45e7f078cd0eaf7e3c243f6c33:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394 (2011-12-26 12:46:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

David S. Miller (1):
      Merge branch 'nf' of git://1984.lsi.us.es/net

Eric Dumazet (1):
      netem: dont call vfree() under spinlock and BH disabled

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: fix return value of ctnetlink_get_expect()
      netfilter: ctnetlink: fix scheduling while atomic if helper is autoloaded

Wei Yongjun (1):
      packet: fix possible dev refcnt leak when bind fail

 net/netfilter/nf_conntrack_netlink.c |   18 +++++++++++++-----
 net/packet/af_packet.c               |    6 +++++-
 net/sched/sch_netem.c                |    7 ++++---
 3 files changed, 22 insertions(+), 9 deletions(-)
