Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2F2RE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:04:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53095 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2F2RE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:04:56 -0400
Message-ID: <4FEDE035.6040005@wwwdotorg.org>
Date: Fri, 29 Jun 2012 11:04:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: ccross@android.com, olof@lixom.net, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: apbio: use dmaengine based dma driver
References: <1340969407-7662-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340969407-7662-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 05:30 AM, Laxman Dewangan wrote:
> Use the dmaengine based Tegra APB DMA driver for
> apbio access in place of legacy Tegra APB DMA.
> 
> The new driver is selected if legacy driver is not
> selected and new DMA driver is enabled through config
> file.

> +bool tegra_apb_dma_init(void)
> +{
...
> +	tegra_apb_dma_chan = dma_request_channel(mask, NULL, NULL);
> +	if (!tegra_apb_dma_chan) {
> +		pr_err("%s: can not allocate dma channel\n", __func__);
> +		goto err_dma_alloc;
> +	}

That fires quite a few times during boot, before the DMA driver is
probed. I think the message should be down-graded to a pr_dbg(). Do you
agree? I can fix that myself when applying this if you're OK with the
change.

Aside from that, this looks fine to me.
