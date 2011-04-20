Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1DTCRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 22:17:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34991 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933Ab1DTCRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 22:17:49 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110420020128.GA27631@suse.de>
References: <20110419204117.979118654@clark.kroah.org>
	 <1303263653.3464.65.camel@localhost>  <20110420020128.GA27631@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-aEbPMqPw7CG5iD+v75tB"
Date: Wed, 20 Apr 2011 03:17:42 +0100
Message-ID: <1303265862.3464.77.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aEbPMqPw7CG5iD+v75tB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-04-19 at 19:01 -0700, Greg KH wrote:
> On Wed, Apr 20, 2011 at 02:40:53AM +0100, Ben Hutchings wrote:
> > On Tue, 2011-04-19 at 13:30 -0700, Greg KH wrote:
> > > 2.6.32-longterm review patch.  If anyone has any objections, please l=
et us know.
> > >=20
> > > ------------------
> > >=20
> > > From: Hans Rosenfeld <hans.rosenfeld@amd.com>
> > >=20
> > > commit 9d8888c2a214aece2494a49e699a097c2ba9498b upstream.
> > >=20
> > > Remove check_c1e_idle() and use the new AMD errata checking framework
> > > instead.
> >=20
> > Clean-up patches are generally not candidates for longterm updates.
>=20
> This was added because a follow-on patch required it.

Ah yes, 'x86, AMD: Set ARAT feature on AMD processors' is using the same
condition.

Of course, that could have been backported by referring to the function
that this removes, rather than pulling in a load of other changes with
consequent risk of regressions.

> > However, I notice that the range of procesors considered to have erratu=
m
> > 400 was also changed:
> >=20
> > [...]
> > > +const int amd_erratum_400[] =3D
> > > +	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
> > > +			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
> > [...]
> > > -	/* Family 0x0f models < rev F do not have C1E */
> > > -	if (c->x86 =3D=3D 0x0F && c->x86_model >=3D 0x40)
> > > -		return 1;
> > > -
> > > -	if (c->x86 =3D=3D 0x10) {
> > > -		/*
> > > -		 * check OSVW bit for CPUs that are not affected
> > > -		 * by erratum #400
> > > -		 */
> > > -		if (cpu_has(c, X86_FEATURE_OSVW)) {
> > [...]
> > > -		}
> > > -		return 1;
> > [...]
> >=20
> > Family 0x0f model 0x40 and model 0x41 stepping 0 and 1 are excluded.
> > Family 0x10 model 0x00, 0x01 and model 0x02 stepping 0 are excluded.
> > Is that the real fix here?
>=20
> In this patch, no, it's just infrastructure for a later one.
> And I think the bug you noticed here was also fixed in a later patch in
> the series, right?

I don't know that it is a bug.  But if you're referring to patch 26/28
'x86, cpu: Fix regression in AMD errata checking code', that fixes a bug
in range checking in the generic function but does not revert this
change.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-aEbPMqPw7CG5iD+v75tB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATa5CRee/yOyVhhEJAQo/VhAAn4uuhSG9ZQQXrFun2HUzyE6GZdACaw10
UjzxL9Yin3Fkp2KtxHuI0vxTGyEhCKsDsZ/EtqN3JF6siopafj6zS/5ewXYJXR8U
pdJk93zmQGPb2l/4/i1j/WS2bimeA90cdrI0kp8bbMabeU+cMIl43CBUmLRmheoq
ON0j02kawOqaYCzrW/5w8lllNVu12sNIOsDHI7ZTLwb0KlkSDWWzxoTwJSEPqXFa
DtvQHq3Utg27PAXAZ3xeoWj4JtER628xnlRmp7NtVzaYRO7AWZgajYZmPczfNZkt
jxoK7k4y+ED/kLaQPTkHHSItHq0WaV5PJAh8OI1t6Y/rJ2eX2Fnt2HzvCMNlfFRA
zkYx96+ScAXhI6iSSikRgSqlxfvHoVLZwROXi0M4Ec1U4uvSLwp+lmgKZ8Cpqwo1
+b+wFVb6FQFH7ynCcxVP1Rrf3Ljl5SDfKEZy2q8aGfG9z1oofUhEDTsqLLNc+USp
VoUEVJKIk9g5svnHBhiCjLM5ZBUC38RxKWD/W8ajJe31QCXZ0pIh9BLnTlTP8+8g
VnDNSLZ9rqysY/PpvcF6zRe3FZ96LgScG4vZZtHUkVfZ+wTXnfFaWPgXDachikRJ
JhxtDNMCW48SxlCeKDhGZf/KnAJuogL9oYFJtlM4g6pZee55dEtiPJVBWFwMu08R
3T1UZwXxBbg=
=ZgDT
-----END PGP SIGNATURE-----

--=-aEbPMqPw7CG5iD+v75tB--
