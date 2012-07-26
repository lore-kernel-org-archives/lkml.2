Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2GZVwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:52:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60427 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329Ab2GZVwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:52:22 -0400
Date: Thu, 26 Jul 2012 22:51:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: add MAX8907 core driver
Message-ID: <20120726215150.GI4560@opensource.wolfsonmicro.com>
References: <1343331630-27126-1-git-send-email-swarren@wwwdotorg.org>
 <20120726203526.GD4560@opensource.wolfsonmicro.com>
 <5011B32D.1080102@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X0cz4bGbQuRbxrVl"
Content-Disposition: inline
In-Reply-To: <5011B32D.1080102@wwwdotorg.org>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X0cz4bGbQuRbxrVl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 26, 2012 at 03:14:21PM -0600, Stephen Warren wrote:
> On 07/26/2012 02:35 PM, Mark Brown wrote:

> > This looks very suspicious...  why do we need to call=20
> > irqd_irq_disabled() here?

> I believe the status register reflects the unmasked status, it's just
> the interrupt signal that's affected by the mask.

This is totally normal, the standard pattern here is to and the status
register with the mask register before parsing.

> So the idea here was that the IRQ core is already maintaining state
> which describes which IRQs are enabled/disabled and wake/not. Rather
> than have irq_enable/irq_disable/set_wake do nothing but save the same
> state to irq_chip-specific structures, I removed the body of those
> functions and instead just call irqd_irq_disabled() etc. wherever I
> would have accessed the "local" state. Is that not a legitimate design
> then?

It seems very smelly, if you were supposed to do this then you wouldn't
have to be defining the empty operations.  There's also the counter
argument that it means you've got to go through every interrupt and work
out the state before syncing rather than just being able to blast the
register states in but that's fairly weak.

I think it's a totally sensible idea to reuse the state in the core, but
I do think it's a bad idea to dance around the core's back like this
with the empty operations.

--X0cz4bGbQuRbxrVl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEbvdAAoJEBus8iNuMP3dm+MP/R5H1jRrOtbvujSAJuZooF2q
6rxZvj61sbgXm1h6qe8ABuQzlV0qH+DqHhyNyhkdE/RgwzsC4KV2bDIFT2JhvuRR
lYFtiAkIxCkfoNMIoqjpfvYoDKKyntCjWLPGI7Amlic3B+GFFdoiAfvIH+0WdORX
FGRcEnKAiFfrwZbnUhIrCncZMoamfkQ140A5T0RrZFRpbwKuk7UzvuEEaPdtb5JC
B4ykoTTBXTyzlG2GtXgtyDK3DZIaVSEZzhMcez1sC1mTi2VTp9ftsL/YC3lsf64B
kBTiM5yINIA2JkU+oq6gXTheXzAog2I/Qs4kyf04AHPrSZIAC/37iMfQuIP+AA/V
6uRjM7Qly3GFRB/T+XH/F8kCdJZKH/0YNtTzJTywFTJlGSC5Jynb916cUZqwaMi3
rvSV1kZ/q2oAQy4pIdD0FzbRHRFAd64KGojgBoSBwmfLS/w2d1OLbo8SG0H964Eg
n32fDcKiQzS7lFai/DVJQHsydty7PQdFDqON++ztz557ReybaIxeoEOVGb50V3eH
RQe3YUSLiTHYU3zLzcWgG5jidaBr7+rLLz/aBvDjTX60BrhLgHBe70e7eZbwqHVR
+VdA3JauF1QlUzgjao3s6AAoCibL7JFt4w5w9Da0u8IMUKVqNAz96F/uRA7eCo3h
TfwgmOziXyeQ0ULpJdKU
=wby9
-----END PGP SIGNATURE-----

--X0cz4bGbQuRbxrVl--
