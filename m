Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2I0BMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:12:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49821 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2I0BMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:12:33 -0400
Date: Wed, 26 Sep 2012 18:12:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <0000013a03150b18-b7c1bfbe-967f-4c33-86e0-f3ca344706cd-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.00.1209261810180.7072@chino.kir.corp.google.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com>
 <0000013a03150b18-b7c1bfbe-967f-4c33-86e0-f3ca344706cd-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012, Christoph Lameter wrote:

> > Nack, this is already handled by CREATE_MASK in the mm/slab.c allocator;
> 
> CREATE_MASK defines legal flags that can be specified. Other flags cause
> and error. This is about flags that are internal that should be ignored
> when specified.
> 

That should be ignored for the mm/slab.c allocator, yes.

> I think it makes sense to reserve some top flags for internal purposes.
> 

It depends on the implementation: if another slab allocator were to use 
additional bits that would be a no-op with mm/slab.c, then this patch 
would be too restrictive.  There's also no requirement that any "internal 
flags" reserved by a slab allocator implementation must be shared in the 
same kmem_cache field as the flags passed to kmem_cache_create() -- it's 
actually better if they aren't since they seldom need to be accessed in 
the same cacheline.
