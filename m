Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2KQCkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 21:40:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48915 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab2KQCkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 21:40:04 -0500
Date: Fri, 16 Nov 2012 18:36:49 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: anish kumar <anish198519851985@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] power: battery: pointer math issue in gab_probe()
Message-ID: <20121117023649.GA29966@lizard>
References: <20120929071346.GE10993@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120929071346.GE10993@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 10:13:46AM +0300, Dan Carpenter wrote:
> psy->properties is an enum (32 bit type) so adding sizeof() puts us
> four times further along than we intended.  It should be cast to a char
> pointer before doing the math.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Casting to void * would also work on GCC, at least.

Applied, thanks a lot!

> 
> diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
> index 9bdf444..776f118 100644
> --- a/drivers/power/generic-adc-battery.c
> +++ b/drivers/power/generic-adc-battery.c
> @@ -279,7 +279,8 @@ static int __devinit gab_probe(struct platform_device *pdev)
>  	}
>  
>  	memcpy(psy->properties, gab_props, sizeof(gab_props));
> -	properties = psy->properties + sizeof(gab_props);
> +	properties = (enum power_supply_property *)
> +				((char *)psy->properties + sizeof(gab_props));
>  
>  	/*
>  	 * getting channel from iio and copying the battery properties
