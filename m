Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2I1H4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:56:08 -0400
Received: from mx2.parallels.com ([64.131.90.16]:59523 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab2I1H4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:56:07 -0400
Message-ID: <506555E9.2030809@parallels.com>
Date: Fri, 28 Sep 2012 11:46:49 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com> <5062C029.308@parallels.com> <alpine.DEB.2.00.1209261813300.7072@chino.kir.corp.google.com> <5063F94C.4090600@parallels.com> <alpine.DEB.2.00.1209271552350.13360@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1209271552350.13360@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 02:56 AM, David Rientjes wrote:
> On Thu, 27 Sep 2012, Glauber Costa wrote:
> 
>> But I still don't see the big reason for your objection. If other
>> allocator start using those bits, they would not be passed to
>> kmem_cache_alloc anyway, right? So what would be the big problem in
>> masking them out before it?
>>
> 
> A slab allocator implementation may allow for additional bits that are 
> currently not used or used for internal purposes by the current set of 
> slab allocators to be passed in the unsigned long to kmem_cache_create() 
> that would be a no-op on other allocators.  It's implementation defined, 
> so this masking should be done in the implementation, i.e. 
> __kmem_cache_create().
> 
> For context, as many people who attended the kernel summit and LinuxCon 
> are aware, a new slab allocator is going to be proposed soon that actually 
> uses additional bits that aren't defined for all slab allocators.  My 
> opinion is that leaving unused bits and reserved bits to the 
> implementation is the best software engineering practice.
> 

I am happy as long as we don't BUG and can mask out that feature.
If Christoph is happy with me masking it in the SLAB only, I'm also fine.
