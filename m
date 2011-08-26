Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab1HZJNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:13:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52429 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab1HZJNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:13:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=aMsqpmRjO/+8bLLfby0GEh6K6Vdfdzllus9Qr+TuYxRlEUhLFr+Dp7zEU5YptufTp
	vYyVpLWZYznEIouHwGQ0g==
Date: Fri, 26 Aug 2011 02:13:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhao Jin <cronozhj@gmail.com>
cc: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: trivial: cleanup: remove unneeded return
In-Reply-To: <4E573F68.1020603@gmail.com>
Message-ID: <alpine.DEB.2.00.1108260211370.14732@chino.kir.corp.google.com>
References: <CADqbE94+eZPeMggwkeZsXYxmkCRddRT7OXeiEyj_b3m=g5GxUQ@mail.gmail.com> <CADqbE97+FKz-7op-nmdOVmq3mrXadaxQrtk9Zud90E7iMMEUVQ@mail.gmail.com> <4E573F68.1020603@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Zhao Jin wrote:

> Terribly sorry. It was gmail who wrapped the line.
> Please see this following version. Thanks!
> 

It's still whitespace damaged, please see Documentation/email-clients.txt.  
If it doesn't help, please add to that document with whatever eventually 
works for you, it will help many people in the future!

This probably shouldn't be cc'd to trivial, it's a candidate to go through 
Pekka's slab tree.  And once you get the email client sorted out or Pekka 
decides to do it manually, feel free to add my

	Acked-by: David Rientjes <rientjes@google.com>

even though you forgot the changelog and your own signed-off-by line on 
this one :)

> ---
>  mm/slab.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 6d90a09..82e0a0e 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3678,13 +3678,12 @@ static inline void __cache_free(struct kmem_cache
> *cachep, void *objp,
> 
>      if (likely(ac->avail < ac->limit)) {
>          STATS_INC_FREEHIT(cachep);
> -        ac->entry[ac->avail++] = objp;
> -        return;
>      } else {
>          STATS_INC_FREEMISS(cachep);
>          cache_flusharray(cachep, ac);
> -        ac->entry[ac->avail++] = objp;
>      }
> +
> +    ac->entry[ac->avail++] = objp;
>  }
> 
>  /**
