Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab2EURb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:31:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59225 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab2EURb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:31:27 -0400
Date: Mon, 21 May 2012 19:31:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lucas Stach <dev@lynxeye.de>, Hiroshi DOYU <hdoyu@nvidia.com>,
        linux-tegra@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu/tegra: gart: Reserve iomem resource
Message-ID: <20120521173124.GB11824@avionic-0098.mockup.avionic-design.de>
References: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>
 <1337019127-6863-2-git-send-email-hdoyu@nvidia.com>
 <20120521141152.GA21513@avionic-0098.mockup.avionic-design.de>
 <4FBA702A.1010203@wwwdotorg.org>
 <1337619935.1621.13.camel@tellur>
 <4FBA77E2.4000409@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <4FBA77E2.4000409@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:qDc8BmocukyCHzENXq97XvpNr7QMKPdZKymuKMa0i92
 0CFSRxSWSOoOtaF7RjhW2hD9WHHb03EUW48nwxPVDOEgxyBE+z
 3aEq+4WxhcpD3iCvy6SjU2jzpvb+93BQv6Gfk2xIAAvRQ9/bsm
 cRgyF1lMOikwiFOs33gnf8XpYLWlv6rmq2FvXfsChMI2WYDn8H
 RtNPmBa4lIjZPpPUCx1beFmE+qLHA03vlpieT8gyS5lDGcguGJ
 B9nnizpJC4ONH2kejHTYDivi3odmJhvJCSY4k2NN3Y4k80AUr4
 BC6OddSRs9E+065X8+g72GL0zjBXd99qFUN59pPVmEdNaoLesL
 WRGVwXE3k2ubfnpRflh0f5wajx1cC2BTVIMKAiI5O/Lw+g6LBX
 XYmnAVOginH9XDHJjVN0YtfTntZ6ROCJOo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Stephen Warren wrote:
> On 05/21/2012 11:05 AM, Lucas Stach wrote:
> > Am Montag, den 21.05.2012, 10:41 -0600 schrieb Stephen Warren:
> >> On 05/21/2012 08:11 AM, Thierry Reding wrote:
> >>> * Hiroshi DOYU wrote:
> >>>> GART Register/Aperture range should be reserved.
> >> ...
> >>>> diff --git a/drivers/iommu/tegra-gart.c
> >>>> b/drivers/iommu/tegra-gart.c
> >> ...
> >>>> +	if (!devm_request_mem_region(dev, res_remap->start, +
> >>>> resource_size(res_remap), dev_name(dev))) { +		dev_err(dev,
> >>>> "failed to reserve GART aperture\n"); +		return -EBUSY; +	} +
> >>>
> >>> I'm not so sure that this is a good idea. If the GART driver
> >>> requests the GART aperture, then users of the GART aperture (e.g.
> >>> the DRM driver) will no longer be able to use it.
> >>
> >> Presumably the DRM driver would be obtaining access to parts of the
> >> GART aperture through the GART driver, rather than just grabbing the
> >> IO region and using it for itself?
> >=20
> > With a TTM-like memory manager the DRM driver will take over the address
> > space management of the GART aperture. The GART driver is only used to
> > set up the mappings in the IOMMU. The DRM driver is the one that sets
> > up/tears down the CPU mappings on demand, so the aperture should be
> > claimed in the DRM driver.
>=20
> Even if the DRM driver is managing the aperture, I still think the GART
> driver should claim it. The physical address of the aperture is a
> property of the GART, so only the GART's resources (and DT node) should
> contain a representation of where that aperture is. The DRM driver
> should call into the GART driver to find out where the aperture is, and
> hence GART is able to claim it without conflict.

That could be difficult to do. There isn't any API to allow this. I guess if
something like that is added it should probably go into the IOMMU framework.

Thierry

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk+6e+wACgkQZ+BJyKLjJp+tOQCcCLK4qxtPlJOVuA1S7GC2O+eR
23EAnAiJs3mIFp/VKWLNrsffvD9uFnRU
=PbUB
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
