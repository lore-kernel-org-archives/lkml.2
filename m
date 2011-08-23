Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1HWKBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 06:01:36 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:48219 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241Ab1HWKBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 06:01:32 -0400
Date: Tue, 23 Aug 2011 13:01:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Julia Lawall <julia@diku.dk>
Cc: Alan Stern <stern@rowland.harvard.edu>, kernel-janitors@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] drivers/usb/host/ohci-omap3.c: test the
 just-initialized value
Message-ID: <20110823100125.GK1341@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1314021636-11528-3-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOhpupldhMlYbdva"
Content-Disposition: inline
In-Reply-To: <1314021636-11528-3-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOhpupldhMlYbdva
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 22, 2011 at 04:00:35PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>=20
> Test the just-initialized value rather than some other one.
>=20
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @r@
> identifier x,y,f!=3D{PTR_ERR,ERR_PTR,ERR_CAST};
> statement S;
> @@
>=20
> x =3D f(...);
> (
> if (\(x =3D=3D NULL\|IS_ERR(x)\)) S
> |
> *if (\(y =3D=3D NULL\|IS_ERR(y)\))
>  { ... when !=3D x
>    return ...; }
> )
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

applied, thanks

--=20
balbi

--BOhpupldhMlYbdva
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU3p1AAoJEAv8Txj19kN1n8MH/26i5SzDVWJ+fRyd3U8iH7HB
E/6GL4MabZyNuhNdgHSCUQrxBSyUQFv3PuI0lj7kvYGDxJrihlSzs/JtHw5MenWe
dtYWLQ1gmbG8kGaaHKtJNEYkdnyhITLqGYjH4cD9n+KSqcgp/WEzCoiNVD9o2w4+
s3nn2ALF1lp5k3fdB3yzbIjJhKIZBDFLIz5hLjE6OTTAy/d1vfa/hZbIbNQ6Q/C2
fR/RW8vBVO79fUpKTNt1UXtvoTjinQWnHDuWz6/caKaJDPubflg4op/NSoH2OGkv
7DdWNTwFLTp9dAnssg5ARslE1YUp2MNqwo5k3PhNODG6zDmWHz058yKmpYXz93s=
=1mSl
-----END PGP SIGNATURE-----

--BOhpupldhMlYbdva--
