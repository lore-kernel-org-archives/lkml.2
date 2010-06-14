Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab0FNBxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 21:53:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50694 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab0FNBxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 21:53:47 -0400
Date: Mon, 14 Jun 2010 11:53:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthieu CASTET <matthieu.castet@parrot.com>
Subject: linux-next: build warning after merge of the ubi tree
Message-Id: <20100614115339.5dbca9f6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Jun_2010_11_53_39_+1000_EpTBD0Gz4mKLWKq."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Jun_2010_11_53_39_+1000_EpTBD0Gz4mKLWKq.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

After merging the ubi tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/mtd/ubi/scan.c: In function 'check_what_we_have':
drivers/mtd/ubi/scan.c:960: warning: passing argument 1 of 'get_random_byte=
s' discards qualifiers from pointer target type

Introduced by commit 095751a6e0838a712393a74eb0b7b6559dbdbe81 ("UBI:
generate random image_seq when formatting MTD devices").  "ubi" is
declared const (as a paramater to check_what_we_have()), so
&ubi->image_seq is a pointer to a const int.  get_random_bytes() wants to
modify that ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Jun_2010_11_53_39_+1000_EpTBD0Gz4mKLWKq.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwVi6MACgkQjjKRsyhoI8zbzACfQwdabN5GHNXetsL8oP2iKUyI
vDkAnjupShVy1QoKPpOp930PTsQa1Coy
=12g4
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Jun_2010_11_53_39_+1000_EpTBD0Gz4mKLWKq.--
