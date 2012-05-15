Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2EOGeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:34:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab2EOGeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:34:06 -0400
Date: Tue, 15 May 2012 16:33:53 +1000
From: NeilBrown <neilb@suse.de>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: check the return of mddev_find()
Message-ID: <20120515163353.5ab9c084@notabene.brown>
In-Reply-To: <1337063200-11174-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1337063200-11174-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tXQnAUdX5K=2djbFlaL=OS7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tXQnAUdX5K=2djbFlaL=OS7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 May 2012 14:26:40 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> Check the return of mddev_find(), since it may fail due to out of
> memeory or out of usable minor number.
>=20
> The reason I chose -ENODEV instead of -ENOMEM or something else is
> md_alloc() function chose that ;)
>=20
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  drivers/md/md.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 477eb2e..0bd44e3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6371,6 +6371,9 @@ static int md_open(struct block_device *bdev, fmode=
_t mode)
>  	struct mddev *mddev =3D mddev_find(bdev->bd_dev);
>  	int err;
> =20
> +	if (!mddev)
> +		return -ENODEV;
> +
>  	if (mddev->gendisk !=3D bdev->bd_disk) {
>  		/* we are racing with mddev_put which is discarding this
>  		 * bd_disk.

Hi,
 thanks for the patch.

 I'm fairly sure that we won't actually get to md_open unless md_probe has
 succeeded and called add_disk, in which case there *must* be a matching
 mddev.

 However it doesn't hurt and looks safer so I have applied it.

Thanks,
NeilBrown

--Sig_/tXQnAUdX5K=2djbFlaL=OS7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7H40Tnsnt1WYoG5AQLiRBAAoyyAVK0C1d88AvPK2krm8AnJAfWMdAf5
cUJwKo6pd0bLemOWTrx3NPsrEqzWKkfzKrcWJtVNKfUGcmcMjsacD3Dy0JXr3fwH
FWs+XaMoi3GUCdQDI/MAS44VmdDY8VCPNMCKBq/clggGnDqtC+9h+rO7gbfs5Z6A
YIqnw2ai0VJ70hwP10escu685ig/GWuI06At6Ak4BigHf/uqiD/2CSi7NtYDYDay
908EIR4W6X6utWY01YJkSrYZK5PJ8O62wR6Ll3QAhThwKCMSO9uGXd5DsW36x0vd
vAaMZb1rW0gUsproPyfRWpaaR0jfqOK8BUFJO0dLw9EjsBo7gROt5JAKK/HxQcBS
OLKBbeFhlpl0lnPhUyhdw5abwGE6gNvYo60iDn3Glyi7LcgWP9TAYjRs4ypIhzci
xkmoDdNyZLFv/57KFEsKmSng1/lXT6VTIGmU33/Bus4r7RmQxf1kNwTscCauolX9
HyWd+tF/GLoleI7nto7Kgf7CwvS3OiwIXz4rN/H7RE5g2WYIZNN4uz+0RV4vaZH7
nNkAIep4x8NVT+ADzvDrKgvCtsVLC+V6mwA8cxj9Yg2uKpumKWvD/+Ibg8iDP70p
7ELkCgp8QvpvQ777cZIj51HbOxtKV/Rm2OpNtMILNIerv3h/dnzCf22Xw6OZSRfk
5UK/mSxFQvA=
=6wkl
-----END PGP SIGNATURE-----

--Sig_/tXQnAUdX5K=2djbFlaL=OS7--
