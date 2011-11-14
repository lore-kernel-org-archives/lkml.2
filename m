Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1KNUj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:39:57 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41247 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab1KNUj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:39:56 -0500
Date: Mon, 14 Nov 2011 15:36:08 -0500 (EST)
Message-Id: <20111114.153608.2064552703690099046.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sim@hostway.ca, tglx@linutronix.de, netdev@vger.kernel.org,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, davej@redhat.com,
        schwidefsky@de.ibm.com, mingo@elte.hu
Subject: Re: [3.1] Divide by zero in __tcp_select_window()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320787405.26025.10.camel@edumazet-laptop>
References: <20111108205411.GA23642@hostway.ca>
	<1320787405.26025.10.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 Nov 2011 12:36:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 08 Nov 2011 22:23:25 +0100

> OK, it seems we let a timer running while we free the socket (same error
> path than your previous bug report, because of the NULL route)
> 
> We arm this keepalive timer in tcp_create_openreq_child()
> 
> net/ipv4/tcp_minisocks.c:513
> 	if (sock_flag(newsk, SOCK_KEEPOPEN))
> 		inet_csk_reset_keepalive_timer(newsk,
> 			keepalive_time_when(newtp));
> 
> I would try to add a call to tcp_clear_xmit_timers() as well
> 
> Please try following patch :

We've been waiting quite some time to get some testing validation on
this patch, but I think it's correct.

Eric can you formally submit this?  Thanks!
