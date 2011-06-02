Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab1FBJGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 05:06:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63332 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412Ab1FBJGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 05:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nJsB3WGw1/c6jvANclWN31s++X+0qaOMi9HOby0exYuSxJVLQxZDNqgHITEE51IGwD
         05nwIxvBXDM0I9zd7kMx2fjev8IH4FtQWAE9iFOVdEwCb4d3l6GExvnw5CQf5l2xeP1F
         XwUyBKgUZEVejkRk1aUqK+3WHxgXUgCdAIKws=
MIME-Version: 1.0
In-Reply-To: <20110602073335.GA20630@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<BANLkTikgqSsg5+49295h7kdZ=sQpZLs4kw@mail.gmail.com>
	<20110602073335.GA20630@cmpxchg.org>
Date: Thu, 2 Jun 2011 18:06:51 +0900
Message-ID: <BANLkTikztP6RoyBgMqUHgrzJFLZrHMCs=Q@mail.gmail.com>
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
> On Thu, Jun 02, 2011 at 08:52:47AM +0900, Hiroyuki Kamezawa wrote:
>> 2011/6/1 Johannes Weiner <hannes@cmpxchg.org>:
>> Hmm, I welcome and will review this patches but.....some points I want to say.
>>
>> 1. No more conflict with Ying's work ?
>>     Could you explain what she has and what you don't in this v2 ?
>>     If Ying's one has something good to be merged to your set, please
>> include it.
>
> The problem is that the solution we came up with at LSF, i.e. the
> one-dimensional linked list of soft limit-exceeding memcgs, is not
> adequate to represent the hierarchy structure of memcgs.
>
> My solution is fundamentally different, so I don't really see possible
> synergy between the patch series right now.
>
> This was the conclusion last time:
> http://marc.info/?l=linux-mm&m=130564056215365&w=2
>

Hmm, will look.

IIUC, current design of per-zone tree is for supoorting current policy
in efficient way as "pick up the largest usage excess memcg"

If we change policy, it's natural to make changes in implementation.


>> 2. it's required to see performance score in commit log.
>
> The patch series is not a performance optimization.  But I can include
> it to prove there are no regressions.
>
yes, it's helpful.


>> 4. This work can be splitted into some small works.
>>      a) fix for current code and clean ups
>>      a') statistics
>>      b) soft limit rework
>>      c) change global reclaim
>>
>>   I like (a)->(b)->(c) order. and while (b) you can merge your work
>> with Ying's one.
>>   And for a') , I'd like to add a new file memory.reclaim_stat as I've
>> already shown.
>>   and allow resetting.
>
> Resetting reclaim statistics is a nice idea, let me have a look.
> Sorry, I am a bit behind on reviewing other patches...
>
I think I'll cut-out the patch and merge it before my full work.


>>   Hmm, how about splitting patch 2/8 into small patches and see what happens in
>>   3.2 or 3.3 ? While that, we can make softlimit works better.
>>   (and once we do 2/8, our direction will be fixed to the direction to
>> remove global LRU.)
>
> Do you have specific parts in mind that could go stand-alone?
>
> One thing I can think of is splitting up those parts:
>
>  1. move /target/ reclaim to generic code
>
>  2. convert /global/ reclaim from global lru to hierarchy reclaim
>     including root_mem_cgroup
>

Hmm, at brief look
patch 2/8
 - hierarchy walk rewrite code should be stand alone and can be merged
1st, as clean-up
 - root cgroup LRU handling was required for performance. I think we
removed tons of
  atomic ops and can remove that special handling personally. But this change of
  root cgroup handling should be in separate patch. with performance report.
....

I'll do close look later, sorry.
-Kame



>> 5. please write documentation to explain what new LRU do.
>
> Ok.
>
>> BTW, after this work, lists of ROOT cgroup comes again. I may need to check
>> codes which see memcg is ROOT or not. Because we removed many atomic
>> ops in memcg, I wonder ROOT cgroup can be accounted again..
>
> Oh, please do if you can find the time.  The memcg lru rules are
> scary!
>

IIRC, It was requested by Red*at ;)

Thanks,
-Kame
