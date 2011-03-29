Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1C2DCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 23:02:48 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15666 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1C2DCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 23:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QRQTqZMXfRzc1SwEQgCq74INpBZEotoJWxPLba0/70bOrlkOSEyjKHrioV4BTj9StO
         KOF5E7cqTBbWNMkuLJ1Q==
MIME-Version: 1.0
In-Reply-To: <20110329112940.fcccd175.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110328093957.089007035@suse.cz>
	<AANLkTi=CPMxOg3juDiD-_hnBsXKdZ+at+i9c1YYM=vv1@mail.gmail.com>
	<20110329091254.20c7cfcb.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTin4J5kiysPdQD2aTC52U4-dy04C1g@mail.gmail.com>
	<20110329094756.49af153d.kamezawa.hiroyu@jp.fujitsu.com>
	<20110329112940.fcccd175.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 28 Mar 2011 20:02:43 -0700
Message-ID: <BANLkTikt_wJaVqUBKJYJ6rOqvL1GhqJxDw@mail.gmail.com>
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 7:29 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 29 Mar 2011 09:47:56 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> On Mon, 28 Mar 2011 17:37:02 -0700
>> Ying Han <yinghan@google.com> wrote:
>
>> > The approach we are thinking to make the page->lru exclusive solve the
>> > problem. and also we should be able to break the zone->lru_lock
>> > sharing.
>> >
>> Is zone->lru_lock is a problem even with the help of pagevecs ?
>>
>> If LRU management guys acks you to isolate LRUs and to make kswapd etc..
>> more complex, okay, we'll go that way. This will _change_ the whole
>> memcg design and concepts Maybe memcg should have some kind of balloon driver to
>> work happy with isolated lru.
>>
>> But my current standing position is "never bad effects global reclaim".
>> So, I'm not very happy with the solution.
>>
>> If we go that way, I guess we'll think we should have pseudo nodes/zones, which
>> was proposed in early days of resource controls.(not cgroup).
>>
>
> BTW, against isolation, I have one thought.
>
> Now, soft_limit_reclaim is not called in direct-reclaim path just because we thought
> kswapd works enough well. If necessary, I think we can put soft-reclaim call in
> generic do_try_to_free_pages(order=0).

We were talking about that internally and that definitely make sense to add.

>
> So, isolation problem can be reduced to some extent, isn't it ?
> Algorithm of softlimit _should_ be updated. I guess it's not heavily tested feature.

Agree and that is something we might want to go and fix. soft_limit in
general provides a nice way to
over_committing the machine, and still have control of doing target
reclaim under system memory pressure.

>
> About ROOT cgroup, I think some daemon application should put _all_ process to
> some controled cgroup. So, I don't want to think about limiting on ROOT cgroup
> without any justification.
>
> I'd like you to devide 'the talk on performance' and 'the talk on feature'.
>
> "This makes makes performance better! ...and add an feature" sounds bad to me.

Ok, then let's stick on the memory isolation feature now :)

--Ying
>
> Thanks,
> -Kame
>
>
