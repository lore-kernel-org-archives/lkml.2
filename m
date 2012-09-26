Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab2IZIrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:47:00 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39760 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab2IZIqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:46:45 -0400
Message-ID: <5062C029.308@parallels.com>
Date: Wed, 26 Sep 2012 12:43:21 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 04:46 AM, David Rientjes wrote:
> On Tue, 25 Sep 2012, Christoph Lameter wrote:
> 
>>> No cache should ever pass those as a creation flags. We can just ignore
>>> this bit if it happens to be passed (such as when duplicating a cache in
>>> the kmem memcg patches)
>>
>> Acked-by: Christoph Lameter <cl@linux.com>
>>
> 
> Nack, this is already handled by CREATE_MASK in the mm/slab.c allocator; 
> the flag extensions beyond those defined in the generic slab.h header are 
> implementation defined.  It may be true that SLAB uses a bit only 
> internally (and already protects it with a BUG_ON() in 
> __kmem_cache_create()) but that doesn't mean other implementations can't 
> use such a flag that would be a no-op on another allocator.
> 

So the problem I am facing here is that when I am creating caches from
memcg, I would very much like to reuse their flags fields. They are
stored in the cache itself, so this is not a problem. But slab also
stores that flag, leading to the precise BUG_ON() on CREATE_MASK that
you quoted.

In this context, passing this flag becomes completely valid, I just need
that to be explicitly masked out.

What is your suggestion to handle this ?

