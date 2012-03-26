Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2CZBRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:17:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55284 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2CZBRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:17:31 -0400
Date: Mon, 26 Mar 2012 12:17:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>, Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the scsi tree
Message-Id: <20120326121719.dc4c2b1faca5cf12c8d76d93@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Mar_2012_12_17_19_+1100_OILfI=tkKPPBzt6X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Mar_2012_12_17_19_+1100_OILfI=tkKPPBzt6X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/staging/keucr/scsiglue.c:349:2: error: unknown field 'proc_info' sp=
ecified in initializer
drivers/staging/rts_pstor/rtsx.c:258:2: error: unknown field 'proc_info' sp=
ecified in initializer
drivers/staging/rts5139/rts51x_scsi.c:2190:2: error: unknown field 'proc_in=
fo' specified in initializer

Caused by commit 104c4fe25dc9 ("[SCSI] remove scsi_host_template::proc_info=
").

Since this is a staging driver, I applied these following patches:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 26 Mar 2012 12:07:35 +1100
Subject: [PATCH] scsi: disable broken staging driver

This driver is broken by commit 104c4fe25dc9 ("[SCSI] remove
scsi_host_template::proc_info") from the scsi tree.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/keucr/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/keucr/Kconfig b/drivers/staging/keucr/Kconfig
index ba756bf..aef4858 100644
--- a/drivers/staging/keucr/Kconfig
+++ b/drivers/staging/keucr/Kconfig
@@ -1,6 +1,6 @@
 config USB_ENESTORAGE
 	tristate "USB ENE SM card reader support"
-	depends on USB && SCSI && m
+	depends on USB && SCSI && m && BROKEN
 	---help---
 	  Say Y here if you wish to control a ENE SM Card reader.
 	  To use SD/MS card, please build driver/usb/storage/ums-eneub6250.ko
--=20
1.7.9.1

=46rom 4c836f9935ea1d2b2bc365aa1af70afbb2545311 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 26 Mar 2012 12:13:34 +1100
Subject: [PATCH] scsi: disable more staging drivers due to scsi breakage

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/rts5139/Kconfig   |    2 +-
 drivers/staging/rts_pstor/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rts5139/Kconfig b/drivers/staging/rts5139/Kcon=
fig
index afd526b..56bff83 100644
--- a/drivers/staging/rts5139/Kconfig
+++ b/drivers/staging/rts5139/Kconfig
@@ -1,6 +1,6 @@
 config RTS5139
 	tristate "Realtek RTS5139 USB card reader support"
-	depends on USB && SCSI
+	depends on USB && SCSI && BROKEN
 	help
 	  Say Y here to include driver code to support the Realtek
 	  RTS5139 USB card readers.
diff --git a/drivers/staging/rts_pstor/Kconfig b/drivers/staging/rts_pstor/=
Kconfig
index 4d66a99..1980a49 100644
--- a/drivers/staging/rts_pstor/Kconfig
+++ b/drivers/staging/rts_pstor/Kconfig
@@ -1,6 +1,6 @@
 config RTS_PSTOR
 	tristate "RealTek PCI-E Card Reader support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && BROKEN
 	help
 	  Say Y here to include driver code to support the Realtek
 	  PCI-E card readers.
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__26_Mar_2012_12_17_19_+1100_OILfI=tkKPPBzt6X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPb8OfAAoJEECxmPOUX5FEmmkP/RLlaNXyx63L7JIyUoraNdyb
YrZrwkFwPggL0ICPt0w6+l2TtxcZuavwA6KAW4zkr4FLZ1KWjh3ZgUkuW5yd4O/R
i6sB/uoaVvxTEZLxNJawQzBrxKfY+ToIuac7JThrjFIcu+5cSNFqEItIRo4G0bA/
K5Kh0AZ9ZMBWA784elHg1XemK8L5Zush7gNGAOmK4csMjzJLPSF4SFSsKLPcAviv
BzPFGrVeY4xU7x4H4gCXUJwIbYGGWoQalYb+ZUbEOSrfyDo+n3eE3TQ9n1Q5lA7J
OkKXCA9YMJs4jn5BIjuW3h2EYCD4u0ojMXgmHZZwVjKUvBUGBTIEcFPbKsA4BT0Q
r+hJvTktKq+YrKWMevBr5nMBaFFYzwpydO0RvE/fEdQEHiM06TJDa7+jPKOdAhDI
Pc1GDk1hpc2OBJ/aeM8agLd8dGnvNVJsqzVk+JeXjGR0I71JWvMy+WbyZ/JcY2UJ
xu1FpBkUuydRE7iV9jGGUvqWrrYxeTzHaIhhn5MaBQkkhb6ydBKVVJGQS7KnlmJu
SDj9IHFw1IgFnueFn4oMvXyQpGcYk0JdXJuYfcd6do99xY1/LNb2Q4pULMY39308
We3CYMe0aGOsXFuUQOpEqAbe4t84EthyEkDTxXKJWxpo57K6MzpJ+nRrERN+HAH0
ceJpujRUNVOaCIo0zmTu
=kfdh
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Mar_2012_12_17_19_+1100_OILfI=tkKPPBzt6X--
