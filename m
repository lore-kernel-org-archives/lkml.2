Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab2KEUug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:50:36 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54315 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab2KEUuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:50:35 -0500
Message-ID: <50982698.7050605@gmail.com>
Date: Mon, 05 Nov 2012 15:50:32 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix NULL checking in dma_pool_create()
References: <1352097996-25808-1-git-send-email-xi.wang@gmail.com> <20121105123738.0a0490a7.akpm@linux-foundation.org>
In-Reply-To: <20121105123738.0a0490a7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/12 3:37 PM, Andrew Morton wrote:
> 
> Well, the dma_pool_create() kerneldoc does not describe dev==NULL to be
> acceptable usage and given the lack of oops reports, we can assume that
> no code is calling this function with dev==NULL.
> 
> So I think we can just remove the code which handles dev==NULL?

Actually, a quick grep gives the following...

arch/arm/mach-s3c64xx/dma.c:731:	dma_pool = dma_pool_create("DMA-LLI", NULL, sizeof(struct pl080s_lli), 16, 0);
drivers/usb/gadget/amd5536udc.c:3136:	dev->data_requests = dma_pool_create("data_requests", NULL,
drivers/usb/gadget/amd5536udc.c:3148:	dev->stp_requests = dma_pool_create("setup requests", NULL,
drivers/net/wan/ixp4xx_hss.c:973:		if (!(dma_pool = dma_pool_create(DRV_NAME, NULL,
drivers/net/ethernet/xscale/ixp4xx_eth.c:1106:		if (!(dma_pool = dma_pool_create(DRV_NAME, NULL,

- xi
