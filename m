Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0CTXHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 19:07:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60359 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab0CTXHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 19:07:33 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1269126097.18314.111.camel@localhost>
References: <1269126097.18314.111.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lLaOouP5Gq7Hvp+q2yEI"
Date: Sat, 20 Mar 2010 23:07:26 +0000
Message-ID: <1269126446.18314.117.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 4/4] pci/dmar: Tone down warnings about invalid BIOS DMAR
 tables
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lLaOouP5Gq7Hvp+q2yEI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We now know how to deal with these tables so that they are harmless.
Use the TAINT_FIRMWARE_WORKAROUND flag and don't say the BIOS is
'broken' as this makes users think of hardware damage.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/dmar.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index f101057..8aa31c2 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -615,12 +615,13 @@ int __init dmar_table_init(void)
=20
 static void warn_invalid_dmar(u64 addr, const char *message)
 {
-	WARN_ONCE(1, "Your BIOS is broken; DMAR reported at address %llx%s!\n"
-		  "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-		  addr, message,
-		  dmi_get_system_info(DMI_BIOS_VENDOR),
-		  dmi_get_system_info(DMI_BIOS_VERSION),
-		  dmi_get_system_info(DMI_PRODUCT_VERSION));
+	WARN_TAINT_ONCE(1, TAINT_FIRMWARE_WORKAROUND,
+			"BIOS bug: DMAR reported at address %llx%s!\n"
+			"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+			addr, message,
+			dmi_get_system_info(DMI_BIOS_VENDOR),
+			dmi_get_system_info(DMI_BIOS_VERSION),
+			dmi_get_system_info(DMI_PRODUCT_VERSION));
 }
=20
 int __init check_zero_address(void)
--=20
1.7.0



--=-lLaOouP5Gq7Hvp+q2yEI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6VVLee/yOyVhhEJAQKgyQ/+MpBjOhJAJiKVMEZJkEW+ilzzaPLhyhdJ
/5A6V/WJ4V87fCBfjiDtKiA6702nWboFZJhxS7iQC9qurn7GOI5BKPh6GYqW/NZO
l8zvq5OMm9TzpX3c0McO4PCzG/LWGPA8/fIts1a5oyamPjQHxCd0ymoR84OnwJ9a
isQZwIgmvHRc7IduOs/KceLKoBmV0dU7JcZu03CDX34Z3HxTs89Yttt9vhMKt7rh
bCkObgVb/HfRzZm1jJ8oaFmjciY7ansqpDHK7eFUAXWqKcATDK1A4DeLe2jXtM3W
sgOj5WxDW6spGhq2RnYImVPIBT0OvJyOzeTL1V7py3z2PcC/16DEtOsDdWqrRT9F
kiXD1w90Vc8c56fZENZ7/eSgjEhBZRXUFN5lHLIKgngyE3N+efrurau2EikeIhs0
KcFLyaIXc87irlrnMav19b3qw0BnENQ95nMZaWT9J82NobvwpT4+O4rOx44QKXI5
qR7bLgPEYclax7W5XkGkEPSan+9dHU9awiTayo2qSGebG13xc4Dme6k6aJraA0/z
SM7IzEeFNNjxW0/OP3GUc1vxU46Yc6hE/Dxtd+7WjyE3QqtHmL9KeHaSjMx+0MsS
ULavby8OSXJYcMqR3p5xoFepPKoOSjwtDFNfgTIbMSN3anHYqEMX/oq2cTlhbfeA
sM+7kU8Ajig=
=QbjR
-----END PGP SIGNATURE-----

--=-lLaOouP5Gq7Hvp+q2yEI--
