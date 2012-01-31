Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2AaR6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 12:58:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58437 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672Ab2AaR6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 12:58:13 -0500
X-Sasl-enc: dMOsp3LnwLIMjQNhfbRS70MCZbGKKvRZbz4SMu/yWLDr 1328032692
Message-ID: <4F282BB2.6080604@fastmail.fm>
Date: Tue, 31 Jan 2012 17:58:10 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, Mark Grosen <mgrosen@ti.com>
Subject: Re: [PATCH 2/2] remoteproc: s/big switch/lookup table/
References: <1328028762-28352-1-git-send-email-ohad@wizery.com> <1328028762-28352-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1328028762-28352-2-git-send-email-ohad@wizery.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/01/12 16:52, Ohad Ben-Cohen wrote:
> +/*
> + * A lookup table for resource handlers. Always keep in sync with
> + * enum fw_resource_type.
> + */
> +static rproc_handle_resource_t rproc_handle_rsc[] = {
> +	rproc_handle_carveout,	/* RSC_CARVEOUT */
> +	rproc_handle_devmem,	/* RSC_DEVMEM */
> +	rproc_handle_trace,	/* RSC_TRACE */
> +	rproc_handle_vring,	/* RSC_VRING */
> +	NULL, /* RSC_VIRTIO_DEV is handled early upon registration */
> +};
> +

You could change this to

[RSC_CARVEOUT] = rproc_handle_carveout,

Then you would be safe against renumbering and would only need to worry
about addition (which your RSC_LAST check copes with).

Thanks,

Jack
