Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab1E0FLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:11:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55159 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1E0FLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:11:44 -0400
Date: Fri, 27 May 2011 15:11:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110527151135.cd6f758a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_May_2011_15_11_35_+1000_1rbmrqj/nD./88tY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_May_2011_15_11_35_+1000_1rbmrqj/nD./88tY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

drivers/misc/kgdbts.c: In function 'check_and_rewind_pc':
drivers/misc/kgdbts.c:307: error: implicit declaration of function 'instruc=
tion_pointer_set'

Caused by commit 63ab25ebbc50 ("kgdbts: unify/generalize gdb breakpoint
adjustment") from Linus' tree.

Lots of architectures do not use asm-generic/ptrace.h where
instruction_pointer_set() is defined.

I have reverted that commit for today.

This error was detected in our builds of the mmotm tree on May 14
(see http://kisskb.ellerman.id.au/kisskb/buildresult/4161286/).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_May_2011_15_11_35_+1000_1rbmrqj/nD./88tY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3zKHAAoJEDMEi1NhKgbspboIAIKNL8UlzqWTv1aiFNdOjjyS
pSzSJgWk1vhEF0VlSup1LgRDWOfVCeEQmkimQriGfOlWGRDRC7KIy3sJM8RH3ZST
iKwYOPg/CogLHZiU/mwOEf6KjFHSP6SIg0fd4NOqms0yc6nFiqZfblZJRQ3xT+qy
IuvtYY0IuNn9iOsrF35cW4tRmJUu9xxiGCR0wXflGTjKd/9cLXuRSozaKt3ZP54O
CdvGqm9nLhu84YX15q9PnxKLbHVs2zhuEg8js5kMVz7vJzS7QY02bSrf0ZinKipG
j2uQYm99PTKGEEDO5lhYOX7/PolvOfw/0bQcNrlIcX/TIOOiA8tPEhsN/JhuELU=
=qfJr
-----END PGP SIGNATURE-----

--Signature=_Fri__27_May_2011_15_11_35_+1000_1rbmrqj/nD./88tY--
