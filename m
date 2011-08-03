Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1HCIzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 04:55:44 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:58893 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab1HCIzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 04:55:37 -0400
Message-ID: <4E390CF9.60503@stericsson.com>
Date: Wed, 3 Aug 2011 10:55:21 +0200
From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Per FORLIN <per.forlin@stericsson.com>, Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "users@igloocommunity.org" <users@igloocommunity.org>,
        Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH] usb: musb: ux500: set dma config for both src and dst
References: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
In-Reply-To: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 05:33 PM, Per FORLIN wrote:
> From: Per Forlin<per.forlin@linaro.org>
>
> The dma driver requires both src and dst to be set.
> This fix is needed in order to run gadget mass storage.
> Patch is verified on snowball.
>
> Signed-off-by: Per Forlin<per.forlin@linaro.org>
> ---
>   drivers/usb/musb/ux500_dma.c |   16 +++++++---------
>   1 files changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
> index cecace4..2313475 100644
> --- a/drivers/usb/musb/ux500_dma.c
> +++ b/drivers/usb/musb/ux500_dma.c
> @@ -133,15 +133,13 @@ static bool ux500_configure_channel(struct dma_channel *channel,
>   					DMA_SLAVE_BUSWIDTH_4_BYTES;
>
>   	slave_conf.direction = direction;
> -	if (direction == DMA_FROM_DEVICE) {
> -		slave_conf.src_addr = usb_fifo_addr;
> -		slave_conf.src_addr_width = addr_width;
> -		slave_conf.src_maxburst = 16;
> -	} else {
> -		slave_conf.dst_addr = usb_fifo_addr;
> -		slave_conf.dst_addr_width = addr_width;
> -		slave_conf.dst_maxburst = 16;
> -	}
> +	slave_conf.src_addr = usb_fifo_addr;
> +	slave_conf.src_addr_width = addr_width;
> +	slave_conf.src_maxburst = 16;
> +	slave_conf.dst_addr = usb_fifo_addr;
> +	slave_conf.dst_addr_width = addr_width;
> +	slave_conf.dst_maxburst = 16;
> +
>   	dma_chan->device->device_control(dma_chan, DMA_SLAVE_CONFIG,
>   					     (unsigned long)&slave_conf);
>
>    

Acked-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

Thanks,

-- 
Mian Yousaf Kaukab

