Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2EVHHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:07:47 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65493 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2EVHHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:07:46 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-32-4fbb3b3c0ce9
Message-ID: <4FBB3B41.8010102@kernel.org>
Date: Tue, 22 May 2012 16:07:45 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.ports.arm.kernel,gmane.linux.kernel
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Subash Patel <subashrp@gmail.com>,
        Nick Piggin <npiggin@gmail.com>
Subject: Re: [PATCHv2 3/4] mm: vmalloc: add VM_DMA flag to indicate areas
 used by dma-mapping framework
References: <1337252085-22039-1-git-send-email-m.szyprowski@samsung.com> <1337252085-22039-4-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1337252085-22039-4-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 07:54 PM, Marek Szyprowski wrote:

> Add new type of vm_area intented to be used for consisten mappings
> created by dma-mapping framework.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/linux/vmalloc.h |    1 +
>  mm/vmalloc.c            |    3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 6071e91..8a9555a 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -14,6 +14,7 @@ struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
>  #define VM_USERMAP	0x00000008	/* suitable for remap_vmalloc_range */
>  #define VM_VPAGES	0x00000010	/* buffer for pages was vmalloc'ed */
>  #define VM_UNLIST	0x00000020	/* vm_struct is not listed in vmlist */
> +#define VM_DMA		0x00000040	/* used by dma-mapping framework */
>  /* bits [20..32] reserved for arch specific ioremap internals */

>  

>  /*
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 8cb7f22..9c13bab 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2582,6 +2582,9 @@ static int s_show(struct seq_file *m, void *p)
>  	if (v->flags & VM_IOREMAP)
>  		seq_printf(m, " ioremap");
>  
> +	if (v->flags & VM_DMA)
> +		seq_printf(m, " dma");
> +


Hmm, VM_DMA would become generic flag?
AFAIU, maybe VM_DMA would be used only on ARM arch.
Of course, it isn't performance sensitive part but there in no reason to check it, either
in other architecture except ARM.

I suggest following as

#ifdef CONFIG_ARM
#define VM_DMA	0x00000040
#else
#define VM_DMA	0x0
#end

Maybe it could remove check code at compile time.

>  	if (v->flags & VM_ALLOC)
>  		seq_printf(m, " vmalloc");
>  



-- 
Kind regards,
Minchan Kim
