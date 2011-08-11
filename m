Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab1HKB7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 21:59:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38076 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab1HKB7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 21:59:37 -0400
Date: Thu, 11 Aug 2011 11:59:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: linux-next: build failure in Linus' tree
Message-Id: <20110811115926.655a067c61de5f430ef5e772@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Aug_2011_11_59_26_+1000_FgWW=B0uPxD7im1O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Aug_2011_11_59_26_+1000_FgWW=B0uPxD7im1O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

With Linus' tree, today's linux-next build (x86_64 allmodconfig) failed
like this:

drivers/edac/i7core_edac.c:259:19: error: field 'edac_mce' has incomplete t=
ype
drivers/edac/i7core_edac.c:262:24: error: 'MCE_LOG_LEN' undeclared here (no=
t in a function)
drivers/edac/i7core_edac.c: In function 'i7core_mce_output_error':
drivers/edac/i7core_edac.c:1671:25: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1672:20: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1673:23: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1674:15: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1675:18: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1676:18: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1680:7: error: dereferencing pointer to incomple=
te type
drivers/edac/i7core_edac.c:1742:22: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1742:31: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1743:39: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1744:15: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1751:7: error: dereferencing pointer to incomple=
te type
drivers/edac/i7core_edac.c: In function 'i7core_check_error':
drivers/edac/i7core_edac.c:1787:50: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1791:3: error: invalid use of undefined type 'st=
ruct mce'
drivers/edac/i7core_edac.c:1793:49: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c: In function 'i7core_mce_check_error':
drivers/edac/i7core_edac.c:1838:11: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1842:9: error: dereferencing pointer to incomple=
te type
drivers/edac/i7core_edac.c:1847:6: error: dereferencing pointer to incomple=
te type
drivers/edac/i7core_edac.c:1859:52: error: dereferencing pointer to incompl=
ete type
drivers/edac/i7core_edac.c:1864:9: error: dereferencing pointer to incomple=
te type
drivers/edac/i7core_edac.c: In function 'i7core_unregister_mci':
drivers/edac/i7core_edac.c:1910:2: error: implicit declaration of function =
'edac_mce_unregister'
drivers/edac/i7core_edac.c: In function 'i7core_register_mci':
drivers/edac/i7core_edac.c:2008:2: error: implicit declaration of function =
'edac_mce_register'

Caused by commit af9d220bac41 ("EDAC: Correct Kconfig dependencies").
Since CONFIG_EDAC_MCE is no longer selected most of the stuff in
linux/edac_mce.h is not available.  I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Aug_2011_11_59_26_+1000_FgWW=B0uPxD7im1O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQzd+AAoJEDMEi1NhKgbsEjUH+gJVrV9StjBN4EMUbAmaoAHe
3BPd6/0j1lad1Rsk2pm0j8vnBlhQiuLkoLFlbt2sDoTUoZSlu5Ctuwr4bDVS30c6
G4UZsxUn2RrjKOZuHnaiJgIPHMgkwgsOjl81wiacXXTRVBcZXjwZYx7Mj+GMMBVV
L78j0MNL6vxCEOTz2LUtf97VKMAj/ZZs9zR/+Su1b7bWcgvxaw5z4xvXVzsQhZyX
haNR1qnenOqaPbw2sbAM+ccM8uKFn11QP3oD3M1Ed/PDlD4gSlT7C9VtuQxIVznc
9sU2kKDI3jou1jOLqduEL1SkxU/Kb8tosr2TY3J44eJB2mf44zYrtEuxQ4Lj+xs=
=5vLP
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Aug_2011_11_59_26_+1000_FgWW=B0uPxD7im1O--
