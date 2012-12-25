Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2LYL2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:28:04 -0500
Received: from latitanza.investici.org ([82.94.249.234]:57798 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab2LYL2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:28:03 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 latitanza.investici.org A7BF7980F2
Date: Tue, 25 Dec 2012 12:26:57 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 19/29] batman-adv: fix random jitter calculation
Message-ID: <20121225112657.GC2604@ritirata.org>
References: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
 <1356315256-6572-20-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <1356315256-6572-20-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 24, 2012 at 11:14:06AM +0900, Akinobu Mita wrote:
> batadv_iv_ogm_emit_send_time() attempts to calculates a random integer
> in the range of 'orig_interval +- BATADV_JITTER' by the below lines.
>=20
>         msecs =3D atomic_read(&bat_priv->orig_interval) - BATADV_JITTER;
>         msecs +=3D (random32() % 2 * BATADV_JITTER);
>=20
> But it actually gets 'orig_interval' or 'orig_interval - BATADV_JITTER'
> because '%' and '*' have same precedence and associativity is
> left-to-right.
>=20
> This adds the parentheses at the appropriate position so that it matches
> original intension.
>=20
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Marek Lindner <lindner_marek@yahoo.de>
> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> Cc: Antonio Quartulli <ordex@autistici.org>
> Cc: b.a.t.m.a.n@lists.open-mesh.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---

Acked-by: Antonio Quartulli <ordex@autistici.org>

But I would suggest to apply this change to net, since it is a fix.

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ2Y2BAAoJEADl0hg6qKeOBO8QAL3lkJA82Hk1Co++znzd9nEl
0yr21UdyxPqhhlVACD+EX1pcFt2QC4Gm5yD6Mu/g2UA9GCBuz2PCHQfc8GR/xoIn
U0e14nug3oe9az4gfhWdkyYe3CzYVhDz+qWeazM+qzdZK/WVluQ/uy2hh5LUnkve
XPN6q9DwwoSW8fFLSMxhWZ1cSsvTk6cWArUAGyLEuF5c+w3PKvzKLK2oZcUFWqvR
+iW52Y7W8m9gbivRavq570ZsDWh248wzTm1qIsWknpFpORWaU47gt8XEpMuhGdJG
WjKIC5LzsTtQxwCSoF5zIczxBE7WgoCUUbUHXgA5PUkX2NWSdUw0LB0O513TySIo
7joXIFDpfu1R2w8YQWPEnKOfYeE/jDf2zJBgI+LnKViDUhPL2otfjB183ljlmFnl
KQHBrhDA8mqCCe3l5SOtdrTpDXBniWnOaAEgdb5aCINGRn5XCba3fH9Gn+ENN6GD
JAuOxNojJDX1mv2IB1CO9afJhOknqflgDF5FBoZdYHyM5VwZntrQllNIk+z/9T2n
OWTDWKVbNWAHvQ+dniSnfdAjitlOL98t/n7KfpUv1aOwK6jHssbqUnJRLbzN1dSU
VnjOaiAGhhDJvdeJ0xEgkjdfecfHVxmpyrFVi1cdfMQX9//c7iXFqjH0TC+U8FBz
7Z3FqJfifdNAJ4OG7g6c
=hU8U
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
