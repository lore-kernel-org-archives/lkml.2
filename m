Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab2I1ON6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:13:58 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:41382 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756714Ab2I1ON4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:13:56 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 10:13:54 EDT
Date: Fri, 28 Sep 2012 14:12:54 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <alpine.DEB.2.00.1209271552350.13360@chino.kir.corp.google.com>
Message-ID: <0000013a0d390e11-03bf6f97-a8b7-4229-9f69-84aa85795b7e-000000@email.amazonses.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com> <5062C029.308@parallels.com>
 <alpine.DEB.2.00.1209261813300.7072@chino.kir.corp.google.com> <5063F94C.4090600@parallels.com> <alpine.DEB.2.00.1209271552350.13360@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, David Rientjes wrote:

> On Thu, 27 Sep 2012, Glauber Costa wrote:
>
> > But I still don't see the big reason for your objection. If other
> > allocator start using those bits, they would not be passed to
> > kmem_cache_alloc anyway, right? So what would be the big problem in
> > masking them out before it?
> >
>
> A slab allocator implementation may allow for additional bits that are
> currently not used or used for internal purposes by the current set of
> slab allocators to be passed in the unsigned long to kmem_cache_create()
> that would be a no-op on other allocators.  It's implementation defined,
> so this masking should be done in the implementation, i.e.
> __kmem_cache_create().

Ok we can do that in the future. There is nothing in this patch that
prevents that from happening. It would affect the memcg implementation
because they can no longer simply grab the flags and pass them in for
creating another slab.

> For context, as many people who attended the kernel summit and LinuxCon
> are aware, a new slab allocator is going to be proposed soon that actually
> uses additional bits that aren't defined for all slab allocators.  My
> opinion is that leaving unused bits and reserved bits to the
> implementation is the best software engineering practice.

Could you please come out with the new allocator and post some patchsets?

We can extend the number of flags reserved if necessary but we really need
to see the source for that.
