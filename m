Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab1C1E0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 00:26:23 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:57373 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab1C1E0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 00:26:22 -0400
Date: Sun, 27 Mar 2011 21:26:03 -0700
From: Andres Salomon <dilinger@queued.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MFD: allow cs5535-mfd to build on X86 only
Message-ID: <20110327212603.209ad054@queued.net>
In-Reply-To: <20110328145212.8ed636e8.sfr@canb.auug.org.au>
References: <20110328145212.8ed636e8.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2G/HJEuRCid6Fn3zENk0602"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2G/HJEuRCid6Fn3zENk0602
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Stephen ran into the following build error:

drivers/mfd/cs5535-mfd.c:30:22: error: asm/olpc.h: No such file or
directory

olpc.h exists only on x86 (and in the future, ARM).  Rather than
wrapping the include in an #ifdef, just change cs5535-mfd to only build
on x86.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andres Salomon <dilinger@queued.net>
---

On Mon, 28 Mar 2011 14:52:12 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
>=20
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>=20
> drivers/mfd/cs5535-mfd.c:30:22: error: asm/olpc.h: No such file or
> directory
>=20
> Caused by commit fa1df691688f ("mfd: Add mfd_clone_cell(), convert
> cs5535-mfd/olpc-xo1 to it").
>=20
> I have reverted that commit (and commit adfa4bd4a8bf "mfd: OLPC:
> Clean up names to match what OLPC actually uses" that conflicted with
> the revert).

Whoops, this should fix it.  One could argue that we should allow this
to build on MIPS as well, but.. we'll cross that bridge later.  Thanks!


 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a9a1af4..3fbeb3b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -591,7 +591,7 @@ config AB3550_CORE
 config MFD_CS5535
 	tristate "Support for CS5535 and CS5536 southbridge core functions"
 	select MFD_CORE
-	depends on PCI
+	depends on PCI && X86
 	---help---
 	  This is the core driver for CS5535/CS5536 MFD functions.  This is
           necessary for using the board's GPIO and MFGPT functionality.
--=20
1.7.2.5


--Sig_/2G/HJEuRCid6Fn3zENk0602
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2QDdsACgkQOmXwGc/ULya+vACeLva+4A78P70Un37XTjypu/WR
CskAnjPGOZg5PUAKuAi8Le+sk/RfgOaK
=Pxg6
-----END PGP SIGNATURE-----

--Sig_/2G/HJEuRCid6Fn3zENk0602--
