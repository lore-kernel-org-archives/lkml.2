Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2ENS2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:28:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59351 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2ENS2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:28:40 -0400
Message-ID: <1337020106.2042.2.camel@koala>
Subject: Re: [PATCH] UBIFS: add crypto lookup field to tree node cache
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 14 May 2012 21:28:26 +0300
In-Reply-To: <alpine.DEB.2.00.1205141907290.12448@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205111323010.17715@eristoteles.iwoars.net>
	 <1337001716.2528.56.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1205141907290.12448@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-W8EzLtb+GwEtoYYZhfq+"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-W8EzLtb+GwEtoYYZhfq+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-14 at 19:20 +0200, Joel Reardon wrote:
> The long long is divided as follows:
> 32 bits for the (KSA-relative) LEB number, 32 bits for the offset in the
> leb where the key is found. So its the same as the lnum/offs for the
> current one. Theres substancial compression though, that is available,
> since theres likely not more than 2^^32 LEBS for the KSA and the number o=
f
> bits needed for key offset is LEB_SHIFT - 4.
>=20
> Is 32 bits sufficient to address all keys:
> one key per datanode means 4096 * 2^32 =3D 2^44, so only 16 TB available
> for 32 bit key addresses.
>=20
> Though there is similar waste for lnum/offs as well. Perhaps zbranches ca=
n
> be stored as a u8[] and demarshalled with bit-op macros when needed for
> computations.

OK, thanks for explanation. Why not to then store 2x32-bit fields
instead, which is consistent with the current style? Why "long long"?

--=20
Best Regards,
Artem Bityutskiy

--=-W8EzLtb+GwEtoYYZhfq+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPsU7KAAoJECmIfjd9wqK0JygP/RjDbKbWrWM6fM7KbZZ2S+3i
ZyD1C/qdeb1RVfzLJ2bCNFqbbjXVI3e2bZ2xO5l2eojOxWHh1WPBEPWHrjV/p6B2
cJ9zlMLJMAuW7vOU+DMBZPwZiCmH+mtzgPhzePRl1650Gk/3H9BcWzNAFkfeQSCt
D40m3ddnT63h91s+WpLibcKy8vx3FEaXARrFQAEVMUCImFag4qPWN4slTuXYtbxK
ad+oV+Oj2VZEbdCtYi5iT4Uw243a1hb2LWVjggTcGNKOpJNUNgs3lwvATZpquT8c
P/oMfw+rbU54ELupu4U17vJhouMrCHUlEveTBlDIPRauJHqejpkqJS6cYIbkEVtO
Pg7AqlF7jJL6RaRSkVQ5yrvdZcf2y7p4vRNC8jpnEOEl9eQ5xbYA86qk7XriSfC7
NFeDWN/pmqEqQ8VGV1+yLEFbX+drV5YUs4bl3ESajrSO4QNmNg4uIyKTtpGSuAVx
zJGqfbNl0sfHgl/ixLXPZDyW5wgg6IDhalm5O5iKgW8+tvEpIWO3CTFsOOWG4ol7
wM3GUTJcu+mviXALWQoWHc6nB5UuBCIvQEHo4q1e92WcrOuvenITXH7tV/X5DOso
7l69Mp9pSzdP5TqoQ61MGMnkCgPqxutAXhNeLJa2AFT0NNRqJw0Y64MgDw0/6Yqn
FeW2nWHk6QP35ShvNmBH
=Mdc5
-----END PGP SIGNATURE-----

--=-W8EzLtb+GwEtoYYZhfq+--

