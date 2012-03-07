Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029Ab2CGUiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:38:51 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53308 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab2CGUit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:38:49 -0500
Date: Wed, 07 Mar 2012 15:16:25 -0500 (EST)
Message-Id: <20120307.151625.829659631072828076.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: Valdis.Kletnieks@vt.edu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.3.0-rc6-next20120305 net/ipv4/tcp_ipv4.c:930 suspicious
 rcu_dereference_check() usage!
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331131543.2474.72.camel@edumazet-laptop>
References: <30475.1331126726@turing-police.cc.vt.edu>
	<1331131543.2474.72.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Mar 2012 12:38:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 07 Mar 2012 06:45:43 -0800

> [PATCH net-next] tcp: md5: correct a RCU lockdep splat
> 
> commit a8afca0329 (tcp: md5: protects md5sig_info with RCU) added a
> lockdep splat in tcp_md5_do_lookup() in case a timer fires a tcp
> retransmit.
> 
> At this point, socket lock is owned by the sofirq handler, not the user,
> so we should adjust a bit the lockdep condition, as we dont hold
> rcu_read_lock().
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Reported-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Applied, thanks Eric.
