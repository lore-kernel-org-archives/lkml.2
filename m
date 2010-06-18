Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0FRVd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:33:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:23057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab0FRVd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:33:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,441,1272870000"; 
   d="scan'208";a="528238435"
Date: Fri, 18 Jun 2010 23:32:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Ian Molton <spyro@f2s.com>, Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] mfd-core: properly handle
 platform_device_add_resources fail in mfd_add_device
Message-ID: <20100618213250.GG3582@sortiz.org>
References: <1275298255.23779.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275298255.23779.2.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 05:30:55PM +0800, Axel Lin wrote:
> platform_device_add_resources may fail, thus add error checking for it.
Thanks Axel, patch applied.

Cheers,
Samuel.

 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/mfd-core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 7dd76bc..1823a57 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -70,7 +70,9 @@ static int mfd_add_device(struct device *parent, int id,
>  			goto fail_res;
>  	}
>  
> -	platform_device_add_resources(pdev, res, cell->num_resources);
> +	ret = platform_device_add_resources(pdev, res, cell->num_resources);
> +	if (ret)
> +		goto fail_res;
>  
>  	ret = platform_device_add(pdev);
>  	if (ret)
> -- 
> 1.5.4.3
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
