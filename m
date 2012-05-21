Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab2EURjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:39:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63588 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2EURi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:38:57 -0400
Date: Mon, 21 May 2012 19:38:49 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lucas Stach <dev@lynxeye.de>, Hiroshi DOYU <hdoyu@nvidia.com>,
        linux-tegra@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu/tegra: gart: Reserve iomem resource
Message-ID: <20120521173849.GA12042@avionic-0098.mockup.avionic-design.de>
References: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>
 <1337019127-6863-2-git-send-email-hdoyu@nvidia.com>
 <20120521141152.GA21513@avionic-0098.mockup.avionic-design.de>
 <4FBA702A.1010203@wwwdotorg.org>
 <1337619935.1621.13.camel@tellur>
 <4FBA77E2.4000409@wwwdotorg.org>
 <20120521173124.GB11824@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20120521173124.GB11824@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:V0OSdhEcXOwseYwSGTvcs3PuEqiIYbiU4T2DdvMCGAc
 CLPHX6y3ptkwFw0hOGrg4KYMMjpKs71eo50haL9h5qZVP9Z3t8
 NlZeWgtPerh+Tj/SYhGCk7pkYVkTk5oigsoZP1y99v1Z2PFsY0
 WooPqO7hxxtfgTCP0Zf7sWH7nkMzaQSHcSCpyoqxxJPNx5MBls
 JmkG+hdm1tqt8KagxW1TGdPVBlTIcTi2mMcMlnyjg/1xKnU46w
 ZIDlZfNXfYWnI4o/59L7JBnWYXNZsoxgeMCU87arzgLRjtOJKJ
 U20OzV5IAI+8Fo6HBbVu3irAwHRFc07ter+USROxgB5ZpqNZVx
 berpVszhurkyS8WH6HFiJnLLHfOlFmDvUI4oopCgdhWiC4e/dz
 Gei/nkCUK4TOD67Rno6lXxDtlvs++jgqN0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Thierry Reding wrote:
> * Stephen Warren wrote:
> > On 05/21/2012 11:05 AM, Lucas Stach wrote:
> > > Am Montag, den 21.05.2012, 10:41 -0600 schrieb Stephen Warren:
> > >> On 05/21/2012 08:11 AM, Thierry Reding wrote:
> > >>> * Hiroshi DOYU wrote:
> > >>>> GART Register/Aperture range should be reserved.
> > >> ...
> > >>>> diff --git a/drivers/iommu/tegra-gart.c
> > >>>> b/drivers/iommu/tegra-gart.c
> > >> ...
> > >>>> +	if (!devm_request_mem_region(dev, res_remap->start, +
> > >>>> resource_size(res_remap), dev_name(dev))) { +		dev_err(dev,
> > >>>> "failed to reserve GART aperture\n"); +		return -EBUSY; +	} +
> > >>>
> > >>> I'm not so sure that this is a good idea. If the GART driver
> > >>> requests the GART aperture, then users of the GART aperture (e.g.
> > >>> the DRM driver) will no longer be able to use it.
> > >>
> > >> Presumably the DRM driver would be obtaining access to parts of the
> > >> GART aperture through the GART driver, rather than just grabbing the
> > >> IO region and using it for itself?
> > >=20
> > > With a TTM-like memory manager the DRM driver will take over the addr=
ess
> > > space management of the GART aperture. The GART driver is only used to
> > > set up the mappings in the IOMMU. The DRM driver is the one that sets
> > > up/tears down the CPU mappings on demand, so the aperture should be
> > > claimed in the DRM driver.
> >=20
> > Even if the DRM driver is managing the aperture, I still think the GART
> > driver should claim it. The physical address of the aperture is a
> > property of the GART, so only the GART's resources (and DT node) should
> > contain a representation of where that aperture is. The DRM driver
> > should call into the GART driver to find out where the aperture is, and
> > hence GART is able to claim it without conflict.
>=20
> That could be difficult to do. There isn't any API to allow this. I guess=
 if
> something like that is added it should probably go into the IOMMU framewo=
rk.

Thinking some more about this, even then care needs to be taken to allow on=
ly
one user access to the GART aperture. Having the DRM driver request the
region would automatically prevent any other driver from requesting the same
memory. This is no longer true if an extra API is used to request the GART
aperture from the IOMMU. Unless of course some of these restrictions are
reimplemented in the IOMMU API.

Thierry

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk+6fakACgkQZ+BJyKLjJp+OtgCdFH3PS7W7DgiSOtLkGYq7LckM
FVYAnjNF/ng/KAUXeLHul8T/9wABUu37
=MNv+
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
