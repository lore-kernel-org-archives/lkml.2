Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750Ab1LPAjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:39:11 -0500
Received: from ozlabs.org ([203.10.76.45]:36063 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab1LPAjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:39:09 -0500
Date: Fri, 16 Dec 2011 02:27:21 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: chrisw@redhat.com, aik@ozlabs.ru, joerg.roedel@amd.com, agraf@suse.de,
        iommu@lists.linux-foundation.org, qemu-devel@nongnu.org,
        B08248@freescale.com, alex.williamson@redhat.com,
        scottwood@freescale.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qemu-devel] [PATCH 2/2] device_isolation: Support isolation on
 POWER p7ioc (IODA) bridges
Message-ID: <20111215152721.GA4553@truffala.fritz.box>
Mail-Followup-To: Michael Ellerman <michael@ellerman.id.au>,
	chrisw@redhat.com, aik@ozlabs.ru, joerg.roedel@amd.com,
	agraf@suse.de, iommu@lists.linux-foundation.org,
	qemu-devel@nongnu.org, B08248@freescale.com,
	alex.williamson@redhat.com, scottwood@freescale.com,
	dwmw2@infradead.org, linux-kernel@vger.kernel.org
References: <1323929329-23927-2-git-send-email-david@gibson.dropbear.id.au>
 <1323931718.13200.1.camel@concordia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <1323931718.13200.1.camel@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 15, 2011 at 05:48:38PM +1100, Michael Ellerman wrote:
> On Thu, 2011-12-15 at 17:08 +1100, David Gibson wrote:
> > This patch adds code to the code for the powernv platform to create
> > and populate isolation groups on hardware using the p7ioc (aka IODA) PC=
I host
> > bridge used on some IBM POWER systems.
>=20
> > diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/p=
latforms/powernv/pci-ioda.c
> > index 0cdc8302..6df632e 100644
> > --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> > +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> > @@ -861,6 +862,9 @@ static void __devinit pnv_ioda_setup_bus_dma(struct=
 pnv_ioda_pe *pe,
> >  		set_iommu_table_base(&dev->dev, &pe->tce32_table);
> >  		if (dev->subordinate)
> >  			pnv_ioda_setup_bus_dma(pe, dev->subordinate);
> > +#ifdef CONFIG_DEVICE_ISOLATION
> > +		device_isolation_dev_add(&pe->di_group, &dev->dev);
> > +#endif
>=20
> You already have a nop version of that in device_isolation.h, so the
> ifdef is not required AFAICS.

Alas, this is not true, since the pe->di_group member will not exist
if !CONFIG_DEVICE_ISOLATION.  And the stub is an inline, not a macro.

The stubs probably can be fine tuned to avoid ifdefs in more places.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7qEdkACgkQaILKxv3ab8aZNACfSZyJgOz7akNcMl9nB3NEaLRO
FDsAnj6GY4+xXclfOB3jG4Ot4jy8Jj4o
=CM5q
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
