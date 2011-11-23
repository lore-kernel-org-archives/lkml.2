Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780Ab1KWDo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:44:28 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60901 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1KWDo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:44:26 -0500
Date: Wed, 23 Nov 2011 14:44:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (uprobes
 tree related)
Message-Id: <20111123144409.7d1816bef960a2f277aaf1b9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Nov_2011_14_44_09_+1100_gNqV92jV.htmRQIF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Nov_2011_14_44_09_+1100_gNqV92jV.htmRQIF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

In file included from include/linux/mm_types.h:15:0,
                 from include/linux/sched.h:64,
                 from arch/powerpc/mm/mem.c:21:
include/linux/uprobes.h:174:49: error: 'struct mm_struct' declared inside p=
arameter list [-Werror]
include/linux/uprobes.h:174:49: error: its scope is only this definition or=
 declaration, which is probably not what you want [-Werror]

And many more similar.

Caused by commit 61fafad13005 ("uprobes_xol" - "uprobes: slot allocation").

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 23 Nov 2011 14:35:01 +1100
Subject: [PATCH] uprobes: declare mm_struct before its use in uprobes.h

Since there is a circular dependency between uprobes.h and mm_type.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/uprobes.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 20bdd0a..091dfb8 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -26,6 +26,7 @@
 #include <linux/rbtree.h>
=20
 struct vm_area_struct;
+struct mm_struct;
 #ifdef CONFIG_ARCH_SUPPORTS_UPROBES
 #include <asm/uprobes.h>
 #else
--=20
1.7.7.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Nov_2011_14_44_09_+1100_gNqV92jV.htmRQIF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzGwJAAoJEECxmPOUX5FEk3UP/1hl3ohHAGntNYHJ9JnmTwx/
dTufdIt8BLWXDOOocM1JufPupyrj5kKQDenzJBJ4mo6p5KCcgvnzCtAkb5BY4GfW
K9NCT6Zrk8CXQ3Y5uQwbNrF5trwCwIK4tUOj/C8I5k5xABM6IlH1x/5/VgSFMp7h
q2hIdwKPOMq4ifuUdaWS/QLoUhJUvXRblMGqzcbT38hV5LeSldoDBEMhpJHr3V1u
XKgsJkePwSeGtvA2+P+AKctNgSx75yoiOvBd24oPSGdokXaU0oRZ2xbbU02lqOhf
e3Kd/eJ6HtyCsRCoPe8dh/bqhhRm9GYkHx4JprZHfsfY/n4HIqX7Fs+A74+wqu7l
OkMfHXuCeD1CI4vdaT0bb2N/lOcQwDEmyvjpWZSykI/nyyDndYAmXq2xUf91fndl
E2zkozrNw0ypHX8ettH4c+V8TfvwO++aNzzcID7D1aaWIgesTaaon3MuWmvMvTg7
vnosJA4ygWkyJDXD8XXFjIVswvukydgO91AM7vmm+jrgvneR4z3FSWYkIcceUtmZ
LyVxtDK1HJ9lyTDGxNrdK6EQQvEIKSY6tP+4A1OjuZfqqbFQU1wg9m9v3f1Ycnfo
At0QEKfObhL1bl9Sa8lKagi2VgicF5zh/Duq8FfQgsa48joJDXikuyWx4WPKexGJ
omnmvVM+7w5wXSqVv9kS
=ULd/
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Nov_2011_14_44_09_+1100_gNqV92jV.htmRQIF--
