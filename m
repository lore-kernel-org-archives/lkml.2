Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2E2TmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 15:42:23 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40960 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab2E2TmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 15:42:22 -0400
Message-ID: <4FC52612.5060006@parallels.com>
Date: Tue, 29 May 2012 23:40:02 +0400
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
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290932530.4666@router.home> <4FC4F1A7.2010206@parallels.com> <alpine.DEB.2.00.1205291101580.6723@router.home> <4FC501E9.60607@parallels.com> <alpine.DEB.2.00.1205291222360.8495@router.home> <4FC506E6.8030108@parallels.com> <alpine.DEB.2.00.1205291424130.8495@router.home>
In-Reply-To: <alpine.DEB.2.00.1205291424130.8495@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 11:26 PM, Christoph Lameter wrote:
> On Tue, 29 May 2012, Glauber Costa wrote:
>
>> But we really need a page to be filled with objects from the same cgroup, and
>> the non-shared objects to be accounted to the right place.
>
> No other subsystem has such a requirement. Even the NUMA nodes are mostly
> suggestions and can be ignored by the allocators to use memory from other
> pages.

Of course it does. Memcg itself has such a requirement. The collective 
set of processes needs to have the pages it uses accounted to it, and 
never go over limit.

>> Otherwise, I don't think we can meet even the lighter of isolation guarantees.
>
> The approach works just fine with NUMA and cpusets. Isolation is mostly
> done on the per node boundaries and you already have per node statistics.

I don't know about cpusets in details, but at least with NUMA, this is 
not an apple-to-apple comparison. a NUMA node is not meant to contain 
you. A container is, and that is why it is called a container.

NUMA just means what is the *best* node to put my memory.
Now, if you actually say, through you syscalls "this is the node it 
should live in", then you have a constraint, that to the best of my 
knowledge is respected.

Now isolation here, is done in the container boundary. (cgroups, to be 
generic).
