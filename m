Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab2GEO5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:57:23 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51014 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab2GEO5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:57:22 -0400
Message-ID: <4FF5AB4D.6090500@gmail.com>
Date: Thu, 05 Jul 2012 09:57:17 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH] of: address: Don't fail a lookup just because a node
 has no reg property
References: <1341498754-30445-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1341498754-30445-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 09:32 AM, Lee Jones wrote:
> Sometimes it doesn't make any sense for a node to have an address.
> In this case device lookup will always be unsuccessful because we
> currently assume every node will have a reg property. This patch
> changes the semantics so that the resource address and the lookup
> address will only be compared if one exists.
> 
> Things like AUXDATA() rely on of_dev_lookup to return the lookup
> entry of a particular device in order to do things like apply
> platform_data to a device. However, this is currently broken for
> nodes which do not have a reg property, meaning that platform_data
> can not be passed in those cases.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---

Acked-by: Rob Herring <rob.herring@calxeda.com>

Do you have something dependent on this or want me to apply?

Rob

>  drivers/of/platform.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 343ad29..9600480 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -317,10 +317,9 @@ static const struct of_dev_auxdata *of_dev_lookup(const struct of_dev_auxdata *l
>  	for(; lookup->compatible != NULL; lookup++) {
>  		if (!of_device_is_compatible(np, lookup->compatible))
>  			continue;
> -		if (of_address_to_resource(np, 0, &res))
> -			continue;
> -		if (res.start != lookup->phys_addr)
> -			continue;
> +		if (!of_address_to_resource(np, 0, &res))
> +			if (res.start != lookup->phys_addr)
> +				continue;
>  		pr_debug("%s: devname=%s\n", np->full_name, lookup->name);
>  		return lookup;
>  	}
> 


