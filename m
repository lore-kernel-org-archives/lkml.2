Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab0JUWzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:55:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:25475 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab0JUWzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:55:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,219,1286175600"; 
   d="scan'208";a="669661442"
Date: Fri, 22 Oct 2010 00:54:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@openmoko.org>
Subject: Re: [PATCH] mfd: Fix resource reclaim in pcf50633_remove()
Message-ID: <20101021225457.GE11685@sortiz-mobl>
References: <1287565019.7849.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287565019.7849.2.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Oct 20, 2010 at 04:56:59PM +0800, Axel Lin wrote:
> Calling sysfs_remove_group() to remove sysfs entries
> and unregister bl_pdev in pcf50633_remove().
patch applied, thanks.

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/pcf50633-core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
> index 6d4233f..501ce13 100644
> --- a/drivers/mfd/pcf50633-core.c
> +++ b/drivers/mfd/pcf50633-core.c
> @@ -339,12 +339,14 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
>  	struct pcf50633 *pcf = i2c_get_clientdata(client);
>  	int i;
>  
> +	sysfs_remove_group(&client->dev.kobj, &pcf_attr_group);
>  	pcf50633_irq_free(pcf);
>  
>  	platform_device_unregister(pcf->input_pdev);
>  	platform_device_unregister(pcf->rtc_pdev);
>  	platform_device_unregister(pcf->mbc_pdev);
>  	platform_device_unregister(pcf->adc_pdev);
> +	platform_device_unregister(pcf->bl_pdev);
>  
>  	for (i = 0; i < PCF50633_NUM_REGULATORS; i++)
>  		platform_device_unregister(pcf->regulator_pdev[i]);
> -- 
> 1.7.2
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
