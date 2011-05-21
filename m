Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1EUGVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 02:21:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46656 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1EUGVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 02:21:03 -0400
Date: Sat, 21 May 2011 02:20:27 -0400 (EDT)
Message-Id: <20110521.022027.978642556111515425.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 20 May 2011 23:20:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I wanted to push this quickly to fix the build fallout:

1) SCTP build failed due to intersection of two commits
   happening in two different trees.

2) ipv6 RTA_PREFSRC support doesn't propagate the prefsrc
   value into new copied routes.

3) garp can use kfree_rcu() too

Please pull, thanks a lot!

The following changes since commit 557eed603159b4e007c57d97fad1333ecebd3c2e:

  Merge branch 'upstream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev (2011-05-20 14:31:27 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

David S. Miller (1):
      sctp: Fix build failure.

Eric Dumazet (1):
      garp: use kfree_rcu()

Florian Westphal (1):
      ipv6: copy prefsrc setting when copying route entry

 net/802/garp.c       |   20 ++------------------
 net/ipv6/route.c     |    1 +
 net/sctp/bind_addr.c |    2 +-
 3 files changed, 4 insertions(+), 19 deletions(-)
