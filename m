Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2ITBVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:21:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34847 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913Ab2ITBVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:21:39 -0400
Message-ID: <1348104094.4836.60.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 117/135] NFS: return error from decode_getfh in decode open
From: Ben Hutchings <ben@decadent.org.uk>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Adamson, Dros" <Weston.Adamson@netapp.com>
Date: Thu, 20 Sep 2012 02:21:34 +0100
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA908FD7C84@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120917003625.784119135@decadent.org.uk>
	 <20120917003642.413673073@decadent.org.uk>
	 <20120919012623.GA17910@herton-Z68MA-D2H-B3>
	 <1348025970.4836.38.camel@deadeye.wl.decadent.org.uk>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA908FD7C84@SACEXCMBX04-PRD.hq.netapp.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MxyU4+y+RCR/uQGwCnnt"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MxyU4+y+RCR/uQGwCnnt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-09-19 at 15:53 +0000, Myklebust, Trond wrote:
> On Wed, 2012-09-19 at 04:39 +0100, Ben Hutchings wrote:
> > On Tue, 2012-09-18 at 22:26 -0300, Herton Ronaldo Krzesinski wrote:
> > > On Mon, Sep 17, 2012 at 01:38:22AM +0100, Ben Hutchings wrote:
> > > > 3.2-stable review patch.  If anyone has any objections, please let =
me know.
> > > >=20
> > > > I'm not sure whether my expansion of the fix is correct here.
[...]
> > > I'm also not sure about the expansion of the fix here, not knowing ve=
ry
> > > much about nfs. It seems that the code in some cases want to discard =
the
> > > status from decode_getfattr, for example nfs4_xdr_dec_rename is one c=
ase
> > > which does the same. Is it ok to return the status of decode_getfattr=
 on
> > > nfs4_xdr_dec_open here? Or should it remain like it was before?
> >=20
> > It looks like we try to get the file and directory attributes, and thos=
e
> > are nice to have but the open operation is still successful even if we
> > can't get them.  So my extra 'fixes' here are wrong.  Trond, is this
> > right?
>=20
> Hi Ben,
>=20
> We do not want to fail the RPC call in the case where the attribute
> decode failed; we already have ways to recover from that situation in
> the higher layers of the open code (we send a separate getattr RPC
> call). If, on the other hand, the filehandle decode fails, then we are
> screwed since we can't know exactly which file was just opened and this
> would be the reason for Dros's patch.
>=20
> So please do leave the decode_getfattr() line as it was, and apply the
> change to the decode_getfh() line only.

Thanks for the confirmation; this is what I've done.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-MxyU4+y+RCR/uQGwCnnt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFpvnue/yOyVhhEJAQppvxAAjVsEciN0cV/fEmJio4AasJWjJLt9vS4k
StRlA2MLdQS2le14RC7CY2RbFpIyc0uIKmhX1/k71uRMshcjoRp0NTA92aMeGxov
30fFRrerzHis66Eu4FyH9XiBWyjaQaKe3GD7Fw8ZpRHEoaeqZJgdJOBglf3OqS/Y
IAH/iV30e+j3eS7aW/NjE8rlBEj45qyAXwp/vUAQU1a1q9RAY4B/N9kvCnf59b4H
MZIa1qLydF8NTMJb/svkbX/2FzrtWlQtC/YLf78m4BEp0CY045sit5f1JYlye7yA
W5rp1lxzHDrFfFkexT9321ghiAqBLJhha5JL1G9iWQmEtYK+MhsN6Os4ISIRPYUb
TWoZyAbqSQuoEbzgkZ2rd0jN7bg4KPVl7YatKX3RLczM71N7v/DDt5Ka/QKYrYI8
2tiajbeCXHoA/4WzXIKFXx89iNYJRHlRyUQHB18mF/QLXxaEZKFakf3lXtXfKyJw
JEh2lQPSi2NKqhGazE84WacvKI4KF6fDJzPkCT2NsMfl81da8LpRK6l8KAzJikHU
OKLZJYhMX7FiMlEHNKYDFElPPTLmMfv1ZAgdGwrv8m1H4tBmF3S6nEJHUG2H8rST
Fv9PWQksS3y2dPXUwEnSdmaTEkcKVgzwzim+oL1thQQwA6/kIbDzDlK8Jmvv9Ssv
YATFgoSdZEo=
=8GLH
-----END PGP SIGNATURE-----

--=-MxyU4+y+RCR/uQGwCnnt--
