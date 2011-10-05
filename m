Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab1JEIYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:24:01 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:40609 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab1JEIYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:24:00 -0400
Date: Wed, 5 Oct 2011 19:23:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20111005192353.f6171e1a747fc7eda143c2bb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Oct_2011_19_23_53_+1100_SyoM.6qZLqrNuab."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Oct_2011_19_23_53_+1100_SyoM.6qZLqrNuab.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

kernel/cgroup_task_counter.c: In function 'task_counter_create':
kernel/cgroup_task_counter.c:60:3: error: implicit declaration of function =
'ERR_PTR' [-Werror=3Dimplicit-function-declaration]
kernel/cgroup_task_counter.c:60:3: warning: return makes pointer from integ=
er without a cast [enabled by default]

Caused by commit 7d8662e11b18 ("cgroups: add a task counter subsystem")
from the akpm tree.

I added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 5 Oct 2011 19:20:15 +1100
Subject: [PATCH] cgroups: ERR_PTR needs err.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/cgroup_task_counter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup_task_counter.c b/kernel/cgroup_task_counter.c
index 2374905..201d8e3 100644
--- a/kernel/cgroup_task_counter.c
+++ b/kernel/cgroup_task_counter.c
@@ -11,6 +11,7 @@
 #include <linux/cgroup.h>
 #include <linux/slab.h>
 #include <linux/res_counter.h>
+#include <linux/err.h>
=20
=20
 struct task_counter {
--=20
1.7.6.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Oct_2011_19_23_53_+1100_SyoM.6qZLqrNuab.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjBQZAAoJEECxmPOUX5FEj3cP/jTbjndcgukAUpvCp/sAJgq5
EMYiGULSyufn3bH1yZuhbWCtD0QmXD7mKhgvpYx04FLC5fuuPjOS9EU4S5LRjtqT
txvACRR3TkAxlEU50L6M6VVBOYRC9seyFFaQP2BIZP/3J1kGs+8NBMDYBWcZWevw
c/e7nIbc5/O+f7zV48GU1+3pGe90kRx9+qnmobiFy6QGTl2Kx/Tke+2nOQ37Bm5Y
/f8u84DNdZIlpugNPKnkFk9Zd0fiAjRwm1NiltZS0XZPrnajrIlcx6XZvWMZrH8L
aapPl8Jww/9lKmcwA8uDVtkWdmaYKTnXsxcwMD9OXcFUzle9WPP1RLVRkQJoGQvx
qmxz5rcEszFZyeBZ4QG2AC8PEOj9+2fkCPXWN5Cu9yh5+Hzmi2XZ2ufzqf6dtUUA
RMCIKW1RtctwZekyjClicWJCggKjzZ72nVCZk0pvbwOhZZtRV4//50fsTYPHrg8u
6XP4acmI9CNHWCSrGwqP+v7+kHHms/PtXoV/zul2rzModvYQqaUvvFxKRaygh+DF
RZbCIebdYOAjSqqm+Lm+4K7ji4IkwCu4NtsdUAr9s3IXjxD5stqvg8sPJ7MHOPZu
OAdkAozIag53NKpX+HyEwRSMUIQSzYLKvTbLIIz79n9h0UGrHG+eaM58hXohwswx
YqGl9O8bUhvQHujeymG5
=6da/
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Oct_2011_19_23_53_+1100_SyoM.6qZLqrNuab.--
