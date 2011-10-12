Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1JLFh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 01:37:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:16421 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab1JLFh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 01:37:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,527,1312182000"; 
   d="scan'208";a="25457458"
Subject: Re: [PATCH 2/2 v2] pch_dma: Reduce wasting memory
From: Vinod Koul <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
In-Reply-To: <1318379915-8697-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1318379915-8697-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 11:00:00 +0530
Message-ID: <1318397400.1546.368.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 09:38 +0900, Tomoya MORINAGA wrote:
> nr_channels is defined in "struct pch_dma".
> and struct pch_dma_chan is defined in "struct pch_dma".
> So, "sizeof(struct pch_dma_chan) * nr_channels" is unnecessary.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
> ---
> v2: Change sizeof(struct pch_dma) to sizeof(*pd)
> ---
>  drivers/dma/pch_dma.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 326fedc..58b215c 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -997,8 +997,7 @@ static int __devinit pch_dma_probe(struct pci_dev *pdev,
>  	int i;
>  
>  	nr_channels = id->driver_data;
> -	pd = kzalloc(sizeof(struct pch_dma)+
> -		sizeof(struct pch_dma_chan) * nr_channels, GFP_KERNEL);
> +	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
>  	if (!pd)
>  		return -ENOMEM;
>  
Applied thanks.

Although we can further optimize by removing static array and
dynamically allocate channel structures based on nr_channels, that can
be taken further separately.

-- 
~Vinod

