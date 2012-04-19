Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2DSAl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:41:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49994 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2DSAly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:41:54 -0400
Date: Thu, 19 Apr 2012 10:41:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Subject: linux-next: build failure in Linus' tree
Message-Id: <20120419104145.2b8ffe08e9982048f5c0f5f1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Apr_2012_10_41_45_+1000_Ec.uz/DAbIGGI1Gc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Apr_2012_10_41_45_+1000_Ec.uz/DAbIGGI1Gc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

While building Linus' tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

security/commoncap.c: In function 'cap_bprm_set_creds':
security/commoncap.c:510:22: error: 'PER_CLEAR_ON_SETID' undeclared (first =
use in this function)

Caused by commit d52fc5dde171 ("fcaps: clear the same personality flags as =
suid when fcaps are used").

I added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 19 Apr 2012 10:38:26 +1000
Subject: [PATCH] security: commoncap.c needs to include personality.h

fixes this build error on PowerPC:

security/commoncap.c: In function 'cap_bprm_set_creds':
security/commoncap.c:510:22: error: 'PER_CLEAR_ON_SETID' undeclared (first =
use in this function)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 security/commoncap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/security/commoncap.c b/security/commoncap.c
index 0ecf4ba..71a166a 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -29,6 +29,7 @@
 #include <linux/securebits.h>
 #include <linux/user_namespace.h>
 #include <linux/binfmts.h>
+#include <linux/personality.h>
=20
 /*
  * If a non-root user executes a setuid-root binary in
--=20
1.7.10.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_Apr_2012_10_41_45_+1000_Ec.uz/DAbIGGI1Gc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPj19JAAoJEECxmPOUX5FEP9wP/iry6lTlH2X7lcK16ax8cPgS
Ml07oVQqPQ5txKCkcwpjmaIJtvCOaCjiDYpJXaSpDyqn+YTi/GrBI+3ZuVIn+mix
tj+W1NIN29NrC7NpczU1X9rFZfcWRSmIjNR85zTWmTn4IaGVRVX0zz70kcbzb3ka
9ny3+Nnk3IB09xacBvv3rqdWQWWifFliQ3+MVnRUCRL5sKjVZDAdKcAWudXtMthy
4RzK/kA49smrXHhiuu5xBxM0pcaZnVd8f1/2Zmc72w4dWA/z+GJqh1sTyt58Ek84
c94P47neuuLhHHPoE7cuyVvQJ8L/tbUNCr+LzlTwT8OEYTTXoQ7pvmYifkJUAtcI
dZvN+PnagDA77YaySHaAdzUmGEJBaHrdnRP0y+S7Dg1KD1hGcA3/aVhUb6Tew0EG
Z5wM0VtAbjFvK8fLCezzgShCDnI/RpBR7j3ZEQmbosA0Fm+VK4Qhb/7XAGi/1iNW
A+/M80x14QKD4A4flgrNDyautk9QLsrNLyQmEbsikTU2AFQoIQtt/jd3BGJoI7oN
lpI3OCJUfsGAqzhNforhH9yJT8xLnDlsGQL9hCYJBdlhpckNabbO7BsOisfRawjo
5KgT8f6L1fCPZ6VVRG/Tf5Y97WLdvYm3lqDoERqtZknqEJ7RpeQ+kMIlu/STSMJf
hMsR7DUz8xpZddUDWSuL
=W/Ry
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Apr_2012_10_41_45_+1000_Ec.uz/DAbIGGI1Gc--
