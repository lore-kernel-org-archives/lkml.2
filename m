Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1JKOFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:05:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:12556 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1JKOFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:05:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="62125356"
Subject: Re: [PATCH 2/2] pch_dma: Modify redundant memory allocation
From: Vinod Koul <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
In-Reply-To: <1318337002-10041-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1318337002-10041-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
	 <1318337002-10041-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 19:27:07 +0530
Message-ID: <1318341427.1546.347.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 21:43 +0900, Tomoya MORINAGA wrote:
> nr_channels is defined in "struct pch_dma".
> and struct pch_dma_chan is defined in "struct pch_dma".
> So, "sizeof(struct pch_dma_chan) * nr_channels" is unnecessary.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
> ---
>  drivers/dma/pch_dma.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index e72bfeb..d78f526 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -811,8 +811,7 @@ static int __devinit pch_dma_probe(struct pci_dev *pdev,
>  	int i;
>  
>  	nr_channels = id->driver_data;
> -	pd = kzalloc(sizeof(struct pch_dma)+
> -		sizeof(struct pch_dma_chan) * nr_channels, GFP_KERNEL);
> +	pd = kzalloc(sizeof(struct pch_dma), GFP_KERNEL);
kernel convention is 
	sizeof(*pd)

>  	if (!pd)
>  		return -ENOMEM;
>  


-- 
~Vinod

