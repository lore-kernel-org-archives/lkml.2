Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2EBPQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:16:38 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47745 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab2EBPQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:16:35 -0400
Message-ID: <4FA14F5D.4040504@parallels.com>
Date: Wed, 2 May 2012 12:14:37 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Suleiman Souhlal <suleiman@google.com>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 00/23] slab+slub accounting for memcg
References: <1334958560-18076-1-git-send-email-glommer@parallels.com> <CABCjUKDGw20nojLqvZZbn0orO1aR9dhTZ65X_7ZSZto0eMk1GQ@mail.gmail.com>
In-Reply-To: <CABCjUKDGw20nojLqvZZbn0orO1aR9dhTZ65X_7ZSZto0eMk1GQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 06:43 PM, Suleiman Souhlal wrote:
>> I am leaving destruction of caches out of the series, although most
>> >  of the infrastructure for that is here, since we did it in earlier
>> >  series. This is basically because right now Kame is reworking it for
>> >  user memcg, and I like the new proposed behavior a lot more. We all seemed
>> >  to have agreed that reclaim is an interesting problem by itself, and
>> >  is not included in this already too complicated series. Please note
>> >  that this is still marked as experimental, so we have so room. A proper
>> >  shrinker implementation is a hard requirement to take the kmem controller
>> >  out of the experimental state.
> We will have to be careful for cache destruction.
> I found several races between allocation and destruction, in my patchset.
>
> I think we should consider doing the uncharging of kmem when
> destroying a memcg in mem_cgroup_destroy() instead of in
> pre_destroy(), because it's still possible that there are threads in
> the cgroup while pre_destroy() is being called (or for threads to be
> moved into the cgroup).

I found some problems here as well.
I am trying to work ontop of what Kamezawa posted for pre_destroy() 
rework. I have one or two incorrect uncharging issues to solve, that's 
actually what is holding me for posting a new version.

expected soon

