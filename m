Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab2E2RCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:02:17 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47623 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab2E2RCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:02:16 -0400
Message-ID: <4FC5008A.1060808@parallels.com>
Date: Tue, 29 May 2012 20:59:54 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 12/28] slab: pass memcg parameter to kmem_cache_create
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-13-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290922340.4666@router.home> <4FC4F04F.1070401@parallels.com> <alpine.DEB.2.00.1205291131590.6723@router.home> <4FC4FAF6.8060900@parallels.com> <alpine.DEB.2.00.1205291149280.8406@router.home>
In-Reply-To: <alpine.DEB.2.00.1205291149280.8406@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 08:52 PM, Christoph Lameter wrote:
> Well kmem_cache_alloc cache is the performance critical hotpath.
>
> If you are already there and doing all of that then would it not be better
> to simply count the objects allocated and freed per cgroup? Directly
> increment and decrement counters in a cgroup? You do not really need to
> duplicate the kmem_cache structure and do not need to modify allocators if
> you are willing to take that kind of a performance hit. Put a wrapper
> around kmem_cache_alloc/free and count things.

Well, I see it as the difference between being a big slower, and a lot 
slower.

Accounting in memcg is hard, specially because it is potentially 
hierarchical, (meaning you need to nest downwards until your parents).

I never discussed that this is, unfortunately, a hotpath. However, I did 
try to minimize the impact as much as I could.

Not to mention that the current scheme is bound to improvement as 
cgroups improve. One of the things being discussed is to having all 
cgroups always in the same hierarchy. If that ever happens, we can have 
the information about the current cgroup stored in a very accessible 
way, so to make this even faster.

This felt like the best way I could do with the current infrastructure, 
(and again, I did make it free for people not limiting kmem), and is 
way, way cheaper than doing accounting here.

