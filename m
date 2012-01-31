Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2AaUhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:37:13 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:61249 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676Ab2AaUhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:37:12 -0500
Date: Tue, 31 Jan 2012 13:37:03 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Barry Song <Barry.Song@csr.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, linux-mtd@lists.infradead.org,
        Barry Song <Baohua.Song@csr.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erik Gilling <konkers@google.com>
Subject: Re: [PATCH 2/3] GPIO: TEGRA: move to use
 platform_devm_request_and_ioremap() helper
Message-ID: <20120131203703.GI22611@ponder.secretlab.ca>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-3-git-send-email-Barry.Song@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328004002-24646-3-git-send-email-Barry.Song@csr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 06:00:01PM +0800, Barry Song wrote:
> From: Barry Song <Baohua.Song@csr.com>
> 
> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Erik Gilling <konkers@google.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

This of course depends on the other patch, so I won't merge it until
there is an okay from gregkh.  Also, with his okay I'd be happy to
take it through the gpio tree to reduce dependencies.

g.


> ---
>  drivers/gpio/gpio-tegra.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
> index bdc2937..118e367 100644
> --- a/drivers/gpio/gpio-tegra.c
> +++ b/drivers/gpio/gpio-tegra.c
> @@ -355,13 +355,7 @@ static int __devinit tegra_gpio_probe(struct platform_device *pdev)
>  		bank->irq = res->start;
>  	}
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Missing MEM resource\n");
> -		return -ENODEV;
> -	}
> -
> -	regs = devm_request_and_ioremap(&pdev->dev, res);
> +	regs = platform_devm_request_and_ioremap(pdev, 0);
>  	if (!regs) {
>  		dev_err(&pdev->dev, "Couldn't ioremap regs\n");
>  		return -ENODEV;
> -- 
> 1.7.1
> 
> 
> 
> Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
> More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
