Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527Ab2JXKD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:03:57 -0400
Received: from mx2.parallels.com ([64.131.90.16]:34679 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607Ab2JXKD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:03:56 -0400
Message-ID: <5087BD06.5010904@parallels.com>
Date: Wed, 24 Oct 2012 14:03:50 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] slab: move kmem_cache_free to common code
References: <1350914737-4097-1-git-send-email-glommer@parallels.com> <1350914737-4097-3-git-send-email-glommer@parallels.com> <CAOJsxLEcUJzZnyYDPwzEkjirSKEWXcGM6PxY=nyrktFZgP7ztg@mail.gmail.com>
In-Reply-To: <CAOJsxLEcUJzZnyYDPwzEkjirSKEWXcGM6PxY=nyrktFZgP7ztg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 12:56 PM, Pekka Enberg wrote:
> On Mon, Oct 22, 2012 at 5:05 PM, Glauber Costa <glommer@parallels.com> wrote:
>> +/**
>> + * kmem_cache_free - Deallocate an object
>> + * @cachep: The cache the allocation was from.
>> + * @objp: The previously allocated object.
>> + *
>> + * Free an object which was previously allocated from this
>> + * cache.
>> + */
>> +void kmem_cache_free(struct kmem_cache *s, void *x)
>> +{
>> +       __kmem_cache_free(s, x);
>> +       trace_kmem_cache_free(_RET_IP_, x);
>> +}
>> +EXPORT_SYMBOL(kmem_cache_free);
> 
> As Christoph mentioned, this is going to hurt performance. The proper
> way to do this is to implement the *hook* in mm/slab_common.c and call
> that from all the allocator specific kmem_cache_free() functions.
> 
>                         Pekka
> 
We would ideally like the hooks to be inlined as well. Specially for the
memcg-disabled case, this will only get us a function call for no reason.


