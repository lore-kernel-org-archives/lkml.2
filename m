Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1JNGQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:16:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39574 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab1JNGQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:16:20 -0400
MIME-Version: 1.0
In-Reply-To: <1318570705-17595-2-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com> <1318570705-17595-2-git-send-email-vinod.koul@intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 14 Oct 2011 14:15:59 +0800
Message-ID: <CAGsJ_4yeL7=LbNDGq8R95PUUyaHuYqFe6rrwM527Ux=NcT0FGg@mail.gmail.com>
Subject: Re: [PATCH 01/10] dmaengine: add new enum dma_transfer_direction
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/14 Vinod Koul <vinod.koul@intel.com>:
> From: Vinod Koul <vinod.koul@linux.intel.com>
>
> This new enum removes usage of dma_data_direction for dma direction. The new
> enum cleans tells the DMA direction and mode
> This further paves way for merging the dmaengine _prep operations and also for
> interleaved dma
>
> Suggested-by: Jassi Brar <jaswinder.singh@linaro.org>
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>

Reviewed-by: Barry Song <Baohua.Song@csr.com>

> ---
>  include/linux/dmaengine.h |   22 +++++++++++++++++-----
>  1 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index ace51af..24942ad 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -23,7 +23,6 @@
>
>  #include <linux/device.h>
>  #include <linux/uio.h>
> -#include <linux/dma-direction.h>
>  #include <linux/scatterlist.h>
>
>  /**
> @@ -75,6 +74,19 @@ enum dma_transaction_type {
>  /* last transaction type for creation of the capabilities mask */
>  #define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
>
> +/**
> + * enum dma_transfer_direction - dma transfer mode and direction indicator
> + * @MEM_TO_MEM: Async/Memcpy mode
> + * @MEM_TO_DEV: Slave mode & From Memory to Device
> + * @DEV_TO_MEM: Slave mode & From Device to Memory
> + * @DEV_TO_DEV: Slave mode & From Device to Device
> + */
> +enum dma_transfer_direction {
> +       MEM_TO_MEM,
> +       MEM_TO_DEV,
> +       DEV_TO_MEM,
> +       DEV_TO_DEV,
> +};
>
>  /**
>  * enum dma_ctrl_flags - DMA flags to augment operation preparation,
> @@ -267,7 +279,7 @@ enum dma_slave_buswidth {
>  * struct, if applicable.
>  */
>  struct dma_slave_config {
> -       enum dma_data_direction direction;
> +       enum dma_transfer_direction direction;
>        dma_addr_t src_addr;
>        dma_addr_t dst_addr;
>        enum dma_slave_buswidth src_addr_width;
> @@ -490,11 +502,11 @@ struct dma_device {
>
>        struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
>                struct dma_chan *chan, struct scatterlist *sgl,
> -               unsigned int sg_len, enum dma_data_direction direction,
> +               unsigned int sg_len, enum dma_transfer_direction direction,
>                unsigned long flags);
>        struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
>                struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> -               size_t period_len, enum dma_data_direction direction);
> +               size_t period_len, enum dma_transfer_direction direction);
>        int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>                unsigned long arg);
>
> @@ -520,7 +532,7 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
>
>  static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
>        struct dma_chan *chan, void *buf, size_t len,
> -       enum dma_data_direction dir, unsigned long flags)
> +       enum dma_transfer_direction dir, unsigned long flags)
>  {
>        struct scatterlist sg;
>        sg_init_one(&sg, buf, len);
> --
> 1.7.0.4
>
>
