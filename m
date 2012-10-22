Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab2JVPKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:10:34 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51621 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab2JVPKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:10:32 -0400
Message-ID: <508561E0.5000406@parallels.com>
Date: Mon, 22 Oct 2012 19:10:24 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] slab: move kmem_cache_free to common code
References: <1350914737-4097-1-git-send-email-glommer@parallels.com> <1350914737-4097-3-git-send-email-glommer@parallels.com> <0000013a88eff593-50da3bb8-3294-41db-9c32-4e890ef6940a-000000@email.amazonses.com>
In-Reply-To: <0000013a88eff593-50da3bb8-3294-41db-9c32-4e890ef6940a-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 06:45 PM, Christoph Lameter wrote:
> On Mon, 22 Oct 2012, Glauber Costa wrote:
> 
>> + * kmem_cache_free - Deallocate an object
>> + * @cachep: The cache the allocation was from.
>> + * @objp: The previously allocated object.
>> + *
>> + * Free an object which was previously allocated from this
>> + * cache.
>> + */
>> +void kmem_cache_free(struct kmem_cache *s, void *x)
>> +{
>> +	__kmem_cache_free(s, x);
>> +	trace_kmem_cache_free(_RET_IP_, x);
>> +}
>> +EXPORT_SYMBOL(kmem_cache_free);
>> +
> 
> This results in an additional indirection if tracing is off. Wonder if
> there is a performance impact?
> 
if tracing is on, you mean?

Tracing already incurs overhead, not sure how much a function call would
add to the tracing overhead.

I would not be concerned with this, but I can measure, if you have any
specific workload in mind.

