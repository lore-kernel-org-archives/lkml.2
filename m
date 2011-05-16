Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1EPUaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:30:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47067 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1EPUaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:30:04 -0400
Date: Mon, 16 May 2011 16:29:26 -0400 (EDT)
Message-Id: <20110516.162926.253137939196517730.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 16 May 2011 13:29:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) SFC crashes on 'ethtool -d', from Ben Hutchings.

2) VMXNET3 driver doesn't set LRO correctly on probe, this hits a lot
   of VMWare users.  Fix from Thomas Jarosch.

3) IPVS needs to use correct SEQ release interface, otherwise it leaks
   netns references.  Fix from Hans Schillstrom.

4) Users can (via tun/tap for example) trigger the warnings generated
   by the netdevice feature validation checks we make.  Make such
   warnings of DEBUG level so user's can spam the logs.  Fix from
   Micha©© Miros©©aw.

There is a dup of bridge netfilter fix (already in your tree) with
commit ID cb68552858c64db302771469b1202ea09e696329 in here because
Pablo applied it to the netfilter tree as well (and in his tree it
appears as commit d8083deb4f1aa0977980dfb834fcc336ef38318f).  So when
I merged his tree to get the IPVS namespace leak fix, I got the bridge
netfilter fix dup too.

Please pull, thanks a lot!

The following changes since commit df8d06ade6eed9077f658ac8696fc1cb5c081220:

  Merge branch 'omap-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6 (2011-05-16 08:55:49 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Ben Hutchings (1):
      sfc: Fix oops in register dump after mapping change

David S. Miller (1):
      Merge branch 'pablo/nf-2.6-updates' of git://1984.lsi.us.es/net-2.6

Hans Schillstrom (1):
      IPVS: fix netns if reading ip_vs_* procfs entries

Micha©© Miros©©aw (1):
      net: Change netdev_fix_features messages loglevel

Stephen Hemminger (1):
      bridge: fix forwarding of IPv6

Thomas Jarosch (1):
      vmxnet3: Fix inconsistent LRO state after initialization

 drivers/net/sfc/nic.c                 |    7 +++++++
 drivers/net/vmxnet3/vmxnet3_ethtool.c |    3 +++
 net/core/dev.c                        |   22 ++++++++--------------
 net/netfilter/ipvs/ip_vs_app.c        |    2 +-
 net/netfilter/ipvs/ip_vs_conn.c       |    4 ++--
 net/netfilter/ipvs/ip_vs_ctl.c        |    6 +++---
 6 files changed, 24 insertions(+), 20 deletions(-)
