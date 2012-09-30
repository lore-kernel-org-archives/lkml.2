Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab2I3EIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 00:08:55 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38427 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2I3EIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 00:08:54 -0400
Subject: Re: [patch] power: battery: pointer math issue in gab_probe()
From: anish kumar <anish198519851985@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20120929071346.GE10993@elgon.mountain>
References: <20120929071346.GE10993@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Sep 2012 09:38:45 +0530
Message-ID: <1348978125.7492.2.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-29 at 10:13 +0300, Dan Carpenter wrote:
> psy->properties is an enum (32 bit type) so adding sizeof() puts us
> four times further along than we intended.  It should be cast to a char
> pointer before doing the math.
You really read this driver to find out this one.
Good one.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Casting to void * would also work on GCC, at least.
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


