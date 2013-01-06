Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3AFT2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 14:28:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab3AFT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 14:27:56 -0500
Date: Sun, 6 Jan 2013 20:27:39 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130106192739.GA11566@avionic-0098.adnet.avionic-design.de>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
 <1357371910-3164-3-git-send-email-ldewangan@nvidia.com>
 <20130105080658.GA1315@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20130105080658.GA1315@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:+DdN6t+F1ofw42kIAN27VOU8eFGI+8pOqxZyxX0FHRY
 8XUXDrVr/adZX6JWz768s0pEo5c3XhK9kyzx7bOwsDmrNG6Yax
 Z8bTM5/H/pmlNS6mQXkrxgmfB3QOIlvSJjLdzUqEwoZo4D1/1Z
 NaiSAWClVt6YFecjZiJYRR7ZULDBZ4HHzUlsikg+I4F9SEc3yv
 Tk9Rjn3WLA2gzSDeWOfdsEjfYTRMoBejmDjhGL7/ylKbXmkwfK
 T6d9iGisp0PcI8bkdfQ8JifmO+soXxQ1jJKnXxoU0m4Flc3Mg9
 Yqw7yH45nnDlOJ0ld7Onmw5v6kkSHWeldXPneJKnF8Tnd87tiF
 pAKk4SxMqwURIDbYdzWDg22/GWymR8N1eb+10VrQEoBXLOSEt1
 wPiycxW6l2e9Vsb5gwSiWuxXZjzH6tUHYkg1zwpbjw0yvYOZgw
 suwUB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 05, 2013 at 12:06:58AM -0800, Dmitry Torokhov wrote:
> On Sat, Jan 05, 2013 at 01:15:08PM +0530, Laxman Dewangan wrote:
[...]
> > @@ -735,25 +738,16 @@ static int tegra_kbc_probe(struct platform_device=
 *pdev)
> >  	spin_lock_init(&kbc->lock);
> >  	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc=
);
> > =20
> > -	res =3D request_mem_region(res->start, resource_size(res), pdev->name=
);
> > -	if (!res) {
> > -		dev_err(&pdev->dev, "failed to request I/O memory\n");
> > -		err =3D -EBUSY;
> > -		goto err_free_mem;
> > -	}
> > -
> > -	kbc->mmio =3D ioremap(res->start, resource_size(res));
> > +	kbc->mmio =3D devm_request_and_ioremap(&pdev->dev, res);
> >  	if (!kbc->mmio) {
> > -		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> > -		err =3D -ENXIO;
> > -		goto err_free_mem_region;
> > +		dev_err(&pdev->dev, "Cannot request memregion/iomap address\n");
> > +		return -EADDRNOTAVAIL;
>=20
> Erm, no, -EBUSY please.

EADDRNOTAVAIL is the canonical error for devm_request_and_ioremap()
failure. The kerneldoc comment in lib/devres.c even gives a short
example that uses this error code.

Thierry

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ6dArAAoJEN0jrNd/PrOhVc8P/RBfk2kdD1xrPNZQe60rRWi3
NaFakKFbFyZQrapu3n1bryZol6TiZ70hkKzl/sGvuRXGpP8PbzRW0OyOlBCKNtOk
BJVN56q7/fDEujKEs6sWKa17O9/Qw+rg58/yRgiTaAvjRIua0nT6lzDFaFkWv+k8
fX5Z6p6HqOPoCs+UjjHjeU4seWJIyv4fd6XsElckcTe64lalxAHqCUyFKERW1nto
QSEytY/H++u1gonCch0uf7xKZ/jVDobsOEogTbVdBopSqWIbTBKcTS48AIIiUIu3
0KHFrsOTWgxDVOWZgQXGcUoDZUazulRRHmTy6yV/9SSD7reZyy0KtqRK7inyaoU6
THckG8hItxhPEO2/JtOCky1toPo9RvVcKy1b/qjTDY8SRY/RlXRKjODWB0DmODfZ
WjVeZlRN6CTDPqMw65LKT86vr4X8rKw5gfWR4yxMVu7cpU0FDpCYCf8CmRzz8Oai
GkXyVAs1gLn19F7au/tc923IeBtOzoSMar5MvsZ0QuKAx2ITS1cNXlvYqgGRXLVe
EwbRHVBtR6ubbFGNQ4bIqDCwfh+JjTYmYx+RCiNmQAwewKfrsX8nNul897uTutge
SMyeWnzzBdko0B0Acnvwy2IzlhKyI0KIpmUkRmrfQQh0ZVBjvZieP9ksL0Fgo2fC
etKQZioi7maSHYwWuj7J
=qLcb
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
