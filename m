Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab2ESS1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:27:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43410 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756642Ab2ESS1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:27:02 -0400
Date: Sat, 19 May 2012 19:26:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
Message-ID: <20120519182658.GB4039@opensource.wolfsonmicro.com>
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com>
 <20120519164134.GT4039@opensource.wolfsonmicro.com>
 <4FB7D4D8.2050501@nvidia.com>
 <4FB7D676.9000609@nvidia.com>
 <20120519174052.GX4039@opensource.wolfsonmicro.com>
 <4FB7DEB0.3040001@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lUFOiBjYbj2M+tdK"
Content-Disposition: inline
In-Reply-To: <4FB7DEB0.3040001@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lUFOiBjYbj2M+tdK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 19, 2012 at 11:26:00PM +0530, Laxman Dewangan wrote:

> At the time of registration,  as becasue there is valid
> reg_desc->supply_name and hence it tries to lookup the entry for
> <name>-supply i.e. v2-supply in this case for getting regulator_dev.
> regulator_register() {

> static struct regulator_dev *regulator_dev_lookup(struct device *dev,
>                                                   const char *supply,
>                                                   int *ret)
> {
>         /* first do a dt based lookup */
> ----> Checked here, dev is not null but dev->of_node is null.
>         if (dev && dev->of_node) {
>=20
> ------------>The issue is that I am not getting here as dev->node is
> null here.

But how is this related your patch?  What your patch does is change
things so that instead of trying to look up the supply in the context of
whatever device was passed in by the driver we try to look it up in the
context of the class device we create.  I can't think of any situation
where I'd expect that to make matters any better - the class device
should certainly never appear in the device tree and isn't going to have
a stable name for non-DT systems either.

I'm just not seeing any problem in the core here.  It sounds to me like
the problem might be either with the regulator driver doing something
odd with the struct device it specifies when registering the regulator
(though I'm guessing that it's the tps65910 which looks to be doing
something sensible currently) or the device tree for the board being
odd.  Looking at the changes you posted to tps65910 I suspect the issue
is that you've changed the driver to pass in the platform device for the
regulators as their device rather than the I2C device but it's the I2C
device which appears in the device tree bindings.

If there is a change needed in the core you need to explain what you
believe that change will do.

--lUFOiBjYbj2M+tdK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt+XiAAoJEBus8iNuMP3dDccP/0tqR7KtQfJ/RAwZks7mTPa5
odOtTb132phNWk+YyKpkTWJMXtggqC/ahrljjXFfw9vVAY7KJLurOBNVRx+ZYe0s
eQrzR6IYL1iuB3YXjy0pioqJ+etbAmqLB5Kb9moNE2QsIwv4DdU5XA9OjGZQrCwN
00ybRTXlyU2e0hw+CfbxZvnvrcnE1DISlLF/OMH/1jY8Qw6gibHtgnUGrMyxsDtu
M5Ne9cp1aFtXBVlhgqn2zVd73q3Fa203IdL6FGH2SKZe1q4GMO/c0jNkr3ziUPD+
85bXxeY5oo0g6pLwNQp2US00GhxZmWvExTL9pjIen6A9kIICMCaeqcY4LQ3u+BPs
5bBZBeZAKsRfgb1p0ZUUjrYXQ48lavupnZ2nspGJq5oxMhA5xs/2avB61mUwqdyE
8IdrxNcQ0lcqlFyI2Jm3lJrmk2M8vRQVeFESLLxGupb+YPfrHrWSqz5PEua448te
CGnwJ2hJMRghsZIOXyaRMrzGc4n+67fG965U2rKWKCu1hyNxoxmWj4ru1nOQ3+Ht
zwN/V/OYb3hlCTuHyVGhiXuJS7ZYMcipB4NUtdWKhdALOkWerVSJEfKATeZoMhaD
aYnRbgn3VSPXrpXganlQIg9byeJbY8LbVpN/D2J5079ZcV4DC6GZ7KuktC7RMsHK
x8uNK7asgn9nyEM0qvaY
=l8B9
-----END PGP SIGNATURE-----

--lUFOiBjYbj2M+tdK--
