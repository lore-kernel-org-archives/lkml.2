Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2HPFZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:25:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54513 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2HPFZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:25:43 -0400
Date: Thu, 16 Aug 2012 15:25:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IkJydW5vIFByw6ltb250IDxib25ib25zQGxpbnV4LXZzZXJ2ZXIub3JnPiI=?=@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (hid tree
 related)
Message-Id: <20120816152538.7f850ee1a3b8ce90d9f749a2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Aug_2012_15_25_38_+1000_EBPolrnJ3nOqGEmf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Aug_2012_15_25_38_+1000_EBPolrnJ3nOqGEmf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/hid/hid-picolcd_fb.c: In function 'picolcd_fb_destroy':
drivers/hid/hid-picolcd_fb.c:350:2: error: implicit declaration of function=
 'vfree' [-Werror=3Dimplicit-function-declaration]
drivers/hid/hid-picolcd_fb.c: In function 'picolcd_init_framebuffer':
drivers/hid/hid-picolcd_fb.c:508:2: error: implicit declaration of function=
 'vmalloc' [-Werror=3Dimplicit-function-declaration]
drivers/hid/hid-picolcd_fb.c:508:12: warning: assignment makes pointer from=
 integer without a cast [enabled by default]

Caused by commit fabdbf2fd22f ("HID: picoLCD: split driver code") from
the hid tree.

I added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 16 Aug 2012 15:20:10 +1000
Subject: [PATCH] HID: using vmalloc() requires the include of vmalloc.h

Fixes thes build errors:

drivers/hid/hid-picolcd_fb.c: In function 'picolcd_fb_destroy':
drivers/hid/hid-picolcd_fb.c:350:2: error: implicit declaration of function=
 'vfree' [-Werror=3Dimplicit-function-declaration]
drivers/hid/hid-picolcd_fb.c: In function 'picolcd_init_framebuffer':
drivers/hid/hid-picolcd_fb.c:508:2: error: implicit declaration of function=
 'vmalloc' [-Werror=3Dimplicit-function-declaration]
drivers/hid/hid-picolcd_fb.c:508:12: warning: assignment makes pointer from=
 integer without a cast [enabled by default]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/hid/hid-picolcd_fb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-picolcd_fb.c b/drivers/hid/hid-picolcd_fb.c
index 4d8e22c..cf295c5 100644
--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -18,6 +18,7 @@
  *************************************************************************=
**/
=20
 #include <linux/hid.h>
+#include <linux/vmalloc.h>
 #include "usbhid/usbhid.h"
 #include <linux/usb.h>
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Aug_2012_15_25_38_+1000_EBPolrnJ3nOqGEmf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLIRSAAoJEECxmPOUX5FE3OMP/3DHl0erVQJsgJ4QyGxAxLkL
W/9P6q/u3mJSTkjQkEDfcc4Vask9N0/xUXN7/EC3Pi/rY7dvKX8w69CDnhdBKjXX
V8/JZaFse8rVJWF/Ox8OS/UCfgq86S7lhO8RaY8ZHty8vJwA9hzsH3SVZvy0wVkV
WBl980lcAQVYJZN7TdhA6a5sOC323/LK6FD/mtv7bbr+2xvsA+/lkTzu46g9N+a2
ySQOyTveu+qmbRkyXmrF0gPVV+2/eHAlvXFlCa1oQ7+1gdzpb3BB7tkLzttCYnC9
fNVtl5fGS89pPn4D+2P1AuiloNByZCKAYB+HMiOVODHcToSsn4D5uxwA62jrQ1vy
jzKGHfSTeT1PXbBKA9lckvwXOcZS2sXJlbUoMrVyoz70LBRGmqgap+FeYC2XGY1t
McsceF3VMbLV+pWBQSbWW1HIvJ3f1TpvPv4Z4dFNVercdV+SGKFxeIsdC9oOgJoT
pkQ1a7/nujHPzxQATHbayw5lxTmmtewchMIfFNZ+4hlIdItUYwMwZ3O8ad5VQOnB
r4rRxEJiKyDKsqFq+nSVY0+H0NOxs5AIDwipShzvaYYRFh63ruvc5oGQZ6HgRKaW
ktEM8QQRLLlNpQLc4O+C9uH1GjMU5jxQrEhoCewM43SYb876ofpxGjHd3U0aOyrZ
gnyC2EKHMLeZwrtPOBnf
=ZeeH
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Aug_2012_15_25_38_+1000_EBPolrnJ3nOqGEmf--
