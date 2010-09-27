Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0I0Fz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:55:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58293 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab0I0Fz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:55:57 -0400
Date: Mon, 27 Sep 2010 15:55:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: linux-next: build failure after merge of the final tree (hwpoison
 tree related)
Message-Id: <20100927155551.2e4e4b26.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Sep_2010_15_55_51_+1000_cb6FOK/I59RAKlum"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Sep_2010_15_55_51_+1000_cb6FOK/I59RAKlum
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

After merging the final tree, today's linux-next build (powerpc allnoconfig)
failed like this:

mm/mprotect.o: In function `migrate_huge_page_move_mapping':
mprotect.c:(.text+0x0): multiple definition of `migrate_huge_page_move_mapp=
ing'
mm/shmem.o:shmem.c:(.text+0x0): first defined here
mm/rmap.o: In function `migrate_huge_page_move_mapping':
rmap.c:(.text+0x0): multiple definition of `migrate_huge_page_move_mapping'
mm/shmem.o:shmem.c:(.text+0x0): first defined here

Caused by commit 7b217c52ce7f33379beb27aa7685109fa74ed6bf ("hugetlb:
hugepage migration core").

This function is declared as "extern int ..." with a body in
include/linux/migrate.h for the non CONFIG_MIGRATION case.

I reverted the whole hwpoison tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Sep_2010_15_55_51_+1000_cb6FOK/I59RAKlum
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMoDHnAAoJEDMEi1NhKgbsvjYH+wfQO0rTVQPq+2f220T23PjI
7+EmbYLqWmg86atWGvefJ2P2G/xXgFU72VchMBeunsPyvfmavp2+NJ5zAOnLrWRY
GBnaZ4rzuma0l7GwxFemq8IXq3XyJklWP3shjTr3H1gRxiTe+s1l3OTshrFJtAa6
gxk97Li6AJ1+NAo7fAABqFs0Ab5jPGMpZ6CWuq3qs3B4AM3jh0ypKCfy88IL5jEh
q7HBPSJ2fztidBy3FRtPi76yUicH70NsBJCqv8Bt+cOEboWYyJb8LidHB/EskYTH
5py2/koxE19qve3pKAOqtcTYaeVV7o/OAF6lDcAfzp2zjhSUywC5LdWKZCrbx/g=
=akxp
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Sep_2010_15_55_51_+1000_cb6FOK/I59RAKlum--
