Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab3AIOKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:10:02 -0500
Received: from mx2.parallels.com ([64.131.90.16]:32844 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581Ab3AIOKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:10:01 -0500
Message-ID: <50ED7A3A.2030700@parallels.com>
Date: Wed, 9 Jan 2013 18:10:02 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>
Subject: Re: [PATCH 1/2] Add mempressure cgroup
References: <20130104082751.GA22227@lizard.gateway.2wire.net> <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org> <20130108134424.0423dc1f.akpm@linux-foundation.org>
In-Reply-To: <20130108134424.0423dc1f.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:44 AM, Andrew Morton wrote:
> On Fri,  4 Jan 2013 00:29:11 -0800
> Anton Vorontsov <anton.vorontsov@linaro.org> wrote:
> 
>> This commit implements David Rientjes' idea of mempressure cgroup.
>>
>> The main characteristics are the same to what I've tried to add to vmevent
>> API; internally, it uses Mel Gorman's idea of scanned/reclaimed ratio for
>> pressure index calculation. But we don't expose the index to the userland.
>> Instead, there are three levels of the pressure:
>>
>>  o low (just reclaiming, e.g. caches are draining);
>>  o medium (allocation cost becomes high, e.g. swapping);
>>  o oom (about to oom very soon).
>>
>> The rationale behind exposing levels and not the raw pressure index
>> described here: http://lkml.org/lkml/2012/11/16/675
>>
>> For a task it is possible to be in both cpusets, memcg and mempressure
>> cgroups, so by rearranging the tasks it is possible to watch a specific
>> pressure (i.e. caused by cpuset and/or memcg).
>>
>> Note that while this adds the cgroups support, the code is well separated
>> and eventually we might add a lightweight, non-cgroups API, i.e. vmevent.
>> But this is another story.
>>
> 
> I'd have thought that it's pretty important offer this feature to
> non-cgroups setups.  Restricting it to cgroups-only seems a large
> limitation.
> 

Why is it so, Andrew?

When we talk about "cgroups", we are not necessarily talking about the
whole beast, with all controllers enabled. Much less we are talking
about hierarchies being created, and tasks put on it.

It's an interface only. And since all controllers will always have a
special "root" cgroup, this applies to the tasks in the system all the
same. In the end of the day, if we have something like
CONFIG_MEMPRESSURE that selects CONFIG_CGROUP, the user needs to do the
same thing to actually turn on the functionality: switch a config
option. It is not more expensive, and it doesn't bring in anything extra
as well.

To actually use it, one needs to mount the filesystem, and write to a
file. Nothing else.

What is that drives this opposition towards a cgroup-only interface?
Is it about the interface, or the underlying machinery ?



