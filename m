Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2CVLrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:47:32 -0400
Received: from smtp-out-022.synserver.de ([212.40.185.22]:1047 "EHLO
	smtp-out-015.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752720Ab2CVLrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:47:31 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9453
Message-ID: <4F6B11DC.9090401@metafoo.de>
Date: Thu, 22 Mar 2012 12:49:48 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Ravi Kumar V <kumarrav@codeaurora.org>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.or,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tsoni@codeaurora.org
Subject: Re: [PATCH v4 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 ADM DMA APIs
References: <1332413882-8456-1-git-send-email-kumarrav@codeaurora.org>
In-Reply-To: <1332413882-8456-1-git-send-email-kumarrav@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 11:58 AM, Ravi Kumar V wrote:
> [...]
> +static struct dma_async_tx_descriptor *msm_dma_prep_sg(
> +		struct dma_chan *dchan,
> +		struct scatterlist *dst_sg, unsigned int dst_nents,
> +		struct scatterlist *src_sg, unsigned int src_nents,
> +		unsigned long flags, void *context)
> +{
> [...]
> +
> +	if (!dchan)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (dst_nents == 0 || src_nents == 0)
> +		return ERR_PTR(-EINVAL);
> +	if (!dst_sg || !src_sg)
> +		return ERR_PTR(-EINVAL);
> +
> +	if ((dst_nents != src_nents) || (cmd_config->num_cmd != src_nents))
> +		return ERR_PTR(-EINVAL);
> +
> + [...]
> +
> +	if (!new) {
> +		dev_err(chan->dev,
> +			"No free memory for link descriptor\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> [...]
> +	return &new->async_tx;
> +}

Same comment as before. This is supposed to return either a valid descriptor
or NULL, but not an ERR_PTR.

