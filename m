Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2AXIP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:15:58 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:55429 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab2AXIP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:15:57 -0500
Date: Tue, 24 Jan 2012 09:15:52 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Glauber Costa <glommer@parallels.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, cgroups@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Laurent Chavey <chavey@google.com>
Subject: Re: [PATCH 3/3] net: introduce res_counter_charge_nofail() for
 socket allocations
Message-ID: <20120124081552.GB1660@cmpxchg.org>
References: <1327071436-20763-1-git-send-email-glommer@parallels.com>
 <1327071436-20763-4-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327071436-20763-4-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 06:57:16PM +0400, Glauber Costa wrote:
> There is a case in __sk_mem_schedule(), where an allocation
> is beyond the maximum, but yet we are allowed to proceed.
> It happens under the following condition:
> 
> 	sk->sk_wmem_queued + size >= sk->sk_sndbuf
> 
> The network code won't revert the allocation in this case,
> meaning that at some point later it'll try to do it. Since
> this is never communicated to the underlying res_counter
> code, there is an inbalance in res_counter uncharge operation.
> 
> I see two ways of fixing this:
> 
> 1) storing the information about those allocations somewhere
>    in memcg, and then deducting from that first, before
>    we start draining the res_counter,
> 2) providing a slightly different allocation function for
>    the res_counter, that matches the original behavior of
>    the network code more closely.
> 
> I decided to go for #2 here, believing it to be more elegant,
> since #1 would require us to do basically that, but in a more
> obscure way.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> CC: Tejun Heo <tj@kernel.org>
> CC: Li Zefan <lizf@cn.fujitsu.com>
> CC: Laurent Chavey <chavey@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
