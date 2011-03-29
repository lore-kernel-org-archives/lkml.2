Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934Ab1C2EDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 00:03:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43897 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1C2EDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 00:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vwFCgAsxy5ngvLT9hwrciRRoY4HD8k5VlTrHIGWzCnsEvtVB7IjXy7l2yIfTgCuHnl
         ruleWzFKsJx2O+hHIU8A==
MIME-Version: 1.0
In-Reply-To: <20110329114555.cb5d5c51.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110328093957.089007035@suse.cz>
	<AANLkTi=CPMxOg3juDiD-_hnBsXKdZ+at+i9c1YYM=vv1@mail.gmail.com>
	<20110329091254.20c7cfcb.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTin4J5kiysPdQD2aTC52U4-dy04C1g@mail.gmail.com>
	<20110329094756.49af153d.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTikgop4m9ngX6Dd1K6Jk7jsMMU0xig@mail.gmail.com>
	<20110329114555.cb5d5c51.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 28 Mar 2011 21:03:46 -0700
Message-ID: <BANLkTingVR7QvT9xyfs6o2Y4K=tZ_A9-Lw@mail.gmail.com>
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 7:45 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 28 Mar 2011 19:46:41 -0700
> Ying Han <yinghan@google.com> wrote:
>
>> On Mon, Mar 28, 2011 at 5:47 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> >
>> >> By saying that, memcg simplified the memory accounting per-cgroup but
>> >> the memory isolation is broken. This is one of examples where pages
>> >> are shared between global LRU and per-memcg LRU. It is easy to get
>> >> cgroup-A's page evicted by adding memory pressure to cgroup-B.
>> >>
>> > If you overcommit....Right ?
>>
>> yes, we want to support the configuration of over-committing the
>> machine w/ limit_in_bytes.
>>
>
> Then, soft_limit is a feature for fixing the problem. If you have problem
> with soft_limit, let's fix it.

The current implementation of soft_limit works as best-effort and some
improvement are needed. Without distracting much from this thread,
simply saying it is not optimized on which cgroup to pick from the
per-zone RB-tree.

>
>
>> >
>> >
>> >> The approach we are thinking to make the page->lru exclusive solve the
>> >> problem. and also we should be able to break the zone->lru_lock
>> >> sharing.
>> >>
>> > Is zone->lru_lock is a problem even with the help of pagevecs ?
>>
>> > If LRU management guys acks you to isolate LRUs and to make kswapd etc..
>> > more complex, okay, we'll go that way.
>>
>> I would assume the change only apply to memcg users , otherwise
>> everything is leaving in the global LRU list.
>>
>> This will _change_ the whole memcg design and concepts Maybe memcg
>> should have some kind of balloon driver to
>> > work happy with isolated lru.
>>
>> We have soft_limit hierarchical reclaim for system memory pressure,
>> and also we will add per-memcg background reclaim. Both of them do
>> targeting reclaim on per-memcg LRUs, and where is the balloon driver
>> needed?
>>
>
> If soft_limit is _not_ enough. And I think you background reclaim should
> be work with soft_limit and be triggered by global memory pressure.

This is something i can think about. Also i think we agree that we
should have efficient target reclaim
so the global LRU scanning should be eliminated.

>
> As wrote in other mail, it's not called via direct reclaim.
> Maybe its the 1st point to be shooted rather than trying big change.

Agree on this.

--Ying

>
>
>
>
> Thanks,
> -Kame
>
>
