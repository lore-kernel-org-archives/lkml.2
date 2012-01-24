Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2AXDsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:48:23 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59649 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2AXDsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 22:48:22 -0500
MIME-Version: 1.0
In-Reply-To: <CALWz4izWYb=_svn=UJ1C--pWXv59H2ahn6EJEnTpJv-dT6WGsw@mail.gmail.com>
References: <CAJd=RBAbFd=MFZZyCKN-Si-Zt=C6dKVUaG-C7s5VKoTWfY00nA@mail.gmail.com>
	<20120123130221.GA15113@tiehlicka.suse.cz>
	<CALWz4izWYb=_svn=UJ1C--pWXv59H2ahn6EJEnTpJv-dT6WGsw@mail.gmail.com>
Date: Tue, 24 Jan 2012 09:18:21 +0530
Message-ID: <CAKTCnzk1srmgyDzmSDzMsnbjmmt1ke91=kr0C4bECyxb1J6Rog@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: fix over reclaiming mem cgroup
From: Balbir Singh <bsingharora@gmail.com>
To: Ying Han <yinghan@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Hillf Danton <dhillf@gmail.com>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 12:44 AM, Ying Han <yinghan@google.com> wrote:
> On Mon, Jan 23, 2012 at 5:02 AM, Michal Hocko <mhocko@suse.cz> wrote:
>> On Sat 21-01-12 22:49:23, Hillf Danton wrote:
>>> In soft limit reclaim, overreclaim occurs when pages are reclaimed from mem
>>> group that is under its soft limit, or when more pages are reclaimd than the
>>> exceeding amount, then performance of reclaimee goes down accordingly.
>>
>> First of all soft reclaim is more a help for the global memory pressure
>> balancing rather than any guarantee about how much we reclaim for the
>> group.
>> We need to do more changes in order to make it a guarantee.
>> For example you implementation will cause severe problems when all
>> cgroups are soft unlimited (default conf.) or when nobody is above the
>> limit but the total consumption triggers the global reclaim. Therefore
>> nobody is in excess and you would skip all groups and only bang on the
>> root memcg.
>>

True, ideally soft reclaim should not turn on and allow global reclaim
to occur in the scenario mentioned.

>> Ying Han has a patch which basically skips all cgroups which are under
>> its limit until we reach a certain reclaim priority but even for this we
>> need some additional changes - e.g. reverse the current default setting
>> of the soft limit.
>>

I'd be wary of that approach, because it might be harder to explain
the working of soft limits,I'll look at the discussion thread
mentioned earlier for the benefits of that approach.

>> Anyway, I like the nr_to_reclaim reduction idea because we have to do
>> this in some way because the global reclaim starts with ULONG
>> nr_to_scan.
>
> Agree with Michal where there are quite a lot changes we need to get
> in for soft limit before any further optimization.
>
> Hillf, please refer to the patch from Johannes
> https://lkml.org/lkml/2012/1/13/99 which got quite a lot recent
> discussions. I am expecting to get that in before further soft limit
> changes.

Balbir
