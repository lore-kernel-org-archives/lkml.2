Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab2I3KgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 06:36:14 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:37856 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2I3Kfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:35:30 -0400
Date: Sun, 30 Sep 2012 12:35:19 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: mvebu: Add missing breaks in
 mvebu_gpio_irq_set_type
Message-ID: <20120930123519.5bddb2cd@skate>
In-Reply-To: <1348993407.20815.1.camel@phoenix>
References: <1348993407.20815.1.camel@phoenix>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Axel Lin,

On Sun, 30 Sep 2012 16:23:27 +0800, Axel Lin wrote:
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

Doh, I missed this when converting the if() series to a switch()
construct. It was just pure luck that it worked. Good catch indeed.

Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
