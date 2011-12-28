Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab1L1Ies (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 03:34:48 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:56794 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1L1Ieq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 03:34:46 -0500
Date: Wed, 28 Dec 2011 19:34:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the final tree (vfs tree
 related)
Message-Id: <20111228193432.9dbab662b04a12a4ab29d6ba@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_19_34_32_+1100_QSGXN7HC4cb8PH9+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_19_34_32_+1100_QSGXN7HC4cb8PH9+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

drivers/tty/sysrq.c: In function 'write_sysrq_trigger':
drivers/tty/sysrq.c:867:3: error: implicit declaration of function 'get_use=
r' [-Werror=3Dimplicit-function-declaration]

Caused by commit b1cdabb05024 ("fs: move code out of buffer.c").
Presumably buffer_head.h was implictly including uaccess.h.

I have added the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Dec 2011 19:28:15 +1100
Subject: [PATCH] sysreq.c needs uaccess.h for get_user

Commit b1cdabb05024 ("fs: move code out of buffer.c") removed the include
of linux/buffer_head.h which was presumably implictly including uaccess.h
on sparc32.

Fixes this build error:

drivers/tty/sysrq.c: In function 'write_sysrq_trigger':
drivers/tty/sysrq.c:867:3: error: implicit declaration of function 'get_use=
r' [-Werror=3Dimplicit-function-declaration]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/tty/sysrq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 4629801..7867b7c 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -40,6 +40,7 @@
 #include <linux/oom.h>
 #include <linux/slab.h>
 #include <linux/input.h>
+#include <linux/uaccess.h>
=20
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
--=20
1.7.8.197.g73c6b

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_19_34_32_+1100_QSGXN7HC4cb8PH9+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+tSYAAoJEECxmPOUX5FE4IoP/2TVvN425J/KFWpm9LvyZjS3
2EIEM/GE6cDvomOJs1RloUXinNq8jN7M5DFHEkKQf7lZfNnjnf6qj7wastrwky1G
ntMNHo2JckUw8CliNrdSFSG/spYEWHLoxY7T0euWkTlNiyWBhFRPgLMvGCbYeWey
Qbfgl1ABk4ERMxJTCPx92uL8/O2RLMIA380TFQ9unIZapoJOBRpswJc28WlAIgXv
tJoN2w1zohGpDLfmZW/OQiQbjszmYGqBq65NRueupq9eATXTURASBkGQcmhhpcgN
C9PIbCthWBT/8Bgu1WNv2O/pCg9owGF7V65CweDGr0Ze86m8JMD8D1HSbcFlEvES
cz1LFAQM1O7R0ldl9zJOWgiCPtNWtS53blmekQSP34R71AQW8UlroZQheNoYHIfg
9GuOG4s5x/sFa5KxLwvr43qvURqcZjQ0IiRblsqjqpQ0lUrdyBkw/VGaGUHFMKZ5
vpwK79Dn1KU2e+PNv4RspcR6Ba/OiO1j6cVympg+l05nrkhEXJtC87c/Z5Ng8XVV
sKUUe02gnc0zgPjav8gY2BOSbTuxPTZCxtg1H0DtN+UsCsvZP42cemURhBcx5CmU
x7paij5SpoI1Kop2l3WgmugmebkmxMWtppeqKz4/CfJSjYjChMnzAO03c+9fhnQb
RWe2eljnLg7VmiY5viyy
=Wsuz
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_19_34_32_+1100_QSGXN7HC4cb8PH9+--
