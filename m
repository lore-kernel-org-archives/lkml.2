Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2IQJUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:20:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54237 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab2IQJUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:20:15 -0400
Date: Mon, 17 Sep 2012 19:20:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the arm-soc tree with the staging tree
Message-Id: <20120917192005.ab08c24f98010107fa855edf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_19_20_05_+1000_S5mXClr=.F4ef9tE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_19_20_05_+1000_S5mXClr=.F4ef9tE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/staging/tidspbridge/core/wdt.c between commit c37a1747acbf
("staging: tidspbridge: Prepare for irqs.h removal") from the  tree and
commit ec2c0825ca31 ("ARM: OMAP2+: Remove hardcoded IRQs and enable
SPARSE_IRQ") from the arm-soc tree.

I fixed it up (I guess - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/tidspbridge/core/wdt.c
index 1ed1474,453ef74..0000000
--- a/drivers/staging/tidspbridge/core/wdt.c
+++ b/drivers/staging/tidspbridge/core/wdt.c
@@@ -25,8 -25,7 +25,8 @@@
  #include <dspbridge/host_os.h>
 =20
 =20
 +#define OMAP34XX_WDT3_BASE 		(0x49000000 + 0x30000)
- #define INT_34XX_WDT3_IRQ 		36
+ #define INT_34XX_WDT3_IRQ 		(36 + NR_IRQS)
 =20
  static struct dsp_wdt_setting dsp_wdt;
 =20

--Signature=_Mon__17_Sep_2012_19_20_05_+1000_S5mXClr=.F4ef9tE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVutFAAoJEECxmPOUX5FENCcP/2p3IV/aTfk6pCihRC4Zzp/V
UEg6dO58h9zxYlkdJH344S6DJHXV1j+klwPd9dyhrMDz5mt3vT/aMXbyfm20PEyo
enqlo10Wn9s+Zxk5LHwG2aX8lUpfab5t/K/AV9Hbjj2IBp+JnJJHcdj4ofSlrb/V
/ogOE7U2tC1kd9UEzJ3DIXUY2gCu3GEeV0EN3SrvkNPw4jnMzCisyUjvYLHAD0NM
m9wfTznirIW0EPVHBS67R/nHjOvRo9++KFus/ymVtXRYqubruMtv67/1MQYakYuG
/TkrOcMjvNefkDuXF7BHjUkMqGtYeL9pjBd1RjVSzCjMylcHsmO0IiKNiSyRxpTB
CY99v8cUPXgyYYOvBpU9/ibSrRoEdiJxULlIMmKbUczPe20jip+NzordkTwQElV+
S7kllJsnMw5ptdNj34a1KyAF1kgkiL5jNcck6I9uRE8BuJAbNIWMm43eXdrQUMYm
hfrp2QkUNcNPUGPk9OT98KBvKuyHrLHgV1O4rEbKMKtbLTS/cXdzzFI4V2x4B3uZ
QOSjqCqZdOdY9rLNSHuCYCjuavdy+QsvjpRdFOVgUblEVRtI4f7QgjWD0CvAOtjE
aV+5/NRnoQytjMnE85+2odp4SaAAShV0xQsnKvIsm6qJsNF7wHPKiQ0reHd8y4GJ
JTxUF/W8qkGZ2Yk33zTW
=fyaY
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_19_20_05_+1000_S5mXClr=.F4ef9tE--
