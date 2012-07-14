Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab2GNESd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 00:18:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54898 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab2GNESa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 00:18:30 -0400
Message-ID: <1342239493.25597.461.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Ben Hutchings <ben@decadent.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jul 2012 05:18:13 +0100
In-Reply-To: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1m06UcTE7rcZIWY+cmuH"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1m06UcTE7rcZIWY+cmuH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-07-13 at 13:37 -0700, Linus Torvalds wrote:
> So this has long been one of my pet configuration peeves: as a user I
> am perfectly happy answering the questions about what kinds of
> hardware I want the kernel to support (I kind of know that), but many
> of the "support infrastructure" questions are very opaque, and I have
> no idea which of the them any particular distribution actually depends
> on.
[...]
> The point I'm slowly getting to is that I would actually love to have
> *distro* Kconfig-files, where the distribution would be able to say
> "These are the minimums I *require* to work". So we'd have a "Distro"
> submenu, where you could pick the distro(s) you use, and then pick
> which release, and we'd have something like

I like this idea in principle.

[...]
>  - distro/Kconfig:
>=20
>     config DISTRO_REQUIREMENTS
>         bool "Pick minimal distribution requirements"
>=20
>     choice DISTRO
>         prompt "Distribution"
>         depends on DISTRO_REQUIREMENTS
>=20
>     config FEDORA
>     config OPENSUSE
>     config UBUNTU
>     ...
>=20
>     endchoice
>=20
> and then depending on the DISTRO config, we'd include one of the
> distro-specific ones with lists of supported distro versions and then
> the random config settings for that version:

You might also want to *un*select some options like
CONFIG_SYSFS_DEPRECATED and CONFIG_SYSFS_DEPRECATED_V2 that need to be
set one way or the other depending on the version of udev.  (I think
it's possible to kluge this with the addition of a hidden negative
config option.)

How about stuff like NET and INET, that every distro will need and yet
is configurable even without EXPERT?

[...]
> Sure, you can copy the config file that came with the distro, but it
> has tons of stuff that really isn't required. Not just in hardware,
> but all the debug choices etc that are really a user choice. And it's
> really hard to figure out - even for somebody like me - what a minimal
> usable kernel is.
[...]

And it's still hard for me as kernel packager: just because an option
was requested and enabled to support some bit of userland, doesn't mean
I know what's using or depending on it now.  (I think Dave Jones made
this point already.)  I'm not usually concerned with *minimal* config.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-1m06UcTE7rcZIWY+cmuH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUADzBee/yOyVhhEJAQoTPhAAs6VogZTgrfn3HOJpD88ngO3iVFp6ebch
CD2sw8ytTx6CnEEJfpAWz2miO6ugmPMyGRYQ1tXe78xUkv1U2Vmyx+vWdlcc3E2i
7UPg8C0J9P5gzgNmB5J1fy9mNZIYfgm3AE69rgmuqNmrc+A05BK3ordMrM0TU7//
BtRqSbr4wo51VGcryqEJnpbwYRY9YZ1rM8ncDd0KKDUVSiD+f/NvaqA6DHtaxvPj
2NVIQBomWY9iUwdzXhNLNvDVL+40AL7gi6pMpzcXh6PmUW3bgXDDSP88orXbgKa8
cCB1vpIQp3WBYRIyWjXsTKdxBq5MS6F9MHJl40YzMf4cnvcKfD7Nc7eFoFWGYhFu
8YiQyn2DV7WdsCPnprQWZ9fVFAlRB23Bhpl2i7CbHIvQeiZBs51iBgFLdSXmVHDu
wOh7QRBjHVY4FEeWa+1g5RwrD+pMKzmXQpUPFYs1vaJqChKJW3dF6796BWmpGfTP
ISD0Ks+dOESLdCZVBm67MItjkgEHJr7ZhOVdaYvoZd4t1/FHwwslSD61aSaSj0ob
Lot5mHA0A+AVPOB1ZC5SZBc0+UrNxetZpnAf9X8jLKR0Fs12mnBot7wP9Fs17IH1
wTZIhZCGX/tBA58lfrPdESOhZ5LSQn/iOEifq8a97UaIhEmS0qNggbb1Jy4DR1cY
pTb9bqu7Wyc=
=jH6F
-----END PGP SIGNATURE-----

--=-1m06UcTE7rcZIWY+cmuH--
