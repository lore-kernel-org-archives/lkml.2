Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762549Ab2FVRK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:10:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59702 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab2FVRK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:10:28 -0400
Message-ID: <4FE4A701.1040303@wwwdotorg.org>
Date: Fri, 22 Jun 2012 11:10:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] dma: tegra: do not set transfer desc flag to DMA_CTRL_ACK
 in cyclic mode
References: <1340365364-16276-1-git-send-email-ldewangan@nvidia.com> <1340365364-16276-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340365364-16276-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 05:42 AM, Laxman Dewangan wrote:
> The sound dmaengine pcm driver uses the dma in cyclic mode and
> it does not ack the transfer descriptor  after transfer stops.
> This may lead to hold that desc in chip's dma driver and does
> not allow to reuse/free that descriptors. Hence not enabling
> flag DMA_CTRL_ACK when dma runs in cyclic mode.

> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> @@ -1093,7 +1093,7 @@ struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
> -	dma_desc->txd.flags = DMA_CTRL_ACK;
> +	dma_desc->txd.flags = 0;

I honestly have no idea about this one. If the dmaengine maintainers
think it's semantically correct, I have no objections.
