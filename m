Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1FCCbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 22:31:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59932 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722Ab1FCCbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 22:31:38 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Timo Warns <warns@pre-sense.de>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110601081141.803241093@blue.kroah.org>
References: <20110601081141.803241093@blue.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-WraNKKdSyMaBVxzoiH1Z"
Date: Fri, 03 Jun 2011 03:31:29 +0100
Message-ID: <1307068289.22348.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [087/165] Fix for buffer overflow in
 ldm_frag_add not sufficient
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WraNKKdSyMaBVxzoiH1Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-06-01 at 17:10 +0900, Greg KH wrote:
> 2.6.39-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
> Content-Length: 1139
> Lines: 36
>=20
> From: Timo Warns <Warns@pre-sense.de>
>=20
> commit cae13fe4cc3f24820ffb990c09110626837e85d4 upstream.
>=20
> As Ben Hutchings discovered [1], the patch for CVE-2011-1017 (buffer
> overflow in ldm_frag_add) is not sufficient.  The original patch in
> commit c340b1d64000 ("fs/partitions/ldm.c: fix oops caused by corrupted
> partition table") does not consider that, for subsequent fragments,
> previously allocated memory is used.
>=20
> [1] http://lkml.org/lkml/2011/5/6/407

I still assert that the function is broken because the fragments are
copied to incorrect offsets.  However, this change should at least make
it *harmless* junk.

Ben.

> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Timo Warns <warns@pre-sense.de>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  fs/partitions/ldm.c |    5 +++++
>  1 file changed, 5 insertions(+)
>=20
> --- a/fs/partitions/ldm.c
> +++ b/fs/partitions/ldm.c
> @@ -1335,6 +1335,11 @@ static bool ldm_frag_add (const u8 *data
> =20
>  	list_add_tail (&f->list, frags);
>  found:
> +	if (rec >=3D f->num) {
> +		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, f->num);
> +		return false;
> +	}
> +
>  	if (f->map & (1 << rec)) {
>  		ldm_error ("Duplicate VBLK, part %d.", rec);
>  		f->map &=3D 0x7F;			/* Mark the group as broken */
>=20
>=20
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review
>=20

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-WraNKKdSyMaBVxzoiH1Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATehHgee/yOyVhhEJAQr4phAAh360vhJ4G1ily2HVH+RA9abYzI86/mNK
+I297Od7guUItFzaPBMQaTfxfV+dOgVa8w/FEpwdhd4CMndNNAlgQ5jCvA2q0T7B
ekzJ/R5qPPxmc9skQguCQ+dP3f3DsIMOwL7qGGLCNAgaq2wkI8lLCaVP44+SlFlT
4crYOrutoLST+5aK/4CKQaIiBo4f/N7cfsFsuEBUlXrZrvn5EsuewOKM21eq3UWE
9pw+nBQ0fELi2LoR17umYsYiphAJPmCSgi5sBpIvC2X7V3jnbAasMiKisBd8b09q
uKQrYXPZFZQVIRDlbO4vq8AkbhPGIrvK2L/oJs9gcwcgqh69yj9ul130/bgRXBdP
U8fqLh0sUiNgLdUGpv2xVpEBUGTcrSCWpaXJgHXVu6Ogkt9cM+np5uTli+tPhSKw
skaBSv6hU5+AOysxf5rVhf+0YaTKmNhOptWjqlEgA9Xom7gganlgXBve547s/ORD
ldHEK+coaYveF/6wiLSwLIdn5/ITzB03I/E1xL7aT04LEfO5UeBXCtUjPaGob8k7
G8o7ZFyh5hWb18fHyN0zlX6mJVFC8nhnURvrxjPyY1/EC6/rmqhPeUFU0zSiEbZN
4yrCvaburIsTBLTrbZFucsh0x0Ki/uyI852a0fb8yzjvy5FJSD5IY8adaaU69yVy
aANiHBWC0Gw=
=N5gx
-----END PGP SIGNATURE-----

--=-WraNKKdSyMaBVxzoiH1Z--
