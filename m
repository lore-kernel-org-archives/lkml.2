Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab2I1Ugl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:36:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965005Ab2I1Uae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:34 -0400
Date: Fri, 28 Sep 2012 13:30:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <0000013a0d36b332-44a8ef43-b881-4267-bb4b-f2e441ae185c-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.00.1209281326070.21335@chino.kir.corp.google.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com>
 <0000013a03150b18-b7c1bfbe-967f-4c33-86e0-f3ca344706cd-000000@email.amazonses.com> <alpine.DEB.2.00.1209261810180.7072@chino.kir.corp.google.com> <0000013a0804637a-82ca7649-bc6c-42ef-9a2c-e79b63f47a23-000000@email.amazonses.com>
 <alpine.DEB.2.00.1209271551220.13360@chino.kir.corp.google.com> <0000013a0d36b332-44a8ef43-b881-4267-bb4b-f2e441ae185c-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Christoph Lameter wrote:

> > No, it's implementation defined so it shouldn't be in kmem_cache_create(),
> > it should be in __kmem_cache_create()
> 
> The flags are standardized between allocators. We carve out a couple of
> bits here that can be slab specific.
> 

That's true today, it won't be true in a week.

> > I'm referring to additional slab allocators that will be proposed for
> > inclusion shortly.
> 
> I am sorry but we cannot consider something that has not been discussed
> and publicly reviewed on the mailing list before. We have no way to
> understand your rationales at this point and it would take quite some time
> to review a new allocator. I would at least have expected the design of
> the allocator to be discussed on linux-mm. Nothing of that nature has
> happened as far as I can tell.
> 

Nobody here is disagreeing that the patch here is fine for slab, slub, 
and slob as they are currently implemented.  I'm simply trying to avoid 
ripping it out later and asking Glauber to consider something else that 
achieves what he needs.  There is, until this patch, no requirement 
anywhere that the flags passed to kmem_cache_create() may not be extended 
for allocator-specific behavior and I'd prefer to avoid adding such a 
specification unless absolutely necessary; in this case, there is an 
alternative that I've already outlined and it seems like Glauber is 
comfortable with using.
