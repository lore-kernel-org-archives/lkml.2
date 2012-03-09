Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2CIHho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:37:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42990 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2CIHhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:37:43 -0500
Date: Fri, 9 Mar 2012 18:37:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Lee <rob.lee@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the cpuidle-cons tree with the arm-soc
 tree
Message-Id: <20120309183732.512d3676599da324f4747219@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_18_37_32_+1100_uOfxeQ3EVZp.yiKt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_18_37_32_+1100_uOfxeQ3EVZp.yiKt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

Today's linux-next merge of the cpuidle-cons tree got a conflict in
arch/arm/mach-at91/cpuidle.c between commit 00482a4078f4 ("ARM: at91:
implement the standby function for pm/cpuidle") from the arm-soc tree and
commit 7a1f6e72dce1 ("ARM: at91: Consolidate time keeping and irq
enable") from the cpuidle-cons tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/cpuidle.c
index 555d956,d40b3f3..0000000
--- a/arch/arm/mach-at91/cpuidle.c
+++ b/arch/arm/mach-at91/cpuidle.c
@@@ -37,23 -33,15 +33,8 @@@ static int at91_enter_idle(struct cpuid
  			struct cpuidle_driver *drv,
  			       int index)
  {
- 	struct timeval before, after;
- 	int idle_time;
-=20
- 	local_irq_disable();
- 	do_gettimeofday(&before);
- 	if (index =3D=3D 0)
- 		/* Wait for interrupt state */
- 		cpu_do_idle();
- 	else if (index =3D=3D 1)
- 		at91_standby();
 -	u32 saved_lpr;
 -
 -	__asm__("b 1f; .align 5; 1:\n"
 -	"	mcr p15, 0, r0, c7, c10, 4");	/* drain write buffer */
 -
 -	saved_lpr =3D sdram_selfrefresh_enable();
 -	cpu_do_idle();
 -	sdram_selfrefresh_disable(saved_lpr);
++	at91_standby();
 =20
- 	do_gettimeofday(&after);
- 	local_irq_enable();
- 	idle_time =3D (after.tv_sec - before.tv_sec) * USEC_PER_SEC +
- 			(after.tv_usec - before.tv_usec);
-=20
- 	dev->last_residency =3D idle_time;
  	return index;
  }
 =20

--Signature=_Fri__9_Mar_2012_18_37_32_+1100_uOfxeQ3EVZp.yiKt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWbM8AAoJEECxmPOUX5FEJrcP/2jzP/iwY3GBiU03pSBT2NSM
Q7ETFI/a+caZwDIyKW7QVlUSmon4eiBnsbWkILWN9iAD6rcidiqH+MKWEEEA/Y+2
9VLe04XJ6R8Z4vWgOEdHM/d6fvjunjY4ZMUwxSsWveK24j1TQ4GTcjsH8R47VRXb
ychlPvFmJHRArv2JXvh8aG6fZvhT2JFXySiqwsKCcmKMJ2lRmmvdw31FF2cwoFfW
s5IFbrb2lF1mxcZCzGQ/TdVm8ldyiBlW1my6SeQbB9TJLwgM8AKD2LQLx8chBYEN
Ft35O0OAshobPCPSkoX1AAptPJhGSDLjeWZ1dCnmAnplfbOhb573ORDUqpwhlDgx
X5ityMSZfUtq/gxgjaJzLF7rYI6mnl3f0ckBxVnoBC8qGOcrq1t/aLGX2A1RRs9X
Yo3SlG8HBMtMhOBxsOX1zQ7k9VTno9cci4fUMYXzLkFLRW9d90TcsSsBqiIGSH16
699VCTYespgYzGbCDS/5fIDS4X0KaYu/1u1vHBYxHqdzWLN9njAasoBEFTjxyGkB
EoEBk8nyTS4NAPep3dS3YB2iMF1iCliFWPABWxOHAKxNmOywppfyyOuIu2y1aL4r
NLHGbhqhZaw/xmCgNmLtkBrD4+jgOIy+n4W8QdEruOkkoNRpMLeQ05aiB1Swg/mc
pA5DlWEiu80rDLJPz9ww
=eURE
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_18_37_32_+1100_uOfxeQ3EVZp.yiKt--
