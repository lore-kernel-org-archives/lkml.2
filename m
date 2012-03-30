Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab2C3ALn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:11:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48665 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2C3ALg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:11:36 -0400
Date: Fri, 30 Mar 2012 11:11:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        David Howells <dhowells@redhat.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20120330111123.300bf9558ee25ac9f46a7ebe@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Mar_2012_11_11_23_+1100_MbaMWvT=xMvRkiwd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Mar_2012_11_11_23_+1100_MbaMWvT=xMvRkiwd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm tree got conflicts in
arch/arm/mach-integrator/core.c and arch/arm/mach-integrator/pci.c
between commit 9f97da78bf01 ("Disintegrate asm/system.h for ARM") from
Linus' tree and commit 695436e3738e ("ARM: 7349/1: integrator: convert to
sparse irqs") from the arm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-integrator/core.c
index 1a65d77,304dfb2..0000000
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@@ -25,8 -25,10 +25,9 @@@
 =20
  #include <mach/hardware.h>
  #include <mach/platform.h>
- #include <asm/irq.h>
  #include <mach/cm.h>
+ #include <mach/irqs.h>
+=20
 -#include <asm/system.h>
  #include <asm/leds.h>
  #include <asm/mach-types.h>
  #include <asm/mach/time.h>
diff --cc arch/arm/mach-integrator/pci.c
index 36068f4,e15aa43..0000000
--- a/arch/arm/mach-integrator/pci.c
+++ b/arch/arm/mach-integrator/pci.c
@@@ -26,7 -26,7 +26,6 @@@
  #include <linux/interrupt.h>
  #include <linux/init.h>
 =20
- #include <asm/irq.h>
 -#include <asm/system.h>
  #include <asm/mach/pci.h>
  #include <asm/mach-types.h>
 =20

--Signature=_Fri__30_Mar_2012_11_11_23_+1100_MbaMWvT=xMvRkiwd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPdPorAAoJEECxmPOUX5FEqpoQAKT2bvqEnwGjlGsLHwRYlVu+
Z8cAyRTI4OSgFRxwi8Pic4J745NEHf9ApHCVN9J9iN8k/xFzZBCr4zn4jVcn0mNK
B3abexUXbiM4pPIM5qvQaWV9hqdkBLx+GGF/jOc4CtBC4gCpFrwR+ZKMKYkk+OK3
DDxl04MksZL6KYn0kibgODXAv5weBAR6yEqIUcTM1DVvvG6XLgz/4hvPUGNc3le+
PzlggTWZLuNwPEWNKsqXwa25lRnWiaObUqbIvep/leJCMJh3ArM+Sk56bTYNuBdk
Tp+p5G2YIE6yIooQUlDEJVbfGvg5pH/4PTezKK3B1xia+MWeFVZRZTTJdJlIMr2j
AosOeIBI0OWTIChB3Wky3HVJgk84oysewafxl2nnOQh2O+tZNRd280aiI1QLAVUl
akWEfM+VBg/HFZt625U8IGbgPUu3UFxEyH6njZa6gvASwCyDT5pO2RffzEIhvfQM
ZEJGTc7tLWXbmGF1xP6Gnz/EQQOUdfUl/zVpeecKc54e2bZUeFhZO3Ra9oQRvBFZ
GoTM3DAVL1YTJtjoljPV4rrM863heLXn2bjH9DqYZ9oCfWcpgjzFuQ6jY2ijM+gX
kQealiZBsOk5Ja9m3qqn/pVUOl8oRdtgwLcHJKIEc/sZ4jMsERBJ2IMmrHCKTjTl
06joHl7QcouezUVFfIjg
=hLUg
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Mar_2012_11_11_23_+1100_MbaMWvT=xMvRkiwd--
