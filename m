Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2KUNlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:41:12 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33666 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2KUNlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:41:11 -0500
Message-ID: <50ACD9F2.40207@gmail.com>
Date: Wed, 21 Nov 2012 07:41:06 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Bongkyu Kim <bongkyu.kim@lge.com>
CC: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/i2c: support more interrupt specifiers
References: <1353488322-14764-1-git-send-email-bongkyu.kim@lge.com>
In-Reply-To: <1353488322-14764-1-git-send-email-bongkyu.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 02:58 AM, Bongkyu Kim wrote:
> This patch supports more interrupt specifiers for i2c client.

Why?

> Signed-off-by: Bongkyu Kim <bongkyu.kim@lge.com>
> ---
>  drivers/of/of_i2c.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
> index 3550f3b..c6d9b7e 100644
> --- a/drivers/of/of_i2c.c
> +++ b/drivers/of/of_i2c.c
> @@ -34,6 +34,7 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
>  		struct dev_archdata dev_ad = {};
>  		const __be32 *addr;
>  		int len;
> +		int nr = 0;
>  
>  		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
>  
> @@ -57,7 +58,9 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
>  			continue;
>  		}
>  
> -		info.irq = irq_of_parse_and_map(node, 0);
> +		info.irq = irq_of_parse_and_map(node, nr++);
> +		while (irq_of_parse_and_map(node, nr))
> +			nr++;

What's the point if you are just discarding the interrupt number? If
this is needed, then shouldn't you fix i2c_board_info first?

Rob

>  		info.of_node = of_node_get(node);
>  		info.archdata = &dev_ad;
>  
> 
