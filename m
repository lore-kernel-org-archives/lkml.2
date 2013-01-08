Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3AHNKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:10:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41191 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611Ab3AHNKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:10:11 -0500
Date: Tue, 8 Jan 2013 13:10:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130108131008.GW4544@opensource.wolfsonmicro.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <1357555480-24022-6-git-send-email-mika.westerberg@linux.intel.com>
 <20130108110228.GM4544@opensource.wolfsonmicro.com>
 <20130108124153.GJ13897@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qndya+I13rh6QJ0p"
Content-Disposition: inline
In-Reply-To: <20130108124153.GJ13897@intel.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qndya+I13rh6QJ0p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 08, 2013 at 02:41:53PM +0200, Mika Westerberg wrote:
> On Tue, Jan 08, 2013 at 11:02:28AM +0000, Mark Brown wrote:

> > No, the way to do this is to fix x86 to enable the clock API there.  The
> > x86 maintainers couldn't be bothered when I submitted a patch and
> > getting anyone to take a patch to make it available by default appears
> > to be unreasonably hard but perhaps if someone from Intel tries the x86
> > maintainers might take a patch...

> Do you mean enabling CONFIG_COMMON_CLK on x86?

Yes.

> > We shouldn't be adding special case code to every driver that might need
> > a clock that gets used on an Intel system.

> I agree and it is cleaner to have the same API for all arches. However, I'm
> not sure how do we create the fixed clocks then? There is nothing in ACPI
> namespace (or in the ACPI 5.0 spec) that allows you to describe clocks and
> their relationships.

I'm sure it's not beyond the bounds of possibility that we could solve
this problem...

> So then we end up either:

> 	1. Creating a custom board file for Lynxpoint which creates the
> 	   clocks. This is something I think x86 maintainers don't want to
> 	   see.

> 	2. Creating the clock in the driver itself in its ACPI enumeration
> 	   implementation. This might work but it litters the drivers with
> 	   clock details.

> Or is there something I'm missing?

Well, it seems fairly clear to me that the SoC wiring ought to be done
outside the driver.

It is something that needs to be resolved for your smartphone SoCs for
this and for other things like platform data for external chips, what's
actually happening in practical systems here is that people are just
hacking the arch code as there's no mechanism for providing
configuration at present.

--qndya+I13rh6QJ0p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7BpwAAoJELSic+t+oim90+AP/0Ukxapw1ZbeN2yJuq9EL4o7
jMw1z5PKS9n0DVHLMBFVefsfuQoZxIDSG2F29kqQfvFVofm3Lj2IA9C2D7jclO2t
7/EwfWr0lhZxmiv5dZCVaUkfJvZRIXLcx8j6rf/otC74o/844hSQDnXNaVb6Um4H
Eg7DcePvVCYzrZlBmm98nlXsJqAjpZODgxbiCM0SEQgLh0/jFWhw/v3bsG4X7BYH
OjAl4t5j0suhzV9E86r2J/iJI1zMVinjuEHBkN4ZXyMppkR0lMQUP/RlMcZ7psSK
hJ21gsagEntmZINb8A/OyDtAttDQt64AgJUDp/RWeYC6LRMO5xT42BCNvTtlpmhh
WhHaKF165DeXVztlcO7fPxJsAR6cgLg7EMMbsa1CiO5zQjf6GaT3w5ol/4nP137Y
zgG30sqX0EMOSz6eOB2qzuK1x4RrvLrjX9sqtyEPw9I/tjeF844p22IFWtBMJYpC
u1sLB+MXs78hBeqEpi9CANXTdg34L+ZwpcInJthoPnTSBkMyxYPe2/Um5dNZ8Zzc
CxD2eCthYeOjAcK0P3AYsuwlQZq5OoYwvIOQUoBRIA/dDzc56RyNXJrRC3O0jdXr
th5JU597pcCzLXXYfF/dpZq+mBMYplp3tDj5JLa114az7//5k2L2T3YKVgj9jOFA
NCEdBnDPW/LCRO89GJ2N
=kvhO
-----END PGP SIGNATURE-----

--qndya+I13rh6QJ0p--
