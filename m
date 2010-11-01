Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0KALKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 07:10:45 -0400
Received: from ozlabs.org ([203.10.76.45]:37868 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab0KALKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 07:10:43 -0400
Subject: Re: [PATCH] iSeries: Don't leak if allocations fail in
 mf_getSrcHistory
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Jesper Juhl <jj@chaosbits.net>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@pcug.org.au>
In-Reply-To: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gBTVMiECxDTmalQzWme3"
Date: Mon, 01 Nov 2010 22:10:42 +1100
Message-ID: <1288609842.10671.7.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gBTVMiECxDTmalQzWme3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-10-30 at 19:20 +0200, Jesper Juhl wrote:
> Hi,
>=20
> If memory is tight and a dynamic allocation fails there's no reason to=
=20
> make a bad situation worse by leaking memory.
>=20
> mf_getSrcHistory potentially leaks pages[0-3]. I believe the right thing=
=20
> to do is to free that memory again before returning -ENOMEM - which is=
=20
> what this patch does.
>=20
> I realize that the function is under '#if 0' so this probably doesn't=20
> matter much, but I assume that the function is still there for a reason=
=20
> (but I could be wrong, I don't know the powerpc code).
> Anyway, I suggest we remove the leak.

Stephen is the iSeries maintainer, and I think he #if 0'ed the code. But
I don't think it will ever be un-ifdef'ed, so should probably just be
removed.

cheers


--=-gBTVMiECxDTmalQzWme3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzOoDIACgkQdSjSd0sB4dL0dACgqcRspxXeU01uHOVG9ZaBdwkd
1Q8AmgKshK1tiCp7tMAWNiZAeESMBdZn
=UUKN
-----END PGP SIGNATURE-----

--=-gBTVMiECxDTmalQzWme3--

