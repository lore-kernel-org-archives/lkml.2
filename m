Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab2E3ICl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:02:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35639 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab2E3ICh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <4FC5D228.2070100@parallels.com>
References: <alpine.DEB.2.00.1205291101580.6723@router.home>
	<4FC501E9.60607@parallels.com>
	<alpine.DEB.2.00.1205291222360.8495@router.home>
	<4FC506E6.8030108@parallels.com>
	<alpine.DEB.2.00.1205291424130.8495@router.home>
	<4FC52612.5060006@parallels.com>
	<alpine.DEB.2.00.1205291454030.2504@router.home>
	<4FC52CC6.7020109@parallels.com>
	<alpine.DEB.2.00.1205291514090.2504@router.home>
	<4FC530C0.30509@parallels.com>
	<20120530012955.GA4854@google.com>
	<4FC5D228.2070100@parallels.com>
Date: Wed, 30 May 2012 17:02:35 +0900
X-Google-Sender-Auth: kiSkAbsQfUX0iYXsqnG1vRMZvvI
Message-ID: <CAOS58YPqOBgmXQia5wM1FKKj5zD2K6gbC3EyQyppFnVSM2i-gQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, May 30, 2012 at 4:54 PM, Glauber Costa <glommer@parallels.com> wrote:
> On 05/30/2012 05:29 AM, Tejun Heo wrote:
>>
>> The two goals for cgroup controllers that I think are important are
>> proper (no, not crazy perfect but good enough) isolation and an
>> implementation which doesn't impact !cg path in an intrusive manner -
>> if someone who doesn't care about cgroup but knows and wants to work
>> on the subsystem should be able to mostly ignore cgroup support.  If
>> that means overhead for cgroup users, so be it.
>
>
> Well, my code in the slab is totally wrapped in static branches. They only
> come active when the first group is *limited* (not even created: you can
> have a thousand memcg, if none of them are kmem limited, nothing will
> happen).

Great, but I'm not sure why you're trying to emphasize that while my
point was about memory overhead and that it's OK to have some
overheads for cg users. :)

> After that, the cost paid is to find out at which cgroup the process is at.
> I believe that if we had a faster way for this (like for instance: if we had
> a single hierarchy, the scheduler could put this in a percpu variable after
> context switch - or any other method), then the cost of it could be really
> low, even when this is enabled.

Someday, hopefully.

> I will rework this series to try work more towards this goal, but at least
> for now I'll keep duplicating the caches. I still don't believe that a loose
> accounting to the extent Christoph proposed will achieve what we need this
> to achieve.

Yeah, I prefer your per-cg cache approach but do hope that it stays as
far from actual allocator code as possible. Christoph, would it be
acceptable if the cg logic is better separated?

Thanks.

-- 
tejun
