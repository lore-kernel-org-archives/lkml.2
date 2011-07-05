Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1GELuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:50:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58293 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab1GELuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:50:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 6/8 RESEND] drivers: add Contiguous Memory Allocator
Date: Tue, 5 Jul 2011 13:50:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunsang Jeong <chunsang.jeong@linaro.org>
References: <1309851710-3828-7-git-send-email-m.szyprowski@samsung.com> <1309863722-6370-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1309863722-6370-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051350.11150.arnd@arndb.de>
X-Provags-ID: V02:K0:6AFPCHoXFgKYFJ0XXy83i2YcyC7bOmqJUtR1ADVjhOJ
 D1ki+axHA5IWF12ioSI+S8xta+cuRRHlzdV1Ds+FYlw7AsQ0u5
 iTdoi8zP8VpVYzak22lkr+V5pYN5WXjbibdEoIfDFQxWOPuVpx
 fCek+kEbll4AVqoqanwejSGqxsIDqw9+rWiNITLlTF+gXT2MW+
 T6lEKX3mFCawbDTU6KxEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Marek Szyprowski wrote:
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

Reviewed-by: Arnd Bergmann <arnd@arndb.de>, but I noticed two
one-character mistakes:

> +if CMA
> +
> +config CMA_DEBUG
> +	bool "CMA debug messages (DEVELOPEMENT)"

s/DEVELOPEMENT/DEVELOPMENT/

> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 4c5701c..be6aab4 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -5,6 +5,7 @@ obj-y			:= core.o sys.o bus.o dd.o syscore.o \
>  			   cpu.o firmware.o init.o map.o devres.o \
>  			   attribute_container.o transport_class.o
>  obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
> +obj-$(CONFIG_CMA) += dma-contiguous.o
>  obj-y			+= power/
>  obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o

Please add another tab to indent the line in the same way as the others.

	Arnd
