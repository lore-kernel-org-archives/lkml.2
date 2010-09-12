Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0ILUn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:43:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52367 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753501Ab0ILUn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:43:26 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX18+glccO3s+gkdkKGbJ17XOKVZWyudQ51B8uJ/t1w
	U03e+I83yWt0VU
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH] staging: batman-adv: check kmalloc() return value
Date: Sun, 12 Sep 2010 22:43:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Andreas Langer <an.langer@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1284317791-4744-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1284317791-4744-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1580855.oHMeUH8upn";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201009122244.00861.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1580855.oHMeUH8upn
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Vasiliy Kulikov wrote:
> kmalloc() may fail, if so drop current packet.

Thanks for your patch. The indention is right, but it adds just another bug=
=20
(locking related).

> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
>=20
>  drivers/staging/batman-adv/routing.c |    6 ++++--
>  drivers/staging/batman-adv/unicast.c |    8 ++++++--
>  drivers/staging/batman-adv/unicast.h |    2 +-
>  3 files changed, 11 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/staging/batman-adv/routing.c
> b/drivers/staging/batman-adv/routing.c index e12fd99..e545260 100644
> --- a/drivers/staging/batman-adv/routing.c
> +++ b/drivers/staging/batman-adv/routing.c
> @@ -1232,8 +1232,10 @@ int recv_ucast_frag_packet(struct sk_buff *skb,
> struct batman_if *recv_if)
>=20
>  		orig_node->last_frag_packet =3D jiffies;
>=20
> -		if (list_empty(&orig_node->frag_list))
> -			create_frag_buffer(&orig_node->frag_list);
> +		if (list_empty(&orig_node->frag_list)) {
> +			if (create_frag_buffer(&orig_node->frag_list))
> +				return NET_RX_DROP;
> +		}
>=20
>  		tmp_frag_entry =3D
>  			search_frag_packet(&orig_node->frag_list,

You must spin_unlock_irqrestore before you return from that function.

Best regards,
	Sven

--nextPart1580855.oHMeUH8upn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJMjTuPAAoJEF2HCgfBJntGO/sP/3Z4RUEiVlcraL7QtwzyTEUr
ixxT4ZvoX9qkVvyJQA7xpU5eKHNI98GjbrJ/cbkmxIU0OT9kGwRTlZDVadgKpA9c
jfdyz908wAZrfevLnjybMtnfHnYL0IWUWLETgSS1GiPq5zsZkb0lp0FSPktYE2nt
/vMZURL0oRTkpIOqTdPjqwBKWy1nzEbpVdbzPpSBI+sTxKu2DiO6KTpqzEVw8b1+
grjGjoCIcft1B5XQ6FRdwKvddxvDGuoKMox/JqkDTqvpL9Iza6daCXf1nTUTNwoD
vCbRkI49VKPjeYpAu+6qxtqBu5Hlv1kmeWgcc6Ml1RPd0F9DgeG9cFzp0DgYNP9W
O8KpoiXzjxT2WO5TVtJUThU5bgC6D36/z6z6omujkoUUgDiCxDlUvOgTs5VRhs5D
NQsTW0vxP3S52+oFYZJNcpj7csmpHWIqDTQ6BQZTDls9m5jS47IYoZzyeepRsUDb
pk7em5A20C9GDKhO8dOlNShU2ws2t7ylsU2OqO93mJwcY8TH3Tzf3D1otxCElp+J
An33yvFaGdHmt/zS7q7hMYXVApT6N/8KWXZLYqxCC1NOz19yrfKTSp5EP13MuRPm
o/lrEL9VZ1QKXBZyHQ8dJjw/BusVHB1lJ/pj4vtXIerVBDPnqvMq07ZaWtuXz2Zh
Nx0Q/+uWqk6hSGTrufRO
=4L/4
-----END PGP SIGNATURE-----

--nextPart1580855.oHMeUH8upn--
