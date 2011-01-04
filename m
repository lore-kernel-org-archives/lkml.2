Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1ADV3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:29:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40157 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1ADV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:29:17 -0500
Date: Tue, 4 Jan 2011 22:29:16 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 0/2] Annotate gpio-configuration with __must_check
Message-ID: <20110104212916.GA14436@pengutronix.de>
References: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
 <20110104202718.GA31444@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20110104202718.GA31444@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 04, 2011 at 12:27:18PM -0800, Greg KH wrote:
> On Tue, Jan 04, 2011 at 05:51:06PM +0100, Wolfram Sang wrote:
> > Here is a small series generating a lot of warnings, especially in board
> > bringup-files. Still, I think it is worthwhile to be strict about check=
ing
> > return values of gpio-configuration-functions. My suggestion to keep th=
e noise
> > a bit lower is to put it into linux-next for one cycle and then merge i=
t for
> > 2.6.39? That should give people some time to fix the issues in time. Lo=
oking
> > forward to comments.
>=20
> It's ok to add this type of thing, but please, go through and fix the
> warnings at the same time.  Otherwise it's a bit rude to force others to
> fix their code for something that you did.

Yeah, I understand. I was a "victim" of the patch causing all those "key no=
t in
=2Edata" messages back then. So, I actually did start a coccinelle-script f=
ixing
the issues. I examined one sub-directory using a CPU/SoC I know relatively
well. I had to learn that even then, it is pretty hard to determine what
exactly to do if gpio_request() fails. For example, an unavailable GPIO bei=
ng
the write-protect-pin for SD-cards might be simply ignored, maybe a warning
printed and the card will be rw by default. Another GPIO might be a chip-se=
lect
of a device I have never heard of before. It might be crucial and board_init
should fail if it cannot be requested. Or not. Things get worse for
architectures I never used before. This is why I think it is really better =
to
let people do the fixups who have/understand the hardware in question.
Otherwise the fixups could indeed be more harmful than helpful.

If this is still too rude for your taste, then what about a mechanism simil=
ar
to DEBUG_SECTION_MISMATCH?

Kind regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk0jkSwACgkQD27XaX1/VRvjxQCgj0e2rHLqA5IS2/pbEVVzA3eb
DeQAoJG3A8Yd2SN06GqgvhIw9ux3NbOI
=llyK
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
