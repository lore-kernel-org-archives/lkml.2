Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2AaLeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:34:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53242 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2AaLeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:34:08 -0500
Date: Tue, 31 Jan 2012 12:33:58 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Erik Gilling <konkers@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-mtd@lists.infradead.org, Barry Song <Baohua.Song@csr.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 1/3] platform: add common resource requesting and
 mapping helper
Message-ID: <20120131113358.GM2471@pengutronix.de>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-2-git-send-email-Barry.Song@csr.com>
 <20120131101734.GE2471@pengutronix.de>
 <CAGsJ_4wyJ6Wymy4AWoW1eHubZX=W7GT_Fbow9ofXoY1RrcHzgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gw4vLALk08fVJy3V"
Content-Disposition: inline
In-Reply-To: <CAGsJ_4wyJ6Wymy4AWoW1eHubZX=W7GT_Fbow9ofXoY1RrcHzgA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gw4vLALk08fVJy3V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Barry,

> > You don't need to do the error checking for 'res'. You can simply do
> >
> > res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > base =3D devm_request_and_ioremap(&dev->dev, res);
>=20
> i do know  devm_request_and_ioremap() does res checking. but that is
> implicit, confused and not a smart way actually.

I agree about the implicit thing (keep in mind the function is new). But
calling a function "not smart" because it checks its arguments? I do
like the NULL check of kfree() for example.

> actually, no people by now really use the implicit checking. that
> shows people don't really think that is a good programming way.

I'd think most people just copy&paste and don't have an opinion either
way, so the quantity doesn't show much.

> > devm_request_and_ioremap() will check res. Given that, I don't think
> > we can save a lot with another wrapper.
>=20
> i think we can save some.
> The story begins from Grant's feedback in:
> http://www.spinics.net/lists/arm-kernel/msg157644.html

I am not sure using 'platform_devm_request_and_ioremap' and later using
plain 'devm_*' functions (without platform_-prefix) is less confusing.
The alternative would be to check which helper functions also use
'struct resource' and if they do checks on that. If all do that, you
would have the simple rule, that you only need to check yourself if you
access it yourself.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--gw4vLALk08fVJy3V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8n0aYACgkQD27XaX1/VRvQQwCfc4uFzEsLurU0rb6k0ZC3H0OI
jEoAn1OUBDFgco5RfLLPt6oGT05UvGl/
=UQLr
-----END PGP SIGNATURE-----

--gw4vLALk08fVJy3V--
