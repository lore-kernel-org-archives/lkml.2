Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3ACBRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:17:01 -0500
Received: from ozlabs.org ([203.10.76.45]:41541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3ACBQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:16:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] cpuset: cleanup cpuset[_can]_attach()
In-Reply-To: <20130102153439.GA11220@mtj.dyndns.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org> <1354138460-19286-7-git-send-email-tj@kernel.org> <50DACF5B.6050705@huawei.com> <20121226120415.GA18193@mtj.dyndns.org> <87zk0s5h7c.fsf@rustcorp.com.au> <20130102153439.GA11220@mtj.dyndns.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 03 Jan 2013 11:17:11 +1030
Message-ID: <871ue35bzk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:
> Hello, Rusty.
>
> On Wed, Jan 02, 2013 at 03:12:15PM +1030, Rusty Russell wrote:
>> > Hmmm?  cpumask_t can't be used for stack but other than that I don't
>> > see how it would be deprecated completely.  Rusty, can you please
>> > chime in?
>> 
>> The long-never-quite-complete-plan was for struct cpumask to be
>> undefined when CONFIG_CPUMASK_OFFSTACK=y.  That means noone can declare
>> them, or pass them on the stack, since they'll get a compiler error.
>> 
>> Now, there are some cases where it really is a reason to use a static
>> bitmap, and 1/2 a K of wasted space be damned.  There's a
>> deliberately-ugly way of doing that: declare a bitmap and use
>> to_cpumask().  Of course, if we ever really want to remove NR_CPUS and
>> make it completely generic, we have to kill all these too, but noone is
>> serious about that.
>
> So, I guess this currently is caught in a place which isn't here or
> there.  I'm pretty skeptical whether it makes sense to bother about
> static usages tho.  Can I keep them for static ones?

I didn't realize that cpuset_attach was a fastpath.  If it is, put a
static there and I'll fix turn it into a bitmap when I need to.
Otherwise, please don't change the code in the first place.

Cheers,
Rusty.
