Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab2KMSM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:12:29 -0500
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:44223 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175Ab2KMSM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:12:26 -0500
Message-ID: <50A28D99.2000309@gentoo.org>
Date: Tue, 13 Nov 2012 12:12:41 -0600
From: Matthew Thode <prometheanfire@gentoo.org>
Reply-To: prometheanfire@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121030 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: iommu@lists.linux-foundation.org, joro@8bytes.org, cardoe@gentoo.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        mthode@mthode.org, ddutile@redhat.com, bhelgaas@google.com,
        dwmw2@infradead.org
Subject: Re: [PATCH] intel-iommu: Fix lookup in add device
References: <20121113172144.6783.37724.stgit@bling.home>
In-Reply-To: <20121113172144.6783.37724.stgit@bling.home>
X-Enigmail-Version: 1.5a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig30DD44203562B017129ADCC1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig30DD44203562B017129ADCC1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/13/2012 11:22 AM, Alex Williamson wrote:
> We can't assume this device exists, fall back to the bridge itself.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Tested-by: Matthew Thode <prometheanfire@gentoo.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/iommu/intel-iommu.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index d4a4cd4..0badfa4 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -4108,7 +4108,7 @@ static void swap_pci_ref(struct pci_dev **from, s=
truct pci_dev *to)
>  static int intel_iommu_add_device(struct device *dev)
>  {
>  	struct pci_dev *pdev =3D to_pci_dev(dev);
> -	struct pci_dev *bridge, *dma_pdev;
> +	struct pci_dev *bridge, *dma_pdev =3D NULL;
>  	struct iommu_group *group;
>  	int ret;
> =20
> @@ -4122,7 +4122,7 @@ static int intel_iommu_add_device(struct device *=
dev)
>  			dma_pdev =3D pci_get_domain_bus_and_slot(
>  						pci_domain_nr(pdev->bus),
>  						bridge->subordinate->number, 0);
> -		else
> +		if (!dma_pdev)
>  			dma_pdev =3D pci_dev_get(bridge);
>  	} else
>  		dma_pdev =3D pci_dev_get(pdev);
>=20

I've tested this and it works just fine.

--=20
-- Matthew Thode (prometheanfire)


--------------enig30DD44203562B017129ADCC1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoo2iAAoJECRx6z5ArFrDM/oQANDRznWn1BAsuUMEVRgcgOGM
Ezru9+I9baZeKxPOTFp+nmL3IWS/BS3nCFl3ALIZI/NMJUzOyYg9GtaHTOgHp4el
58ZyzTqlS9yF2iadhErVIP7KsREQ42KFosYCr+Y4r00F37MgJztV9ag/c12Xp9gc
AxeB7E7G9pqITMUKcKkx20qwm/Ygx/qIDD6uN7ZlW9dXOe11ziXQCnMQPs9u6i93
OyiAp6KWmOn+noPei59aqXBk1jqz6F9T6CgAW4A7VVSfqvivLAV/IvwhDZQoGLEK
j/fetcQDWDulhzV5YWpWi8G8A9DTlBZRiYAgoduUvwmDWSaXd465+142aWVVZaK0
tFpzA7gkUHDxph+DmEAuAlQZeqNelRn/FtHtqeDckSlb9s9HlUzdxtIJWqh1QW4S
dJN+vz3L56Mq6vA+JJHF4juoOI2Gh2oBqdgzaY2xG7/azbUlfkjodB3NWdaR4vAB
0GE+5+HwPKwapZKdBz9Yee1L4x4F4WBGoP7c+DK8npRa4SqTUqi2vjnYIyV3QnJv
YJkLU1QeJNY1FjkYh1j/DRNYPLbQ+/PXfDBV+ln9QY6AmCaqfUKjELf1WJ/6hSeQ
GrUsMYiXFrOhnU/kqYtagZYDbaf8RFBLmHHuE2PMz++fuyWG5VTQvTLZ+h/Wtnxs
vTKlb1OnyULwQZqCBtq2
=G/Ba
-----END PGP SIGNATURE-----

--------------enig30DD44203562B017129ADCC1--
