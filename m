Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1JDHdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:33:08 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47549 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1JDHdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:33:06 -0400
Date: Tue, 4 Oct 2011 18:32:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ali Bahar <ali@internetdog.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20111004183257.fea644e6ca5403a253990604@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Oct_2011_18_32_57_+1100_zGIBzFHjDC/QemtF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_18_32_57_+1100_zGIBzFHjDC/QemtF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) produced these errors/warnings:

drivers/staging/rtl8712/usb_intf.c:172:1: warning: data definition has no t=
ype or storage class [enabled by default]
drivers/staging/rtl8712/usb_intf.c:172:1: warning: type defaults to 'int' i=
n declaration of 'MODULE_DEVICE_TABLE' [-Wimplicit-int]
drivers/staging/rtl8712/usb_intf.c:172:1: warning: parameter names (without=
 types) in function declaration [enabled by default]
drivers/staging/rtl8712/usb_intf.c: In function 'r8712u_drv_entry':
drivers/staging/rtl8712/usb_intf.c:649:9: error: 'THIS_MODULE' undeclared (=
first use in this function)
drivers/staging/rtl8712/hal_init.c:66:17: error: expected declaration speci=
fiers or '...' before string constant

Caused by various commits in the staging tree interacting with the
module.h split.

I have added the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Oct 2011 18:30:10 +1100
Subject: [PATCH] staging: r8712u:  include module.h where needed

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/rtl8712/hal_init.c |    1 +
 drivers/staging/rtl8712/usb_intf.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/h=
al_init.c
index 1bd9c37..d0029aa 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -32,6 +32,7 @@
 #include <linux/device.h>
 #include <linux/usb/ch9.h>
 #include <linux/firmware.h>
+#include <linux/module.h>
=20
 #include "osdep_service.h"
 #include "drv_types.h"
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/u=
sb_intf.c
index 0a2f274..fb2e89c 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -29,6 +29,7 @@
 #define _HCI_INTF_C_
=20
 #include <linux/usb.h>
+#include <linux/module.h>
=20
 #include "osdep_service.h"
 #include "drv_types.h"
--=20
1.7.6.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Oct_2011_18_32_57_+1100_zGIBzFHjDC/QemtF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOirapAAoJEECxmPOUX5FEgewP/3vgtWtjpd6Wsbo1u2IZ0ENN
ZuBoQldicQ9BA54mdhOCjX4TC1Tu4PRBFWOSzUef/KT7/qaYjnHGmmcHoWV+f3pz
KKUJ9Jzup4pVXhbX9PKpTPWvLtI0xnzIJX2ITPBmotGkgkw8mSJSoTX/YcE+RAc7
H5qkjbm0uacNudVvJgL9SMrVDDs+Y4K8OMy5BfTCS7mIg4MmzMvF49ELKfmdua56
MeQQFFPd06Bu/JaRudtxQVVF7lhndeyJ0Ib8i+sX85s1iKk40f8AMoo2GNTUaFup
FAnzZPJc39WAhwtosF/sCnIkHpo6X80HJeFhcg2/yShWEuXv9BaYKur2eZnxNjKo
A0fINXoN5q/G3nRNNJtj2R2gE8uRyRFnCuoyhe19kxIrVe5I7ep1iUahHwBILbff
EGtJp/30uUXgPdb1G30cT6JmttTUGgWWIAArxJJxJp1oI2ud28ZAbPQ5XFKT9Cbb
HIVAMRL3qE6aq2fav9ssT9uJKPuChHLN9/jDnKFjTPpb05ku5n4iPfZFXPMO0Dg4
ENichA7F/bgq+/x986JMsnZV7uNZqPr/x1uwz2+L8pG508G/3B9WQYewadNPjsSw
NBbmV3smlqR0m6BlRne5wQ3pDhDIY9Pir6hGWjiiBQ/aXuhKdSPdUd6MwmnYa71r
Ks5yhXNzIIXqEPEleti2
=zG11
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_18_32_57_+1100_zGIBzFHjDC/QemtF--
