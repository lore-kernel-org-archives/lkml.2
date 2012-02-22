Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2BVX4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 18:56:39 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46757 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab2BVX4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 18:56:38 -0500
Date: Wed, 22 Feb 2012 18:56:25 -0500 (EST)
Message-Id: <20120222.185625.1452176745900047968.davem@davemloft.net>
To: asharma@fb.com
Cc: ja@ssi.bg, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shemminger@vyatta.com
Subject: Re: route add default fails with ESRCH?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F45742F.1070605@fb.com>
References: <alpine.LFD.2.00.1202222319150.1603@ja.ssi.bg>
	<4F45638B.30305@fb.com>
	<4F45742F.1070605@fb.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 22 Feb 2012 15:56:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Sharma <asharma@fb.com>
Date: Wed, 22 Feb 2012 15:03:11 -0800

> Turns out that we had a /sbin/ifup-local that deleted all the routes
> including default gw and populated the route afresh.
> 
> route del default gw ...
> ip route | grep -v scope | awk '{print $1}' | while read route; do ip
> route flush $route; done
> 
> This worked fine with fib_hash, but breaks with fib_trie. I'll
> investigate why this was done and look for a workaround if possible.

It breaks because that script sequence quoted above depends upon the
order in which the routes are listed.  Since fib_hash and fib_trie use
different datastructures, the order in which route entries are dumped
will not be the same and this is completely unavoidable.

You therefore must not, and can not, have scripts which have such a
dependency.
