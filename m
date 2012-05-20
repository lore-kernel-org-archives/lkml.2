Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2ETJBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 05:01:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50530 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858Ab2ETJBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 05:01:16 -0400
Date: Sun, 20 May 2012 10:01:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
Message-ID: <20120520090112.GE16590@opensource.wolfsonmicro.com>
References: <4FB7D4D8.2050501@nvidia.com>
 <4FB7D676.9000609@nvidia.com>
 <20120519174052.GX4039@opensource.wolfsonmicro.com>
 <4FB7DEB0.3040001@nvidia.com>
 <20120519182658.GB4039@opensource.wolfsonmicro.com>
 <4FB7EE84.7090704@nvidia.com>
 <20120519205055.GA16590@opensource.wolfsonmicro.com>
 <4FB80CEE.4050201@nvidia.com>
 <20120519231347.GD16590@opensource.wolfsonmicro.com>
 <4FB89E6D.7000206@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ns7jmDPpOpCD+GE/"
Content-Disposition: inline
In-Reply-To: <4FB89E6D.7000206@nvidia.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ns7jmDPpOpCD+GE/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 20, 2012 at 01:04:05PM +0530, Laxman Dewangan wrote:

> By executing the following code in tps65910-regulator.c, ptobe(),
>                config.of_node =
> of_find_node_by_name(tps65910->dev->of_node,
>                                                         info->name);
> is always returning NULL.

> This is because the info->name which are "ldo1" or "ldo2" are looked
> on the parent node i.e. pdev->dev.parent->of_node, not inside child
> node "regulator" of pdev->dev.parent->of_node.  The function

No.  This is happening because the device tree doesn't have any supplies
mapped for the regulators.  This is nothing at all to do with where the
code looks for the supplies, no matter where it looks there's nothing to
find.

> of_find_node_by_name() only looked for props on that node
> ("tps65911"), does not search from child node "regulator".

This is exactly what I'd expect it to do.  Why would it do anything
different?  Why does it make sense to change the code rather than map
the supplies where the code is currently looking for them?

> So for fixing this,
> The search for info->name should start from the child node
> "regulator" of the "tps65911" to get proper regulator of_node for
> for regulator being register.

You keep saying this but you're still not giving any motivation at all
for making this change.  It's *vital* that you explain why you want to
make this change.  Simply saying that this is the "proper node" over and
over again doesn't do that.

>         ldo2_reg: ldo2 {
>             ::::::::
>             /** regulatr entry */
>             ::::::::::::
>             ldo2-supply = <&ldo1_reg>; /* So ldo1 supply the ldo2. */

This mapping should be moved up to the chip top level; this is just like
any other supply for the chip.

> ldo1 registration went fine.
> During ldo2 registration, I passed the regulator_desc->supply_name as ldo2.

I'd be somewhat surprised if this is what the pin is actually called,
idiomatically the supply name should be whatever the pin is named on the
chip.

> Here we are passing the config.dev = pdev->dev.parent.
> And hence the config.dev.of_node is containing the node of "tps6511".

Of course, what's the problem here?

> Does following change in core.c make sense to handle the case where
> config->of_node and dev->of_node is not same? Here we still use the
> dev which is passed by config->dev and make use of config->of_node.

But *why* do we want to use config->of_node?  This is the bit that's
missing, you keep on repeating that this is the "proper node" over and
over again but you've not been explaining the reasoning behind this.

Supplies for regulators should be no different to supplies for anything
else in the system but you're trying to add a special case for them.
This isn't obviously sensible.  What makes them special?

--Ns7jmDPpOpCD+GE/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuLLRAAoJEBus8iNuMP3d63sP/1poHHOJmHj+IgtsJaOvG6z0
YeeH8E7Cy2XJ8Y3JpIGbzjsruWXll3muy49a0yXj5XgSrYK+RGtdZL9FKtr1f32C
3NAbizv1LytQ6vyVF9N745QRdFptdmv4NodK7AkHu7SjGIsVsxXgmdE+xKH+3dur
10tftxsmo23yzxwDipZRSnHVKb7m4V/emj3BxSI+G8cc1F9k43Toib5H5TM54Ipz
ajhrljrWSTZVtnOqzayv6YXc/KIhyenKwkKC1h5AGjBl+4hFpdy36nkp4RGZKqv5
28ssLEys7wBGT35IuJqSz3GYpNoJnBzZuut2zYkKdmCZiwZ5vYVtrnLSBehuxWZv
tPmGoVuf+AofsAA2jyRtdmf1klNiqORYqWKjP9l63Du0JOXuneDV71Nn/nG96g6O
jTRZS0+mHAyquFIRt0XjNgbeH8zV8j6WRjnF2D/ex7DrVSVMYsAm43glWEOHhUKq
7uF9RWXRP78k+ksycMD1qRb+oP3BfsUrk1dfYuEQICf+sPLwtmhFv7PAdlDRTB9B
B4px8pfNA7YFph35tK8qYajbVJx/geGfUs+kf8V90P4HTD/tnIKP1u20KtlVZYgc
84J6TT+Gt+IwJGdITQSgSO+3Gyo3tP42Y+IUHgT2NyPQ70H3cjIPDrKz+ULm4cRK
FupzZ0E0dqvXQRumTSDE
=JGcr
-----END PGP SIGNATURE-----

--Ns7jmDPpOpCD+GE/--
