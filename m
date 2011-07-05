Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1GEKZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:25:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64980 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1GEKZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:25:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Tue, 05 Jul 2011 12:24:58 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 6/8] drivers: add Contiguous Memory Allocator
In-reply-to: <1309851710-3828-7-git-send-email-m.szyprowski@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org
Cc: "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>
Message-id: <000101cc3afd$cac46ff0$604d4fd0$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: Acw65wJ1jp7zAY37SWW2gb29m2bk+AAFgkUg
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com>
 <1309851710-3828-7-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, July 05, 2011 9:42 AM Marek Szyprowski wrote:

> The Contiguous Memory Allocator is a set of helper functions for DMA
> mapping framework that improves allocations of contiguous memory chunks.
> 
> CMA grabs memory on system boot, marks it with CMA_MIGRATE_TYPE and
> gives back to the system. Kernel is allowed to allocate movable pages
> within CMA's managed memory so that it can be used for example for page
> cache when DMA mapping do not use it. On dma_alloc_from_contiguous()
> request such pages are migrated out of CMA area to free required
> contiguous block and fulfill the request. This allows to allocate large
> contiguous chunks of memory at any time assuming that there is enough
> free memory available in the system.
> 
> This code is heavily based on earlier works by Michal Nazarewicz.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/base/Kconfig           |   77 +++++++++
>  drivers/base/Makefile          |    1 +
>  drivers/base/dma-contiguous.c  |  367
> ++++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-contiguous.h |  104 +++++++++++
>  4 files changed, 549 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/base/dma-contiguous.c
>  create mode 100644 include/linux/dma-contiguous.h
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index d57e8d0..95ae1a7 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -168,4 +168,81 @@ config SYS_HYPERVISOR
>  	bool
>  	default n
> 
> +config CMA
> +	bool "Contiguous Memory Allocator"
> +	depends HAVE_DMA_CONTIGUOUS && HAVE_MEMBLOCK

The above line should be obviously "depends on HAVE_DMA_CONTIGUOUS &&
HAVE_MEMBLOCK".
I'm sorry for posting broken version. 

(snipped)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



