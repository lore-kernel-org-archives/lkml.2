Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959Ab1FWX4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:56:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42532 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752Ab1FWXz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:55:59 -0400
Date: Fri, 24 Jun 2011 09:55:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-am33-list@redhat.com, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] STAGING: Comedi: Build only on arches providing
 PAGE_KERNEL_NOCACHE
Message-Id: <20110624095542.e05698b4.sfr@canb.auug.org.au>
In-Reply-To: <20110623114536.GA14011@linux-mips.org>
References: <20110623114536.GA14011@linux-mips.org>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Jun_2011_09_55_42_+1000_t.eUmnEAvhaT_nyS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Jun_2011_09_55_42_+1000_t.eUmnEAvhaT_nyS
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

On Thu, 23 Jun 2011 12:45:37 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:
>
> On architectures that don't define PAGE_KERNEL_NOCACHE, the Comedi driver=
 turns
> into tragedy:
>=20
>   CC [M]  drivers/staging/comedi/drivers.o
> drivers/staging/comedi/drivers.c: In function =E2=80=98comedi_buf_alloc=
=E2=80=99:
> drivers/staging/comedi/drivers.c:505:41: error: =E2=80=98PAGE_KERNEL_NOCA=
CHE=E2=80=99 undeclared (first use in this function)
> drivers/staging/comedi/drivers.c:505:41: note: each undeclared identifier=
 is rep orted only once for each function it appears in
> make[3]: *** [drivers/staging/comedi/drivers.o] Error 1
>=20
> Restrict the driver to only those architectures that define PAGE_KERNEL_N=
OCACHE.
>=20
> PAGE_KERNEL_NOCACHE is a kludge - some system architectures such as SGI I=
P27
> are even uable to offer uncached operation - at least in the way an unwit=
ting
> driver might assume.  I haven't looked in details how the driver is using
> the area vmaped with PAGE_KERNEL_NOCACHE but maybe doing it XFS-style usi=
ng
> cached memory and the flush_kernel_vmap_range / invalidate_kernel_vmap_ra=
nge
> APIs in conjunction with the DMA API is a practical alternative.
>=20
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Since Greg is on vacation, I will add this patch to my fixes tree in
linux-next until a better fix comes along (if there is one).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Jun_2011_09_55_42_+1000_t.eUmnEAvhaT_nyS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOA9J+AAoJEDMEi1NhKgbsFfkH/iXyBLKfo00uV5ym/QNH51Eb
Xt8PeJ6xp1AevCgm94ei9jpIodgeyH7YVo1dJhyD6dI7Z8hPC6mTkcMytnM/ou5F
+rAajf1T+qWBSJvft+1U1LZu4bae9zl054lkEnMx8Vwj5lhWALuI+NI92F8wNUwV
M1aO1fyyOHiIDwNJZEn0iJ3XxCnwdm1MFNiujlqacapfoBSjpClBSS/S+RJLT7Wr
SkmuMnI/6/RbknFR6gpyn3GnzjeTslUVUYBgS42rV9chaEWotT+spgpvpmYdyMEq
rhucb+lutMAKr/kLpqONBoJS98zOCFH3PputZU13oB3TYGi8Iv9eeklFpqG9048=
=OrXa
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Jun_2011_09_55_42_+1000_t.eUmnEAvhaT_nyS--
