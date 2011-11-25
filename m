Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1KYPDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 10:03:37 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:56980 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1KYPDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 10:03:36 -0500
Date: Fri, 25 Nov 2011 16:00:49 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 2/2] gpiolib: introduce gpio_set_deglitch
Message-ID: <20111125150049.GB15008@game.jcrosoft.org>
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
 <1322230120-14120-2-git-send-email-plagnioj@jcrosoft.com>
 <20111125141444.GA13747@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111125141444.GA13747@legolas.emea.dhcp.ti.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12556598712880704453
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrudduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeen
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -210
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddmnehlihhnuhigucdlqddutddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:14 Fri 25 Nov     , Felipe Balbi wrote:
> Hi,
> 
> On Fri, Nov 25, 2011 at 03:08:40PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > this will allow to manage the Glitch Input Filter
> > as present on AT91 as example
> > 
> > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > ---
> >  drivers/gpio/gpiolib.c     |   44 ++++++++++++++++++++++++++++++++++++++++++++
> >  include/asm-generic/gpio.h |    4 ++++
> >  include/linux/gpio.h       |    5 +++++
> >  3 files changed, 53 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index b7e5e75..d2b1833 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -1563,6 +1563,50 @@ fail:
> >  }
> >  EXPORT_SYMBOL_GPL(gpio_set_pullup);
> >  
> > +/**
> > + * gpio_set_deglitch - sets @deglitch for a @gpio
> > + * @gpio: the gpio to set deglitch
> > + * @deglitch: deglitch level
> > + */
> > +int gpio_set_deglitch(unsigned gpio, unsigned deglitch)
> 
> sounds a lot like debounce, what's the difference ?
deglitch allow you to filter the fact that the line take time to be stable
go to 1 and 0

debounce will set 2 different threshold for changing the state from 0 to 1 and
invertly

Best Regards,
J.
