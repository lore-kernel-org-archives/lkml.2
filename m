Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1AQVfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:35:13 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:57399 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752542Ab1AQVfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:35:10 -0500
Message-ID: <4D34B614.3000909@bluewatersys.com>
Date: Tue, 18 Jan 2011 10:35:16 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Hong Xu <hong.xu@atmel.com>
CC: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com, jacmet@sunsite.dk,
        nicolas.ferre@atmel.com
Subject: Re: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
References: <hong.xu@atmel.com> <1295248809-30334-2-git-send-email-hong.xu@atmel.com>
In-Reply-To: <1295248809-30334-2-git-send-email-hong.xu@atmel.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2011 08:20 PM, Hong Xu wrote:
> Some SAM9 chips have the ability to perform DMA between CPU and SMC controller.
> This patch adds DMA support for SAM9RL, SAM9G45, SSAM9G46,AM9M10, SAM9M11.
> 
> Signed-off-by: Hong Xu <hong.xu@atmel.com>
> ---

One more comment:

> +	if (cpu_has_dma() && use_dma) {
> +		dma_cap_mask_t mask;
> +
> +		dma_cap_zero(mask);
> +		dma_cap_set(DMA_MEMCPY, mask);
> +		host->dma_chan = dma_request_channel(mask, 0, NULL);
> +
> +		if (!host->dma_chan) {
> +			dev_err(host->dev, "Failed to request DMA channel\n");
> +			host->dma_ready = 0;

Because host is kzalloc'ed above, you do not need to set host->dma_ready
to zero here.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
