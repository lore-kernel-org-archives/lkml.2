Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505Ab2JXI43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:56:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39309 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab2JXI41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:56:27 -0400
MIME-Version: 1.0
In-Reply-To: <1350914737-4097-3-git-send-email-glommer@parallels.com>
References: <1350914737-4097-1-git-send-email-glommer@parallels.com>
	<1350914737-4097-3-git-send-email-glommer@parallels.com>
Date: Wed, 24 Oct 2012 11:56:25 +0300
X-Google-Sender-Auth: x7xuTmEedpALhYZr9QTXDwwi9MA
Message-ID: <CAOJsxLHuQxZ8Hh_bhidaZRMqKssRc=h3RRPPPYD=unoJU-G4AA@mail.gmail.com>
Subject: Re: [PATCH 2/2] slab: move kmem_cache_free to common code
From: Pekka Enberg <penberg@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 5:05 PM, Glauber Costa <glommer@parallels.com> wrote:
> +/**
> + * kmem_cache_free - Deallocate an object
> + * @cachep: The cache the allocation was from.
> + * @objp: The previously allocated object.
> + *
> + * Free an object which was previously allocated from this
> + * cache.
> + */
> +void kmem_cache_free(struct kmem_cache *s, void *x)
> +{
> +       __kmem_cache_free(s, x);
> +       trace_kmem_cache_free(_RET_IP_, x);
> +}
> +EXPORT_SYMBOL(kmem_cache_free);

As Christoph mentioned, this is going to hurt performance. The proper
way to do this is to implement the *hook* in mm/slab_common.c and call
that from all the allocator specific kmem_cache_free() functions.

                        Pekka
