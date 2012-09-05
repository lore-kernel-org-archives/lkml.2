Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2IEFsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:48:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39182 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2IEFsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:48:05 -0400
Date: Wed, 5 Sep 2012 15:48:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?B?IlNhbXVlbCBJZ2xlc2lhcyBHb25zw6Fs?= =?UTF-8?B?dmV6Ig==?= 
	<siglesias@igalia.com>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20120905154801.b21cf25d96767b69489aec29@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Sep_2012_15_48_01_+1000_1DehWrO0g8CEmm2i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Sep_2012_15_48_01_+1000_1DehWrO0g8CEmm2i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/ipack/ipack.c: In function 'ipack_device_read_id':
drivers/staging/ipack/ipack.c:291:2: error: implicit declaration of functio=
n 'ioread8' [-Werror=3Dimplicit-function-declaration]
drivers/staging/ipack/ipack.c:309:3: error: implicit declaration of functio=
n 'ioread16be' [-Werror=3Dimplicit-function-declaration]

Caused by commit 187e47824013 ("Staging: ipack: Read the ID space during
device registration").

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 5 Sep 2012 15:44:11 +1000
Subject: [PATCH] Staging: ipack: disable due to build error

The powerpc allyesconfig build gives this:

drivers/staging/ipack/ipack.c: In function 'ipack_device_read_id':
drivers/staging/ipack/ipack.c:291:2: error: implicit declaration of functio=
n 'ioread8' [-Werror=3Dimplicit-function-declaration]
drivers/staging/ipack/ipack.c:309:3: error: implicit declaration of functio=
n 'ioread16be' [-Werror=3Dimplicit-function-declaration]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/ipack/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfig
index af32178..5c428d7 100644
--- a/drivers/staging/ipack/Kconfig
+++ b/drivers/staging/ipack/Kconfig
@@ -4,6 +4,7 @@
=20
 menuconfig IPACK_BUS
 	tristate "IndustryPack bus support"
+	depends on BROKEN
 	---help---
 	  If you say Y here you get support for the IndustryPack Framework
 	  for drivers for many types of boards that support this industrial
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__5_Sep_2012_15_48_01_+1000_1DehWrO0g8CEmm2i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRueRAAoJEECxmPOUX5FE4KUP/0DKRtFn9HXsE2ZTRu7Qq5Nj
u3ZoOcL9HNffrH6T9zkoyqcweHVjT+KgvPp4pHMqVRGhGhZ1Y/pVj1zxQjXdGpZ2
H+aLAbst8Sqn0fXaqD309ap1mKP+0GdcW6ICEQBVxIXFOo8zqMcVPRWDAgLBlZR6
lyeFWsyvNTk8fxsfQiDROksCkq5nW14pLhW7T/avlimfClHi4XGkCWwT9ABq/MB1
4kfnq9QqxEBkA1u7G2BisYJosXJAvn/PCDYDgGqhBm9YRJ1RfnyN/cVNtHNFUs2J
l2K7fGoCftoanHcEAd9bJYdFg/Zgrcsd4gsCVKJ41Zzy8m6+1j5GN/1suh84F/Lh
hA0YaIREpHei98AltZSymEMc/XbNLeAqobW2sZPLHqNzLbrNR/vxM0kJz6sotCOx
ye8ic+R2npQAO0zqcwteYgjdfvJ2bADGDaLMwjhvHbsmAJ26r4E+8tlfSRwNi8m7
VpA6SR0gbp7gxiB9Vmsjl24qyCu7UiqA6dQigCqJstgIB3rONZ9Jan0V+VttFjDn
lv4s/4y7XW/2qa0qCU/jdgOoC3JIGTK2sunpEHAHvROzT8OK/3QzSOzPWQXckgEu
kresFmxo+67viKStTIk9Wr9j1/u0e7Y/fk8pIK6g0HidR7SAFkPNMEgxNb2kHtlz
bkpx532nu6BfVnNGHBRs
=R2Ey
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Sep_2012_15_48_01_+1000_1DehWrO0g8CEmm2i--
