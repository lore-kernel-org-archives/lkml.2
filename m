Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0HXGOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 02:14:32 -0400
Received: from compulab.co.il ([67.18.134.219]:32858 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab0HXGOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 02:14:30 -0400
Message-ID: <4C736319.6090701@compulab.co.il>
Date: Tue, 24 Aug 2010 09:13:45 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        eric miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 1/3] mfd: da903x - fix da903x_add_subdevs error path
References: <1282628645.6074.1.camel@mola>
In-Reply-To: <1282628645.6074.1.camel@mola>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> This patch fixes da903x_add_subdevs error path:
> 1. return -ENOMEM if platform_device_alloc() fail.
> 2. call platform_device_put() if platform_device_add() fail.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mike Rapoport <mike@compulab.co.il>

> ---
>  drivers/mfd/da903x.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
> index c07aece..2fadbae 100644
> --- a/drivers/mfd/da903x.c
> +++ b/drivers/mfd/da903x.c
> @@ -470,13 +470,19 @@ static int __devinit da903x_add_subdevs(struct da903x_chip *chip,
>  		subdev = &pdata->subdevs[i];
>  
>  		pdev = platform_device_alloc(subdev->name, subdev->id);
> +		if (!pdev) {
> +			ret = -ENOMEM;
> +			goto failed;
> +		}
>  
>  		pdev->dev.parent = chip->dev;
>  		pdev->dev.platform_data = subdev->platform_data;
>  
>  		ret = platform_device_add(pdev);
> -		if (ret)
> +		if (ret) {
> +			platform_device_put(pdev);
>  			goto failed;
> +		}
>  	}
>  	return 0;
>  


-- 
Sincerely yours,
Mike.
