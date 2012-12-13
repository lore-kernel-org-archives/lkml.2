Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2LMXej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:34:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2LMXei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:34:38 -0500
Date: Thu, 13 Dec 2012 15:34:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 2/2] dmatest: check for dma mapping error
Message-Id: <20121213153437.b8b0198d.akpm@linux-foundation.org>
In-Reply-To: <1355139464-6855-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355139464-6855-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1355139464-6855-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012 13:37:44 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> We get a warning if CONFIG_DMA_API_DEBUG=y
> 
> [   28.150631] WARNING: at lib/dma-debug.c:933 check_unmap+0x5d6/0x6ac()
> [   28.157058] dw_dmac dw_dmac.0: DMA-API: device driver failed to check map error[device address=0x0000000035698305] [size=14365 bytes] [mapped as single]
> 
> ...
>
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -378,15 +378,35 @@ static int dmatest_func(void *data)
>  
>  			dma_srcs[i] = dma_map_single(dev->dev, buf, len,
>  						     DMA_TO_DEVICE);
> +			ret = dma_mapping_error(dev->dev, dma_srcs[i]);
> +			if (ret) {
> +				unmap_src(dev->dev, dma_srcs, len, i);
> +				pr_warn("%s: #%u: mapping error %d with "
> +					"src_off=0x%x len=0x%x\n",
> +					thread_name, total_tests - 1, ret,
> +					src_off, len);
> +				failed_tests++;
> +				continue;
> +			}

The changelog and the code don't match.  Which one is out of date?
