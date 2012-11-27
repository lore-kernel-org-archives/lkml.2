Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2K0P7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:59:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43772 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888Ab2K0P7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:59:03 -0500
Message-ID: <1354031931.4266.57.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 187/270] net/wireless: ipw2200: Fix panic occurring in
 ipw_handle_promiscuous_tx()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Tue, 27 Nov 2012 15:58:51 +0000
In-Reply-To: <1353949160-26803-188-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-188-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kSGzEv3T2TnNKGHOm37v"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kSGzEv3T2TnNKGHOm37v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:57 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
>=20
> commit bf11315eeda510ea4fc1a2bf972d8155d31d89b4 upstream.
>=20
> The driver does not count space of radiotap fields when allocating skb fo=
r
> radiotap packet. This leads to kernel panic with the following call trace=
:
>=20
> ...
> [67607.676067] [<c152f90f>] error_code+0x67/0x6c
> [67607.676067] [<c142f831>] ? skb_put+0x91/0xa0
> [67607.676067] [<f8cf5e5b>] ? ipw_handle_promiscuous_tx+0x16b/0x2d0 [ipw2=
200]
> [67607.676067] [<f8cf5e5b>] ipw_handle_promiscuous_tx+0x16b/0x2d0 [ipw220=
0]
> [67607.676067] [<f8cf899b>] ipw_net_hard_start_xmit+0x8b/0x90 [ipw2200]
> [67607.676067] [<f8741c5a>] libipw_xmit+0x55a/0x980 [libipw]
> [67607.676067] [<c143d3e8>] dev_hard_start_xmit+0x218/0x4d0
> ...
>=20
> This bug was found by VittGam.
> https://bugzilla.kernel.org/show_bug.cgi?id=3D43255
>=20
> Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>

This is missing from 3.4; it may just need de-fuzzing to apply.

Ben.

> ---
>  drivers/net/wireless/ipw2x00/ipw2200.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireles=
s/ipw2x00/ipw2200.c
> index 0036737..1f2edf2 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -10470,7 +10470,7 @@ static void ipw_handle_promiscuous_tx(struct ipw_=
priv *priv,
>  		} else
>  			len =3D src->len;
> =20
> -		dst =3D alloc_skb(len + sizeof(*rt_hdr), GFP_ATOMIC);
> +		dst =3D alloc_skb(len + sizeof(*rt_hdr) + sizeof(u16)*2, GFP_ATOMIC);
>  		if (!dst)
>  			continue;
> =20

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-kSGzEv3T2TnNKGHOm37v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULTjO+e/yOyVhhEJAQo1JxAAl6g3ADjmfrmKS4t5KXDhCO8RnjMxQild
CudENI+/Aaf3vUbEvbRvir4dakFsTZFhCWMBqXNLRXlD68nA3RkpYDCBn4UfaTLz
NQV9kEmD4/yVv2WS1n5YW/NokN2D8c8Je8LNDdbpcIPECqKEEC6y73yG8NdtXQK5
N6x+sooxPQHOUmwheIY/Qd4SSi4q1WTGEoNs+lYw7AMZqX4H9EioVPaN3VMHf+qN
wDvkJkUoR3xbAI08YBKlBDugTQUfZoED1MQedWzGjiDPLQZ1o72FMpV8xLvf7/q1
NTtM13H6czD2nimLOox6IO20FpWZsLVzwEMGsCaTcZ8xVgJkRnONEwCFwisTOm8S
o2B4KdQCetiOIlZxRZfl6pve0LxczpU0cSSIAsaiMk3OmWDrH4nhybRsocOOIill
I/iPMdgiYi1n7DsW4rq7klobKPKF07msf44NnV2qD3NqUh1CHHUcBMexUjGvEcfc
pWvLsFJ3tKSA5vzgULMcGAY/RFECJ0s7fTj1KBM/NsfOVxvJO0YtB93/iwTdPaDU
WZ/fShd5lBtDL0hzzlXFEV3VIn9wIaKEnNvN0M2sj3hAEFyo9HAPvpUPffhmZEXG
NFj5atR6in+WiBeVbfuITraHGHi0JHGGIC6TKB64RFeqLlngjFnr1s81kja8U8V3
a2WFgSZiyKU=
=GZtx
-----END PGP SIGNATURE-----

--=-kSGzEv3T2TnNKGHOm37v--
