Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1ELBNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:13:07 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55763 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1ELBNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:13:04 -0400
Date: Thu, 12 May 2011 11:12:55 +1000
From: Stephen Rothwell <sfr@au1.ibm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the nfs tree
Message-Id: <20110512111255.95a765aa.sfr@au.ibm.com>
Organization: IBM Ozlabs Linux Technology Centre
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_May_2011_11_12_55_+1000_7NQMv7anBxxGsj6b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_May_2011_11_12_55_+1000_7NQMv7anBxxGsj6b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/nfs/write.c: In function 'nfs_flush_multi':
fs/nfs/write.c:942: error: too many arguments to function 'pnfs_update_layo=
ut'
fs/nfs/write.c: In function 'nfs_flush_one':
fs/nfs/write.c:1016: error: too many arguments to function 'pnfs_update_lay=
out'
fs/nfs/read.c: In function 'nfs_pagein_multi':
fs/nfs/read.c:291: error: too many arguments to function 'pnfs_update_layou=
t'
fs/nfs/read.c: In function 'nfs_pagein_one':
fs/nfs/read.c:354: error: too many arguments to function 'pnfs_update_layou=
t'

Cased by commit 4b386a0fe47b ("NFSv4.1: Ensure that layoutget uses the
correct gfp modes") which forgot to update the function declaration for
the !CONFIG_NFS_V4_1 case.

I have used the nfs tree from next-20110511 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@au.ibm.com
IBM OzLabs Linux Technology Centre

--Signature=_Thu__12_May_2011_11_12_55_+1000_7NQMv7anBxxGsj6b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNyzQXAAoJEDMEi1NhKgbs/UAH/11ZsRnv80MSYNO+yDL4z+oi
xqHLnckHMWJZK4o8T3wj2ui1F2qQn9wgW4Q0XzgGoIgqybaAA1BlvjIMvGJtf13t
5o1/c6rmVG8Fsw5wXsSZ7LvY3aRT7N6dbhqHopAfRvOARRbWYYxZFMFsSCYbUSTL
Z6oJ0I4F8IhJZVG06CvYAIZzZMmBmZ9QPu7KAIuJXL/QRxoRfpsKRs1jhsf2ovMx
RZEQl2pQ2EjgsQ9wiTNbsdHC1lAERP759SWYXevT14ljiCusWM87Ivlb4gfh0vrg
ZoQqiIw7vDHQsIGr8bd0jOx5ukEYp6xy00jg1mwnBnnQiYmdzWwo+K9nWPDvUvk=
=GcXK
-----END PGP SIGNATURE-----

--Signature=_Thu__12_May_2011_11_12_55_+1000_7NQMv7anBxxGsj6b--
