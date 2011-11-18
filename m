Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab1KRQK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:10:57 -0500
Received: from smtp151.dfw.emailsrvr.com ([67.192.241.151]:54505 "EHLO
	smtp151.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab1KRQK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:10:56 -0500
Message-ID: <4EC6838F.8020705@calxeda.com>
Date: Fri, 18 Nov 2011 10:10:55 -0600
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Wojciech Baranowski <baranowski@chromium.org>
CC: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/platform: Allow missing address for dev name lookup
References: <1321628948.21392.37.camel@zalecze.wat.corp.google.com>
In-Reply-To: <1321628948.21392.37.camel@zalecze.wat.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 09:09 AM, Wojciech Baranowski wrote:
> While looking up linux name for platform device, check the address only if it
> has been supplied in lookup table.
> 
And the reason you want to do this is?

Rob

> Signed-off-by: Wojciech Baranowski <baranowski@chromium.org>
> ---
>  drivers/of/platform.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index cbd5d70..94763c0 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -314,12 +314,14 @@ static const struct of_dev_auxdata *of_dev_lookup(const struct of_dev_auxdata *l
>  	if (!lookup)
>  		return NULL;
>  
> -	for(; lookup->name != NULL; lookup++) {
> +	for (; lookup->name != NULL; lookup++) {
>  		if (!of_device_is_compatible(np, lookup->compatible))
>  			continue;
> -		if (of_address_to_resource(np, 0, &res))
> +		if (lookup->phys_addr &&
> +				of_address_to_resource(np, 0, &res))
>  			continue;
> -		if (res.start != lookup->phys_addr)
> +		if (lookup->phys_addr &&
> +				res.start != lookup->phys_addr)
>  			continue;
>  		pr_debug("%s: devname=%s\n", np->full_name, lookup->name);
>  		return lookup;

