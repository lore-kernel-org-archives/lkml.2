Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab2KSN5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 08:57:48 -0500
Received: from mx2.parallels.com ([64.131.90.16]:46761 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2KSN5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 08:57:47 -0500
Message-ID: <50AA3ABF.4090803@parallels.com>
Date: Mon, 19 Nov 2012 17:57:19 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>,
        <linux-man@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
References: <20121107105348.GA25549@lizard> <20121107112136.GA31715@shutemov.name> <CAOJsxLHY+3ZzGuGX=4o1pLfhRqjkKaEMyhX0ejB5nVrDvOWXNA@mail.gmail.com> <20121107114321.GA32265@shutemov.name> <alpine.DEB.2.00.1211141910050.14414@chino.kir.corp.google.com> <20121115033932.GA15546@lizard.sbx05977.paloaca.wayport.net> <alpine.DEB.2.00.1211141946370.14414@chino.kir.corp.google.com> <20121115073420.GA19036@lizard.sbx05977.paloaca.wayport.net> <alpine.DEB.2.00.1211142351420.4410@chino.kir.corp.google.com> <20121115085224.GA4635@lizard> <alpine.DEB.2.00.1211151303510.27188@chino.kir.corp.google.com> <50A60873.3000607@parallels.com> <alpine.DEB.2.00.1211161157390.2788@chino.kir.corp.google.com> <50A6AC48.6080102@parallels.com> <alpine.DEB.2.00.1211161349420.17853@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211161349420.17853@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2012 01:57 AM, David Rientjes wrote:
> On Sat, 17 Nov 2012, Glauber Costa wrote:
> 
>>> I'm wondering if we should have more than three different levels.
>>>
>>
>> In the case I outlined below, for backwards compatibility. What I
>> actually mean is that memcg *currently* allows arbitrary notifications.
>> One way to merge those, while moving to a saner 3-point notification, is
>> to still allow the old writes and fit them in the closest bucket.
>>
> 
> Yeah, but I'm wondering why three is the right answer.
> 

This is unrelated to what I am talking about.
I am talking about pre-defined values with a specific event meaning (in
his patchset, 3) vs arbitrary numbers valued in bytes.

>>> Umm, why do users of cpusets not want to be able to trigger memory 
>>> pressure notifications?
>>>
>> Because cpusets only deal with memory placement, not memory usage.
> 
> The set of nodes that a thread is allowed to allocate from may face memory 
> pressure up to and including oom while the rest of the system may have a 
> ton of free memory.  Your solution is to compile and mount memcg if you 
> want notifications of memory pressure on those nodes.  Others in this 
> thread have already said they don't want to rely on memcg for any of this 
> and, as Anton showed, this can be tied directly into the VM without any 
> help from memcg as it sits today.  So why implement a simple and clean 
> mempressure cgroup that can be used alone or co-existing with either memcg 
> or cpusets?
> 
>> And it is not that moving a task to cpuset disallows you to do any of
>> this: you could, as long as the same set of tasks are mounted in a
>> corresponding memcg.
>>
> 
> Same thing with a separate mempressure cgroup.  The point is that there 
> will be users of this cgroup that do not want the overhead imposed by 
> memcg (which is why it's disabled in defconfig) and there's no direct 
> dependency that causes it to be a part of memcg.
> 
I think we should shoot the duck where it is going, not where it is. A
good interface is more important than overhead, since this overhead is
by no means fundamental - memcg is fixable, and we would all benefit
from it.

Now, whether or not memcg is the right interface is a different
discussion - let's have it!

