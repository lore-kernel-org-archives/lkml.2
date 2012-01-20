Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2ATRH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:07:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46748 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2ATRHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:07:55 -0500
Date: Fri, 20 Jan 2012 09:07:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>, Laurent Chavey <chavey@google.com>
Subject: Re: [PATCH 3/3] net: introduce res_counter_charge_nofail() for
 socket allocations
Message-ID: <20120120170749.GA3086@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1327071436-20763-1-git-send-email-glommer@parallels.com>
 <1327071436-20763-4-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327071436-20763-4-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
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

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
