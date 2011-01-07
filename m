Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1AGAFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:05:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51342 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1AGAFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:05:22 -0500
Date: Fri, 7 Jan 2011 11:05:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20110107110513.30776114.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Jan_2011_11_05_13_+1100_Ghyg12MvjJJnxlfs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Jan_2011_11_05_13_+1100_Ghyg12MvjJJnxlfs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/built-in.o: In function `.pmf_get_function':
(.text+0x723c): undefined reference to `.kref_get'
arch/powerpc/platforms/built-in.o: In function `.pmf_unregister_driver':
(.text+0x72c8): undefined reference to `.kref_get'
arch/powerpc/platforms/built-in.o: In function `.pmf_do_functions':
(.text+0x793c): undefined reference to `.kref_get'
arch/powerpc/platforms/built-in.o: In function `.__pmf_find_function':
(.text+0x7c80): undefined reference to `.kref_get'
arch/powerpc/platforms/built-in.o: In function `.pmf_register_driver':
(.text+0x8044): undefined reference to `.kref_get'
arch/powerpc/platforms/built-in.o:(.text+0x8310): more undefined references=
 to `.kref_get' follow
lib/lib.a(kref.o):(__ksymtab+0x10): undefined reference to `kref_get'
drivers/built-in.o: In function `.get_current_tty':
(.text+0x60970): undefined reference to `.kref_get'
drivers/built-in.o: In function `.__proc_set_tty':
tty_io.c:(.text+0x61624): undefined reference to `.kref_get'
drivers/built-in.o: In function `.tty_init_dev':
(.text+0x64d2c): undefined reference to `.kref_get'
drivers/built-in.o: In function `.tty_open':
tty_io.c:(.text+0x64ee4): undefined reference to `.kref_get'
tty_io.c:(.text+0x64f20): undefined reference to `.kref_get'
drivers/built-in.o:tty_io.c:(.text+0x64f58): more undefined references to `=
.kref_get' follow

Caused by commit 15454034cb3021d8bb9d21b4f35072a809197fdd ("block: add
internal hd part table references") which removes kref_get() instead of
kref_test_and_get()!

This really wasn't tested, right?

I have used the block tree from next-20110106 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Jan_2011_11_05_13_+1100_Ghyg12MvjJJnxlfs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNJli5AAoJEDMEi1NhKgbsWAAH/jPZLsPI6msIebXnBOtSWif0
WsmUYQoeOgiVW9QLjOWCYgiMDF5TN8OnthmZ1zf1cSDotII+IKUdsmR1BpPfi6VA
rD+bwEgjhJcPty00so+k0kRrnFf+EzOUiOX+7EtGe/J0c/g0QGScW6X6MH0uy1i9
XWcB7Q8Y/E2EPLRszZfb3od6OsK6h2T6FEeVLUUOkUSflgKr8R8DB3+cC4v2sjiy
I94cy/9BIdvuEISyw6IT4GUlkeR7DEbiM/Z46jZYtqMvADXhM/EOc87qF1oGR4fR
vniXcrxll6AnOAzYFWKP4wYLkF8VoRSvWD46OlHdPzWerzO+1FR2t4capiBHmw4=
=nebS
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Jan_2011_11_05_13_+1100_Ghyg12MvjJJnxlfs--
