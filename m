Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1FBM7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:59:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35159 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1FBM7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X+IPS0Ipu0FUmNa9JwhM6m5dGcQTn92Nk8Mup1vnZvAv3n7L8z5x2DgaEaHMudv4q8
         rw9jBpE1jGl0K6n/DzixdJl9RcTgldx1x9S/7vXGIYI25S5lmIVhYrwnGR4SNuqXojMk
         vcfzRJPd183LuVw6X2zgMb5/W6wMzg4Hrulac=
MIME-Version: 1.0
In-Reply-To: <20110602100007.GB20725@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<BANLkTikgqSsg5+49295h7kdZ=sQpZLs4kw@mail.gmail.com>
	<20110602073335.GA20630@cmpxchg.org>
	<BANLkTikztP6RoyBgMqUHgrzJFLZrHMCs=Q@mail.gmail.com>
	<20110602100007.GB20725@cmpxchg.org>
Date: Thu, 2 Jun 2011 21:59:40 +0900
Message-ID: <BANLkTi=xvunhqpXFJ=wJFkCuu+7Czh4nZw@mail.gmail.com>
Subject: Re: [patch 0/8] mm: memcg naturalization -rc2
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/2 Johannes Weiner <hannes@cmpxchg.org>:
> On Thu, Jun 02, 2011 at 06:06:51PM +0900, Hiroyuki Kamezawa wrote:
>> 2011/6/2 Johannes Weiner <hannes@cmpxchg.org>:
>> > On Thu, Jun 02, 2011 at 08:52:47AM +0900, Hiroyuki Kamezawa wrote:
>> >>   Hmm, how about splitting patch 2/8 into small patches and see what happens in
>> >>   3.2 or 3.3 ? While that, we can make softlimit works better.
>> >>   (and once we do 2/8, our direction will be fixed to the direction to
>> >> remove global LRU.)
>> >
>> > Do you have specific parts in mind that could go stand-alone?
>> >
>> > One thing I can think of is splitting up those parts:
>> >
>> >  1. move /target/ reclaim to generic code
>> >
>> >  2. convert /global/ reclaim from global lru to hierarchy reclaim
>> >     including root_mem_cgroup
>>
>> Hmm, at brief look
>> patch 2/8
>>  - hierarchy walk rewrite code should be stand alone and can be merged
>> 1st, as clean-up
>
> You mean introducing mem_cgroup_hierarchy_walk() and make use of it in
> mem_cgroup_hierarchical_reclaim() as a first step?
>

yes. I like to cut out a patch from a series and forward it to mainline,
and make the series smaller. in some way...


>>  - root cgroup LRU handling was required for performance. I think we
>> removed tons of
>>   atomic ops and can remove that special handling personally. But this change of
>>   root cgroup handling should be in separate patch. with performance report.
>
> I disagree.
>
> With view on the whole patch series, linking ungrouped process pages
> to the root_mem_cgroup is traded against
>
>   1. linking ungrouped process pages to the global LRU
>
>   2. linking grouped process pages to both the global LRU and the
>      memcg LRU
>
> The comparison you propose is neither fair nor relevant because it
> would never make sense to merge that patch without the others.

If you show there is no performance regression when
 - memory cgroup is configured.
 - it's not disabled by boot option
 - there are only ROOT cgroup.
(Then, I'd like to see score.)


It seems your current series is a mixture of 2 works as
"re-desgin of softlimit" and "removal of global LRU".
I don't understand why you need 2 works at once.

Above test is for the latter. You need another justification for the former.
So, I'd like to ask you to divide the series into 2 series.

Thanks,
-Kame
