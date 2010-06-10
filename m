Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0FJBLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:11:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45622 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033Ab0FJBLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:11:42 -0400
Date: Thu, 10 Jun 2010 11:11:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [kbuild regression, post-rc1] Remote installation over
 read-only NFS broken
Message-Id: <20100610111135.5a24e082.sfr@canb.auug.org.au>
In-Reply-To: <20100607211630.GA3902@sepie.suse.cz>
References: <201006071110.26245.rjw@sisk.pl>
	<alpine.LFD.2.00.1006070732170.3515@i5.linux-foundation.org>
	<20100607211630.GA3902@sepie.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Jun_2010_11_11_35_+1000_NyW8TpTpKgwMeADd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Jun_2010_11_11_35_+1000_NyW8TpTpKgwMeADd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Mon, 7 Jun 2010 23:16:30 +0200 Michal Marek <mmarek@suse.cz> wrote:
>
> I can fix both issues by the below patch, but then it reintroduces the
> issue Eric reported to me with the original approach:
>=20
> | And indeed it's strange - while scripts/Makefile.build doesn't fail
> | since
> | there seems to be a script that generates some Makefiles in between
> | the build process, I'll get this figured out to see what is the root
> | cause.
>=20
> (the whole thread is at http://lkml.org/lkml/2010/1/6/16).  Eric, does
> the above still hold, i.e. if you apply the below patch, does
> scripts/Makefile.modbuiltin fail again? If so, is it possible to fix the
> driver build process instead?
>=20
> Here is the patch:
>=20
> Subject: [PATCH] kbuild: Generate modules.builtin in make modules

This patch breaks (at least) a powerpc ppc64_defconfig build with
separate object directory (that starts completely empty).

/bin/sh: line 1: init/modules.builtin: No such file or directory

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Jun_2010_11_11_35_+1000_NyW8TpTpKgwMeADd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwQO8cACgkQjjKRsyhoI8wN9gCgj6XtItDJKM8B05RKF/EvBcBi
65gAoIAuPFXOxOHrTrvtGV3Yby4g2sjr
=O0TZ
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Jun_2010_11_11_35_+1000_NyW8TpTpKgwMeADd--
