Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3AGCGD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 21:06:03 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34555 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753269Ab3AGCGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 21:06:01 -0500
Message-ID: <1357524362.4940.16.camel@joe-AO722>
Subject: Re: [v3 PATCH 05/12] spi/atmel_spi: update the dt support
From: Joe Perches <joe@perches.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        richard.genoud@gmail.com, JM.Lin@atmel.com
Date: Sun, 06 Jan 2013 18:06:02 -0800
In-Reply-To: <1357523413-27209-6-git-send-email-wenyou.yang@atmel.com>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
	 <1357523413-27209-6-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 09:50 +0800, Wenyou Yang wrote:
> To meet the different spi IP version of atmel SoC,
> add more compatible "atmel,at91rm9200-spi", "atmel,at91sam9260-spi"
> "atmel,at91sam9g45-spi", "atmel,at91sam9x5-spi" with different
> config and devtype.

trivial comment:

> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
[]
> @@ -230,11 +302,15 @@ struct atmel_spi_device {
>   * register, but I haven't checked that it exists on all chips, and
>   * this is cheaper anyway.
>   */
> -static bool atmel_spi_is_v2(void)
> +static bool atmel_spi_is_v2(struct atmel_spi *as)

There's a comment that needs updating above this now

>  {
> -	return !cpu_is_at91rm9200();
> +	if (as->pdata->version == 2)
> +		return true;
> +	else
> +		return false;

	return as->pdata->version == 2;

is rather more readable to me


