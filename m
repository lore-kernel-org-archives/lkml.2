Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab1JNLBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 07:01:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47911 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1JNLBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 07:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <1318570705-17595-10-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	<1318570705-17595-10-git-send-email-vinod.koul@intel.com>
Date: Fri, 14 Oct 2011 16:31:04 +0530
Message-ID: <CAJe_Zhdy6gs1xqomhpGH9wrTHq5DhZsSDpzeNFRr84e9VPQEig@mail.gmail.com>
Subject: Re: [PATCH 09/10] USB: move to dma_transfer_direction
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org, 21cnbao@gmail.com,
        rmk@arm.linux.org.uk, Vinod Koul <vinod.koul@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2011 11:08, Vinod Koul <vinod.koul@intel.com> wrote:
>
> diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
> index ef4333f..9587bdd 100644
> --- a/drivers/usb/musb/ux500_dma.c
> +++ b/drivers/usb/musb/ux500_dma.c
> @@ -112,7 +112,7 @@ static bool ux500_configure_channel(struct dma_channel *channel,
>        struct musb_hw_ep *hw_ep = ux500_channel->hw_ep;
>        struct dma_chan *dma_chan = ux500_channel->dma_chan;
>        struct dma_async_tx_descriptor *dma_desc;
> -       enum dma_data_direction direction;
> +       enum dma_transfer_direction direction;
>        struct scatterlist sg;
>        struct dma_slave_config slave_conf;
>        enum dma_slave_buswidth addr_width;
> @@ -132,7 +132,7 @@ static bool ux500_configure_channel(struct dma_channel *channel,
>        sg_dma_address(&sg) = dma_addr;
>        sg_dma_len(&sg) = len;
>
> -       direction = ux500_channel->is_tx ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +       slave_dirn = ux500_channel->is_tx ? MEM_TO_DEV : DEV_TO_MEM;
>        addr_width = (len & 0x3) ? DMA_SLAVE_BUSWIDTH_1_BYTE :
>                                        DMA_SLAVE_BUSWIDTH_4_BYTES;
>
s/slave_dirn/direction ?
