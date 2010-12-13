Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0LMUni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:43:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:51164 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab0LMUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:43:36 -0500
Message-ID: <4D06852B.8030409@oracle.com>
Date: Mon, 13 Dec 2010 12:42:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andres Salomon <dilinger@collabora.co.uk>
Subject: Re: [PATCH V2 -next] cs5535: fix printk format warnings
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>	 <20101213114421.3abe0dcb.randy.dunlap@oracle.com> <1292272085.26970.50.camel@Joe-Laptop>
In-Reply-To: <1292272085.26970.50.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/10 12:28, Joe Perches wrote:
> Use vsprintf extension %pR to format resource.
> 
> Original-patch-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> ---
> 
>  drivers/gpio/cs5535-gpio.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
> index b566fd5e..d7da7a1 100644
> --- a/drivers/gpio/cs5535-gpio.c
> +++ b/drivers/gpio/cs5535-gpio.c
> @@ -266,8 +266,7 @@ static int __devinit cs5535_gpio_probe(struct platform_device *pdev)
>  	cs5535_gpio_chip.pdev = pdev;
>  	spin_lock_init(&cs5535_gpio_chip.lock);
>  
> -	dev_info(&pdev->dev, "region 0x%x - 0x%x reserved\n",
> -			res->start, res->end);
> +	dev_info(&pdev->dev, "reserved resource region %pR\n", res);
>  
>  	/* mask out reserved pins */
>  	mask &= 0x1F7FFFFF;
> 
> 


OK.  How about similar patch for the other warnings:

drivers/misc/cs5535-mfgpt.c:320: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'resource_size_t'
drivers/misc/cs5535-mfgpt.c:320: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'resource_size_t'

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
