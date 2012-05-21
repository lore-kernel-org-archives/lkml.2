Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab2EUOMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:12:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab2EUOL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:11:59 -0400
Date: Mon, 21 May 2012 16:11:52 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu/tegra: gart: Reserve iomem resource
Message-ID: <20120521141152.GA21513@avionic-0098.mockup.avionic-design.de>
References: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>
 <1337019127-6863-2-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <1337019127-6863-2-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:hXmCDsXeWi0Akf/uJRIyWtxO6GtplFcxncFEzFaYFsf
 d5k9wzYzskJxUcyzU79MiDjiZp+cGJcSBhiV/vmvfn5gGiS3yA
 I76yWCPu56hYMv5S7qi13kLnhzh7vgttWNkyTkBvhbwaB8NZJk
 GLAnYQMDTk4WXuQwij/Q2EVB1wawBm8NdSzIaQ7x880x1qwoaD
 hSzmJBLnHxoF/SBPrh6IV4pWmW634z4lRKIHqmxuY9M1ex3o33
 Idn9rKpok//8IuBm1M9BrQFM1jt2XehPE1pV0YKsf9Hk8x+joi
 pAc8fgrJX6Psfhtkba7p6zFgb9SjOQyG7b4F27TQThjaQXM8Hl
 8LHzszJn8UvzLtN27Wd4YV+tWV1jn7mE1JyK6hrweZ0UffpqX6
 vnCveqz122WiaCog5/Srb0pD3Sl8Dxo7PI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Hiroshi DOYU wrote:
> GART Register/Aperture range should be reserved.
>=20
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> ---
>  drivers/iommu/tegra-gart.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
> index 33a23b6..a431006 100644
> --- a/drivers/iommu/tegra-gart.c
> +++ b/drivers/iommu/tegra-gart.c
> @@ -366,12 +366,18 @@ static int tegra_gart_probe(struct platform_device =
*pdev)
>  		return -ENOMEM;
>  	}
> =20
> -	gart_regs =3D devm_ioremap(dev, res->start, resource_size(res));
> +	gart_regs =3D devm_request_and_ioremap(dev, res);
>  	if (!gart_regs) {
>  		dev_err(dev, "failed to remap GART registers\n");
>  		return -ENXIO;
>  	}
> =20
> +	if (!devm_request_mem_region(dev, res_remap->start,
> +				     resource_size(res_remap), dev_name(dev))) {
> +		dev_err(dev, "failed to reserve GART aperture\n");
> +		return -EBUSY;
> +	}
> +

I'm not so sure that this is a good idea. If the GART driver requests the
GART aperture, then users of the GART aperture (e.g. the DRM driver) will no
longer be able to use it.

Thierry

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk+6TSgACgkQZ+BJyKLjJp/lMwCeLOvSINVDwHcBuMG9kV5ks+1h
A0kAn28Ku9VgsUB2BqsvXHNzujaooXj+
=+IKF
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
