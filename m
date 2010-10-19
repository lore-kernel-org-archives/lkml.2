Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab0JSNCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:02:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:48547 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822Ab0JSNCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:02:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,350,1283756400"; 
   d="scan'208";a="668786190"
Date: Tue, 19 Oct 2010 15:02:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@openezx.org>, Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: [PATCH] mfd: Fix ezx_pcap_probe error path
Message-ID: <20101019130226.GP2736@sortiz-mobl>
References: <1287491304.2457.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287491304.2457.3.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Oct 19, 2010 at 08:28:24PM +0800, Axel Lin wrote:
> return -ENOMEM if create_singlethread_workqueue failed.
Thanks for the patch, applied to my for-next branch.

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/ezx-pcap.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
> index d283d77..c2b698d 100644
> --- a/drivers/mfd/ezx-pcap.c
> +++ b/drivers/mfd/ezx-pcap.c
> @@ -465,6 +465,7 @@ static int __devinit ezx_pcap_probe(struct spi_device *spi)
>  	pcap->irq_base = pdata->irq_base;
>  	pcap->workqueue = create_singlethread_workqueue("pcapd");
>  	if (!pcap->workqueue) {
> +		ret = -ENOMEM;
>  		dev_err(&spi->dev, "cant create pcap thread\n");
>  		goto free_pcap;
>  	}
> -- 
> 1.7.0.4
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
