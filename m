Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1CHRQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 12:16:10 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51168 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab1CHRQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 12:16:07 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Michel =?iso-8859-1?q?D=E4nzer?= <michel@daenzer.net>
Subject: Re: [regression] 2.6.37-post-rc7 with radeon kms: reproducably locks up hard when using desktop cube of kwin
Date: Tue, 8 Mar 2011 18:15:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7-tp42-snapshot-p1+2-00163-gfb62c00-dirty; KDE/4.5.3; i686; ; )
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        DRI <dri-devel@lists.freedesktop.org>
References: <201103051510.35057.Martin@lichtvoll.de> <AANLkTim8kRi8twRJmAZRQs6WhJin8cMMp70mBV+cpLQX@mail.gmail.com> <1299580669.14068.219.camel@thor.local> (sfid-20110308_163828_651397_1E6F50A0)
In-Reply-To: <1299580669.14068.219.camel@thor.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12406007.ZOnpCmsdst";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103081816.00235.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12406007.ZOnpCmsdst
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Tuesday 08 March 2011 schrieb Michel D=C3=A4nzer:
> On Die, 2011-03-08 at 19:40 +1000, Dave Airlie wrote:
> > On Tue, Mar 8, 2011 at 7:35 PM, Martin Steigerwald=20
<Martin@lichtvoll.de> wrote:
> > > Its rainy again in Sevilla...
> > >=20
> > > Am Sunday 06 March 2011 schrieb Dave Airlie:
> > >> > I verified this. Lockup happens with 2.6.38, last one tested
> > >> > rc8-gfb62c00, but not with 2.6.37 with exactly same userspace.
> > >> > Needed to try the effect several times, as this time the lockup
> > >> > with 2.6.38 only happened shortly after the second activation
> > >> > of the effect.
> > >>=20
> > >> Hmm, can you attach Xorg logs from both?
> > >=20
> > > Attached. I have dmesgs available as well. Both kernels are mainly
> > > upstream. The 2.6.37 contains some recursive mtime patches from Jan
> > > for Ext3/4 that are very likely unrelated. For 2.6.38 I am testing
> > > too hibernation patches from Raphael, but the lockup also happened
> > > with a plain vanilla 2.6.38 one before.
> > >=20
> > >> I'm guessing its either pageflipping or a later kernel allowing
> > >> some feature of mesa to be used.
> >=20
> > Okay can you try using an xorg.conf with Option "pageflip" "false"
> > set in it for the radeon.
>=20
> That should be
>=20
> Option "EnablePageFlip" "false"

So the desktop cube runs absolutely stable with 2.6.38 when I disable page=
=20
flipping. The hang just happens with enabled page flipping. But beside the=
=20
desktop cube I had no other hang with page flipping enabled.

If its not related to exact gfx chip, it should be easily reproducable:

=2D install kwin

=2D kwin --replace your current window manager

=2D make sure composoting is enabled if it isn't=20

=2D Ctrl-Alt-F11, maybe hang happens on the second time, not on the first,=
=20
but hang should happen quite reproducably

My compositing settings are:

martin@shambhala:~> grep -A 13 "\[Compositing\]" ~/.kde/share/config/kwinrc
[Compositing]
AnimationSpeed=3D3
Backend=3DOpenGL
CheckIsSafe=3Dtrue
DisableChecks=3Dtrue
Enabled=3Dtrue
GLDirect=3Dtrue
GLMode=3DTFP
GLTextureFilter=3D2
GLVSync=3Dtrue
HiddenPreviews=3D5
OpenGLIsUnsafe=3Dfalse
XRenderSmoothScale=3Dfalse

(I disabled checks whether compositing is performant or safe enough=20
sometime ago, as KWin did not enable compositing otherwise, maybe due to=20
performance reasons. But from what I know OpenGL compositing should be=20
pretty safe on my chipset.)

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart12406007.ZOnpCmsdst
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk12ZEEACgkQmRvqrKWZhMdr+QCfXxtRr9cw0Rf7KlPJhiXYPoB2
cNUAnioHUQM7VSFp7AO++Y4pJpFln6Cs
=RNl9
-----END PGP SIGNATURE-----

--nextPart12406007.ZOnpCmsdst--
