Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423208Ab2KNSpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:45:08 -0500
Received: from mx2.parallels.com ([64.131.90.16]:35106 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423019Ab2KNSpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:45:07 -0500
Message-ID: <50A45729.4000203@parallels.com>
Date: Thu, 15 Nov 2012 06:44:57 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>
Subject: Re: [RFC] rework mem_cgroup iterator
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz> <50A3C42F.9020901@parallels.com> <20121114184110.GD21185@mtj.dyndns.org>
In-Reply-To: <20121114184110.GD21185@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 10:41 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Wed, Nov 14, 2012 at 05:17:51PM +0100, Glauber Costa wrote:
>> Why can't we reuse the scheduler iterator and move it to kernel/cgroup.c
>> ? It already exists, provide sane ordering, and only relies on parent
>> information - which cgroup core already have - to do the walk.
> 
> Hmmm... we can but I personally much prefer for_each_*() iterators
> over callback based ones.  It's just much easier to share states
> across an iteration and follow the logic.  walk_tg_tree_from() does
> have the benefit of being able to combine pre and post visits in the
> same walk, which doesn't seem to have any user at the moment.
> 
> Thanks.
> 

Is there any particular reason why we can't do the other way around
then, and use a for_each_*() for sched walks? Without even consider what
I personally prefer, what I really don't like is to have two different
cgroup walkers when it seems like we could very well have just one.
