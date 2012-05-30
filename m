Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2E3HW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:22:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46474 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab2E3HW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:22:58 -0400
Message-ID: <4FC5CACD.6000105@gmail.com>
Date: Wed, 30 May 2012 03:22:53 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: "'KOSAKI Motohiro'" <kosaki.motohiro@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Krishna Reddy'" <vdumpa@nvidia.com>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Hiroshi Doyu'" <hdoyu@nvidia.com>,
        "'Subash Patel'" <subashrp@gmail.com>
Subject: Re: [PATCHv2 4/4] ARM: dma-mapping: remove custom consistent dma
 region
References: <1337252085-22039-1-git-send-email-m.szyprowski@samsung.com> <1337252085-22039-5-git-send-email-m.szyprowski@samsung.com> <4FC5659D.6040805@gmail.com> <019401cd3e34$0c6af4d0$2540de70$%szyprowski@samsung.com>
In-Reply-To: <019401cd3e34$0c6af4d0$2540de70$%szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/30/12 3:15 AM), Marek Szyprowski wrote:
> Hello,
>
> On Wednesday, May 30, 2012 2:11 AM KOSAKI Motohiro wrote:
>
>>>    static void *
>>>    __dma_alloc_remap(struct page *page, size_t size, gfp_t gfp, pgprot_t prot,
>>>    	const void *caller)
>>>    {
>>> -	struct arm_vmregion *c;
>>> -	size_t align;
>>> -	int bit;
>>> +	struct vm_struct *area;
>>> +	unsigned long addr;
>>>
>>> -	if (!consistent_pte) {
>>> -		printk(KERN_ERR "%s: not initialised\n", __func__);
>>> +	area = get_vm_area_caller(size, VM_DMA | VM_USERMAP, caller);
>>
>> In this patch, VM_DMA is only used here. So, is this no effect?
>
> I introduced it mainly to let user know which areas have been allocated by the dma-mapping api.

vma->flags are limited resource, it has only 32 (or 64) bits. Please don't use it for such unimportant
thing.


> I also plan to add a check suggested by Minchan Kim in __dma_free_remap() if the vmalloc area
> have been in fact allocated with VM_DMA set.


