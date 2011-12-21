Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1LUCr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 21:47:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46076 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151Ab1LUCrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 21:47:51 -0500
Message-ID: <1324435650.2844.182.camel@deadeye>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
From: Ben Hutchings <ben@decadent.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 02:47:30 +0000
In-Reply-To: <1324434950.14214.3.camel@joe2Laptop>
References: <1324430940.2844.144.camel@deadeye>
	 <1324431127.2844.146.camel@deadeye> <1324434950.14214.3.camel@joe2Laptop>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rR6XqhiWyN5RW7QTcWIx"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rR6XqhiWyN5RW7QTcWIx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-12-20 at 18:35 -0800, Joe Perches wrote:
> On Wed, 2011-12-21 at 01:32 +0000, Ben Hutchings wrote:
> > Physical addresses may be wider than virtual addresses (e.g. on i386
> > with PAE) and must not be formatted with %p.
> []
> > The resource could alternately be formatted with %Pr.
> > diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/=
hw/cxgb4/device.c
> []
> > @@ -318,10 +318,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
> >  	     rdev->lldi.vr->qp.size,
> >  	     rdev->lldi.vr->cq.start,
> >  	     rdev->lldi.vr->cq.size);
> > -	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
> > +	PDBG("udb len 0x%x udb base %llx db_reg %p gts_reg %p qpshift %lu "
> >  	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
> >  	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
> > -	     (void *)pci_resource_start(rdev->lldi.pdev, 2),
> > +	     (u64)pci_resource_start(rdev->lldi.pdev, 2),
>=20
> Probably should be unsigned long long

unsigned long long is so long long long to type.  And u64 is now defined
as unsigned long long on all architectures, partly because of that.

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-rR6XqhiWyN5RW7QTcWIx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATvFIwue/yOyVhhEJAQpbUg/+OfseC8ZndYGQT1BZ3Loti6gyw7uTTCqF
lmQPdEGf4MN/LfkMTI6rEPO9atBzljxT7KCAcMVplzhJHpBziSuzw6rpLKxyB4lK
TKqkLIb8yBkpmswFTQ8VfxI14DUg4iFxm8jNhGv3vjgkkHlZ4TH7aMq4CTNAcNqj
amJ7h8cPyDSkV5Bof8WzpnPbtUr3ovZZ4tLhegOCguStpSiehvfQYKhhRgKdhA/6
fljT4xhRWDnMZixxuCUiWQchbFNgg/g51yOC4gNEPoDzNd1RdTgwWG5GQE+uu/Q0
fI6yyiUBEuujqp842nG6lfPrXfO0mhaIvOiCdr6+Fh0CZKz6MxnwMK9225p2pJMW
fJevvywXllI482wvAfPqt8APc2KtYaRtPAzXk5N0wq6dbW8jgqkUavUKv74zcCgE
+6Srn/IqX51qM2PDULaegi2k2f82v2CqCJ5Q5UhmUzKwB2TTCFJVERLW7ByAbtMU
JGPGPJhylky2gRAYoNHaBPpggPCvAM0bfLgq0s9d3V8ER2lvBS/Bl2cuagVca6K6
EzmOzdYJA7UffcziIML8IEmfXLCq+pzH9Z0P2eFVp7BjemroNt0+OLRtAzMWtdsB
1U0P6S+Gl7eI+RIhYSgmF1z1rWRLIYS6IWzPaFbpEtLLXY6IwXtyykncC4dmdM61
pq3dQviQOJs=
=ohY7
-----END PGP SIGNATURE-----

--=-rR6XqhiWyN5RW7QTcWIx--
