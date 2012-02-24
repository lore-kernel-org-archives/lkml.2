Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2BXR2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:28:04 -0500
Received: from 5.mo5.mail-out.ovh.net ([87.98.173.103]:37873 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932121Ab2BXR17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:27:59 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Feb 2012 12:27:59 EST
Date: Fri, 24 Feb 2012 17:54:43 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v3 17/21] ARM: at91: merge SRAM Memory banks thanks to
 mirroring
Message-ID: <20120224165443.GA21556@game.jcrosoft.org>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
 <c9b1e3ffbc322a1d1e1272062a9361abe536a33a.1330006537.git.nicolas.ferre@atmel.com>
 <4F46B3DF.7010402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F46B3DF.7010402@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14034905288799005453
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtdegucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrtdehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:47 Fri 24 Feb     , Ryan Mallon wrote:
> On 24/02/12 01:26, Nicolas Ferre wrote:
> 
> > From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > 
> > On at91sam9260 and at91sam9g20 the SRAM banks are mirrored. We can
> > merge them together to be able to have bigger and continuous
> > internal RAM.
> 
> I think this patch needs some comments in the code. As mentioned in the
> last round, this functionality is not documented, so it is not obvious
> how/why this works. This is especially true for any user who has
> problems with this code and then tries to look up those addresses in
> their at91 manual only to find the regions are reserved.
> 
> Nicolas, are you able to give an official Atmel stance on this?
you have the ack from Nico and he send the e-mail

Best Regards,
J.
> 
> ~Ryan
> 
> > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > ---
> >  arch/arm/mach-at91/at91sam9260.c              |   13 +++++--------
> >  arch/arm/mach-at91/include/mach/at91sam9260.h |    4 ++++
> >  2 files changed, 9 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
> > index 14882ae..4ade265 100644
> > --- a/arch/arm/mach-at91/at91sam9260.c
> > +++ b/arch/arm/mach-at91/at91sam9260.c
> > @@ -310,15 +310,12 @@ static void __init at91sam9xe_map_io(void)
> >  
> >  static void __init at91sam9260_map_io(void)
> >  {
> > -	if (cpu_is_at91sam9xe()) {
> > +	if (cpu_is_at91sam9xe())
> >  		at91sam9xe_map_io();
> > -	} else if (cpu_is_at91sam9g20()) {
> > -		at91_init_sram(0, AT91SAM9G20_SRAM0_BASE, AT91SAM9G20_SRAM0_SIZE);
> > -		at91_init_sram(1, AT91SAM9G20_SRAM1_BASE, AT91SAM9G20_SRAM1_SIZE);
> > -	} else {
> > -		at91_init_sram(0, AT91SAM9260_SRAM0_BASE, AT91SAM9260_SRAM0_SIZE);
> > -		at91_init_sram(1, AT91SAM9260_SRAM1_BASE, AT91SAM9260_SRAM1_SIZE);
> > -	}
> > +	else if (cpu_is_at91sam9g20())
> > +		at91_init_sram(0, AT91SAM9G20_SRAM_BASE, AT91SAM9G20_SRAM_SIZE);
> > +	else
> > +		at91_init_sram(0, AT91SAM9260_SRAM_BASE, AT91SAM9260_SRAM_SIZE);
> >  }
> >  
> >  static void __init at91sam9260_ioremap_registers(void)
> > diff --git a/arch/arm/mach-at91/include/mach/at91sam9260.h b/arch/arm/mach-at91/include/mach/at91sam9260.h
> > index 2e47b6d..08ae9af 100644
> > --- a/arch/arm/mach-at91/include/mach/at91sam9260.h
> > +++ b/arch/arm/mach-at91/include/mach/at91sam9260.h
> > @@ -113,6 +113,8 @@
> >  #define AT91SAM9260_SRAM0_SIZE	SZ_4K		/* Internal SRAM 0 size (4Kb) */
> >  #define AT91SAM9260_SRAM1_BASE	0x00300000	/* Internal SRAM 1 base address */
> >  #define AT91SAM9260_SRAM1_SIZE	SZ_4K		/* Internal SRAM 1 size (4Kb) */
> > +#define AT91SAM9260_SRAM_BASE	0x002FF000	/* Internal SRAM base address */
> > +#define AT91SAM9260_SRAM_SIZE	SZ_8K		/* Internal SRAM size (8Kb) */
> >  
> >  #define AT91SAM9260_UHP_BASE	0x00500000	/* USB Host controller */
> >  
> > @@ -126,6 +128,8 @@
> >  #define AT91SAM9G20_SRAM0_SIZE	SZ_16K		/* Internal SRAM 0 size (16Kb) */
> >  #define AT91SAM9G20_SRAM1_BASE	0x00300000	/* Internal SRAM 1 base address */
> >  #define AT91SAM9G20_SRAM1_SIZE	SZ_16K		/* Internal SRAM 1 size (16Kb) */
> > +#define AT91SAM9G20_SRAM_BASE	0x002FC000	/* Internal SRAM base address */
> > +#define AT91SAM9G20_SRAM_SIZE	SZ_32K		/* Internal SRAM size (32Kb) */
> >  
> >  #define AT91SAM9G20_UHP_BASE	0x00500000	/* USB Host controller */
> >  
> 
> 
