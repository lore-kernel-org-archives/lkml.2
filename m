Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2JBBf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 21:35:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47773 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2JBBfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 21:35:55 -0400
Date: Tue, 2 Oct 2012 11:35:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: linux-next: build failure after merge of the acpi tree
Message-Id: <20121002113546.cf53b96a62e0e32786e76af2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_11_35_46_+1000_PRRWy7bHa1hMOnjm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_11_35_46_+1000_PRRWy7bHa1hMOnjm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

After merging the acpi tree, today's linux-next build (x86_64_allmodconfig)
failed like this:

drivers/usb/core/usb-acpi.c: In function 'usb_acpi_check_port_connect_type':
drivers/usb/core/usb-acpi.c:90:18: error: storage size of 'pld' isn't known

Caused by commit 05f916894a69 ("usb/acpi: Store info on device
removability") from Linus' tree interacting with commit 8ede06aba5df
("ACPI: Use ACPICA native way to decode the PLD buffer") from the acpi
tree.

I applied this merge fix that I have been applying to the usb tree (which
has now been merged by Linus).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 24 Sep 2012 16:51:38 +1000
Subject: [PATCH] usb-acpi: Comply with the ACPI API change after usb tree m=
erge

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/usb/core/usb-acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/usb-acpi.c b/drivers/usb/core/usb-acpi.c
index 0ef7d42..e9b159a 100644
--- a/drivers/usb/core/usb-acpi.c
+++ b/drivers/usb/core/usb-acpi.c
@@ -87,7 +87,7 @@ static int usb_acpi_check_port_connect_type(struct usb_de=
vice *hdev,
 	acpi_status status;
 	struct acpi_buffer buffer =3D { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *upc;
-	struct acpi_pld pld;
+	struct acpi_pld_info *pld;
 	int ret =3D 0;
=20
 	/*
@@ -111,13 +111,13 @@ static int usb_acpi_check_port_connect_type(struct us=
b_device *hdev,
 	}
=20
 	if (upc->package.elements[0].integer.value)
-		if (pld.user_visible)
+		if (pld->user_visible)
 			usb_set_hub_port_connect_type(hdev, port1,
 				USB_PORT_CONNECT_TYPE_HOT_PLUG);
 		else
 			usb_set_hub_port_connect_type(hdev, port1,
 				USB_PORT_CONNECT_TYPE_HARD_WIRED);
-	else if (!pld.user_visible)
+	else if (!pld->user_visible)
 		usb_set_hub_port_connect_type(hdev, port1, USB_PORT_NOT_USED);
=20
 out:

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Oct_2012_11_35_46_+1000_PRRWy7bHa1hMOnjm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQakTyAAoJEECxmPOUX5FEplAQAJsktGKXLNAWYvGDZZ7Rpnhx
iB+4hdziZYOhAv4o1ZhhbmpdiHwRX2+oVQPdBGfFq9AFajdiTwywGIWJ99O+9ODT
QXLeqyU+EgiNhUvMFMgjksJwnZrDmzKhyWNahvb/zpIWj1jLqfa0ohWOD+1bpC3S
CIRQnL3iLKJtO17mZwW88Z9LkSX9tZ31jPbR0E9NlqQnEE8bFmBbkgQ14f4IXUf5
HyOgvr6M+9jGe2y5vyi6QzeWHxE7Hsvhhu8QImA2qPT7UbdlpH6rNZODGwZLrJZ3
NNXdCUVbwgpZiq0Xve2PSGpWkXjsr4AYC4t613k04OxwdKrMUTiIo3joHCBfysB1
JzES6m3QV9R3jy2vny94NhcAZFv5B5/Sj8fF0luke+UMRkUd+2buoapi1pcCB2sA
gmIu9I/oYBg4TG96j8JUr7b2u5JTSzit6rSyT8HDT0w1I5omJgZPImZZdDJOUFpz
cLOjDwICJ2C5/kS7l/Yt4dQrhEv5FERiYlYVPCiRkwLdm9PtG76jOlajVzf+2fJy
4R5xYRQ/RwbqtIkk0ciPQerCrHvoN0irdi9U0n32MbeyvTb209Z2R3e05XIvkZsl
z7YNt9/GozFlft6YZR9SAH4mZXbL67A/Mc1/iSChD8HHuPJeMDLl+qnP09YL0agB
J+yFGZmLIwEb8YfbsNRy
=96cu
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_11_35_46_+1000_PRRWy7bHa1hMOnjm--
