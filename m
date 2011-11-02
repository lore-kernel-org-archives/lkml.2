Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023Ab1KBTsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:48:33 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:32821 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790Ab1KBTsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:48:32 -0400
Date: Wed, 2 Nov 2011 21:48:28 +0200
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, Nicolas Pitre <nico@fluxnic.net>,
        Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Gary King <gking@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/tegra: add support for tegra30 interrupts
Message-ID: <20111102194827.GF14372@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1320248292-22736-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173F9A46E5@HQMAIL01.nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173F9A4758@HQMAIL01.nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173F9A47A7@HQMAIL01.nvidia.com>
 <20111102192112.GC12913@n2100.arm.linux.org.uk>
 <20111102192625.GD14372@legolas.emea.dhcp.ti.com>
 <20111102193947.GD12913@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wtjvnLv0o8UUzur2"
Content-Disposition: inline
In-Reply-To: <20111102193947.GD12913@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wtjvnLv0o8UUzur2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 02, 2011 at 07:39:47PM +0000, Russell King - ARM Linux wrote:
> On Wed, Nov 02, 2011 at 09:26:26PM +0200, Felipe Balbi wrote:
> > would it be better to just change the default value in
> > arm-generic/gpio.h to something very large ?
> >=20
> > I mean, ideally that wouldn't be gpio_desc wouldn't be an array anyway
> > right ?
>=20
> You'll excuse me if I take this slightly personally.
>=20
> You really can't expect me to say that I'm fine with a 6K growth in
> kernel size for something that not every platform needs if there's
> been objections to maybe a 128 byte growth for including the V:P
> patching code in the kernel by default.
>=20
> Either we care about memory usage or we don't.  If we don't, lets get
> rid of offering ARM_PATCH_PHYS_VIRT in any configuration and always
> build with the dynamic V:P stuff enabled for the trivial cases.  I
> mean:
>=20
>  config ARM_PATCH_PHYS_VIRT
> -	bool "Patch physical to virtual translations at runtime" if EMBEDDED
> +	bool
> 	default y
> 	depends on !XIP_KERNEL && MMU
> 	depends on !ARCH_REALVIEW || !SPARSEMEM

you forgot to comment on the fact that gpio_desc shouldn't be held in an
array. Any comments ?

What I mean is that, just like irq_descs, we should be able to allocate
them dynamically. Maybe, just like irq_descs, hold them in a radix tree
and maybe even have a matching API "gpio_alloc_descs()".

It's a pain, anyway, to keep track of GPIO base numbers, specially on
complex boards where you have gpio controllers which are internal to the
SoC and several others connected via e.g. I2C.

Most PHY chips for several I/O have some extra GPIOs which are generally
unused or hacked around (see tusb6010.c for example).

--=20
balbi

--wtjvnLv0o8UUzur2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsZ6LAAoJEIaOsuA1yqREwQkP/RB1cLAl44cJFAQrewfnJCc1
W6+9qsi/ce0Q36IujtGRs0HLCjoM9/ARukK2ZNWmI1Eaaj+FazLS2HAx1g2xd9NZ
1xe8IJ3jfSl6UK68c8aDBRKG/Zz7BfMGfzT/F7izhzKwiRF3OzBGq2wjQjH3QyIE
u8AN2kEd54vfQN+iMxL4eAx9Cj1TU6+drlE7QBwNcVoatpeKMNNlXq3bsVV+ds/o
2SoXoo9B0thzQMy4McsSJ6eipSCdsNpoSwF1SR3Sd/YzcjJ9V6zqw5HHQK2iUtys
1iNUvdcxLdMs0X6484l9H1uNOBWrX7OVKUZIOEiE94I0yiocPdQvqnNhBEOKDVmE
UFEfpqGYu24BH0ssmMbV6DCwZlaymKefV3n8uQWwNYaahWvQ3r0lj3WVXmFZTzeo
08yGnOs7ztyR4sQaFTgHwcbAr6K/Xs2J8aFTDlaI2ykuk9af2VYoP8OFoHmPxVko
9MfQTOYNjQi2FyY544gCWRvomZYpmuOF0Pnw1+WQCdK5MNv+6T4bK80x+/EcNiDv
8Ge+2svSTHSV6IM69M1Jdj+QFEs5eC2U9GATgbxBVccXu0XkyZcUCSacQt3RWLkm
+qh79wqS+qs3iRAyuIcdRkIZ5dVXzsePHS7LGOKM1xiRdUXB5gQzD+3bFOj4YPP9
JJzEWERrBb1XIDUE3QWZ
=z/68
-----END PGP SIGNATURE-----

--wtjvnLv0o8UUzur2--
