Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1A0Sdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:33:41 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47147 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1A0Sdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:33:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mf+sEIj2LM3LJv9LAxcVFJXPXX+Nl9TGihnUlxrzjdgZfbTDcIhFxGxhRYTGhHgzv/
         5lmpYNA2+ZCG4PU4/RlqjpK2RgFzJOoyCYWXBu5egzQwL3YSvgdqyAA2d6v+N858OB94
         alzXyrypo41Z1smPOhLmn9isbUzUEtnt79P9s=
Date: Thu, 27 Jan 2011 20:33:28 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: skb_split in tcp_retransmit_skb question
Message-ID: <20110127183327.GB4153@swordfish.minsk.epam.com>
References: <20110127152057.GA4153@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <20110127152057.GA4153@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (01/27/11 17:20), Sergey Senozhatsky wrote:
> Hello,
>=20
> Suppose we have the following scenario:
>=20
> tcp_write_timer ->
>  tcp_retransmit_skb
>=20
> in tcp_retransmit_skb we have `if (skb->len > cur_mss)' evaluted to true,=
 which leads
> to tcp_fragment(sk, skb, cur_mss, cur_mss) call. tcp_fragment calls skb_s=
plit(skb, buff, len)
> which, in turn, calls skb_split_no_header(skb, skb1, len, pos), where we =
have
> `skb_shinfo(skb)->nr_frags++' while in `for (i =3D 0; i < nfrags; i++)' l=
oop.

Sorry for the noise. Alexey has pointed out that we have=20
skb_shinfo(skb)->nr_frags =3D 0 in skb_split_no_header. Have no idea how di=
d I miss it.=20

Thanks,

	Sergey

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk1BuncACgkQfKHnntdSXjRytwP/Wdjy9/P8mmMfzIknxb7s3jrO
bFmBB4QcETA/j0ZndGhjU/PGngFMnloh+Oh1kPZ9FQplewyqoDiBj+Bk19uVB9bm
273Rs5pjH99plbxFeWGPqRAGvvBrOvl6RvXHXPezlU8lynZgls/XgG+yPW1gkMKo
tLhNmaWUky+Ts0sxVd0=
=v8rH
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
