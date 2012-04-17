Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2DQCCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:02:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36477 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2DQCCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:02:47 -0400
Date: Tue, 17 Apr 2012 12:02:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: Will Drewry <wad@chromium.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (security tree related)
Message-Id: <20120417120233.5be055e2821d71b3eadd0149@canb.auug.org.au>
In-Reply-To: <alpine.LRH.2.02.1204171127130.14814@tundra.namei.org>
References: <20120416154607.302f7ae245472e1e917dacef@canb.auug.org.au>
	<CABqD9hauxzd4vVbxyC5M1p9e6mLt1cjYP7wbhzTKPi3iMpc0kg@mail.gmail.com>
	<CABqD9hYhC3dNX3CVSbsuJaG=zBUC4VMyMVYYmyOTN+Xfb=uC8w@mail.gmail.com>
	<alpine.LRH.2.02.1204171127130.14814@tundra.namei.org>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Apr_2012_12_02_33_+1000_GcEHLSP.GHGS3Z0v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Apr_2012_12_02_33_+1000_GcEHLSP.GHGS3Z0v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Tue, 17 Apr 2012 11:33:26 +1000 (EST) James Morris <jmorris@namei.org> w=
rote:
>
> On Mon, 16 Apr 2012, Will Drewry wrote:
>=20
> > >> arch/powerpc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
> > >> arch/powerpc/kernel/ptrace.c:1713:2: error: statement with no effect=
 [-Werror=3Dunused-value]
> > >> cc1: all warnings being treated as errors
>=20
> Is this happening because of
>=20
> 	#define secure_computing(x) 0
>=20
> ?
>
> In any case, that should probably be a static inline.

That could well be so - sorry I missed that.  The failure was in an
allnoconfig build, so CONFIG_SECCOMP was off.

And yes, changing that to:

static inline int secure_computing(int this_syscall) { return 0; }

fixes the build problem.  So that is a better fix.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Apr_2012_12_02_33_+1000_GcEHLSP.GHGS3Z0v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPjM85AAoJEECxmPOUX5FEGE4P/2pcZF7iaiI7bil1p44ikEDi
jRRG+EYE4X/5D1WV8DWH/Rm5OrvbZPOqe+qy5VIOIcpOvDm/1bO5yckf2eoweQuz
jCcY79OceABxZZdACmVdQa+5VIvDosb7USPOWjLXIqOehgb8g1IqL8ThE1GTGRs6
qUr75dxf2p8huAGq2zB7Pqylj+tJcwv2Pb7EUXRdC2zp2vplbhQbcywkCwTfuieX
WISInGXkrJp/pMXM/8mbGX4Sn7/Kt3Y44YQfnByX0ZcCuedTC8wChTTVW41EuBPg
uo9X6CSrTofyk4xCy0d2+KHdv+w6TGShUDxRJzxm07sbcJIII4K10KYmUGffS4Xb
bc6bZF2oyqOz10wSZJfipVE4aTGIa6hqQFJ2Liaov5cPmd+pIExSFL4PPBkHp8e7
5oLbL+8nfIK/8qm6ZRbjwYhhTN+3HnzPn7eZVcz3aUYZ0ZLOGbkKmtdeRwErXzkQ
l8CuSkIPdrzB3tmYL2C6ZfK4eZNcacXNrptuZAUf9/4H/YKJYtOM3nImPC+qfQ1+
HxdkAGeU4I0ov9J+geQyL14aWzWYsYPMiqkqm5+eiGqfZp1UqseSnyN/r6cAD3W0
yazgNFFkJ2suhVy2qQk61eD7jdq3m/5Qd2/KwHuXKI5vsCyDjOBoLElA6Zbg4rmO
qP9rC+7Lf22uLI8oA+Rf
=1U/p
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Apr_2012_12_02_33_+1000_GcEHLSP.GHGS3Z0v--
