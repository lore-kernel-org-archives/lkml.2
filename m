Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab2I3Ipa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:45:30 -0400
Received: from londo.lunn.ch ([80.238.139.98]:36535 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2I3Ip3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:45:29 -0400
Date: Sun, 30 Sep 2012 10:45:16 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: mvebu: Add missing breaks in
 mvebu_gpio_irq_set_type
Message-ID: <20120930084516.GD21046@lunn.ch>
References: <1348993407.20815.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348993407.20815.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 04:23:27PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/gpio/gpio-mvebu.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
> index 902af43..7a874129 100644
> --- a/drivers/gpio/gpio-mvebu.c
> +++ b/drivers/gpio/gpio-mvebu.c
> @@ -381,11 +381,13 @@ static int mvebu_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  		u = readl_relaxed(mvebu_gpioreg_in_pol(mvchip));
>  		u &= ~(1 << pin);
>  		writel_relaxed(u, mvebu_gpioreg_in_pol(mvchip));
> +		break;
>  	case IRQ_TYPE_EDGE_FALLING:
>  	case IRQ_TYPE_LEVEL_LOW:
>  		u = readl_relaxed(mvebu_gpioreg_in_pol(mvchip));
>  		u |= 1 << pin;
>  		writel_relaxed(u, mvebu_gpioreg_in_pol(mvchip));
> +		break;
>  	case IRQ_TYPE_EDGE_BOTH: {
>  		u32 v;
>  
> @@ -401,6 +403,7 @@ static int mvebu_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  		else
>  			u &= ~(1 << pin);	/* rising */
>  		writel_relaxed(u, mvebu_gpioreg_in_pol(mvchip));
> +		break;
>  	}
>  	}
>  	return 0;

Hi Axel

Good catch, thanks.

Acked-by: Andrew Lunn <andrew@lunn.ch>

	  Andrew
