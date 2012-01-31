Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2AaVQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:16:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51521 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2AaVQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:16:00 -0500
Date: Tue, 31 Jan 2012 22:15:54 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Barry Song <21cnbao@gmail.com>, Barry Song <Barry.Song@csr.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Erik Gilling <konkers@google.com>,
        linux-mtd@lists.infradead.org, Barry Song <Baohua.Song@csr.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 1/3] platform: add common resource requesting and mapping
 helper
Message-ID: <20120131211554.GA28105@pengutronix.de>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-2-git-send-email-Barry.Song@csr.com>
 <20120131101734.GE2471@pengutronix.de>
 <CAGsJ_4wyJ6Wymy4AWoW1eHubZX=W7GT_Fbow9ofXoY1RrcHzgA@mail.gmail.com>
 <20120131113358.GM2471@pengutronix.de>
 <20120131203455.GG22611@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20120131203455.GG22611@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > I am not sure using 'platform_devm_request_and_ioremap' and later using
> > plain 'devm_*' functions (without platform_-prefix) is less confusing.
> > The alternative would be to check which helper functions also use
> > 'struct resource' and if they do checks on that. If all do that, you
> > would have the simple rule, that you only need to check yourself if you
> > access it yourself.
>=20
> The reason I suggested the wrapper is that then the driver code doesn't n=
eed
> to fart around with the res pointer at all.  It reduces boilerplate in pl=
atform
> drivers which I think is a good thing.

I do understand your motivation and fully agree with what you are aiming for
(that's exactly why I implemented devm_request_and_ioremap()).

This patch is a micro-optimization, though, and won't cut it IMHO. I still =
have
issues with only one platform_devm_* and all the rest being devm_* (without
platform_). Things might look better, if we'd for example also have
platform_devm_request_irq() or something similar. That might be an approach
where we can play around with and see what is left to do. Or, if other
approaches might be more elegant.

To discuss that, try things, etc, I'd simply like to have a bit more time. =
If
we are accepting the first iteration right away, and people let run their
coccinelle-scripts based on that, it might get annoying to change that a se=
cond
time, I'd think.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8oWgoACgkQD27XaX1/VRv/RQCbBqDcDHfcf6yjhBBArqo1+MTE
2PwAn0eIynZTYHg6zEWxwCrUyZ2tYZFe
=+4+Z
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
