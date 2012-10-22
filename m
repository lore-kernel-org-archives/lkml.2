Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2JVOqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:46:00 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:48390 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754737Ab2JVOp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:45:59 -0400
Date: Mon, 22 Oct 2012 14:45:58 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] slab: move kmem_cache_free to common code
In-Reply-To: <1350914737-4097-3-git-send-email-glommer@parallels.com>
Message-ID: <0000013a88eff593-50da3bb8-3294-41db-9c32-4e890ef6940a-000000@email.amazonses.com>
References: <1350914737-4097-1-git-send-email-glommer@parallels.com> <1350914737-4097-3-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Glauber Costa wrote:

> + * kmem_cache_free - Deallocate an object
> + * @cachep: The cache the allocation was from.
> + * @objp: The previously allocated object.
> + *
> + * Free an object which was previously allocated from this
> + * cache.
> + */
> +void kmem_cache_free(struct kmem_cache *s, void *x)
> +{
> +	__kmem_cache_free(s, x);
> +	trace_kmem_cache_free(_RET_IP_, x);
> +}
> +EXPORT_SYMBOL(kmem_cache_free);
> +

This results in an additional indirection if tracing is off. Wonder if
there is a performance impact?

