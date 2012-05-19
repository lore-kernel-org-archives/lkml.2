Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab2ESXNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 19:13:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48746 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755197Ab2ESXNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 19:13:51 -0400
Date: Sun, 20 May 2012 00:13:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
Message-ID: <20120519231347.GD16590@opensource.wolfsonmicro.com>
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com>
 <20120519164134.GT4039@opensource.wolfsonmicro.com>
 <4FB7D4D8.2050501@nvidia.com>
 <4FB7D676.9000609@nvidia.com>
 <20120519174052.GX4039@opensource.wolfsonmicro.com>
 <4FB7DEB0.3040001@nvidia.com>
 <20120519182658.GB4039@opensource.wolfsonmicro.com>
 <4FB7EE84.7090704@nvidia.com>
 <20120519205055.GA16590@opensource.wolfsonmicro.com>
 <4FB80CEE.4050201@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+B+y8wtTXqdUj1xM"
Content-Disposition: inline
In-Reply-To: <4FB80CEE.4050201@nvidia.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+B+y8wtTXqdUj1xM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 20, 2012 at 02:43:18AM +0530, Laxman Dewangan wrote:

> For mapping, the node should start from "regulators", not from pmu
> on this example.

What makes you say this?  I'm really not even sure what it means.
How does a node "start" from something?  Supply mappings are direct
links between consumers and regulators.

> Here my understanding is that config->of_node should contain the
> node information of the regulator being registered only. In DT case,
> it should not be null.

Right, but this is unrelated to what we're doing when the regulator is a
consumer.  Then we just do the same thing as regulator_get(dev, name).

> >I still don't see any change needed here, from the above it simply looks
> >like the supplies aren't set up.

> Unfortunately,
> My regulator_get is failing if I dont correct the above logic to
> have proper config.of_node.

But this seems like it is unrelated to the patch we're discussing!  Your
patch does nothing to config.of_node, it changes the device used to look
up the supply.  To repeat yet again:

| context of the class device we create.  I can't think of any situation
| where I'd expect that to make matters any better - the class device
| should certainly never appear in the device tree and isn't going to have
| a stable name for non-DT systems either.

*Please* engage with this, especially the non-DT part.  You need to
explain how what you're saying is related to the patch you posted, you
keep talking about a "proper" config.of_node and saying this happens to
make your system work but this isn't visibily related to the patch you
posted.

What is not "proper" about the of_node that was supplied for the
regulator being registered?  In what way is this related to the device
used by the regulator functioning as a consumer to request a supply?

--+B+y8wtTXqdUj1xM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuCklAAoJEBus8iNuMP3dAF4P+wZkXJ39366YQpG6R4i/NoYg
vYX+lPSNvrLeY2o1nkx0oYXNG2Woj8sj1OA1kJ3nn28lckAlVX4iMhFoAGwvZWEK
MAVuhP/ioQ7sv0LKrTL8Vzpn/NRSJk/sVowOWSmwkBafIUJUxARLRP26fOdO5+/+
b2joBlWCVQyu/sSx29Kg7x7ROXwOXW2IvgfWLpifA73xM/r5zSVhvTv51C4svzUa
hhIobcrjH9BGOr/GzV3aFFoi2xvbYftbi2qTyl5uaRzrmyRjJd5+mmojwo57DGPD
FwJ0AkbaD2py2yFviiExtbLgUlKZMLtGJSpp/lpqETHJZGIphGCzW3MNniAul/ri
eDM3TrKuoxGogHC4eYT9vWHPt8ZGgvyAP7rUl3/Kz0vvMI7bWrzwwVSTgleomwyv
PlI3pd2Kfn6zt0/Q8JvGeHKUZwAlPsjY5dW+MetTRVmRjyRYYa6ShILbI/NvdwVf
X67GyM+fKbHi/uxMPlzQsLsZGNeM3h5LaVASZoVNawdLeRF2p98/Xn9R81ekLGLb
vuqdjWMEdGUM062z0FM+lTRgoQI0aTihPXN2jdOJrdSOHwxPN2lxoL9on8CfLRTx
jdWq1i4Sh1NknMeoJBYqijI4V2hmSk+ZiACHzQSKl7zis37QyP/EDWTVYkXwFaBy
Fr8BsQt5S6tMMKJoszf+
=7sg4
-----END PGP SIGNATURE-----

--+B+y8wtTXqdUj1xM--
