Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2I0OEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:04:16 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:64739 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab2I0OEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:04:15 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 10:04:15 EDT
Date: Thu, 27 Sep 2012 13:54:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <alpine.DEB.2.00.1209261813300.7072@chino.kir.corp.google.com>
Message-ID: <0000013a08020b4d-ecc22fc9-75e4-4f1d-8a76-5496a98d1df9-000000@email.amazonses.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com> <5062C029.308@parallels.com>
 <alpine.DEB.2.00.1209261813300.7072@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012, David Rientjes wrote:

> I would suggest cachep->flags being used solely for the flags passed to
> kmem_cache_create() and seperating out all "internal flags" based on the
> individual slab allocator's implementation into a different field.  There
> should be no problem with moving CFLGS_OFF_SLAB elsewhere, in fact, I just
> removed a "dflags" field from mm/slab.c's kmem_cache that turned out never
> to be used.  You could simply reintroduce a new "internal_flags" field and
> use it at your discretion.

This means touching another field from critical paths of the allocators.
It would increase the cache footprint and therefore reduce performance.

