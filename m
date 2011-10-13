Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab1JMAMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:12:07 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:59642 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1JMAMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:12:06 -0400
Date: Thu, 13 Oct 2011 11:11:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111013111137.4abf421857ff0ec7ac1edb41@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Oct_2011_11_11_37_+1100_8CR6cAObNPAshA/C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Oct_2011_11_11_37_+1100_8CR6cAObNPAshA/C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/Kconfig between commit d0ee9f404f42 ("ARM: limit CONFIG_HAVE_IDE
to platforms that do") from the arm tree and commit 06a4eada6a73 ("ARM:
switch from NO_MACH_MEMORY_H to NEED_MACH_MEMORY_H") from the arm-soc
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index bb2b5ba,c1c9dc0..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -212,11 -212,20 +212,24 @@@ config ARM_PATCH_PHYS_VIR
  	  this feature (eg, building a kernel for a single machine) and
  	  you need to shrink the kernel to the minimal size.
 =20
+ config NEED_MACH_MEMORY_H
+ 	bool
+ 	help
+ 	  Select this when mach/memory.h is required to provide special
+ 	  definitions for this platform.  The need for mach/memory.h should
+ 	  be avoided when possible.
+=20
+ config PHYS_OFFSET
+ 	hex "Physical address of main memory"
+ 	depends on !ARM_PATCH_PHYS_VIRT && !NEED_MACH_MEMORY_H
+ 	help
+ 	  Please provide the physical address corresponding to the
+ 	  location of main memory in your system.
 =20
 +config GENERIC_BUG
 +	def_bool y
 +	depends on BUG
 +
  source "init/Kconfig"
 =20
  source "kernel/Kconfig.freezer"
@@@ -386,7 -400,7 +404,8 @@@ config ARCH_FOOTBRIDG
  	select CPU_SA110
  	select FOOTBRIDGE
  	select GENERIC_CLOCKEVENTS
 +	select HAVE_IDE
+ 	select NEED_MACH_MEMORY_H
  	help
  	  Support for systems based on the DC21285 companion chip
  	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
@@@ -675,7 -703,7 +710,8 @@@ config ARCH_RP
  	select NO_IOPORT
  	select ARCH_SPARSEMEM_ENABLE
  	select ARCH_USES_GETTIMEOFFSET
 +	select HAVE_IDE
+ 	select NEED_MACH_MEMORY_H
  	help
  	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
  	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@@ -694,7 -722,7 +730,8 @@@ config ARCH_SA110
  	select HAVE_SCHED_CLOCK
  	select TICK_ONESHOT
  	select ARCH_REQUIRE_GPIOLIB
 +	select HAVE_IDE
+ 	select NEED_MACH_MEMORY_H
  	help
  	  Support for StrongARM 11x0 based boards.
 =20
@@@ -841,7 -873,7 +882,8 @@@ config ARCH_U30
  	select CLKDEV_LOOKUP
  	select HAVE_MACH_CLKDEV
  	select GENERIC_GPIO
 +	select ARCH_REQUIRE_GPIOLIB
+ 	select NEED_MACH_MEMORY_H
  	help
  	  Support for ST-Ericsson U300 series mobile platforms.
 =20

--Signature=_Thu__13_Oct_2011_11_11_37_+1100_8CR6cAObNPAshA/C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOliy5AAoJEECxmPOUX5FE/IwP+wQC2PdNJaExiiBpKMZO/BiR
ByTn07oJDmfF3ShL+oe+bUKrI40ZuDtONU/d8NBPp+0pKYOb2vmKIAUNw1aNvHNI
kOVtMNym4ourl+1Skgfpo4a7Z5AEOw0GZTwBkcjgX5t0EqiCv/exaWq7qa/3Wvpo
a1ub/ORUrpqvLUPGWO9HCd2RIX8kgnTS8jNrtVTXQ5T4VGMVTsZv+pQOP4+R/iLd
FMYGi3E7U2j5ZK5KTWAppSjL3neUe0Llj07im6MoRkO7LvE0iV6KpSynvIHUACsi
G79hl4NmTmuyKerSvOH8n00ND8uXffc4FUAPSZNXKXlwy8kHqPzGQVc5G72pVCNq
I7wEEo0dXy6iwMsoA2KJ5bLJXL9IFoA2H31mKz9vlgFEJCm0u/yLs4AiIjwGA5CX
Nc4Bi+Hv3Zh1h785AsKzusXzesWyQje93glcDegk29SR/Z0QcgSFwA6aBgjJvDj9
CFMRKYFRY24MGklbYt6PD6WWsALmlMgMGlPvv85dJG4Qaz6U4gPQL6BhXOivgYjV
Rtwved7epmTwQfNuQOkoKTsmZo+2k2LN9C1Dms3Wgx6ENGOnImBx9u8WEvlnOs8H
bA5Df+kJWrmku5eovkncjsM29bRkFPXT1kipttAzxyvMTdhXyQ+VuwFl6qS4G3TM
4QsPpgesF2X7/yPOrQ3c
=gIdb
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Oct_2011_11_11_37_+1100_8CR6cAObNPAshA/C--
