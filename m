Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab2E3HQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:16:03 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32996 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab2E3HP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:15:59 -0400
Date: Wed, 30 May 2012 09:15:53 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv2 4/4] ARM: dma-mapping: remove custom consistent dma region
In-reply-to: <4FC5659D.6040805@gmail.com>
To: "'KOSAKI Motohiro'" <kosaki.motohiro@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Krishna Reddy'" <vdumpa@nvidia.com>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Hiroshi Doyu'" <hdoyu@nvidia.com>,
        "'Subash Patel'" <subashrp@gmail.com>
Message-id: <019401cd3e34$0c6af4d0$2540de70$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Ac09+LkV1X9UXSC6RJC9eDuE1GoLUgAOiDQg
References: <1337252085-22039-1-git-send-email-m.szyprowski@samsung.com>
 <1337252085-22039-5-git-send-email-m.szyprowski@samsung.com>
 <4FC5659D.6040805@gmail.com>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, May 30, 2012 2:11 AM KOSAKI Motohiro wrote:

> >   static void *
> >   __dma_alloc_remap(struct page *page, size_t size, gfp_t gfp, pgprot_t prot,
> >   	const void *caller)
> >   {
> > -	struct arm_vmregion *c;
> > -	size_t align;
> > -	int bit;
> > +	struct vm_struct *area;
> > +	unsigned long addr;
> >
> > -	if (!consistent_pte) {
> > -		printk(KERN_ERR "%s: not initialised\n", __func__);
> > +	area = get_vm_area_caller(size, VM_DMA | VM_USERMAP, caller);
> 
> In this patch, VM_DMA is only used here. So, is this no effect?

I introduced it mainly to let user know which areas have been allocated by the dma-mapping api.

I also plan to add a check suggested by Minchan Kim in __dma_free_remap() if the vmalloc area
have been in fact allocated with VM_DMA set. 

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


