Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2EHQ3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:29:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36707 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755077Ab2EHQ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:29:06 -0400
Date: Tue, 8 May 2012 17:29:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 5/6 v3] mfd: tps65910-irq: Add devicetree init support
Message-ID: <20120508162901.GD15893@opensource.wolfsonmicro.com>
References: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
 <1336502563-31789-6-git-send-email-rklein@nvidia.com>
 <20120508154820.GA15893@opensource.wolfsonmicro.com>
 <1336504291.31930.24.camel@rklein-linux>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="va9XEZk9/dJ5GUjX"
Content-Disposition: inline
In-Reply-To: <1336504291.31930.24.camel@rklein-linux>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--va9XEZk9/dJ5GUjX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2012 at 12:11:31PM -0700, Rhyland Klein wrote:

> Is this more what you would expect? If the dt code initialized the
> irq_base to 0 instead of -1 then this should also work.

> pdata->irq_base = irq_alloc_descs(-1, pdata->irq_base,
> 			tps65910->irq_num, -1);
> if (pdata->irq_base <= 0) {
> 	dev_err(tps65910->dev, "Failed to allocate irq descs: %d\n",
> 		pdata->irq_base);
> 	return pdata->irq_base;
> }

More like:

	if (pdata->irq_base)
		base = pdata->irq_base;
	else
		base = 0;
	pdata->irq_base = irq_alloc_descs(base, 0,

--va9XEZk9/dJ5GUjX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqUmNAAoJEBus8iNuMP3dSM4P/0ijljyUmSbByLrUko7ObgAg
Sp0ZIJruO2ozlbMfVn9YlI6B+JUFyDWZOFdveadjCcS2XW9Pt9xhVL3IfUfXw3WL
eC0ZubeweY0L8hA9mMeNe+Wdc+vbvbRjOiS1KzDSs0C274lc5wolGcZEF8ezaZ7n
pK3u+risU1T/nSl4ZtCr84H81WpNbUcFJO0/AaevKrpsUbSm69qpMWOK+JW99lxV
ro6w5AfGMGF0/kRrws53FJZG4mWlKGYuvbYEKl9F4v7X7YQUV+6d+EUj5eKH9iqq
KvviIkbAkGbuTqUB4Nw26PwpyzJze+8KOhx/JUnVRBv/6WscnR2uz7mM8KAWaCqe
BfToLCv3UdROXH4i6AMyLyYYHQfsTzr916pnhiB0XqSNa76RAAPwvxpC1f+lq3lH
088i7HpsUHw7itlrW10Kvppw1RFITbF9tFIoySjfdFt0sU5EHt0O8aUmW/bSJeNM
IrZct8PF5BDULuwnYeRtyhIxNwcEuCraEEb+P1IB9rDX5zpDUCIQBueTZQ8X+UWk
nI6qmvEtXTaQF92k7bhCW+ck8hSY84ywhvvAe0cxu4oFkJLTswXvAtxPuDiTCq5H
3+Ic9piVJpFuEu2AAwctAuw4VZmwqFmbsqtTsoUzw67+IK4hYX4Wb796jy1q5a+C
ksb8/V+J1LhTpl4RtcmV
=1Y44
-----END PGP SIGNATURE-----

--va9XEZk9/dJ5GUjX--
