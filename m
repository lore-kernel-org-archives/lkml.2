Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab2FUIfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:35:44 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43679 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758800Ab2FUIfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:35:40 -0400
X-AuditID: 9c930179-b7befae000006417-1b-4fe2dcd864bc
Message-ID: <4FE2DCE7.80102@kernel.org>
Date: Thu, 21 Jun 2012 17:35:51 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
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
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv3 2/3] mm: vmalloc: add VM_DMA flag to indicate areas
 used by dma-mapping framework
References: <1339585306-7147-1-git-send-email-m.szyprowski@samsung.com> <1339585306-7147-3-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1339585306-7147-3-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On 06/13/2012 08:01 PM, Marek Szyprowski wrote:

> Add new type of vm_area intented to be used for mappings created by
> dma-mapping framework.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/linux/vmalloc.h |    1 +
>  mm/vmalloc.c            |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 2e28f4d..e725b7b 100644
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
> index 11308f0..e04d59b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2575,6 +2575,9 @@ static int s_show(struct seq_file *m, void *p)
>  	if (v->flags & VM_IOREMAP)
>  		seq_printf(m, " ioremap");
>  
> +	if (v->flags & VM_DMA)
> +		seq_printf(m, " dma");
> +
>  	if (v->flags & VM_ALLOC)
>  		seq_printf(m, " vmalloc");
>  


I still don't make sure that we should add new type for only ARM arch.
I remember you said "It would be used for other architectures once we add" and 
Paul said he has a plan for SH. So at least, you should add such comment in changelog
for persuading grumpy maintainers. :)

Frankly speaking, I could add my Reviewed-by but I think it wouldn't carry much weight
because code is very tiny so you need Acked-by rather than Reviewed-by.
IMHO, This problem is the thing only maintainer should decide.
So I will toss the decision to akpm. Ccing akpm.(Ccing KOSAKI because he had a concern about this).

If anyone have a question to me, I'm Acked-by iff other architecture will use it.
-- 
Kind regards,
Minchan Kim
