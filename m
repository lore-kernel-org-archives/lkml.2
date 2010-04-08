Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab0DHS7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:59:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6326 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab0DHS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:59:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=QyNvvPFiLMJclna0gFBnCqze653iZMfVy//hCbbyr4qvrmMWY6H6Uhw80XBNpg3iQ
	6uuIOtsbfGFTuzYaShROg==
Date: Thu, 8 Apr 2010 11:59:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/2] slub: Fix kmem_ptr_validate() for non-kernel
 pointers
In-Reply-To: <1270657421-1937-2-git-send-email-penberg@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1004081159070.21040@chino.kir.corp.google.com>
References: <1270657421-1937-1-git-send-email-penberg@cs.helsinki.fi> <1270657421-1937-2-git-send-email-penberg@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Pekka Enberg wrote:

> As suggested by Linus, fix up kmem_ptr_validate() to handle non-kernel pointers
> more graciously. The patch changes kmem_ptr_validate() to use the newly
> introduced kern_ptr_validate() helper to check that a pointer is a valid kernel
> pointer before we attempt to convert it into a 'struct page'.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>

> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/slub.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index b364844..7d6c8b1 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2386,6 +2386,9 @@ int kmem_ptr_validate(struct kmem_cache *s, const void *object)
>  {
>  	struct page *page;
>  
> +	if (!kern_ptr_validate(object, s->size))
> +		return 0;
> +
>  	page = get_object_page(object);
>  
>  	if (!page || s != page->slab)
