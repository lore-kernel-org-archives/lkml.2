Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab2FMH4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:56:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43694 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2FMH4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:56:08 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Marek Szyprowski" <m.szyprowski@samsung.com>
Cc: "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad@darnok.org>,
        "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH] x86: dma-mapping: fix broken allocation when dma_mask has
 been provided
References: <1339567046-2264-1-git-send-email-m.szyprowski@samsung.com>
Date: Wed, 13 Jun 2012 09:56:05 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wft0brk93l0zgt@mpn-glaptop>
In-Reply-To: <1339567046-2264-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Opera Mail/12.00 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 07:57:26 +0200, Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> Commit 0a2b9a6ea93 ("X86: integrate CMA with DMA-mapping subsystem")
> broke memory allocation with dma_mask. This patch fixes possible kernel
> ops caused by lack of resetting page variable when jumping to 'again' label.
>
> Reported-by: Konrad Rzeszutek Wilk <konrad@darnok.org>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  arch/x86/kernel/pci-dma.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 62c9457..c0f420f 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -100,7 +100,7 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
>  				 struct dma_attrs *attrs)
>  {
>  	unsigned long dma_mask;
> -	struct page *page = NULL;
> +	struct page *page;
>  	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
>  	dma_addr_t addr;
>@@ -108,6 +108,7 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
> 	flag |= __GFP_ZERO;
>  again:
> +	page = NULL;
>  	if (!(flag & GFP_ATOMIC))
>  		page = dma_alloc_from_contiguous(dev, count, get_order(size));
>  	if (!page)


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
