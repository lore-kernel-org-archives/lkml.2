Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479Ab0HGCp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:45:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33563 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761146Ab0HGCpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:45:22 -0400
Date: Sat, 7 Aug 2010 12:45:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the ext4 tree
Message-Id: <20100807124515.d26dc4e0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__7_Aug_2010_12_45_15_+1000_e3Yb1WqZSG955S/r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__7_Aug_2010_12_45_15_+1000_e3Yb1WqZSG955S/r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

After merging the ext4 tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/jbd2/transaction.c: In function 'start_this_handle':
fs/jbd2/transaction.c:98: warning: unused variable 'ts'

Introduced by commit 8dd420466c7bfc459fa04680bd5690bfc41a4553 ("jbd2:
Remove t_handle_lock from start_this_handle()") which modev the only uses
of this variable inside a section of code protected by CONFIG_JBD2_DEBUG.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__7_Aug_2010_12_45_15_+1000_e3Yb1WqZSG955S/r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMXMi7AAoJEDMEi1NhKgbsKSsH/1xquYPmFZQQYrvxEAAujVx9
9a8PQli9foDA5HlvMmWSOeL8sArhGv489xypnzBNvtVeK1+EkBhd5Ebliss7NMXY
PKR1X6dq1Nihnw9kCmxiT78bP7SOdPwcHWpgIavAxli7zDR/For5eb/RX1syfXmv
FbJkIdaHA8QKpN1n3rY01Xxk1pSTyTCP6GtTPemxXqkq81hvFTfR2oavBRrjnxxN
LcNI/3WSbO7yy66Nbz1LQ/kisdHADk7uyTpcr9JzS5eovVh8bUMeWhg27O9LiSqX
5d7C8/ic9uVavh0fIkAHNd+MdgZnUgRWazvXyMxo+2qIOjJfmCHzXl4grr5GrjA=
=NV82
-----END PGP SIGNATURE-----

--Signature=_Sat__7_Aug_2010_12_45_15_+1000_e3Yb1WqZSG955S/r--
