Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2LFIry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 03:47:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:51040 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2LFIrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 03:47:53 -0500
Message-ID: <50C05BB8.6090908@linutronix.de>
Date: Thu, 06 Dec 2012 09:47:52 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist: add a warning if sg_virt() is used on highmem
 pages
References: <1354706898-24515-1-git-send-email-bigeasy@linutronix.de> <20121205134604.17523790.akpm@linux-foundation.org>
In-Reply-To: <20121205134604.17523790.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 10:46 PM, Andrew Morton wrote:
>> --- a/include/linux/scatterlist.h
>> +++ b/include/linux/scatterlist.h
>> @@ -198,6 +198,9 @@ static inline dma_addr_t sg_phys(struct scatterlist *sg)
>>    **/
>>   static inline void *sg_virt(struct scatterlist *sg)
>>   {
>> +#ifdef CONFIG_DEBUG_SG
>> +	WARN_ON(PageHighMem(sg_page(sg)));
>> +#endif
>>   	return page_address(sg_page(sg)) + sg->offset;
>>   }
>
> Why won't it work?  page_address() will search the kmap table and will
> search for the page.  If the caller had previously kmapped that page,
> all is well.  If the caller has failed to kmap the page, sg_virt() will
> return a nearly-null pointer and presumably someone will later go oops.

I missed that it will work for previously mapped page. If you think
that an oops later is enough then okay, I drop this.

Sebastian
