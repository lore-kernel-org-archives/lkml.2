Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2I0W4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:56:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34235 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab2I0W4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:56:05 -0400
Date: Thu, 27 Sep 2012 15:56:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <5063F94C.4090600@parallels.com>
Message-ID: <alpine.DEB.2.00.1209271552350.13360@chino.kir.corp.google.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com> <5062C029.308@parallels.com>
 <alpine.DEB.2.00.1209261813300.7072@chino.kir.corp.google.com> <5063F94C.4090600@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, Glauber Costa wrote:

> But I still don't see the big reason for your objection. If other
> allocator start using those bits, they would not be passed to
> kmem_cache_alloc anyway, right? So what would be the big problem in
> masking them out before it?
> 

A slab allocator implementation may allow for additional bits that are 
currently not used or used for internal purposes by the current set of 
slab allocators to be passed in the unsigned long to kmem_cache_create() 
that would be a no-op on other allocators.  It's implementation defined, 
so this masking should be done in the implementation, i.e. 
__kmem_cache_create().

For context, as many people who attended the kernel summit and LinuxCon 
are aware, a new slab allocator is going to be proposed soon that actually 
uses additional bits that aren't defined for all slab allocators.  My 
opinion is that leaving unused bits and reserved bits to the 
implementation is the best software engineering practice.
