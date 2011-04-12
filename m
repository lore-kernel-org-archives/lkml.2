Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1DLVtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:49:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44867 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666Ab1DLVtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:49:06 -0400
Date: Tue, 12 Apr 2011 22:48:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Andrew Morton <akpm@linux-foundation.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] leds: provide helper to register "leds-gpio" devices
Message-ID: <20110412214848.GI7806@n2100.arm.linux.org.uk>
References: <1302097097.22904.41.camel@rex> <1302554157-24145-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302554157-24145-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 10:35:57PM +0200, Uwe Kleine-König wrote:
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 9bec869..e8e101e 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -14,6 +14,11 @@ config LEDS_CLASS
>  	  This option enables the led sysfs class in /sys/class/leds.  You'll
>  	  need this to do anything useful with LEDs.  If unsure, say N.
>  
> +config LED_REGISTER_GPIO
> +	bool
> +	help
> +	  This option provides the function gpio_led_register_device.
> +
>  if NEW_LEDS
>  
>  comment "LED drivers"
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 39c80fc..ca428bd 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -3,6 +3,7 @@
>  obj-$(CONFIG_NEW_LEDS)			+= led-core.o
>  obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
>  obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
> +obj-y					+= led-register.o

Why not obj-$(CONFIG_LED_REGISTER_GPIO) += led-register.o

rather than wrapping the code of led-register.c with a #ifdef for the
same symbol?
