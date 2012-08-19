Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab2HSRNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:13:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43923 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095Ab2HSRNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:13:47 -0400
Message-ID: <1345396405.22400.22.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 31/37] tun: dont zeroize sock->file on detach
From: Ben Hutchings <ben@decadent.org.uk>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ruan Zhijie <ruanzhijie@hotmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 19 Aug 2012 18:13:25 +0100
In-Reply-To: <20120817030248.728449300@decadent.org.uk>
References: <20120817030243.807605523@decadent.org.uk>
	 <20120817030248.728449300@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jjYPrHjMkIZacnl1ZYDt"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jjYPrHjMkIZacnl1ZYDt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 04:03 +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Stanislav Kinsbursky <skinsbursky@parallels.com>
>=20
> commit 66d1b9263a371abd15806c53f486f0645ef31a8f upstream.
>=20
> This is a fix for bug, introduced in 3.4 kernel by commit
> 1ab5ecb90cb6a3df1476e052f76a6e8f6511cb3d ("tun: don't hold network
> namespace by tun sockets"), which, among other things, replaced simple
> sock_put() by sk_release_kernel(). Below is sequence, which leads to
> oops for non-persistent devices:

I didn't read this message properly when importing cc'd commits.  I'm
going to drop this patch, as it appears that it will result in an inode
leak or other badness if applied to 3.2.y.  Let David Miller know if any
tun fixes should go into 3.2.y.

Ben.

> tun_chr_close()
> tun_detach()				<=3D=3D tun->socket.file =3D NULL
> tun_free_netdev()
> sk_release_sock()
> sock_release(sock->file =3D=3D NULL)
> iput(SOCK_INODE(sock))			<=3D=3D dereference on NULL pointer
>=20
> This patch just removes zeroing of socket's file from __tun_detach().
> sock_release() will do this.
>=20
> Reported-by: Ruan Zhijie <ruanzhijie@hotmail.com>
> Tested-by: Ruan Zhijie <ruanzhijie@hotmail.com>
> Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/tun.c |    1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 926d4db..3a16d4f 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -187,7 +187,6 @@ static void __tun_detach(struct tun_struct *tun)
>  	netif_tx_lock_bh(tun->dev);
>  	netif_carrier_off(tun->dev);
>  	tun->tfile =3D NULL;
> -	tun->socket.file =3D NULL;
>  	netif_tx_unlock_bh(tun->dev);
> =20
>  	/* Drop read queue */
>=20

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-jjYPrHjMkIZacnl1ZYDt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDEetee/yOyVhhEJAQpZIQ/9EvXLlgMv1k5lFXs0d4rfjG/54HsGKP9g
aiD9oWKD0esD74LrjQkT7r1DxHYHOqZPN5fd4uoiWf+EuVCXQioS5vLrPMaTyQ95
dnig69exG1HphzXAnt5lwP8+F55FPLe6TkkdrvzuK4hFuOnyiT1HJCFnDjI2LCs3
O59fjPKhEPhX7jaB6zA0S7sfuPGJV2kxju+rbL5Z0D3D4ebPw7lrQqhfz5oL7P7b
HCLqV5KCDzTjEgBmmJIs8kRtIcoaNj0WSw+IOit5FJ2vYAhy3aM4Wecv1G1MubUD
vWBNqmnfTRhTy3LJO0BWDwEFjGaRggw+i9UdJN2SapwSEYXG9HiOi12RAf7nPiRD
p4zMyS6rb1aR0RVOf1Z+KLEsi/IRzm/ruUX18rT8z1evO6aTiTJttZrqSChOgVOd
PIM/vU67VfP2KkjsGNvblW0BbYkDmwjf5bwQ8hnnQHXfCQwp2/CDbDrbdcQRs/3U
26hKMnojdI6sYrv+liLloh9KuRsbE6I7ZXvGFbdIkOBks+DDuSKYZu5F/N/lIrJD
9N6nEgsodfGqeKMAqpKpdDB1CEgRD5RpcDcopPqSU6haIO9IsADhyJJTrnwfHuiT
6dBMJxlaT9BN95knZclCJs3daW4UzL3wgghSJU9/BWqGnC5lHg9ExTFZHxLG91Uv
C1NLWZ0+uxA=
=UWvX
-----END PGP SIGNATURE-----

--=-jjYPrHjMkIZacnl1ZYDt--
