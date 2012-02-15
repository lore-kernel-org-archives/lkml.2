Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab2BODlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 22:41:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60645 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2BODlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 22:41:42 -0500
Date: Wed, 15 Feb 2012 14:41:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>, James Morris <jmorris@namei.org>
Subject: linux-next: build failure after merge of the tmem tree
Message-Id: <20120215144131.e1c3b7bbe9c30f6b622872c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_Feb_2012_14_41_31_+1100_iKo7WZrM5d//hE1W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Feb_2012_14_41_31_+1100_iKo7WZrM5d//hE1W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

After merging the tmem tree, today's linux-next build (x86_64
allmodconfig) failed like this:

mm/frontswap.c: In function 'frontswap_shrink':
mm/frontswap.c:217:3: error: implicit declaration of function 'security_vm_=
enough_memory_kern' [-Werror=3Dimplicit-function-declaration]

Caused by commit 8174e70a6bde ("mm: frontswap: core frontswap
functionality") interacting with commit 191c542442fd ("mm: collapse
security_vm_enough_memory() variants into a single function") from the
security tree.

I applied the following merge fix:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 15 Feb 2012 14:35:31 +1100
Subject: [PATCH] mm: frontswap: update for security_vm_enough_memory API ch=
ange

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/frontswap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index d7c91e3..2b80c5a 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -214,7 +214,7 @@ void frontswap_shrink(unsigned long target_pages)
 			pages_to_unuse =3D 0; /* unuse all */
 		}
 		/* ensure there is enough RAM to fetch pages from frontswap */
-		if (security_vm_enough_memory_kern(pages))
+		if (security_vm_enough_memory_mm(current->mm, pages))
 			continue;
 		vm_unacct_memory(pages);
 		break;
--=20
1.7.9

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Feb_2012_14_41_31_+1100_iKo7WZrM5d//hE1W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOylrAAoJEECxmPOUX5FEinUP/3+wxR+k8TXbSohKmaDKCJCu
HooBf1sQztgg3TkLibo45ymTCSQ6SFq+Ex7OBpjSNur147VTqFNj6jYDr1mGQ9Ie
a+ZWMPP49thhkDjjcic/oKrYQQqlKP07JtPJeEw5+Nx2NwZSazZ2xtwrKO/SCT29
S3Qs5L6nkhN6mpxo6j6xC06Xkcuk5pxe8lh5+OVPbr9iqMKql9doCc12Y6CfGocK
+Mnt6QQgPB90o8U7MH1bVMoUWjJvakk8QGzrJg9HobG1Zu2NHngSDgajqhESBu3S
HtePbnxzeOJ1+CY+Atd3ReQK+4pe70tYUohieWXReBuXVaf7FmQJhqrVVDKaIxo5
h7Tw68JoV+mCp/jZVtsXDmMvIX5TxpCeYTUIvDdNZCFeay7I+dGh/gLMZS0KN2et
f+gfEEJPky6EEfY0H9y/uZcEFwv8nwnzMGItGfbamA8VR6pA9F1kefJwZAkeMQ9G
pWDZM20gM1m1viPf0nlUQZ+DN6ybZ1t/7qjoBH016zSpbZkbVobPcCILqxvluX+P
3tKSieaspFk+xVBrBumwSuSYZAQeS4yxDvjR/hd2o9ixR7T2sTgGABM4bvlrI8P5
yfDhlKjSXoEWHYoX6uwZFQSyUpCaKRmtlTt7n9UEWQNPO/9ekiXBKOxLW4XtZgt8
04ekwObboP7mSFz2v6/y
=w8AH
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Feb_2012_14_41_31_+1100_iKo7WZrM5d//hE1W--
