Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0K3EoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 23:44:21 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58219 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0K3EoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 23:44:20 -0500
Date: Mon, 29 Nov 2010 20:44:10 -0800
From: Andres Salomon <dilinger@queued.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cs5535-mfd: fix warning on x86-64
Message-ID: <20101129204410.339805ef@queued.net>
In-Reply-To: <20101129115257.9a78ad14.sfr@canb.auug.org.au>
References: <20101129115257.9a78ad14.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XhctqklKEiYj3xdxRT7Ax7h"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XhctqklKEiYj3xdxRT7Ax7h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Nov 2010 11:52:57 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Samuel,
>=20
> After merging the mfd tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>=20
> drivers/mfd/cs5535-mfd.c: In function 'cs5535_mfd_probe':
> drivers/mfd/cs5535-mfd.c:106: warning: format '%d' expects type
> 'int', but argument 3 has type 'long unsigned int'
>=20

Ick, ARRAY_SIZE is unsigned int on x86, unsigned long on x86-64.  The
patch below fixes this.




From: Andres Salomon <dilinger@queued.net>

ARRAY_SIZE() returns unsigned long on x86-64 (rather than unsigned int);
cast it to the desired type to shut gcc up.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/cs5535-mfd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index b141ca7..e6f7ebc 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -103,8 +103,8 @@ static int __devinit cs5535_mfd_probe(struct pci_dev *p=
dev,
 		goto err_disable;
 	}
=20
-	dev_info(&pdev->dev, "%d devices registered.\n",
-			ARRAY_SIZE(cs5535_mfd_cells));
+	dev_info(&pdev->dev, "%u devices registered.\n",
+			(unsigned int) ARRAY_SIZE(cs5535_mfd_cells));
=20
 	return 0;
=20
--=20
1.7.2.3


--Sig_/XhctqklKEiYj3xdxRT7Ax7h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkz0gRoACgkQOmXwGc/ULyaUQACdFncDZWX8zzX4140fCPGrA+rI
lOQAnjh/9gDfWwIzZccKqYbbQoUoVGBU
=Z7an
-----END PGP SIGNATURE-----

--Sig_/XhctqklKEiYj3xdxRT7Ax7h--
