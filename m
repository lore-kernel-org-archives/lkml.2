Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab1LIE6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:58:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43071 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1LIE6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:58:09 -0500
Date: Fri, 9 Dec 2011 15:57:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <ddaney.cavm@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the akpm tree with the memblock tree
Message-Id: <20111209155759.957c1dcab32a19b643268c23@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Dec_2011_15_57_59_+1100_9k1=nGZ0Sdazceu2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Dec_2011_15_57_59_+1100_9k1=nGZ0Sdazceu2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/mips/Kconfig between commit 9d15ffc824a9 ("mips: Use
HAVE_MEMBLOCK_NODE_MAP") from the memblock tree and commit "MIPS:
randomize PIE load address" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/Kconfig
index 7639c77,c2911b7..0000000
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@@ -25,9 -25,7 +25,10 @@@ config MIP
  	select GENERIC_IRQ_SHOW
  	select HAVE_ARCH_JUMP_LABEL
  	select IRQ_FORCED_THREADING
 +	select HAVE_MEMBLOCK
 +	select HAVE_MEMBLOCK_NODE_MAP
 +	select ARCH_DISCARD_MEMBLOCK
+ 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 =20
  menu "Machine selection"
 =20

--Signature=_Fri__9_Dec_2011_15_57_59_+1100_9k1=nGZ0Sdazceu2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4ZVXAAoJEECxmPOUX5FEp7EP/RXklGrZbAyXDz1N3p4SxRhP
sPFntCrmVyWN4yAKqFvnu2hue4e8sXzl8ilREz0PVvwn+ZiFy8Lr0WVQZ0OFZgbf
0mljTz7RXQ2mz5yI5TQ49J2PThwJ3PDZNK3BuoLlAO5fjcERwOzVCxZ57BEsHhaN
2nwUe1Ilsb0CFn/5Dfle6IolTbt4u9SHDgHwB5NQsy9eqsVY73CmsXlHs/6fS+eM
ftSnES7ejuM39vLAezWspUzclCwwwCxsnmABnA+2Rj1kFgL11kM2QVTa1vDE71o1
2N0bderjUDHmkpfrIoQvTAgV2Nhj4LeVXPdFRQKnkFzClQ/tekelT8EDXtAzR9sl
dCkVEOggBCJTZMO8fNb/d/sbVeDtPP7cQL01IUMEXqjIdGp9cBYrfW1FSjPirgpa
9ukCcKGdE6Aqv3mKOKHQyGX4TCdVLsrR1UFNljKOkaFHb5bJrO/YFBj31Bz1wN3l
RVqSguC6wfpEH7Hb0QyACePNWqPb1B4visOfo7SpDwYhV6dwYN9e7CL0bNW/ZOK1
Reg83TIK7AK8yhYuq9vfVjKfMfU/g2ZQ2f6PbiLMbLVB7GlpO1hP4N/bTtwwFshG
L6veh3CPvqJMsOC97PYQOGvw5lQoXm87muWZoxdt5AFcX29suoVrp5JD5YcGGK/v
DheQimLXgnVWZKNvIzBj
=vflS
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Dec_2011_15_57_59_+1100_9k1=nGZ0Sdazceu2--
