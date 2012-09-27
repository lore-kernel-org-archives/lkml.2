Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2I0BQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:16:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40411 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2I0BQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:16:14 -0400
Date: Wed, 26 Sep 2012 18:16:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <5062C029.308@parallels.com>
Message-ID: <alpine.DEB.2.00.1209261813300.7072@chino.kir.corp.google.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com> <5062C029.308@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012, Glauber Costa wrote:

> So the problem I am facing here is that when I am creating caches from
> memcg, I would very much like to reuse their flags fields. They are
> stored in the cache itself, so this is not a problem. But slab also
> stores that flag, leading to the precise BUG_ON() on CREATE_MASK that
> you quoted.
> 
> In this context, passing this flag becomes completely valid, I just need
> that to be explicitly masked out.
> 
> What is your suggestion to handle this ?
> 

I would suggest cachep->flags being used solely for the flags passed to 
kmem_cache_create() and seperating out all "internal flags" based on the 
individual slab allocator's implementation into a different field.  There 
should be no problem with moving CFLGS_OFF_SLAB elsewhere, in fact, I just 
removed a "dflags" field from mm/slab.c's kmem_cache that turned out never 
to be used.  You could simply reintroduce a new "internal_flags" field and 
use it at your discretion.
