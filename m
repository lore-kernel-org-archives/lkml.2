Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab2BILzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 06:55:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39866 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291Ab2BILzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 06:55:05 -0500
Date: Thu, 9 Feb 2012 11:55:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1 1/2] mfd: tps65910: use regmap for device register
 access.
Message-ID: <20120209115502.GD3058@opensource.wolfsonmicro.com>
References: <1328697985-22504-1-git-send-email-ldewangan@nvidia.com>
 <20120208114120.GF3120@opensource.wolfsonmicro.com>
 <4F32676F.1010305@nvidia.com>
 <20120208130726.GB5943@opensource.wolfsonmicro.com>
 <4F3279D6.4000009@nvidia.com>
 <20120208135816.GE5943@opensource.wolfsonmicro.com>
 <4F335385.5040400@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Content-Disposition: inline
In-Reply-To: <4F335385.5040400@nvidia.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2012 at 10:33:01AM +0530, Laxman Dewangan wrote:
> On Wednesday 08 February 2012 07:28 PM, Mark Brown wrote:

> >But that's just raw_write(), there's no benefit to the additional API
> >call.

> raw_write supported for the volatile register only.

That's an implementation detail since there's little if any use case for
such use, the main use of raw_write() is dumping blocks of data like
firmwares and coefficients which are rarely cached.

> I require an api which can work for volatile as well as non-volatile
> registers.
> Either extend raw_write to support both cases (remove warning and
> handle properly) or add bulk_write.

> I think as bulk_read is there and so having bulk_write on same line
> should be OK.

Note that there's a very important difference between the bulk and raw
versions of the API which you're not taking into account: the bulk
version takes care of endianness differences between the device and the
host.  This would mean that for send we'd need to rewrite the input
array which means we have to take a copy of the data as we probably
shouldn't be changing the input data.

Indeed, looking at the drivers in mainline I can't actually see any of
them which do block writes.

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPM7QQAAoJEBus8iNuMP3dLRkP/iuVLtpni03P5BSvWFmus4PX
yuseBnRJftR7+P8NCkJwhlCJwG2WGPPKXA3yjKjiCiy/6+9k86KYBCKMsKV6s+5P
ezRAVASqvBHJeUHJdmDh/xBwwr24gX65QVU3OuR74hCrsE0YnyFzAyQuTkrp+VIi
iP8uWQRWs/LnDBdKdHAOffnonA7iYIa69RGF3MX0fmX9RmPtKhMCM0C2oKVKaaTR
FajJozIP1huPHyc6kUuwtZiDZKOwY9LfaJXe/Pd3f+DUkAizxOuF/E0SHNBafy2v
yhdeB6ejWcGbodOwYtC9fDhZjmlUubSjKJNry2CKcmXd4kWofbadTv8LEoKTDorv
jhFjfHSKBhSadstLUpHMX7cCEzr9vtRTup1i+c5Rd32uNsnfx6JIPRR78MVRC8c3
jNVGB3CQYW5/0z4z5P6EQbtThTDG3qyF3DdZCerUE7IK+dQLGzwG2WiUjWOMDTIs
ONEI0xIeGMZm+OaUx9HxR1Aepvda+bRKHkJCklh0LuTet1FEuNYhwEE3ECrZnllk
uk17d/IRmhSyKdsu6y/E4aB7hWF198NI4wNo6qqfTbi4czS5bBc6B2vcHzqq+GSr
bXAUsEUaQG1Je/i/K4qltIoUC0jT81vC/3psMPZudwZjybuRXzmi+LBGQEdsDCRB
yWaMUZRfNFIXzdDR0i1w
=IO5P
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--
