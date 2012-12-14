Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946078Ab2LNXIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:08:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37269 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946048Ab2LNXIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:08:41 -0500
MIME-Version: 1.0
In-Reply-To: <20121214120707.GG6898@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
	<1353955671-14385-4-git-send-email-mhocko@suse.cz>
	<CALWz4ixPmvguxQO8s9mqH+OLEXC5LDfzEVFx_qqe2hBaRcsXiA@mail.gmail.com>
	<20121211155432.GC1612@dhcp22.suse.cz>
	<CALWz4izL7fEuQhEvKa7mUqi0sa25mcFP-xnTnL3vU3Z17k7VHg@mail.gmail.com>
	<20121212090652.GB32081@dhcp22.suse.cz>
	<20121212192441.GD10374@dhcp22.suse.cz>
	<CALWz4iygkxRUJX2bEhHp6nyEwyVA8w8WxNcQqzmXuMeH8kMuYA@mail.gmail.com>
	<20121214120707.GG6898@dhcp22.suse.cz>
Date: Fri, 14 Dec 2012 15:08:40 -0800
Message-ID: <CALWz4ix9-j3rf4JRfBXo8cc3wCgBnOY5APm7h6p5NOBH2j=6WQ@mail.gmail.com>
Subject: Re: [patch v2 3/6] memcg: rework mem_cgroup_iter to use cgroup iterators
From: Ying Han <yinghan@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 4:07 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Thu 13-12-12 17:14:13, Ying Han wrote:
> [...]
>> I haven't tried this patch set yet. Before I am doing that, I am
>> curious whether changing the target reclaim to be consistent with
>> global reclaim something worthy to consider based my last reply:
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 53dcde9..3f158c5 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1911,20 +1911,6 @@ static void shrink_zone(struct zone *zone,
>> struct scan_control *sc)
>>
>>                 shrink_lruvec(lruvec, sc);
>>
>> -               /*
>> -                * Limit reclaim has historically picked one memcg and
>> -                * scanned it with decreasing priority levels until
>> -                * nr_to_reclaim had been reclaimed.  This priority
>> -                * cycle is thus over after a single memcg.
>> -                *
>> -                * Direct reclaim and kswapd, on the other hand, have
>> -                * to scan all memory cgroups to fulfill the overall
>> -                * scan target for the zone.
>> -                */
>> -               if (!global_reclaim(sc)) {
>> -                       mem_cgroup_iter_break(root, memcg);
>> -                       break;
>> -               }
>>                 memcg = mem_cgroup_iter(root, memcg, &reclaim);
>
> This wouldn't work because you would over-reclaim proportionally to the
> number of groups in the hierarchy.

Don't get it and especially of why it is different from global
reclaim? I view the global reclaim should be viewed as target reclaim,
just a matter of the root cgroup is under memory pressure.

Anyway, don't want to distract you from working on the next post. So
feel free to not follow up on this.

--Ying

>
>>         } while (memcg);
>>  }
>>
>> --Ying
>
> --
> Michal Hocko
> SUSE Labs
