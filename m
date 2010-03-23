Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0CWNXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:23:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42295 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351Ab0CWNXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:23:12 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-s390@vger.kernel.org,
       linux-sh@vger.kernel.org
In-Reply-To: <20100323074546.GK13417@linux-sh.org>
References: <1269126097.18314.111.camel@localhost>
	 <1269126340.18314.115.camel@localhost>
	 <20100323074546.GK13417@linux-sh.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JxBzKjEiI/A3c1PVSdDJ"
Date: Tue, 23 Mar 2010 13:23:00 +0000
Message-ID: <1269350580.18314.260.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 2/4] panic: Allow taint flag for warnings to be changed
 from TAINT_WARN
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JxBzKjEiI/A3c1PVSdDJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-03-23 at 16:45 +0900, Paul Mundt wrote:
> On Sat, Mar 20, 2010 at 11:05:40PM +0000, Ben Hutchings wrote:
> > WARN() is used in some places to report firmware or hardware bugs that
> > are then worked-around.  These bugs do not affect the stability of the
> > kernel and should not set the usual TAINT_WARN flag.  To allow for
> > this, add WARN_TAINT() and WARN_TAINT_ONCE() macros that take a taint
> > flag as argument.
> >=20
> > Architectures that implement warnings using trap instructions instead
> > of calls to warn_slowpath_*() must now implement __WARN_TAINT(taint)
> > instead of __WARN().
> >=20
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > The architecture-specific changes here are untested and need to be
> > reviewed by architecture maintainers.
> >=20
> I'm a bit confused about how this is supposed to work, the TAINT_xxx
> values are bit positions presently from 0 to 10, while BUGFLAG_xxx are
> ranged from 0 up. You've set up BUGFLAG_TAINT() to that the TAINT_xxx
> value is shifted up 8 bits but neglected the fact that the trap type is
> 16-bits on most (all?) of the platforms using trap-based BUG handling.
>=20
> If the 'taint' in question is just the TAINT_xxx value by itself and will
> never be a bitmap then that's fine, but there's certainly not enough room
> to pass the bitmap in on top of the bugflag otherwise (I don't know if
> this is your intention or not though).

Yes, the taint value must be a bit number not a flag.  Sloppy wording on
my part.

> Also note that some platforms (like SH) implement additional bugflags, so
> we at least want to keep the lower byte available for architecture
> private use.

I noticed, that's why I started at 8 not 1.

> Having said that, the current patch does work for me, although I'm a bit
> nervous about someone thinking it's ok to pass in a taint bitmap here.

We can maybe use BUILD_BUG_ON() here as the taint bit is already
required to be a compile-time constant.

Ben.

> Tested-by: Paul Mundt <lethal@linux-sh.org>
>=20

--=20
Ben Hutchings
Any smoothly functioning technology is indistinguishable from a rigged demo=
.

--=-JxBzKjEiI/A3c1PVSdDJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6jAsue/yOyVhhEJAQKuLRAAo8lRcJIYqpklZT6Ct5UkFmnwQBWniN/J
O8B6FmzAV8e44xkctJegxtmxMBQETjVOmcR6YC0KtzZXQ1VRSzF7kNaQ1i4V5uXn
aBSXf82IxdIs7h9wDWqOH2uXtrheLeEhKTvTyGKEzGsc0t28l2cMUocxsjlFU8VW
oAenqoHUbJAkPvpC1fP8bT42C9rxm5AcO/py0pyqtC+gPaOs/J+606IClqlE4bXi
ZHltMfpoFzBWQLJ7ZB7Aeu1vwFozybSfeoz9/p54BjMhcRcmQTaTSBUfKeyC5EsS
Q8GbKYFtIwKhdnLJ9QNfuiO+0u3/G3dkPHRWVJdivNpplncsrYYTDlKJV+ivRtV1
6xuJVjIONPh5VwEHkqEbYfEdqf9WFHvUbDWOxeMjQ82vuzObFDgR97oIFcwu5X+e
Qbl8XVnRQtk3BhblMnfrDBuwYuudgqMaiuTwYSmQWAoJpL5ftwQRXXYszFrHWVkA
wMVUL9V+Cke4xkvxt0szxBo7y20Je+6OnOj/u3G04cK2f2gdAG7yWXm1x6K5jxjc
OIVB/hzMuLLT3oW9h/gy3OT617X8wz5W83oqH8jcxsBG34QmpWuCYvhXFWF1DkAg
vbxLwPzg4JYcxLjpsJ5ZGuREyf+DQVGu323BV9IdR/JHUahaI73bZ1/L9jo7VKSw
IPYASs3GZ2M=
=xrOe
-----END PGP SIGNATURE-----

--=-JxBzKjEiI/A3c1PVSdDJ--
