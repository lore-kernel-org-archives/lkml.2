Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab2ELFop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 01:44:45 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:59931 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997Ab2ELFoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 01:44:44 -0400
Message-ID: <4FADF8FE.5080705@metafoo.de>
Date: Sat, 12 May 2012 07:45:34 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] mfd: pcf50633-core: Convert to use devm_* APIs
References: <1336699791.8454.1.camel@phoenix> <1336699889.8454.3.camel@phoenix>
In-Reply-To: <1336699889.8454.3.camel@phoenix>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 03:31 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks good...

> --- a/drivers/mfd/pcf50633-core.c
> +++ b/drivers/mfd/pcf50633-core.c
[...]
> @@ -237,16 +236,11 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
>  	pcf50633_irq_init(pcf, client->irq);
>  
>  	/* Create sub devices */
> -	pcf50633_client_dev_register(pcf, "pcf50633-input",
> -						&pcf->input_pdev);
> -	pcf50633_client_dev_register(pcf, "pcf50633-rtc",
> -						&pcf->rtc_pdev);
> -	pcf50633_client_dev_register(pcf, "pcf50633-mbc",
> -						&pcf->mbc_pdev);
> -	pcf50633_client_dev_register(pcf, "pcf50633-adc",
> -						&pcf->adc_pdev);
> -	pcf50633_client_dev_register(pcf, "pcf50633-backlight",
> -						&pcf->bl_pdev);
> +	pcf50633_client_dev_register(pcf, "pcf50633-input", &pcf->input_pdev);
> +	pcf50633_client_dev_register(pcf, "pcf50633-rtc", &pcf->rtc_pdev);
> +	pcf50633_client_dev_register(pcf, "pcf50633-mbc", &pcf->mbc_pdev);
> +	pcf50633_client_dev_register(pcf, "pcf50633-adc", &pcf->adc_pdev);
> +	pcf50633_client_dev_register(pcf, "pcf50633-backlight", &pcf->bl_pdev);
>  
>[...]

... but this is really a unrelated change, which isn't even mentioned in the
changelog.
