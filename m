Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928Ab1ETB44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:56:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48664 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab1ETB4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:56:54 -0400
Date: Fri, 20 May 2011 11:56:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the s390 tree
Message-Id: <20110520115651.fc0fc63f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__20_May_2011_11_56_51_+1000_1Sa6lJ_2Q3NpACnh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_May_2011_11_56_51_+1000_1Sa6lJ_2Q3NpACnh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the s390 tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

mm/rmap.c:788:54: error: macro "page_test_and_clear_dirty" passed 2 argumen=
ts, but takes just 1
mm/rmap.c: In function 'page_mkclean':
mm/rmap.c:788: error: 'page_test_and_clear_dirty' undeclared (first use in =
this function)
mm/rmap.c:788: error: (Each undeclared identifier is reported only once
mm/rmap.c:788: error: for each function it appears in.)
mm/rmap.c:983:52: error: macro "page_test_and_clear_dirty" passed 2 argumen=
ts, but takes just 1
mm/rmap.c: In function 'page_remove_rmap':
mm/rmap.c:983: error: 'page_test_and_clear_dirty' undeclared (first use in =
this function)

Caused by commit 4cbfc8b9f58c ("[S390] merge page_test_dirty and page_clear=
_dirty").

I have used the s390 tree from next-20110519 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__20_May_2011_11_56_51_+1000_1Sa6lJ_2Q3NpACnh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN1cpjAAoJEDMEi1NhKgbsEEEH/2ZQdFhH/gMw0EgtcMz9lH9i
b060xn0lj+XMau9bJ6+rhaeJ0XsTzglXEd1OhZ9F3KOhQkBh8nFnVGITvwBpoe1H
OCX4rVhCK61OBS1ksCYf/wmcP87i59vUyU8p7605nIiNwekeiTCiUNUMKFTxW+c3
RoQgu/XzNku01fx4x6gWvFIqPGQcYcA0HgfmtNe41TTKvnD5uAjncsC0+n68rgAd
+04FMJRlT1NUspIbyD0pCODfihu1elgZZx+J1HRbt5DIGfPCbq7mXjA30xiB/eTg
NiC0bChRNQkZVJM1dpGQEyShoYuyCrdZ5mSTJCXuy0EYa+V0jbWpNc6HXuYjOxc=
=ga8t
-----END PGP SIGNATURE-----

--Signature=_Fri__20_May_2011_11_56_51_+1000_1Sa6lJ_2Q3NpACnh--
