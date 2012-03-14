Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab2CNQYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:24:51 -0400
Received: from smtp-out-225.synserver.de ([212.40.185.225]:1056 "EHLO
	smtp-out-225.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab2CNQYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:24:50 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28259
Message-ID: <4F60C6CF.4090608@metafoo.de>
Date: Wed, 14 Mar 2012 17:26:55 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Ravi Kumar V <kumarrav@codeaurora.org>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 DMA APIs
References: <1331548364-27845-1-git-send-email-kumarrav@codeaurora.org>
In-Reply-To: <1331548364-27845-1-git-send-email-kumarrav@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [...]
> +
> +struct dma_async_tx_descriptor *msm_dma_prep_interleaved(struct dma_chan *dchan,
> +					struct dma_interleaved_template *xt,
> +					unsigned long flags, void *context)
> +{
> +
> +	struct msm_dma_chan *chan;
> +	struct msm_dma_desc_sw *new;
> +	struct adm_box_cmd_t *box_cmd_vaddr;
> +	u32 *cmd_cntrl = context;
> +
> +	if (!dchan)
> +		return ERR_PTR(-EINVAL);

This is supposed to return either NULL or a valid descriptor.

> +
> +	if (!xt)
> +		return ERR_PTR(-EINVAL);
> [...

