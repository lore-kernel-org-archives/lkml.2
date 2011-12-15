Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab1LOGsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:48:46 -0500
Received: from ozlabs.org ([203.10.76.45]:46260 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab1LOGsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:48:45 -0500
Message-ID: <1323931718.13200.1.camel@concordia>
Subject: Re: [Qemu-devel] [PATCH 2/2] device_isolation: Support isolation on
 POWER p7ioc (IODA) bridges
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Gibson <david@gibson.dropbear.id.au>
Cc: alex.williamson@redhat.com, chrisw@redhat.com, aik@ozlabs.ru,
        agraf@suse.de, qemu-devel@nongnu.org, B08248@freescale.com,
        iommu@lists.linux-foundation.org, joerg.roedel@amd.com,
        scottwood@freescale.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Dec 2011 17:48:38 +1100
In-Reply-To: <1323929329-23927-2-git-send-email-david@gibson.dropbear.id.au>
References: <1323929329-23927-2-git-send-email-david@gibson.dropbear.id.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QYH+fw4/Q1tGGLCFKC3B"
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QYH+fw4/Q1tGGLCFKC3B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-12-15 at 17:08 +1100, David Gibson wrote:
> This patch adds code to the code for the powernv platform to create
> and populate isolation groups on hardware using the p7ioc (aka IODA) PCI =
host
> bridge used on some IBM POWER systems.

> diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/pla=
tforms/powernv/pci-ioda.c
> index 0cdc8302..6df632e 100644
> --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> @@ -861,6 +862,9 @@ static void __devinit pnv_ioda_setup_bus_dma(struct p=
nv_ioda_pe *pe,
>  		set_iommu_table_base(&dev->dev, &pe->tce32_table);
>  		if (dev->subordinate)
>  			pnv_ioda_setup_bus_dma(pe, dev->subordinate);
> +#ifdef CONFIG_DEVICE_ISOLATION
> +		device_isolation_dev_add(&pe->di_group, &dev->dev);
> +#endif

You already have a nop version of that in device_isolation.h, so the
ifdef is not required AFAICS.

And similarly elsewhere.

cheers



--=-QYH+fw4/Q1tGGLCFKC3B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7pmEYACgkQdSjSd0sB4dKXIQCgyG1SuZio/KZT2DB049N39tlQ
rlkAnRjZJKyfiHOlRtqsDig46UDiQ0l3
=ap4Z
-----END PGP SIGNATURE-----

--=-QYH+fw4/Q1tGGLCFKC3B--

