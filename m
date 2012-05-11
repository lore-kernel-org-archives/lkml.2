Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422655Ab2EKSIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:08:39 -0400
Received: from mx2.parallels.com ([64.131.90.16]:42105 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933067Ab2EKSIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:08:34 -0400
Message-ID: <4FAD54E1.6040106@parallels.com>
Date: Fri, 11 May 2012 15:05:21 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>
Subject: Re: [PATCH v2 00/29] kmem limitation for memcg
References: <1336758272-24284-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1336758272-24284-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.105.248.83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 02:44 PM, Glauber Costa wrote:
> Hello All,
>
> This is my new take for the memcg kmem accounting.
> At this point, I consider the series pretty mature - although of course,
> bugs are always there...
>
> As a disclaimer, however, I must say that the slub code is much more stressed
> by me, since I know it better. If you have no more objections to the concepts
> presented, the remaining edges can probably be polished in a rc cycle,
> at the maintainers discretion, of course.
>
> Otherwise, I'll be happy to address any concerns of yours.
>
> Since last submission:
>
>   * memcgs can be properly removed.
>   * We are not charging based on current->mm->owner instead of current
>   * kmem_large allocations for slub got some fixes, specially for the free case
>   * A cache that is registered can be properly removed (common module case)
>     even if it spans memcg children. Slab had some code for that, now it works
>     well with both
>   * A new mechanism for skipping allocations is proposed (patch posted
>     separately already). Now instead of having kmalloc_no_account, we mark
>     a region as non-accountable for memcg.
>
Forgot to mention the ida-based index allocation, instead of keeping our 
own bitmap.
