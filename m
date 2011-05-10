Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1EJD7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:59:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47416
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626Ab1EJD7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:59:23 -0400
Date: Mon, 09 May 2011 20:58:51 -0700 (PDT)
Message-Id: <20110509.205851.189693332.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.39-rc6-mmotm0506 - another lockdep splat (networking this
 time)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1304999271.3050.41.camel@edumazet-laptop>
References: <6954.1304989523@localhost>
	<1304994188.3050.17.camel@edumazet-laptop>
	<1304999271.3050.41.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 10 May 2011 05:47:51 +0200

> [PATCH net-next-2.6] net: fix two lockdep splats
> 
> Commit e67f88dd12f6 (net: dont hold rtnl mutex during netlink dump
> callbacks) switched rtnl protection to RCU, but we forgot to adjust two
> rcu_dereference() lockdep annotations :
> 
> inet_get_link_af_size() or inet_fill_link_af() might be called with
> rcu_read_lock or rtnl held, so use rcu_dereference_rtnl()
> instead of rtnl_dereference()
> 
> Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks everyone.
