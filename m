Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1C1DpK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 23:45:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44169 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab1C1DpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 23:45:08 -0400
Date: Mon, 28 Mar 2011 14:44:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110328144458.efedbefc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Mar_2011_14_44_58_+1100_Weuuod5m44OZ3ANX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Mar_2011_14_44_58_+1100_Weuuod5m44OZ3ANX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/memstick/host/r592.c:26: error: 'enable_dma' redeclared as differen=
t kind of symbol
arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enable_dm=
a' was here

Caused by commit 926341250102 ("memstick: add driver for Ricoh R5C592
card reader").

enable_dma() is also defined in a few other architectures including x86
(presumably asm/dma.h does not get included there).

I just reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Mar_2011_14_44_58_+1100_Weuuod5m44OZ3ANX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNkAQ6AAoJEDMEi1NhKgbs6gIH/1t5qXVkVmjj1Vf1B2irRUyk
1BNvtu/m8+JJK4UVi7cpZ3hIP9fP33MyOrUrVpJpQ92JhhfL0xtEr16VxQ7AzydZ
3ryEdnIKs7xyiqpkI0C2jFD9/yAeQwFsYnRYO1pLy12fl33Dta0QV7Rq7qVbajcC
d4MRubVjlCoZnrAT9HLMDDaO245E1iPYSZP70QsI/qNvDjjkYFuzBY0jGRRLHGK6
vFSjftC4+ESie4mOF8eUsRBuV9XQOCl8lg6+SvfRMRKTbgzQXOTEK0RBGQ4tIBFC
Q5hHKhZT5VaW1WAxBQ1oZq5dVlVQRyji0ctHR7DDthIcWYyRCMuaEsxwOcsqXu8=
=QfzV
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Mar_2011_14_44_58_+1100_Weuuod5m44OZ3ANX--
