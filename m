Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2F2Blk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:41:40 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:35518 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2F2Blj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:41:39 -0400
Message-ID: <4FED07CD.6000203@linux.vnet.ibm.com>
Date: Fri, 29 Jun 2012 09:41:33 +0800
From: Zhong Li <zhong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH powerpc 2/2] kfree the cache name  of pgtable cache if
 SLUB is used
References: <1340617984.13778.37.camel@ThinkPad-T420> <1340618099.13778.39.camel@ThinkPad-T420> <1340930720.2563.5.camel@pasglop>
In-Reply-To: <1340930720.2563.5.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062901-2674-0000-0000-00000510F866
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 08:45 AM, Benjamin Herrenschmidt wrote:
> On Mon, 2012-06-25 at 17:54 +0800, Li Zhong wrote:
> 
>> diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
>> index 620b7ac..c9d2a7f 100644
>> --- a/arch/powerpc/mm/init_64.c
>> +++ b/arch/powerpc/mm/init_64.c
>> @@ -130,6 +130,9 @@ void pgtable_cache_add(unsigned shift, void
>> (*ctor)(void *))
>>  	align = max_t(unsigned long, align, minalign);
>>  	name = kasprintf(GFP_KERNEL, "pgtable-2^%d", shift);
>>  	new = kmem_cache_create(name, table_size, align, 0, ctor);
>> +#ifdef CONFIG_SLUB
>> +	kfree(name); /* SLUB duplicates the cache name */
>> +#endif
>>  	PGT_CACHE(shift) = new;
>>  
>>  	pr_debug("Allocated pgtable cache for order %d\n", shift);
> 
> This is very gross ... and fragile. Also the subtle difference in
> semantics between SLUB and SLAB is a VERY BAD IDEA.

I agree.

> I reckon you should make the other allocators all copy the name
> instead.

Thank you for the suggestion. I will do it in the next version.

Thanks, Zhong

> Ben.
> 
> 

