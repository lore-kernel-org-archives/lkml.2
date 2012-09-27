Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2I0WvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 18:51:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48008 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab2I0WvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:51:03 -0400
Date: Thu, 27 Sep 2012 15:50:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <0000013a08020b4d-ecc22fc9-75e4-4f1d-8a76-5496a98d1df9-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.00.1209271546460.13360@chino.kir.corp.google.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com> <5062C029.308@parallels.com>
 <alpine.DEB.2.00.1209261813300.7072@chino.kir.corp.google.com> <0000013a08020b4d-ecc22fc9-75e4-4f1d-8a76-5496a98d1df9-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, Christoph Lameter wrote:

> > I would suggest cachep->flags being used solely for the flags passed to
> > kmem_cache_create() and seperating out all "internal flags" based on the
> > individual slab allocator's implementation into a different field.  There
> > should be no problem with moving CFLGS_OFF_SLAB elsewhere, in fact, I just
> > removed a "dflags" field from mm/slab.c's kmem_cache that turned out never
> > to be used.  You could simply reintroduce a new "internal_flags" field and
> > use it at your discretion.
> 
> This means touching another field from critical paths of the allocators.
> It would increase the cache footprint and therefore reduce performance.
> 

To clarify your statement, you're referring to the mm/slab.c allocation of 
new slab pages and when debugging is enabled as "critical paths", correct?  
We would disagree on that point.
