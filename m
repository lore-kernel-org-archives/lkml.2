Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2KMX0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:26:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52184 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755930Ab2KMX0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:26:04 -0500
Date: Wed, 14 Nov 2012 08:25:56 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lrg@ti.com, ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Add locked version of regulator_put to
 avoid deadlock
Message-ID: <20121113232537.GA27212@opensource.wolfsonmicro.com>
References: <1352198049-5941-1-git-send-email-ldewangan@nvidia.com>
 <20121106111256.GA2512@opensource.wolfsonmicro.com>
 <20121106113138.GB10080@opensource.wolfsonmicro.com>
 <20121113163040.GA19089@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <20121113163040.GA19089@opensource.wolfsonmicro.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 04:30:40PM +0000, Charles Keepax wrote:

> -void regulator_put(struct regulator *regulator)
> +static void __regulator_put_locked(struct regulator *regulator)

Please do follow the coding style of the rest of the code; nothing else
is using __ for private functions.

Please also clarify the changelog - you're not adding a new API here,
you're fiddling about with the internals.  Obviously regulator_put() is
always locked, you're just rearranging code inside the core here.

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQotb4AAoJELSic+t+oim9jqAQAI8Q68cB7+a0q2MsG1NIOYHz
AYvia7hegps8fCGO8I/SfPdnaIGmJbzn90R0X91iH/IuYjwZtgn9itYxOeMlR8qv
gFx/6DNKQnQiWQEMl80hZRMhSLwPzP7Kj9BIJ9LrbqVH1DROtnUjJ2VEQ/sM6RDG
9mE7OZLstZzhF6tXv2mJEnWSr4VlKKb1emH+b0q4eG0dCpdAScxQEN+e7U5odU5c
I0p55HIxn5RzgZOFmdy0KtxvUGGVVq0IHzDK93it/Y3vvKswoABr981xrBCrRLCA
xzu6rUo2En8/mLG8yozTg1z8mQns8aOrHlOfl0gk1dGm2eJcuXNkgzw391qbxCdd
TFNWKQ49q2I8xKmJ92OCZxKtTDSPfYJ+SVYXK1R1VfDnJuC5ar0hQdYeKypPVp2a
O8CNfNDGftyutcDQacVsKWGPJKkpBCM/tnGvXAiFlGWYBc7ajPljUcnNipGwe+ok
tOaNobwO3q6LhgTE6OVTTJmQY+3PnZBFGemtgUd9HCsbpyDGrJt1bs9n7iCtJHAa
bMKOuWOpq+8VeEQfjYcYsHLBdHO/PmpJbpdxJmQuZYjr/R/vwAu4heL6MZ57Gny+
4ZFsXbqkjrFdORoIpZN5i4wpIbgcQ+5nCEZsIMtTeU0yfiACoGeE8yDjHiGSOIor
m/YsAZimZqUQSNzN2nFB
=5p6S
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
