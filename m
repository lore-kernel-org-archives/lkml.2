Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1LAIDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:03:03 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:53326
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753204Ab1LAIDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:03:01 -0500
Message-ID: <4ED734AD.1070303@compulab.co.il>
Date: Thu, 01 Dec 2011 10:02:53 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 4/4] mfd: twl6040-core: Use gpio_request_one
References: <1322704074.11560.3.camel@phoenix> <1322704507.11560.8.camel@phoenix>
In-Reply-To: <1322704507.11560.8.camel@phoenix>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/11 03:55, Axel Lin wrote:
> Use gpio_request_one() instead of multiple gpiolib calls.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/twl6040-core.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
> index 268f80f..e57b1d1 100644
> --- a/drivers/mfd/twl6040-core.c
> +++ b/drivers/mfd/twl6040-core.c
> @@ -509,13 +509,10 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
>  		twl6040->audpwron = -EINVAL;
>  
>  	if (gpio_is_valid(twl6040->audpwron)) {
> -		ret = gpio_request(twl6040->audpwron, "audpwron");
> +		ret = gpio_request_one(twl6040->audpwron, GPIOF_OUT_INIT_LOW,
> +				       "audpwron");
>  		if (ret)
>  			goto gpio1_err;
> -
> -		ret = gpio_direction_output(twl6040->audpwron, 0);
> -		if (ret)
> -			goto gpio2_err;
>  	}

same here, double check gpio_is_valid()?


-- 
Regards,
Igor.
