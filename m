Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab2KPCJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 21:09:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45058 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804Ab2KPCJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 21:09:07 -0500
Message-ID: <1353031727.4867.79.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 01/82] Bluetooth: Always compile SCO and L2CAP in Bluetooth
 Core
From: Ben Hutchings <ben@decadent.org.uk>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, ulisses@profusion.mobi, marcel@holtmann.org,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Date: Fri, 16 Nov 2012 02:08:47 +0000
In-Reply-To: <20121115210748.GB3358@joana>
References: <20121114053933.726869752@decadent.org.uk>
	 <20121114053933.935584768@decadent.org.uk> <20121114212426.GA1866@joana>
	 <20121114.163044.2287972932330697472.davem@davemloft.net>
	 <20121114213819.GT13292@decadent.org.uk>
	 <1353009872.4867.68.camel@deadeye.wl.decadent.org.uk>
	 <20121115210748.GB3358@joana>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2Au1A6BQPbnmy97eNGxo"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2Au1A6BQPbnmy97eNGxo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-11-15 at 19:07 -0200, Gustavo Padovan wrote:
> Hi Ben,
>=20
> * Ben Hutchings <ben@decadent.org.uk> [2012-11-15 20:04:32 +0000]:
>=20
> > On Wed, 2012-11-14 at 21:38 +0000, Ben Hutchings wrote:
> > > On Wed, Nov 14, 2012 at 04:30:44PM -0500, David Miller wrote:
> > > > From: Gustavo Padovan <gustavo@padovan.org>
> > > > Date: Wed, 14 Nov 2012 19:24:26 -0200
> > > >=20
> > > > > Hi Ben,
> > > > >=20
> > > > > * Ben Hutchings <ben@decadent.org.uk> [2012-11-14 05:39:34 +0000]=
:
> > > > >=20
> > > > >> 3.2-stable review patch.  If anyone has any objections, please l=
et me know.
> > > > >>=20
> > > > >> ------------------
> > > > >>=20
> > > > >> From: Ulisses Furquim <ulisses@profusion.mobi>
> > > > >>=20
> > > > >> commit f1e91e1640d808d332498a6b09b2bcd01462eff9 upstream.
> > > > >>=20
> > > > >> The handling of SCO audio links and the L2CAP protocol are essen=
tial to
> > > > >> any system with Bluetooth thus are always compiled in from now o=
n.
> > > > >=20
> > > > > I wonder if this could not break any kind of script or code peopl=
e have that
> > > > > refer directly to the sco and l2cap modules. Also I don't see thi=
s change as
> > > > > really necessary for 3.2.
> > > >=20
> > > > Agreed, I wish this had not been merged into -stable, I would have =
never
> > > > submitted a patch like this myself.
> > >=20
> > > This is required by:
> > >=20
> > > commit ff03261adc8b4bdd8291f1783c079b53a892b429
> > > Author: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
> > > Date:   Thu Aug 23 21:32:44 2012 -0300
> > >=20
> > >     Bluetooth: Fix sending a HCI Authorization Request over LE links
> > >    =20
> > >     commit d8343f125710fb596f7a88cd756679f14f4e77b9 upstream.
> > >=20
> > > which was already applied.
> >=20
> > So, do you think it's better to revert that in 3.2, or to go ahead with
> > this?
>=20
> I suggest you to revert it. There is a much simpler solution if revert, f=
ix
> the patch and apply it again. No need to push this module merge patch her=
e.
>=20
> The problem seems to be only a missing EXPORT_SYMBOL of the smp.c method.=
 That
> should fix it. If you want me to fix that just ask me.

smp_conn_security() is either in the same module or not defined at all.
I'll add an #ifdef CONFIG_BT_L2CAP instead of this patch.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-2Au1A6BQPbnmy97eNGxo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUKWgL+e/yOyVhhEJAQoH+Q/6Awn+U0uR76B2F06I3u/RhFc3aiHdBsPK
Qa3YCaqRdEXIxlKYo6foZ3DFaUx7+0BKGYjgV3kYcI4QL+ETJn+ITU7RYJftYS8U
gastdxUZrKVQ0Qm90xzO9x++FJKlRGZXC5ZQWHRUsDuLL5kRWLCotJAG0YtcOcaT
mzcAKkbbBapb+nTEOBxpUfBMGEQQuGJkkhzPNTco3HOeygvgPKJCXdjFoUdGl6IK
St7N2p8+VJztgvojdApq2XjwdQv/a364QFAwtoT7zSJLPFa3gnI7IXNN8pjgGSXL
E6JuJ/pc9gaQYO/tSBdyUxO/CtTn8SxSmGfBroMMs+G1prhzpwW2aFEo4kVT5Vw7
NyRt14m7ftUUnCxUNhsfM2a1AZFpJ8Mj59VljnbYLSLYJOwpKOrfWP6vebG3Umus
r5uw6MGar20YuwvNZu9n6SK1N4XCizRFN/LSkQ7pJ+GdfKuTIxDEw0SDmXhm0n6J
uGn6kn+hsWn7GMoD4oSnEk7pKTb8nrB12oUSbQYg6/tIakxFaw0dWuINezYoVyPv
a52zEey04qEp320aCCBgIElpivotcrcEA1BcgVJpRiknNfRh3VmtZWsH+PM6rUOP
6YDvZZu8IZfdz26JLIMKQ0rFCT3cLFJpcVvIeiHtw80z0sS9+B79/WeX32qBBoEX
JnrtwBRO1aw=
=8ASc
-----END PGP SIGNATURE-----

--=-2Au1A6BQPbnmy97eNGxo--
