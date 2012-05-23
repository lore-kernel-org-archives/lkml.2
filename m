Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2EWGz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:55:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39053 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2EWGzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:55:55 -0400
Date: Wed, 23 May 2012 16:55:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>
Subject: linux-next: build failure after merge of the final tree (watchdog
 tree related)
Message-Id: <20120523165548.8c706826ee94711bf3a913d8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_16_55_48_+1000_2INYkEIUkEpa9EJ+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_16_55_48_+1000_2INYkEIUkEpa9EJ+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/watchdog/watchdog_core.c: In function 'watchdog_register_device':
drivers/watchdog/watchdog_core.c:109:2: error: implicit declaration of func=
tion 'IS_ERR' [-Werror=3Dimplicit-function-declaration]
drivers/watchdog/watchdog_core.c:112:3: error: implicit declaration of func=
tion 'PTR_ERR' [-Werror=3Dimplicit-function-declaration]

Caused by commit e3b97a7eb87d ("watchdog: create all the proper device
files").

I have applied this fixup patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 23 May 2012 16:52:07 +1000
Subject: [PATCH] watchdog: usin IS_ERR needs linux/err.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/watchdog/watchdog_core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_c=
ore.c
index 534ed2a..1b42936 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -35,6 +35,7 @@
 #include <linux/watchdog.h>	/* For watchdog specific items */
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/idr.h>		/* For ida_* macros */
+#include <linux/err.h>
=20
 #include "watchdog_core.h"	/* For watchdog_dev_register/... */
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_May_2012_16_55_48_+1000_2INYkEIUkEpa9EJ+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvIn0AAoJEECxmPOUX5FEUOwP/3zrRwKqB7+4P+inrNzXOIlb
9V0/j+XkLf/ENXy1YqcEERIaW4y8zKv0BgXxbrolHyJYGsnLyKyBc8Yi2jLbx04a
TvAxVJtRrBMnc/ykeY0t/poNzz7/pKXQCueKmddfd1Qn0ZCX7P4vcQjmUcariRb4
d1LqYFBeExA3Lg4XzF5F+JcpFJ3vDlzZa7TiVet2D0eZXBCMK7C9PPpZ2Hm95tvT
VBPf04SRBpDUQvbGr9YA0nxwSfGa9EeRc218TjbD15L70XMkTQo4oGokXLtEUcRa
vzaEXGXElyyOmNRte1wSBHZ+3M3nFXrLGDJ13ArGn1xfbozpSKEPv/9CFYr7E0tf
iN6b3AmR+sSaGV9SB7Gzw/i1Nmp4iwpa4BRpYBkSXKr0aCRxidqo193ThioKz+L8
YqpbNwF+D7bd9H7hbCNYmO6N0aNtB4fG4tcPot9B7IuCX7ZD2cAuLnNffzepoHD4
9wnrt/7p4QfbqmwC2SkELbNgKVkUB4HxJef5qaUgrZMs0qa0p2niOhS7k8nXNSbt
dfyZ4aETDQPAi+yfpfMgQRAWOKwc1A5u3wtAeuJASLhLqYcyrNwoXCBnClQXGw74
S+tb4kghn6uk74DyEyVotaJO1AXU8JpNfOecJ55+sowXQcLgDWqwelwtB5pKNBAL
Cesh7eX2lsNwjRSr9Ft6
=NT4Q
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_16_55_48_+1000_2INYkEIUkEpa9EJ+--
