Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab2FYWaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:30:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53436 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab2FYWaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:30:18 -0400
Message-ID: <4FE8E5D8.80808@parallels.com>
Date: Tue, 26 Jun 2012 02:27:36 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 07/11] mm: Allocate kernel pages to the right memcg
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-8-git-send-email-glommer@parallels.com> <20120625180747.GE3869@google.com>
In-Reply-To: <20120625180747.GE3869@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.9.3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 10:07 PM, Tejun Heo wrote:
> On Mon, Jun 25, 2012 at 06:15:24PM +0400, Glauber Costa wrote:
>> When a process tries to allocate a page with the __GFP_KMEMCG flag,
>> the page allocator will call the corresponding memcg functions to
>> validate the allocation. Tasks in the root memcg can always proceed.
>>
>> To avoid adding markers to the page - and a kmem flag that would
>> necessarily follow, as much as doing page_cgroup lookups for no
>> reason, whoever is marking its allocations with __GFP_KMEMCG flag
>> is responsible for telling the page allocator that this is such an
>> allocation at free_pages() time. This is done by the invocation of
>> __free_accounted_pages() and free_accounted_pages().
>
> Shouldn't we be documenting that in the code somewhere, preferably in
> the function comments?
>
I can certainly do that.


