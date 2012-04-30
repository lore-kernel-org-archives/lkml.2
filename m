Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab2D3Rkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 13:40:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40988 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2D3Rkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 13:40:45 -0400
Date: Mon, 30 Apr 2012 13:38:34 -0400 (EDT)
Message-Id: <20120430.133834.1047789597359787120.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: denys@visp.net.lb, netdev@vger.kernel.org, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kernel@vger.kernel.org,
        glommer@parallels.com
Subject: Re: inconsistent lock/deadlock crash, vanilla 3.3.4, 32bit, tcp
From: David Miller <davem@davemloft.net>
In-Reply-To: <1335691316.2900.100.camel@edumazet-glaptop>
References: <1335688036.2900.80.camel@edumazet-glaptop>
	<4ba0969cecac9a8e677d1b1eed1a5742@visp.net.lb>
	<1335691316.2900.100.camel@edumazet-glaptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Apr 2012 10:38:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 29 Apr 2012 11:21:56 +0200

> From: Eric Dumazet <edumazet@google.com>
> 
> [PATCH] net: fix sk_sockets_allocated_read_positive
> 
> Denys Fedoryshchenko reported frequent crashes on a proxy server and kindly
> provided a lockdep report that explains it all :
 ...
> Bug is that sk_sockets_allocated_read_positive() calls
> percpu_counter_sum_positive() without BH being disabled.
> 
> This bug was added in commit 180d8cd942ce33
> (foundations of per-cgroup memory pressure controlling.), since previous
> code was using percpu_counter_read_positive() which is IRQ safe.
> 
> In __sk_mem_schedule() we dont need the precise count of allocated
> sockets and can revert to previous behavior.
> 
> Reported-by: Denys Fedoryshchenko <denys@visp.net.lb>
> Sined-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks.
