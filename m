Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab2CGLqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:46:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43528 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756882Ab2CGLqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:46:34 -0500
Date: Wed, 7 Mar 2012 11:46:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/lapis: add platform driver for ML7213
Message-ID: <20120307114631.GE3107@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
 <1329976011-2251-2-git-send-email-tomoya.rohm@gmail.com>
 <20120302163915.GD6056@opensource.wolfsonmicro.com>
 <CANKRQni8hPoHEsV2VecbgKBdfS5+rit0-jXzz_d8F_nY5-dN3g@mail.gmail.com>
 <20120306115246.GD19635@opensource.wolfsonmicro.com>
 <CANKRQngg+8LJvb-+Byv6XPqqWFyCU1U+-hppuxo_=CM1qLUF_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SxgehGEc6vB0cZwN"
Content-Disposition: inline
In-Reply-To: <CANKRQngg+8LJvb-+Byv6XPqqWFyCU1U+-hppuxo_=CM1qLUF_Q@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SxgehGEc6vB0cZwN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 07, 2012 at 10:30:05AM +0900, Tomoya MORINAGA wrote:
> On Tue, Mar 6, 2012 at 8:52 PM, Mark Brown

> >> if these platform devices aren't used, device detection doesn't work c=
orrectly.
> >> So, I added these.

> > You've not actually mentioned the problem you were seeing...

> I saw mapping problem between machine driver and platform driver.
> e.g.  cpu_dai_name "ml7213ioh"

You've still not explained the problem you're seeing but this sounds
like something that should work.  Please address the

> > Apart from anything else you've got the interrupt requested as
> > IRQF_SHARED so the interrupt could get called at any time. =A0It's also
> > not clear that you've got the hardware in a known good state.

> Do you mean request_irq should move to somewhere, like open() or
> hw_params() or ... ?

You need to do enough hardware and software initialisation prior to
requesting the interrupt to ensure that if an interrupt does happen it
won't cause any ill effects.  Checks in the interrupt handler to make
sure things like the ALSA layer stuff have been set up can also be used
to make the interrupt handler safer.

--SxgehGEc6vB0cZwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPV0qQAAoJEBus8iNuMP3d9kcP/2yo8o1Xczs+p5ql8OHX3G+X
hTuK8IljSTK44DJKoNPxwhet5qJml05OjqZEH3sjb5VSCG029tfgHJiZ8ga/wL1D
+vga8M/y8y8Lmo3PJ1IFZ/wpSXJMiWQxKBMOfMdLsFs2K9WWzXwo+OHdfSGG4GSs
U7rjBFIXtwaLxNWKYIphG4M+CV0Fg6ibwtTsy9vrYA0+F9+taC0N+n8k2ZhLYBgy
Y/8RP87Ay0iqC+kkPKakR9gdkdstXYCj2kymzOd9sKomt9lyuBuuN0wu4CZjuSEg
LeIS3IVXncx30qONI4wy/iBMWFTNqeXLAje5MRSAPvuCdEsHloB5L8LZD2VP+3Fl
+B3JdOhd3KdXl7UoO2+AZsI+wJASzXcFrXbt+ykvwEJv0ewY/LFItKfhlqWpQfES
AO/a22I8RlVO5T3f8bTdXWJegMKlkLQUcYebFJ5O4vTbYUENJHY2PCTf3xiy/BMK
riVPbb1Bz6utin+fbFZsP8DG/iZcu7bgnYzH2LAl9mJYv8WzEeJojLzYApyq72Ky
Mew58cyQ8EANMSfscw/ApNnpfeZMjbJtP5xdrxYN1t03YRxP6/OrRxC9tQ2/xysc
Q8izVNXhgl1MBGoY7pXgj2Y1RBNkGCUZl+rluuzsMrcX6zyRtMWSCCfRgxjeKxeL
nVJNfg0x8UMz4j4m8I88
=BC/K
-----END PGP SIGNATURE-----

--SxgehGEc6vB0cZwN--
