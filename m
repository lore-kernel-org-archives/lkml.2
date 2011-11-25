Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab1KYNwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 08:52:20 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:47109 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab1KYNwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 08:52:15 -0500
Date: Fri, 25 Nov 2011 14:47:08 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH] at91_ether: use gpio_is_valid for phy IRQ line
Message-ID: <20111125134708.GM15531@game.jcrosoft.org>
References: <1322128098-17724-1-git-send-email-jamie@jamieiles.com>
 <1322169674-4109-1-git-send-email-nicolas.ferre@atmel.com>
 <20111124222836.GB28582@gallagher>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124222836.GB28582@gallagher>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11313042265803303879
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrudduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeen
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -300
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddmnehvohhiugdpihhnthculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:28 Thu 24 Nov     , Jamie Iles wrote:
> Hi Nicolas,
> 
> On Thu, Nov 24, 2011 at 10:21:14PM +0100, Nicolas Ferre wrote:
> > Use the generic gpiolib gpio_is_valid() function to test
> > if the phy IRQ line GPIO is actually provided.
> > 
> > For non-connected or non-existing phy IRQ lines, -EINVAL
> > value is used for phy_irq_pin field of struct at91_eth_data.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > ---
> >  drivers/net/ethernet/cadence/at91_ether.c |   23 +++++++++++++----------
> >  1 files changed, 13 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/cadence/at91_ether.c b/drivers/net/ethernet/cadence/at91_ether.c
> > index 56624d3..a1c4143 100644
> > --- a/drivers/net/ethernet/cadence/at91_ether.c
> > +++ b/drivers/net/ethernet/cadence/at91_ether.c
> > @@ -255,8 +255,7 @@ static void enable_phyirq(struct net_device *dev)
> >  	unsigned int dsintr, irq_number;
> >  	int status;
> >  
> > -	irq_number = lp->board_data.phy_irq_pin;
> > -	if (!irq_number) {
> > +	if (!gpio_is_valid(lp->board_data.phy_irq_pin)) {
> >  		/*
> >  		 * PHY doesn't have an IRQ pin (RTL8201, DP83847, AC101L),
> >  		 * or board does not have it connected.
> > @@ -265,6 +264,7 @@ static void enable_phyirq(struct net_device *dev)
> >  		return;
> >  	}
> >  
> > +	irq_number = lp->board_data.phy_irq_pin;
> 
> Does this need to be:
> 
> 	irq_number = gpio_to_irq(lp->board_data.phy_irq_pin);
> 
> and the same for the other occurrences?  Otherwise this looks like the 
> right thing to me.
yes

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
