Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2I0WwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:52:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2I0WwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:52:12 -0400
Date: Thu, 27 Sep 2012 15:52:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <0000013a0804637a-82ca7649-bc6c-42ef-9a2c-e79b63f47a23-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.00.1209271551220.13360@chino.kir.corp.google.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com>
 <0000013a03150b18-b7c1bfbe-967f-4c33-86e0-f3ca344706cd-000000@email.amazonses.com> <alpine.DEB.2.00.1209261810180.7072@chino.kir.corp.google.com> <0000013a0804637a-82ca7649-bc6c-42ef-9a2c-e79b63f47a23-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, Christoph Lameter wrote:

> > > > Nack, this is already handled by CREATE_MASK in the mm/slab.c allocator;
> > >
> > > CREATE_MASK defines legal flags that can be specified. Other flags cause
> > > and error. This is about flags that are internal that should be ignored
> > > when specified.
> > >
> >
> > That should be ignored for the mm/slab.c allocator, yes.
> 
> Then you are ok with the patch as is?
> 

No, it's implementation defined so it shouldn't be in kmem_cache_create(), 
it should be in __kmem_cache_create().

> There *are* multiple slab allocators using those bits! And this works for
> them. There is nothing too restrictive here. The internal flags are
> standardized by this patch to be in the highest nibble.
> 

I'm referring to additional slab allocators that will be proposed for 
inclusion shortly.
