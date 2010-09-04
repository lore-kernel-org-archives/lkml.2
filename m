Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0IDPsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 11:48:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39782 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab0IDPsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 11:48:15 -0400
Date: Sat, 4 Sep 2010 17:48:10 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: Pantelis Antoniou <pantelis.antoniou@gmail.com>, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vitaly Bordug <vbordug@ru.mvista.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/2] drivers/net/fs_enet/fs_enet-main.c: Add
	of_node_put to avoid memory leak
Message-ID: <20100904154810.GB1762@pengutronix.de>
References: <1283595164-29146-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <1283595164-29146-1-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 04, 2010 at 12:12:43PM +0200, Julia Lawall wrote:
> In this case, a device_node structure is stored in another structure that
> is then freed without first decrementing the reference count of the
> device_node structure.
>=20
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @r exists@
> expression x;
> identifier f;
> position p1,p2;
> @@
>=20
> x@p1->f =3D \(of_find_node_by_path\|of_find_node_by_name\|of_find_node_by=
_phandle\|of_get_parent\|of_get_next_parent\|of_get_next_child\|of_find_com=
patible_node\|of_match_node\|of_find_node_by_type\|of_find_node_with_proper=
ty\|of_find_matching_node\|of_parse_phandle\|of_node_get\)(...);
> ... when !=3D of_node_put(x)
> kfree@p2(x)
>=20
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> cocci.print_main("call",p1)
> cocci.print_secs("free",p2)
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

>=20
> ---
>  drivers/net/fs_enet/fs_enet-main.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_=
enet-main.c
> index d6e3111..d684f18 100644
> --- a/drivers/net/fs_enet/fs_enet-main.c
> +++ b/drivers/net/fs_enet/fs_enet-main.c
> @@ -1036,7 +1036,7 @@ static int __devinit fs_enet_probe(struct platform_=
device *ofdev,
>  	ndev =3D alloc_etherdev(privsize);
>  	if (!ndev) {
>  		ret =3D -ENOMEM;
> -		goto out_free_fpi;
> +		goto out_put;
>  	}
> =20
>  	SET_NETDEV_DEV(ndev, &ofdev->dev);
> @@ -1099,6 +1099,7 @@ out_cleanup_data:
>  out_free_dev:
>  	free_netdev(ndev);
>  	dev_set_drvdata(&ofdev->dev, NULL);
> +out_put:
>  	of_node_put(fpi->phy_node);
>  out_free_fpi:
>  	kfree(fpi);
>=20
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkyCajoACgkQD27XaX1/VRu5vgCfREXOviRDjNDTDtIw9Ntvqa1q
wBAAn1X1kzVQIZhnTZDgbsSGMlwigmI6
=uVgu
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
