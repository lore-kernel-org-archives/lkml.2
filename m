Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0GZFKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 01:10:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37099 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab0GZFKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 01:10:41 -0400
Date: Mon, 26 Jul 2010 15:10:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave McCracken <dcm@mccr.org>
Subject: linux-next: build failure after merge of the final tree (xen tree
 related)
Message-Id: <20100726151033.d43d14f6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Jul_2010_15_10_33_+1000_Y888PXatShbXRjbz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Jul_2010_15_10_33_+1000_Y888PXatShbXRjbz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386
defconfig) failed like this:

In file included from include/linux/hugetlb.h:297,
                 from arch/x86/mm/init_32.c:18:
arch/x86/include/asm/hugetlb.h: In function 'set_huge_pte_at':
arch/x86/include/asm/hugetlb.h:47: error: implicit declaration of function =
'native_make_pmd'
arch/x86/include/asm/hugetlb.h:47: error: incompatible type for argument 2 =
of 'native_set_pmd'
arch/x86/include/asm/pgtable-2level.h:19: note: expected 'pmd_t' but argume=
nt is of type 'int'

Caused by commit e19a181db99f26dfb8c6fe21f6f7e5f0906ecff7 ("xen: Fix to
hugepages to work around new PWT handling").

I reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Jul_2010_15_10_33_+1000_Y888PXatShbXRjbz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTRjJAAoJEDMEi1NhKgbsWzoIAJKtNe4MIa4WY7uH+uVRsZOl
TgvMDcOCTZxXd8S7zCh7Fbo6D9R9YPowZmY9OwH8O7dy5C/ruuKDxvexPCQqkdLh
LMEh1LaiCRaa0DaEgnvl8NNQ6GhvbFLojnVM6jqYS3ppg16iCWfWCxIArz7zk0C6
MYOhVpGdKDyzyxc6C4Je6yTfdX+RIXHuxOrIk8azxIRb3DkVjw7AcAGoA2H7q58/
+LMi4iXz5YaG4bTLqAYiWwbbVp9NL/jWk+Ds8Am9UK/DZTTGUvKwsLj+zO4YBIWd
JUOLntrXgN+NglDeye01ic2wzB1hhNY76xpp2blzY9OKdAv7REgEj72iP5FCeaQ=
=DQ8m
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Jul_2010_15_10_33_+1000_Y888PXatShbXRjbz--
