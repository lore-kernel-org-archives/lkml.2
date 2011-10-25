Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1JYIpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:45:55 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58781 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab1JYIpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:45:52 -0400
Date: Tue, 25 Oct 2011 19:34:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: linux-next: manual merge of the moduleh tree with the xen-two tree
Message-Id: <20111025193442.66255eed8e72d5e88cce192f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_19_34_42_+1100_WOpd3DhbC32dsllT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_19_34_42_+1100_WOpd3DhbC32dsllT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/xen/xen-selfballoon.c between commit 38a1ed4f039d ("xen: Fix
selfballooning and ensure it doesn't go too far") from the xen-two tree
and commit 29ff02027c68 ("xen: fix implicit stat.h/module.h include usage
in xen-selfballoon.c") from the moduleh tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/xen/xen-selfballoon.c
index d93c708,e21e3ce..0000000
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@@ -68,8 -68,8 +68,10 @@@
   */
 =20
  #include <linux/kernel.h>
 +#include <linux/bootmem.h>
 +#include <linux/swap.h>
+ #include <linux/stat.h>
+ #include <linux/module.h>
  #include <linux/mm.h>
  #include <linux/mman.h>
  #include <linux/module.h>

--Signature=_Tue__25_Oct_2011_19_34_42_+1100_WOpd3DhbC32dsllT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpnSiAAoJEECxmPOUX5FEshgP/1Q8t/7Q/nPNl0tqUIvOihyz
7RKfnS5ipi4aRu09qwtwVGNUV82crDxlii9INDbustYqQEcplL55o6fRDNSlxHbX
bdD7y8U+Pb8gfYRI8SFx6K9Op8YWcgUjy9RbAMXTWmu8H/IsrCpS0jnn9PYK0vNO
92KYyXxJqoqOM8q4yLKwXTZ828p968Sdy/mpMatrS6tPq49vcxA5nG8axY6lvUIN
8SwDRZeMYQmA9nu5UAlp44yQTEazpS9OoHqSJwIAmlwA4Ma1//8tl5oBZKf84BX9
sudU+Z26L/M8r1+FA2Mq0KFAYxVQt1QPA+4bLl40oupmyhKEWKAF3fr5+k+qhfe+
ciYk6yJflUiyS5H0NQU5x6f+s7V4EYb+WytbSYGsoynUXW9nXLNCxuHF8Zy19sB9
VTB+DpWwYNmIWv+6j6TjKwDPXUnnIzWRojZn4V5WTZiIZAIBGfKMgmPSKKhjF3Sk
jpFR0BWzjdmVX1MHQ/DsEtxNx0ZU3Lc+UzX8MJtSPn591l5p4zT6XC9mBO9CtFJg
gg/nHOntNEP/lCR3Gd/5agJEjRlRkdhupgDaV9Ypw9hqLkFW0e5p3qhAw/eFcNjo
K1z5Iuwm+CK6ML1BMVnw2UzZPcDpLAgA1jVJ8c0u5Ac+73oEdHwzxOVMs2DuGzPQ
FBDEUCPqjeGjOPJo542u
=GXBP
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_19_34_42_+1100_WOpd3DhbC32dsllT--
