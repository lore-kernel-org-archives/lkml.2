Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1KAHW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:22:27 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49569 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1KAHW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:22:26 -0400
Date: Tue, 1 Nov 2011 18:22:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: linux-next: manual merge of the moduleh tree with the device-mapper
 tree
Message-Id: <20111101182218.0046a4f479cc11a405349736@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_18_22_18_+1100_q0UhHDPZ1/xYCP=h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_18_22_18_+1100_q0UhHDPZ1/xYCP=h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/md/persistent-data/dm-space-map-disk.c between commit
661ae8a9604f ("The persistent-data library offers a re-usable framework
for the storage") from the device-mapper tree and fix up patch
"drivers-md-change-module.h-export.h-in-persistent-da.patch" from the
moduleh tree.

I fixed it up (see below) (the include of bitops.h has been removed in
the device-mapper commit).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/persistent-data/dm-space-map-disk.c
index aeff785,e6b9d67..0000000
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@@ -12,7 -11,8 +12,7 @@@
 =20
  #include <linux/list.h>
  #include <linux/slab.h>
- #include <linux/module.h>
 -#include <linux/bitops.h>
+ #include <linux/export.h>
  #include <linux/device-mapper.h>
 =20
  #define DM_MSG_PREFIX "space map disk"

--Signature=_Tue__1_Nov_2011_18_22_18_+1100_q0UhHDPZ1/xYCP=h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr54qAAoJEECxmPOUX5FEn2QQAIwOm7uFVA4DzeTsYcWdX/So
frCqGyc/M5E9bBVMOXNOsK7SBlNKXMNelf46K0L2FPTFpDxBLDtS4CDbPT1qfr3Q
NzocDcrZuMN803QY+FMZg64iTwGZQo1T6TdX7h6VRl1k5WyPq4+/YgU209BYfXY1
LUqax8NrGx3pf26lQeFCMLMx4s7Oo5UiKASEbTL4sdj9HlLaRSS+GRNOycI0tRTM
eNEn0DhGXDW4cHnUaYoL0eEXgdGxUfuYXX3crTiaU4d1QslIaES49Rxf01G944E5
R/OsZB242td+r/Dwf84B2Ey2XfmEoYM5aTcJo0hPxZrtj2SMqeTTLzuZzZFASKE7
OoFafy9BNyQR7VutV8DcpJK/6IClknULnOTAgGtDvyUJT5dc7v3XpgBTsnS62a1M
jHLaQrbQFbK9f1WSKxM7BAXhY0aBQBrocd+euhBmVuhZM1NZ84n0Ei8s73Wxpckc
MyMK75M+ZGVOqPyRjk06g+NKbDyHeyA7V+bkzVAOhLQHcbap6xgSacBNqU+yw68W
uPOIL+dnmLbvRP6r58Cf34emASIcAddv+W/liQXHH8M2G6jvxwu3AteHWTK9IuC1
XRmenUU/AR1gB7eewE+Ut+ovr3FMnlay8+IXbOO6Imzw98N5FFpU5fZ8bUnFF0Jf
uYOdp8iRq6rrYvzW2FYk
=LSc6
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_18_22_18_+1100_q0UhHDPZ1/xYCP=h--
