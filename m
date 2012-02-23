Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2BWDeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 22:34:22 -0500
Received: from 17.mo5.mail-out.ovh.net ([46.105.56.132]:54708 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753051Ab2BWDeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 22:34:21 -0500
X-Greylist: delayed 50779 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Feb 2012 22:34:21 EST
Date: Thu, 23 Feb 2012 04:26:18 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v2 03/19] ARM: at91: make matrix register base soc
 independent
Message-ID: <20120223032618.GB20176@game.jcrosoft.org>
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
 <4b71fdf7ee746a09b7ee468aa3bc60d6c34d4c20.1329903206.git.nicolas.ferre@atmel.com>
 <4F456997.50500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F456997.50500@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12950663680582527757
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:17 Thu 23 Feb     , Ryan Mallon wrote:
> On 22/02/12 20:39, Nicolas Ferre wrote:
> 
> > From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > 
> > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Cc: linux-usb@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> Looks okay, one comment (for future) below, but otherwise:
> 
> Reviewed-by: Ryan Mallon <rmallon@gmail.com>
> 
> <snip>
> 
> > diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
> > index 8bdba2a..5fd6fe8 100644
> > --- a/arch/arm/mach-at91/at91sam9263.c
> > +++ b/arch/arm/mach-at91/at91sam9263.c
> > @@ -306,6 +306,7 @@ static void __init at91sam9263_ioremap_registers(void)
> >  	at91sam926x_ioremap_pit(AT91SAM9263_BASE_PIT);
> >  	at91sam9_ioremap_smc(0, AT91SAM9263_BASE_SMC0);
> >  	at91sam9_ioremap_smc(1, AT91SAM9263_BASE_SMC1);
> > +	at91_ioremap_matrix(AT91SAM9263_BASE_MATRIX);
> 
> 
> Not necessarily for this patch set, but this list of functions is
> getting long enough that it could be abstracted away by a table.
> Something like:
> 
>   struct at91_sys_device {
> 	const char *name;
> 	void __iomem **base;
> 	const unsigned long mem_start;
> 	const unsigned long mem_size;
>   };
> 
>   ...
> 
>   static const struct
>   at91_sys_device at91sam9263_sys_devices[] __initconst = {
> 	{"PIT",	&at91_pit_base,
> 	 AT91SAM9263_BASE_PIT, AT91_PIT_SIZE},
> 	...
> 	{"matrix", &at91_matrix_base,
> 	 AT91SAM9263_BASE_MATRIX, AT91_MATRIX_SIZE},
>   }
> 
>   ...
> 
>   void __init
>   at91_ioremap_sys_devices(const struct at91_sys_device *devices,
> 			   int nr_devices)
>   {
> 	int i;
> 
> 	for (i = 0; i < nr_devices; i++) {
> 		void __iomem *base = *(dev[i].base);
> 
> 		base = ioremap(dev[i].mem_start, dev[i].mem_size);
> 		if (!base)
> 			panic("Impossible to ioremap AT91 %s\n",
> 			      dev[i].name);
>   }
we switch to the DT no need

Best Regards,
J.
