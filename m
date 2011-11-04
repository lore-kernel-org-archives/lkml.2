Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab1KDEdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 00:33:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46825 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990Ab1KDEdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 00:33:51 -0400
Message-ID: <1320381208.3079.61.camel@deadeye>
Subject: Re: [005/107] sparc: Allow handling signals when stack is corrupted.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Date: Fri, 04 Nov 2011 04:33:28 +0000
In-Reply-To: <20111102221450.536525065@clark.kroah.org>
References: <20111102221600.GA26650@kroah.com>
	 <20111102221450.536525065@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5cncu/MNZ6OV6YXHcnjZ"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5cncu/MNZ6OV6YXHcnjZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-11-02 at 15:13 -0700, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: "David S. Miller" <davem@davemloft.net>
>=20
> commit 5598473a5b40c47a8c5349dd2c2630797169cf1a upstream.
>=20
> If we can't push the pending register windows onto the user's stack,
> we disallow signal delivery even if the signal would be delivered on a
> valid seperate signal stack.
>=20
> Add a register window save area in the signal frame, and store any
> unsavable windows there.
>=20
> On sigreturn, if any windows are still queued up in the signal frame,
> try to push them back onto the stack and if that fails we kill the
> process immediately.
>=20
> This allows the debug/tst-longjmp_chk2 glibc test case to pass.
[...]

But is there a real application that needs this?

Ben.

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-5cncu/MNZ6OV6YXHcnjZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATrNrGee/yOyVhhEJAQpUxQ//VJCTX7rhLe00SKcV3nFmfm2mTv/b6ZiB
OzGCbJLEeEmSgnc3trq8dciYLwzlrqNWuY4Tnrmtws2WGVgnVbLobRESQQFsVf3o
LAu5NxpWcEu0mQ9etgCb71cRwl6uLN0lYqFmxkUYl1t4snloN0oetVBxiVRQxniV
xMV1zrB8SKi8b3w9qLMtCShVeEHXvSWZAeFOKqt10JMXrLYgZIo2qDAGOHKVLXbo
ASJlTxgO6tuhDHt1shTVF+4dxiE6WG9lHp80YgACpj7HCii7Mhk1aHiXxOxz9eLx
vnqx3gZKdplQYUeSsP0mHBp+zyFImZsEKUQR6NGBupcmeGJCZF7zVyIfW6UVX9xC
0amTnhpbVHLOlk/IyXFB85dsAgjpjwzHnIkVk+sBaVdn3PYBDkeS3yoC+5CBsOT7
poOQij2Bc1PpHpQq8MfYHNFOPGEjhwK+1DNIt7n/rkeJN07Qqw+1p6U1U+eyMA7I
PesE/cCb4n4uoxES/gGMza2J71iEoexIWzWiRjbKwJ2bh2oaMGFenU5mj0k/6T14
gIQH1BE7EmgFOB2PJtaZMxPIHTK2tkpRD++qPFgiLyMCCFeY0BVk0WVWPVz9VvTH
UdN1Pc+ftx3NAZtdVkukUgQ/Quq+4pBS19bFjfQY80X7eCfRN00od8ZTOBD7Op7i
EAO9585s340=
=l2Ty
-----END PGP SIGNATURE-----

--=-5cncu/MNZ6OV6YXHcnjZ--
