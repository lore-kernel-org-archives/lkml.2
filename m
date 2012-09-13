Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2IMIbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:31:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53453 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2IMIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:31:09 -0400
Date: Thu, 13 Sep 2012 18:31:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120913183106.a154a63a75cef8efa03317ad@canb.auug.org.au>
In-Reply-To: <20120913005657.1ae79a95.akpm@linux-foundation.org>
References: <20120913174441.f5fbf5cc38713425331f4d86@canb.auug.org.au>
	<20120913005657.1ae79a95.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_18_31_06_+1000_2iRWqO/XAh19Q7DZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_18_31_06_+1000_2iRWqO/XAh19Q7DZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 13 Sep 2012 00:56:57 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Thu, 13 Sep 2012 17:44:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
>=20
> > After merging the akpm tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/thermal/cpu_cooling.c: In function 'get_idr':
> > drivers/thermal/cpu_cooling.c:89:14: error: 'MAX_ID_MASK' undeclared (f=
irst use in this function)
> >=20
> > Caused by commit "idr: rename MAX_LEVEL to MAX_IDR_LEVEL" from the akpm
> > tree interacting with commit 78edc7cdcf5e ("thermal: add generic cpufreq
> > cooling implementation") from the thermal tree.
> >=20
> > I have applied the following merge fix patch and can carry it as
> > necessary.
> >=20
> > ...
> >
> > --- a/drivers/thermal/cpu_cooling.c
> > +++ b/drivers/thermal/cpu_cooling.c
> > @@ -9,7 +9,7 @@
> >   *  it under the terms of the GNU General Public License as published =
by
> >   *  the Free Software Foundation; version 2 of the License.
> >   *
> > - *  This program is distributed in the hope that it will be useful, but
> > + *  This program is distributed in the hope that it will be useful, bu=
tX_ID_MASK
> >   *  WITHOUT ANY WARRANTY; without even the implied warranty of
> >   *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> >   *  General Public License for more details.
> > @@ -86,7 +86,7 @@ again:
> >  	else if (unlikely(err))
> >  		return err;
> > =20
> > -	*id =3D *id & MAX_ID_MASK;
> > +	*id =3D *id & MAX_IDR_MASK;
> >  	return 0;
> >  }
>=20
> Confused.=20
> http://ozlabs.org/~akpm/mmotm/broken-out/idr-rename-max_level-to-max_idr_=
level-fix-3.patch
> already does this.  How did that change get into the wrong place?

So, ignore the first hunk above, that was my typo. =20

Here is the chunk of the series file I have:

idr-rename-max_level-to-max_idr_level.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
#NEXT_PATCHES_END
#
linux-next.patch
i-need-old-gcc.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
#
#NEXT_PATCHES_START linux-next-urgent

So idr-rename-max_level-to-max_idr_level-fix-3.patch is excluded form
linux-next :-( I guess I need to just move that further down in the
series file?  Though when you send the preceding three patches to Linus,
that fix-3 patch will be needed when I merge the thermal tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Sep_2012_18_31_06_+1000_2iRWqO/XAh19Q7DZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUZnKAAoJEECxmPOUX5FEfioP/A2nuAuTKxFdEuvxaew8Mp+L
ClM6b/fjRTAJnbKGyBfitRfe76Na5Hdjw7oohPYOPA2gLYBHSsGo2fMrhtFMeCMp
5i3Byv91q/PrsJp9uddGtBQBxMMVC3Xs1woLNgHmd5KFoWX8tDDu4rrXqfLN2jFx
TSTqV4dcAAQ10IW+VF8PSXkGFKUJ7Yl+/9ZivyjajwfdzABrBM+PcH7hzaIYfl1h
iDCZjeF+5T0MopnPkTHULhvCScbSEaDfaZ/uI7rdJ40Q4fw2VdAYi0FTn5gLWz+O
cPNfEXdyEvDgWHfDa6qqgt3jLraFJzn29jpuQXd46WCKnK4JqOCrdwSL14uRM3tq
7df+/2yDJwmuLQ3637AIzbloUdRj11rEVeEuI0+VBklRJibgB3/SndyuCYOp9Lt5
kc8FTBeLF4UvugLwazHkzoTRgVN0/Z5p1yek1ybSpiJ1n0RRt4PrT8AQMR4lZKQ/
CZQRR8oYAF3f2fOhKpV+7ESIGHaOzwoUe9Z/0NFHl67xxLQU0Wt8++Uf3UtqhJkS
ZFLiFLKpfcWliGe/83lQOVIFQtu1Wh6nC7mtk7AVZ1PD6QZl9xU0RNxzjk3wEidk
QPUK4PfRdvdWkNycEM+arxF06qFW2tup6jjWDPLvBGLnUz5R2+IXS3dEmP0zLSAm
qHjF122fMIbe7lpdQ6Rj
=Fctw
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_18_31_06_+1000_2iRWqO/XAh19Q7DZ--
