Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1EJV7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:59:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35138
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163Ab1EJV7l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:59:41 -0400
Date: Tue, 10 May 2011 14:59:09 -0700 (PDT)
Message-Id: <20110510.145909.193724537.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.39-rc6-mmotm0506 - another lockdep splat (networking this
 time)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305064116.2437.34.camel@edumazet-laptop>
References: <1304999271.3050.41.camel@edumazet-laptop>
	<20110509.205851.189693332.davem@davemloft.net>
	<1305064116.2437.34.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 10 May 2011 23:48:36 +0200

> Le lundi 09 mai 2011 à 20:58 -0700, David Miller a écrit :
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Tue, 10 May 2011 05:47:51 +0200
>> 
>> > [PATCH net-next-2.6] net: fix two lockdep splats
>> > 
>> > Commit e67f88dd12f6 (net: dont hold rtnl mutex during netlink dump
>> > callbacks) switched rtnl protection to RCU, but we forgot to adjust two
>> > rcu_dereference() lockdep annotations :
>> > 
>> > inet_get_link_af_size() or inet_fill_link_af() might be called with
>> > rcu_read_lock or rtnl held, so use rcu_dereference_rtnl()
>> > instead of rtnl_dereference()
>> > 
>> > Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
>> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> 
>> Applied, thanks everyone.
> 
> David, I found you applied this patch for net-2.6, but it was
> net-next-2.6 material only ...

Thanks for catching that, I'll fix this.
