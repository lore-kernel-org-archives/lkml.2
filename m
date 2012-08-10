Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2HJIf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:35:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2HJIfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:35:23 -0400
Date: Fri, 10 Aug 2012 10:35:08 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
Message-ID: <20120810083508.GA16251@avionic-0098.mockup.avionic-design.de>
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com>
 <20120809202054.GA24503@avionic-0098.mockup.avionic-design.de>
 <CACRpkdaSk9xBaiSAKCj4Pa2kyyfP178XN53i2Q2+CBFx=RoE0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <CACRpkdaSk9xBaiSAKCj4Pa2kyyfP178XN53i2Q2+CBFx=RoE0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:lkV/5CUP8LoBygmOeSESI9WGrXRmpizjda4JjGvBt+L
 OWlmXbLfunVIdnDBxQydSw8DxOECU9dgux3j4cyUovXa84lqQa
 02btlaBMnYYaLU0HpSUIW5c2eQcTZimg2Y6JQEt0BIM338CI55
 LsbIoUZMT5WlJ11uNWLh1aAoXUZD/Ab4CUXwSgpBbfjG+GFCKn
 9kRa/1uzU9IPy84at0oLDdDVG5a8Lf+HkZuRr09HlD66jSc3ki
 i6TvNHn/Du3v9GrTYgcDV6BaMQsJptSb7BjjEhgj4ipQ55hG48
 3eFv6eL3rBk2B7XoG1kgfkVrjQ0PPPVLzs8p28EygMrZGoTEYF
 Axi9EG4oXdM4Jj1xgc3OwjimsjQDN9cfv2eii38rHE9p/RWMuC
 oDcpWE937yEXi30mVE+nGL972+p5lba5Ow=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 10, 2012 at 10:19:02AM +0200, Linus Walleij wrote:
> On Thu, Aug 9, 2012 at 10:20 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > On Sun, Jul 29, 2012 at 07:13:57PM +0200, Linus Walleij wrote:
> >> > +       client->irq =3D irq_of_parse_and_map(client->dev.of_node, 0);
> >> > +       if (client->irq =3D=3D NO_IRQ)
> >>
> >> Just if (!client->irq) since NO_IRQ is 0 nowadays.
> >
> > At the risk of seeming pedantic, NO_IRQ is in fact quite often not 0.
>=20
> No. A year back, yes, but not anymore. We went to great lengths in the
> ARM architecture to ensure NO_IRQ is *always 0. Russell spent
> a lot of time on this.
>=20
> Consult the following article on LWN:
> http://lwn.net/Articles/470820/
>=20
> Then grep your gitlog and you'll see we got rid of it from ARM.

Then why is there still the following in arch/arm/include/asm/irq.h?

	/*
	 * Use this value to indicate lack of interrupt
	 * capability
	 */
	#ifndef NO_IRQ
	#define NO_IRQ	((unsigned int)(-1))
	#endif

> If this driver is for some other arch like openrisc I might accept
> it but please reconsider.

There's nothing in the driver that makes it ARM specific, so it could be
used on other platforms just as well. But as I also said in my previous
mail, in this particular case the value for the interrupt comes from the
call to irq_of_parse_and_map(), which will return 0 on failure,
regardless of the architecture, so there is actually no problem.

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQJMe8AAoJEN0jrNd/PrOh3U4P/1b0dVJvswKWXZTT5eLfC70W
dU6WnEF8cQ0IFeQ0aHbnXOc2f1e7aYVO+YWMmmbvle3Mf1KIpkgCD2zDLss7TvDJ
1Rt5Csuw1yZQx6U3vgGg3/Za0DUXtem3rEmyAd3gXGHT8ujzf4UttnhaZWCx7LVV
00b7OP14MkccTZJ+cZQIatPnlXR3eHIHp0Aediwp0B9HmuQj7GSbibHRfJJPJ7PS
Uqpp+KKIdvXgal1E79w2+Judkw4Pv+EblQy1L8fvxTYpgAYQzCu05JKN3a+jXxsu
SI9ORm/9HcC50zr7upiY3bWRFpvk7z5Aoe87xWYnKE4YtwqP/TWQ1t7ewXs9H/Ho
Biece1PN6XwOtcoBZCCzfpV5RWsOuRuYa+yn/xUiDOk8V45nNAYPu2K1ScQi5He5
ROzbusYMu7IWCNpOMREfdeRyY7CMLdU9W3zwEeFfKAuMUwlpLBGJ9HR4SyxmFX7n
vLQgFuGl0mNj4ty9xmv4d5PIDTfCaTHHunESvOJ/jEcR4wsPxg5fyqjQImrc2etS
4OX/lWXAz2dcyD561Jloa1+ejMxUSiachtl64CaCHe/hYCFrWTk235q8nRrDk0o3
9M4x6DlfYqpX4qyXTbiKt9KT5+8Ji5hj3PbpBpSNk76GTsIufPLmrv9vIO6Rd/W7
TRzCrCVgotVaBLcZLP+V
=33ZC
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
