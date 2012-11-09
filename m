Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab2KIRJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:09:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50942 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754773Ab2KIRJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:09:21 -0500
Date: Fri, 9 Nov 2012 17:09:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, philipspatches@gmail.com, patches@linaro.org
Subject: Re: [PATCH] regulator: core: Update regulator_is_supported_voltage
 for fixed voltages
Message-ID: <20121109170918.GW23807@opensource.wolfsonmicro.com>
References: <1352458309-18141-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I33OQG5IFrqF2BWt"
Content-Disposition: inline
In-Reply-To: <1352458309-18141-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I33OQG5IFrqF2BWt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 09, 2012 at 04:21:49PM +0530, Tushar Behera wrote:

> In case of fixed regulators for which voltage cannot be changed,
> regulator_is_supported_voltage should return success only if the
> min_uV and max_uV parameters are same and it is equal to the current
> voltage of the regulator.

This makes no sense to me at all.  The caller is asking if it's possible
to set the voltage between the minimum and maximum values, any voltage
in that range should be OK.  Your patch makes the function massively
less useful.

> Currently this patch breaks MMC support for boards on which vmmc is a
> fixed regulator and the voltage is not equal to either of 3.3v, 3.0v
> or 1.8v. Earlier it used to work if the voltage was less than 3.3v.

This sounds like a problem in the MMC framework.  If it's happy with
non-standard voltages it should be happy with non-standard voltages,
or perhaps it should be ignoring voltages if it can't find any sane
voltages at all.  The regulator framework is accurately answering the
question it was asked.

It also seems like the MMC framework will be broken by a regulator which
can change voltage but not over the full range the MMC framework is
interested in, this is essentially just a special case of that situation.

--I33OQG5IFrqF2BWt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnTi4AAoJELSic+t+oim9b5QP/Rd+FlVMMKEgiw5SoAPVIAbj
BbGvodqVDkPUtr1TbW5aNZWPJLL5U/sKb6RPKcq0jkUdZKlkCXE6CfCdo4Kyc6fw
gcTQNdboG8JZfy8ClZodhaAYWv1unnMNkJeFnHZVDkRQxFFtlWv6SiD1GuDCuyqE
4UiB9oDdYbuNPWb7D2M0JcUPLPq/bhN2WKmhcILzuyXlShIVv0JjYxtJG06UUcsa
QvxDigbpKMfx57jiLLbEI82OmpK00f0aN2iwVuPJdxckZNhQcY/zQc+WcmNpUJO8
Y/fHVuqgVNZ2Z0aPsXcPgia1XtldgAL0bCSMaAOOXICpCYh71bolEsprrgDiEHV0
cj2Fd3dh0+tUgRqtQQB9kOSD6/qBLLqR6TZBzpJeMVF4YWM3BJK2QdtDqenof/oE
w3XyQvNqEPYGCb6Z/RPfrK9KWb3IlscE6JrmI/giOMWWnRoJW03+U4e2zYjT3vqE
d1UY33+x1SmbWygtoH34RroJr1Znn0OecRUznzPOtctIZ3zFw5/yroa2ucuzzdP8
LbS3pLDgTbn6ZcJyaRnIbXk5ibqTd83XBeeE2gk4z+OQmXNQvbPMDxHxyS6TYa6M
6/XS6AHxs/Wxgc0qgSscAm8SgUuDqFx3ABEQ5bxW/Qh83Oefxvj87q7G6D38/1Bh
ny1A5CFeRsEO/h43kJJW
=EqyD
-----END PGP SIGNATURE-----

--I33OQG5IFrqF2BWt--
