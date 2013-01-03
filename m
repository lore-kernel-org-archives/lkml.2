Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab3ACC3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 21:29:17 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:40291 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3ACC3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 21:29:16 -0500
Date: Wed, 2 Jan 2013 21:29:11 -0500
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Li Zefan <lizefan@huawei.com>, paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] cpuset: cleanup cpuset[_can]_attach()
Message-ID: <20130103022911.GH11220@mtj.dyndns.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
 <1354138460-19286-7-git-send-email-tj@kernel.org>
 <50DACF5B.6050705@huawei.com>
 <20121226120415.GA18193@mtj.dyndns.org>
 <87zk0s5h7c.fsf@rustcorp.com.au>
 <20130102153439.GA11220@mtj.dyndns.org>
 <871ue35bzk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ue35bzk.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

On Thu, Jan 03, 2013 at 11:17:11AM +1030, Rusty Russell wrote:
> > So, I guess this currently is caught in a place which isn't here or
> > there.  I'm pretty skeptical whether it makes sense to bother about
> > static usages tho.  Can I keep them for static ones?
> 
> I didn't realize that cpuset_attach was a fastpath.  If it is, put a

It isn't a hot path.  It's just a bit nasty to have to allocate them
separately.

> static there and I'll fix turn it into a bitmap when I need to.
> Otherwise, please don't change the code in the first place.

So, the plan to drop cpumask_t is still on?  If so, I'll leave
cpumask_var_t.

Thanks.

-- 
tejun
