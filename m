Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1KYO7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:59:15 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:36802 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755687Ab1KYO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:59:14 -0500
Date: Fri, 25 Nov 2011 16:59:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
Message-ID: <20111125145905.GA17151@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
 <20111125141640.GB13747@legolas.emea.dhcp.ti.com>
 <20111125142305.GA15008@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20111125142305.GA15008@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2011 at 03:23:05PM +0100, Jean-Christophe PLAGNIOL-VILLARD =
wrote:
> On 16:16 Fri 25 Nov     , Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Nov 25, 2011 at 03:08:39PM +0100, Jean-Christophe PLAGNIOL-VILL=
ARD wrote:
> > > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.co=
m>
> > > Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> > > Cc: Grant Likely <grant.likely@secretlab.ca>
> > > ---
> > >  drivers/gpio/gpiolib.c     |   44 ++++++++++++++++++++++++++++++++++=
++++++++++
> > >  include/asm-generic/gpio.h |    4 ++++
> > >  include/linux/gpio.h       |    5 +++++
> > >  3 files changed, 53 insertions(+), 0 deletions(-)
> > >=20
> > > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > > index a971e3d..b7e5e75 100644
> > > --- a/drivers/gpio/gpiolib.c
> > > +++ b/drivers/gpio/gpiolib.c
> > > @@ -1519,6 +1519,50 @@ fail:
> > >  }
> > >  EXPORT_SYMBOL_GPL(gpio_set_debounce);
> > > =20
> > > +/**
> > > + * gpio_set_pullup - sets @pullup for a @gpio
> > > + * @gpio: the gpio to set pullup
> > > + * @pullup: pullup level
> > > + */
> > > +int gpio_set_pullup(unsigned gpio, unsigned pullup)
> > > +{
> > > +	unsigned long		flags;
> > > +	struct gpio_chip	*chip;
> > > +	struct gpio_desc	*desc =3D &gpio_desc[gpio];
> > > +	int			status =3D -EINVAL;
> > > +
> > > +	spin_lock_irqsave(&gpio_lock, flags);
> > > +
> > > +	if (!gpio_is_valid(gpio))
> > > +		goto fail;
> > > +	chip =3D desc->chip;
> > > +	if (!chip || !chip->set_pullup)
> > > +		goto fail;
> > > +	gpio -=3D chip->base;
> > > +	if (gpio >=3D chip->ngpio)
> > > +		goto fail;
> > > +	status =3D gpio_ensure_requested(desc, gpio);
> > > +	if (status < 0)
> > > +		goto fail;
> > > +
> > > +	/* now we know the gpio is valid and chip won't vanish */
> > > +
> > > +	spin_unlock_irqrestore(&gpio_lock, flags);
> > > +
> > > +	might_sleep_if(chip->can_sleep);
> > > +
> > > +	return chip->set_pullup(chip, gpio, pullup);
> > > +
> > > +fail:
> > > +	spin_unlock_irqrestore(&gpio_lock, flags);
> > > +	if (status)
> > > +		pr_debug("%s: gpio-%d status %d\n",
> > > +			__func__, gpio, status);
> > > +
> > > +	return status;
> > > +}
> > > +EXPORT_SYMBOL_GPL(gpio_set_pullup);
> >=20
> > Maybe I'm missing something, but isn't it essentially what
> > gpio_set_value() does ? I mean, you set a pullup and you get '1' value
> > and set a pulldown and you get a '0' value ??
> >=20
> > Without a proper description of the necessity for this change, I can't
> > easily tell them apart :-(
> set_value is for output set_pullup is for input mode
>=20
> some IP allow you when you configure an gpio as input to enable the
> internal pullup so no need on the board to add an external pull up

I see, that would fit nicely on the changelog :-)

--=20
balbi

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOz605AAoJEIaOsuA1yqREkEQQAIe0NI28Ddrzx+nFL6nuRMwr
zl/JmEbUxuEZetaso5OREPnFtBqCYP0s0KvpjsWAoFaZjvi+Ki8O2dV3nB6mvr6H
dJecw4R92GjQIQFGYMKZJeo/omGfq6woIABHWF8AmvKWPw2OkNEtR62etmin0aNe
iTIySKihIRzkijPpq9ggWutPwS/GeQcY8BkFS600SfC2PNEmAq5PtvyQH7OxHadW
UbAgUrkzWkSwpLaDpD0FCh9n4QZCWJxCTVLe0ASTPFfQqG1E7s41wAPVngZJP+AU
8wuNMsgQRLvz5cOnxojvwgKgKnA42o22v70v/6TL5uTvVvROb3S1z0KOFnmuhdwv
bvsYiSRYQuIWwl1zC8sw+XYBa6sCLga25XYQ3UzRFTOBHzP9wM10YBS3hAIzAJdM
gOyTiY/Aft3PRtBF/Ic0mH7Uo5+hzaitN3YxxxukD+ALDw+RKVk2DaYi8RwQRq4j
EgyNbTQPgcezN8C9tQG/srtndkdhlY8LKAt2crv0XnuTT1U19b14UYqhot9y+GK0
nvFpNKqFQPvh4JTgJ4gV7keBEsiZyfw+lFzi+sbUcYHoyFBum/mwtmpBMSQRPY4l
42vaqc0Br6In0rqZvvtKk7rtLKf+HKDeH2UNhUKaZuJ18B0EV1M6O69GoZ2ik7Yd
luNevhBit6D8s5elrURk
=s+6v
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
