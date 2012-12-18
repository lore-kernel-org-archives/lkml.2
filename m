Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2LRKWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:22:42 -0500
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:50488 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751028Ab2LRKWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:22:40 -0500
X-Greylist: delayed 8744 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 05:22:40 EST
Date: Tue, 18 Dec 2012 08:54:33 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Roland Stigge <stigge@antcom.de>, rmallon@gmail.com,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        daniel-gl@gmx.net, sr@denx.de, linux-arm-kernel@lists.infradead.org,
        highguy@gmail.com
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
Message-ID: <20121218075433.GO23971@game.jcrosoft.org>
References: <50CF0744.7040404@grandegger.com>
 <50CF1EF1.2070601@antcom.de>
 <50CF237E.5020409@antcom.de>
 <50CF4838.9000401@grandegger.com>
 <50CF5327.6070205@antcom.de>
 <50CF584E.1040601@grandegger.com>
 <50CF5E45.5030104@antcom.de>
 <50CF76D3.9030708@grandegger.com>
 <20121218055525.GJ23971@game.jcrosoft.org>
 <50D01402.9090301@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D01402.9090301@grandegger.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2428847574105893858
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehkedrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehkedrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:58 Tue 18 Dec     , Wolfgang Grandegger wrote:
> On 12/18/2012 06:55 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 20:47 Mon 17 Dec     , Wolfgang Grandegger wrote:
> >> On 12/17/2012 07:02 PM, Roland Stigge wrote:
> >>> On 12/17/2012 06:37 PM, Wolfgang Grandegger wrote:
> >>>> 	/* Do synchronous data output with a single write access */
> >>>> 	__raw_writel(~mask, pio + PIO_OWDR);
> >>>> 	__raw_writel(mask, pio + PIO_OWER);
> >>>> 	__raw_writel(val, pio + PIO_ODSR);
> >>>>
> >>>> For caching we would need a storage. Not sure if it's worth compared to
> >>>> a context switch into the kernel.
> >>>
> >>> Block GPIO is not only for you in userspace. ;-) You can also implement
> >>> efficient n-bit bus I/O in kernel drivers, n-bit-banging. :-) So not
> >>> always context switches involved.
> >>
> >> OK, what do you think about the following untested patch:
> >>
> >> From b44cad16cbbca84715dffd4cb5268497216add25 Mon Sep 17 00:00:00 2001
> >> From: Wolfgang Grandegger <wg@grandegger.com>
> >> Date: Mon, 3 Dec 2012 08:31:55 +0100
> >> Subject: [PATCH 1/2] gpio: add GPIO block callback functions for AT91
> >>
> >> Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
> >> ---
> >>  arch/arm/mach-at91/gpio.c |   29 +++++++++++++++++++++++++++++
> >>  1 file changed, 29 insertions(+)
> >>
> >> diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
> >> index be42cf0..cf6bd45 100644
> >> --- a/arch/arm/mach-at91/gpio.c
> >> +++ b/arch/arm/mach-at91/gpio.c
> >> @@ -42,13 +42,16 @@ struct at91_gpio_chip {
> >>  	void __iomem		*regbase;	/* PIO bank virtual address */
> >>  	struct clk		*clock;		/* associated clock */
> >>  	struct irq_domain	*domain;	/* associated irq domain */
> >> +	unsigned long		mask_shadow;	/* synchronous data output */
> >>  };
> >>  
> >>  #define to_at91_gpio_chip(c) container_of(c, struct at91_gpio_chip, chip)
> >>  
> >>  static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip);
> >>  static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val);
> >> +static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val);
> >>  static int at91_gpiolib_get(struct gpio_chip *chip, unsigned offset);
> >> +static unsigned long at91_gpiolib_get_block(struct gpio_chip *chip, unsigned long mask);
> >>  static int at91_gpiolib_direction_output(struct gpio_chip *chip,
> >>  					 unsigned offset, int val);
> >>  static int at91_gpiolib_direction_input(struct gpio_chip *chip,
> >> @@ -62,7 +65,9 @@ static int at91_gpiolib_to_irq(struct gpio_chip *chip, unsigned offset);
> >>  			.direction_input  = at91_gpiolib_direction_input, \
> >>  			.direction_output = at91_gpiolib_direction_output, \
> >>  			.get		  = at91_gpiolib_get,		\
> >> +			.get_block	  = at91_gpiolib_get_block,	\
> >>  			.set		  = at91_gpiolib_set,		\
> >> +			.set_block	  = at91_gpiolib_set_block,	\
> >>  			.dbg_show	  = at91_gpiolib_dbg_show,	\
> >>  			.to_irq		  = at91_gpiolib_to_irq,	\
> >>  			.ngpio		  = nr_gpio,			\
> >> @@ -896,6 +901,16 @@ static int at91_gpiolib_get(struct gpio_chip *chip, unsigned offset)
> >>  	return (pdsr & mask) != 0;
> >>  }
> >>  
> >> +static unsigned long at91_gpiolib_get_block(struct gpio_chip *chip, unsigned long mask)
> >> +{
> >> +	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> >> +	void __iomem *pio = at91_gpio->regbase;
> >> +	u32 pdsr;
> >> +
> >> +	pdsr = __raw_readl(pio + PIO_PDSR);
> >> +	return pdsr & mask;
> >> +}
> >> +
> >>  static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val)
> >>  {
> >>  	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> >> @@ -905,6 +920,20 @@ static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val)
> >>  	__raw_writel(mask, pio + (val ? PIO_SODR : PIO_CODR));
> >>  }
> >>  
> >> +static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val)
> >> +{
> >> +	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> >> +	void __iomem *pio = at91_gpio->regbase;
> >> +
> >> +	/* Do synchronous data output with a single write access */
> >> +	if (mask != at91_gpio->mask_shadow) {
> >> +		at91_gpio->mask_shadow = mask;
> >> +		__raw_writel(~mask, pio + PIO_OWDR);
> >> +		__raw_writel(mask, pio + PIO_OWER);
> >> +	}
> >> +	__raw_writel(val, pio + PIO_ODSR);
> >> +}
> > this driver is only for old at91 platfrom if you touch at91 you need to update
> > the pinctrl too
> 
> Well, the patch is for the hardware I have at hand and I can test. There
> are many other GPIO hardware interfaces which could be enhanced with
> block gpio. Roland only did it for the interfaces in driver/gpio. Also,
> I think, an ACK for this patch series would be nice before we continue.

no sorry the support of the pinctrl is mandatory

check drivers/pinctrl/pinctrl-at91.c

as this new drivers include both pinctrl & gpio

Best Regards,
J.
