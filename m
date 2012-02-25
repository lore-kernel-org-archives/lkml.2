Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab2BYL6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 06:58:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57108 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964Ab2BYL6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 06:58:04 -0500
Date: Sat, 25 Feb 2012 11:57:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: "Liam Girdwood (lrg@ti.com)" <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sdmmc controllers without vmmc regulator
Message-ID: <20120225115759.GE3167@opensource.wolfsonmicro.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCD8C@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCD8C@HQMAIL01.nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 24, 2012 at 01:35:08PM -0800, Stephen Warren wrote:

> Can we eliminate this warning in of_get_regulator(), and let clients
> Control whether they warn when a regulator isn't found, if they think
> one is mandatory? I think I'd prefer this option; it's consistent with
> the non-DT path in regulator_dev_lookup().

This would be sensible but...

> Or, should I set up dummy regulators in device tree to cover this case,
> such that an SD controller's vmmc-supply always points at a valid phandle.
> In which case, I'd have to add DT support to the dummy regulator.

...you really ought to be doing this anyway (except with the fixed
voltage regulator, the dummy regulator is for stubbing out regulator
support entirely on systems with just one or two software controlled
regulators or where you don't have any information on the board design).
The MMC regulator usage is a bit of a mess for historical reasons, it
shouldn't really be conditional.

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPSMzAAAoJEBus8iNuMP3dEfkP/00SUHHju2cxrwsy7ToNGRV0
7jBSfVYvbfbHz39KPiQS62Q+9CkoKzONCZP0M+n1b7pLbOuJ9MLx9nyZ4Z4BLwrq
/aHPC+dyX2oCKD4fqJLBHa9t2AWlaUwbY5uIcogxraf8SV0czKVjXNcCNVfVq+mH
iBrTsSOdNePmXdnJ4iFMFIP/v7idqXedhenzICWDyYi2MdJKjxYukB22Fc+rLpBk
nCCfrhF/2XhgZ7wJGPqtzBNS5mRMcmjUFjFqPBFH9LsaHHP2WeB7EUfqRiulq1KR
6XhkRsZH+Ea98j+KUBjN8wEWRy2hV4yx5Lv+DrPljVgg5km07+jFS2F3zRklL/4C
QwHDlp5EKA/1sAIdynMgU/M4w+Pne7OVg7kmgQctVq7b1K2swtWqzjI+rAOmgRQx
mW/gEusVcz0K1B9wWLF4hIqJOI+4zuKsn21l1rXkzyuQn6mwRj8u+dYLCwF9VcLp
TVFAyD3VTgz6pdR4+OhEX8G2z0jIDEdpv6b9tR8gWxIrbqbxHjWDfxz8PqiJWG37
40FCspbQFzhMPQ8AFa2GF6HnxJj0SUAVotQWraj9eBwONqqfZZiddft/ZArDY5rN
lwiPdDuvLs6Z3wrB/iTbxyY/lUkNebYcfMDX38gTtCx38hodhiv3VQfN1SLgiq7I
I7OJVncn0qF5pJ/KDGIU
=l0lU
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
