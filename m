Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0HIUyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:54:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52802 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753802Ab0HIUym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:54:42 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX1+fvM9AL5qfvINM6X3dThOqE4UVWvQxvN9/4eF4J6
	rUWZC7uoxhmyxm
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: batman-adv: design suggestions
Date: Mon, 9 Aug 2010 22:53:58 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-1-amd64; KDE/4.4.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Linus =?iso-8859-1?q?L=FCssing?= <linus.luessing@web.de>
References: <20100809203403.GA16183@albatros>
In-Reply-To: <20100809203403.GA16183@albatros>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1596662.VY2eJPhFS6";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201008092254.39960.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1596662.VY2eJPhFS6
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Vasiliy Kulikov wrote:
> Hi folks,
>=20
> I was reading batman-adv sources and noted:

Thanks a lot.


> 1) Some incoming packets may cause a storm of error logs, such as at
> routing.c:862
>=20
>=20
> 	if (icmp_packet->msg_type !=3D ECHO_REQUEST) {
> 		pr_warning("Warning - can't forward icmp packet from %pM to "
> 			   "%pM: ttl exceeded\n", icmp_packet->orig,
> 			   icmp_packet->dst);
>=20
>   Any flooding bad guy is able to fill our disks with logs.
>   This should be logged only at some slow rate (e.g. 5 logs/sec) or as
>   pr_debug().

Correct. So you would prefer pr_warn_ratelimited?


> 2) It seems to me that NF_HOOK() at hard-interface.c:458 is misused:
>=20
>     ...
> 	ret =3D NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_IN, skb, dev, NULL,
> 		      batman_skb_recv_finish);
> 	if (ret !=3D 1)
> 		goto err_out;
>=20
> 	/* packet should hold at least type and version */
> 	if (unlikely(skb_headlen(skb) < 2))
> 		goto err_free;
>=20
> 	/* expect a valid ethernet header here. */
> 	if (unlikely(skb->mac_len !=3D sizeof(struct ethhdr)
>=20
> 				|| !skb_mac_header(skb)))
>=20
> 		goto err_free;
>     ...
>=20
>     static int batman_skb_recv_finish(struct sk_buff *skb)
>     {
>         return NF_ACCEPT;
>     }
>=20
>   As I understand, if there is any hook that returns NF_STOLEN, then skb
>   is leaked.

@Linus Luessing: Could you please check that.

thanks,
	Sven

--nextPart1596662.VY2eJPhFS6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJMYGsOAAoJEF2HCgfBJntGKykP/06+2drCxIFuLtC3BNqY1RZV
b74gAjPOlTjx4D8g+MokmSjdXKlEM3oeFxSRxcSfRX5v+aRHUk0zkLXlOo3LL1gC
4IP1VfQsclvkeKddTmvieJbR/+3GDzkKDjL1UQuthy5VH5VoRqbpIXibnbJUNftP
3Fxwoyt6CBaZRBOMk5/nfL399MFqfpjQYQG5uKAYq2Df+x1tZj6c3+3PlyShZpfd
RY09h2EFKLGnhboJbdPflTIPeTicmg2yqGnqrdEWhOCfT+8PtQdwCN8HSnBKe7Ws
tgQYfEzOn98XHXLsa8jDvHZunUbUNOV03K8b9VKq1LAelriI6xm73kwlPVEvccDH
GILMlIAPqKqb3kzmEmpf76RwoUL1C+zHqYoUfqLZcgpacL93P8+9zrLjuev/InVm
fIyrpGzS5qynwB44+MPvxKT8TJjz439T5vJnc0Upf404g1a5Wx/5t99hQNnzNe5O
5TnCrD/nY7mNYl+UYAK5Z60JOO6RHN/iP5udv7Vj82a36zscAe/y9I3H3aVaHkqJ
oecjpbAR1Ez8WJjRJwooAmWQo/8wrvxqlN7MloL56DH/n3iQq7smMivKTaF1EEEU
NItWe5EjjDUk24ERgsWIGUw97De5GUBsEChaJWZGddvB85GqxQ6DQ8aYsPZPIy3i
PIC+cI8BN2IpCZrhKcvX
=oT0N
-----END PGP SIGNATURE-----

--nextPart1596662.VY2eJPhFS6--
