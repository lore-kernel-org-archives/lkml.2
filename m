Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2IZO5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:57:24 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:3926 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550Ab2IZO5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:57:23 -0400
Date: Wed, 26 Sep 2012 14:57:21 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com>
Message-ID: <0000013a03150b18-b7c1bfbe-967f-4c33-86e0-f3ca344706cd-000000@email.amazonses.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012, David Rientjes wrote:

> Nack, this is already handled by CREATE_MASK in the mm/slab.c allocator;

CREATE_MASK defines legal flags that can be specified. Other flags cause
and error. This is about flags that are internal that should be ignored
when specified.

I think it makes sense to reserve some top flags for internal purposes.

> the flag extensions beyond those defined in the generic slab.h header are
> implementation defined.  It may be true that SLAB uses a bit only
> internally (and already protects it with a BUG_ON() in
> __kmem_cache_create()) but that doesn't mean other implementations can't
> use such a flag that would be a no-op on another allocator.

Other implementations such as SLUB also use the bits in that high range.

Simply ignoring the internal bits on cache creation if they are set is
IMHO not a bit issue and simplifies Glaubers task.

