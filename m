Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab1GTNub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:50:31 -0400
Received: from relay.parallels.com ([195.214.232.42]:52007 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1GTNua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:50:30 -0400
Message-ID: <4E26DD25.4010707@parallels.com>
Date: Wed, 20 Jul 2011 17:50:29 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
References: <20110720121612.28888.38970.stgit@localhost6> <alpine.DEB.2.00.1107201611010.3528@tiger> <4E26D7EA.3000902@parallels.com> <alpine.DEB.2.00.1107201638520.4921@tiger>
In-Reply-To: <alpine.DEB.2.00.1107201638520.4921@tiger>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Wed, 20 Jul 2011, Konstantin Khlebnikov wrote:
>>> The changelog isn't that convincing, really. This is kmem_cache_create()
>>> so I'm surprised we'd ever get NULL here in practice. Does this fix some
>>> problem you're seeing? If this is really an issue, I'd blame the page
>>> allocator as GFP_KERNEL should just work.
>>
>> nf_conntrack creates separate slab-cache for each net-namespace,
>> this patch of course not eliminates the chance of failure, but makes it more
>> acceptable.
>
> I'm still surprised you are seeing failures. mm/slab.c hasn't changed
> significantly in a long time. Why hasn't anyone reported this before? I'd
> still be inclined to shift the blame to the page allocator... Mel,
> Christoph?
>
> On Wed, 20 Jul 2011, Konstantin Khlebnikov wrote:
>> struct kmem_size for slub is more compact, it uses pecpu-pointers instead of
>> dumb NR_CPUS-size array.
>> probably better to fix this side...
>
> So how big is 'struct kmem_cache' for your configuration anyway? Fixing
> the per-cpu data structures would be nice but I'm guessing it'll be
> slightly painful for mm/slab.c.

With NR_CPUS=4096 and MAX_NUMNODES=512 its over 9k!
so it require order-4 page, meanwhile PAGE_ALLOC_COSTLY_ORDER is 3

>
>   			Pekka

