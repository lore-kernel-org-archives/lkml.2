Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2A0FxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:53:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56573 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab2A0FxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 00:53:01 -0500
Date: Fri, 27 Jan 2012 16:52:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, gregkh@suse.de,
        rmk+kernel@arm.linux.org.uk, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC - PATCH 0/7] consolidation of BUG support code.
Message-Id: <20120127165245.263bd8f7259ea629d8f7df31@canb.auug.org.au>
In-Reply-To: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
References: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Jan_2012_16_52_45_+1100_lPa_iHIceHXncyG/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Jan_2012_16_52_45_+1100_lPa_iHIceHXncyG/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 26 Jan 2012 21:44:25 -0500 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> The changes shown here are to unify linux's BUG support under
> the one <linux/bug.h> file.  Due to historical reasons, we have
> some BUG code in bug.h and some in kernel.h -- i.e. the support for
> BUILD_BUG in linux/kernel.h predates the addition of linux/bug.h,
> but old code in kernel.h wasn't moved to bug.h at that time.  As
> a band-aid, kernel.h was including <asm/bug.h> to pseudo link them.
> With the above in mind, the goals of this changeset are:
>=20
> 1) find and fix any include/*.h files that were relying on the
>    implicit presence of BUG code.
> 2) find and fix any C files that were consuming kernel.h and
>    hence relying on implicitly getting some/all BUG code.
> 3) Move the BUG related code living in kernel.h to <linux/bug.h>
> 4) remove the asm/bug.h from kernel.h to finally break the chain.
>=20
> During development, the order was more like 3-4, build-test, 1-2.
> But to ensure that git history for bisect doesn't get needless
> build failures introduced, the commits have been reorderd to fix
> the problem areas in advance.

I have expressed reservations with these tree wide include file cleanups
in the past (there was going pain for me and others during the module.h
split up for example).  So, have you considered the following alternate
method of achieving most (if not all) of the gains:

First a patch that moves the BUG related stuff from kernel.h to
linux/bug.h and replacing the include of asm/bug.h with linux/bug.h in
kernel.h.  This should essentially be a noop (bar some strange
interesting bugs).

The trick is to convince Linus that this patch is OK for the current RC ser=
ies ...

Then you can (at your leisure) fix all the files that need linux/bug.h
included - farming them out as required.  And we could add a check in
checkpatch.pl.

Then (either after 3.4-rc1 or in the 3.5 merge window) we can remove the
include of linux/bug.h from linux/kernel.h and fix any left over build
problems.

I have not thought about this too hard, so there may be large holes in
this plan.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Jan_2012_16_52_45_+1100_lPa_iHIceHXncyG/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPIjutAAoJEECxmPOUX5FERhsP+QEY/NRp9glh41m/LafiWRy2
lj22NE7gC/yGpm4KsrWfdDqy+vZfdhoex9w6VBLGXn+DhsBxMdD6jpTDlfjwV3Uh
Y8yNuUT/rl+wfTRQbi/veZpNUVv2fch0/O1bFVX8zSl9gbcgDpl0xerg1jdmyY+I
B9r/1HNayOKqU/Tdm6WL3H4q3stRiZr1IxSKw52FfSauq+hFOpv7iZC1NXus/mve
jjeg/wswf9EnzK9RIOlruQEpDv9hgP1KQ3pMJObMnaqkbaui31ItK+SJxi8E1zsT
au/bbdZ0QScXoDq+M95M5tH9fj+ceScEfaGl+Pa6qZhWSjlGdf3RFWJtJo3AWa9B
Xh6XcV1ECuBa5F83X6G9h0tBweWR7dB/WUJdnuC50rfh3mYNjS2gmUVLLFsF1m+l
R8BgUwEMCSPuNTgkKWF+wckjPuKdCD5XamV+O2e1K0Rs+ws3NqZllXif7ueGJZsH
JGZslQJ0sHZ41RNndnHW9+e610bSC1MmHEiUksla+mSZcsB+QKT5F0ttEhCdL8ap
SpdF6qtCuVkDi/i24tpcvVOy3JYbHa2B+lvPVYA1Of6PAumtmAUjHVAZMFptjj4J
kwdrslyx6l0d7xVMcu6MynZDbfdrvAuq/hLEo/YDdrtNHyT/qGehcC90Lzgfe0VZ
u/DgnoUjJXuVUfXbuPEa
=wvI4
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jan_2012_16_52_45_+1100_lPa_iHIceHXncyG/--
