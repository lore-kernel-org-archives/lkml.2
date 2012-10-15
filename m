Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2JOHKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:10:43 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:12781 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab2JOHKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:10:41 -0400
Date: Mon, 15 Oct 2012 09:10:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i2c-ocores: Use devm_request_and_ioremap()
Message-ID: <20121015091015.2887fcb9@endymion.delvare>
In-Reply-To: <1344408872-1051-1-git-send-email-thierry.reding@avionic-design.de>
References: <1344408872-1051-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Wed,  8 Aug 2012 08:54:32 +0200, Thierry Reding wrote:
> Replacing the devm_request_mem_region() and devm_ioremap_nocache() calls
> by a single call to devm_request_and_ioremap() simplifies the code.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  drivers/i2c/busses/i2c-ocores.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
> index bffd550..1fad4ae 100644
> --- a/drivers/i2c/busses/i2c-ocores.c
> +++ b/drivers/i2c/busses/i2c-ocores.c
> @@ -283,18 +283,9 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
>  	if (!i2c)
>  		return -ENOMEM;
>  
> -	if (!devm_request_mem_region(&pdev->dev, res->start,
> -				     resource_size(res), pdev->name)) {
> -		dev_err(&pdev->dev, "Memory region busy\n");
> -		return -EBUSY;
> -	}
> -
> -	i2c->base = devm_ioremap_nocache(&pdev->dev, res->start,
> -					 resource_size(res));
> -	if (!i2c->base) {
> -		dev_err(&pdev->dev, "Unable to map registers\n");
> -		return -EIO;
> -	}
> +	i2c->base = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!i2c->base)
> +		return -EADDRNOTAVAIL;

I would suggest sticking to -EBUSY, AFAIK EADDRNOTAVAIL is for network
address errors.

>  
>  	pdata = pdev->dev.platform_data;
>  	if (pdata) {

-- 
Jean Delvare
