Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab2JESNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:13:13 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56850 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2JESNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:13:12 -0400
Message-ID: <506F2334.1040009@gmail.com>
Date: Fri, 05 Oct 2012 13:13:08 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 04/10] of/i2c: Add support for I2C_CLIENT_WAKE when booting
 with Device Tree
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org> <1349451107-8009-5-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1349451107-8009-5-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 10:31 AM, Lee Jones wrote:
> It's important for wakeup sources such as keyboards, power buttons
> and the like to identify themselves as wakeup devices. Until now
> this has not been possible when platforms are booting via Device
> Tree.

A similar feature from Olof already went in for 3.7.

Rob

> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/of/of_i2c.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
> index 1e173f3..2f20019 100644
> --- a/drivers/of/of_i2c.c
> +++ b/drivers/of/of_i2c.c
> @@ -61,6 +61,9 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
>  		info.of_node = of_node_get(node);
>  		info.archdata = &dev_ad;
>  
> +		if (of_get_property(node, "i2c-client-wake", NULL))
> +			info.flags |= I2C_CLIENT_WAKE;
> +
>  		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
>  
>  		result = i2c_new_device(adap, &info);
> 
