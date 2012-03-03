Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2CCICu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 03:02:50 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:19672 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2CCICs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 03:02:48 -0500
Date: Sat, 3 Mar 2012 11:04:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] block, sx8: fix pointer math issue getting fw version
Message-ID: <20120303080449.GK22598@mwanda>
References: <20120302190042.GB3951@elgon.mountain>
 <4F51C103.507@kernel.dk>
 <4F51C18C.5080903@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wIc/V6YLA2QdyfT4"
Content-Disposition: inline
In-Reply-To: <4F51C18C.5080903@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F51D023.0003,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wIc/V6YLA2QdyfT4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 03, 2012 at 08:00:28AM +0100, Jens Axboe wrote:
> On 2012-03-03 07:58, Jens Axboe wrote:
> > On 2012-03-02 20:00, Dan Carpenter wrote:
> >> "mem" is type u8.  We need parenthesis here or it screws up the pointer
> >> math probably leading to an oops.
> >=20
> > Applied, thanks Dan. I have marked it stable, too.
>=20
> Hmm wait Dan, seems to me that u8 pointer math should be equiv to char *
> pointer math and hence it'd work just fine. Are you sure this is a bug?

It's the cast on the line before is what breaks it.  We need the
parentheses so we add first then cast the result.

regards,
dan carpenter


--wIc/V6YLA2QdyfT4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUdChAAoJEOnZkXI/YHqROGAP/RawaZtVRHdRTGrnJmNPRr9m
+r/JdjPDJQBUC/azTE4QXBvW4rmlIwkPLaAnuh+FS6vyp2kc+plvZFYAMdTjth3n
8uFY+FR7qIDcpxfKSBQYZxMuepmGoPCUgFPTKaLKaed2G5aXi8UXwXhoS2CSnqag
x09+NSSAqndgRoEPKRK/+0LmtiDAkbPTHgTpkZ/OmdpGnaHIIuThLudDCuL1B9Dz
8QhTUrmKAjDhbRSjvupsZqjLqXj7+QI87f/fpbCVtgvo61juPLDQXVjzQMDopXjD
HUAmh2dkuEhKmBYSBFGtmgAMobBLE5UrNE4igqMVH3tUNiUIencEJylsz6NnFKwy
/cd0batD6AoqbrOOcY2IAbPwvKumB7rzSsiIcH8VqBB+LYqgbp4/IUup3H/r0AVJ
Td/ghGOS8EHpxh4TVZARHk0Ko2UMxkfK77Htf7D15rBfJlFbLK5YdMjJZFiKFfrZ
iXEsK6ob4a4hh4M/1LFlsH1DfERtIrqKMyNtI7HWrf2ECB2bOm4yVDW8MvvpnYn7
ZAIS7Vu11dTWkC79eqT2fzk95yv6AsntpfrXGVrLeBXcdMQgUNjXiK+Pkt9ZO6tX
BDjmSaeDiGqfWas0741l2837yoD/TVYXXaaaE6GBR5pPWge3vQo8PAAhGZoUWrrk
fSPobaOwdy27UC8YzUT4
=DjZU
-----END PGP SIGNATURE-----

--wIc/V6YLA2QdyfT4--
