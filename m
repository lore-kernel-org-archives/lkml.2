Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab2J2DAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 23:00:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52750 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab2J2DAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 23:00:45 -0400
Date: Mon, 29 Oct 2012 14:00:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the signal tree with the sparc tree
Message-Id: <20121029140032.4019da59dbc50a9be8df9ebc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Oct_2012_14_00_32_+1100_oAlS627FKtqZruV9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Oct_2012_14_00_32_+1100_oAlS627FKtqZruV9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/sparc/kernel/sys_sparc_64.c between commit 517ffce4e1a0 ("sparc64:
Make montmul/montsqr/mpmul usable in 32-bit threads") from the sparc tree
and commit 2f12af35a988 ("sparc64: switch to generic kernel_execve()")
from the signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sparc/kernel/sys_sparc_64.c
index 878ef3d,adfe60e..0000000
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@@ -729,30 -729,3 +729,8 @@@ SYSCALL_DEFINE5(rt_sigaction, int, sig
 =20
  	return ret;
  }
 +
- /*
-  * Do a system call from kernel instead of calling sys_execve so we
-  * end up with proper pt_regs.
-  */
- int kernel_execve(const char *filename,
- 		  const char *const argv[],
- 		  const char *const envp[])
- {
- 	long __res;
- 	register long __g1 __asm__ ("g1") =3D __NR_execve;
- 	register long __o0 __asm__ ("o0") =3D (long)(filename);
- 	register long __o1 __asm__ ("o1") =3D (long)(argv);
- 	register long __o2 __asm__ ("o2") =3D (long)(envp);
- 	asm volatile ("t 0x6d\n\t"
- 		      "sub %%g0, %%o0, %0\n\t"
- 		      "movcc %%xcc, %%o0, %0\n\t"
- 		      : "=3Dr" (__res), "=3D&r" (__o0)
- 		      : "1" (__o0), "r" (__o1), "r" (__o2), "r" (__g1)
- 		      : "cc");
- 	return __res;
- }
-=20
 +asmlinkage long sys_kern_features(void)
 +{
 +	return KERN_FEATURE_MIXED_MODE_STACK;
 +}

--Signature=_Mon__29_Oct_2012_14_00_32_+1100_oAlS627FKtqZruV9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQjfFQAAoJEECxmPOUX5FE0tcP/jdoZEGXlYP2jEfY48gltygc
luwMR6pkHYE5+YrA0n8SH4p7liWlqS5wc8tB4nw/nAYXDVbawE2iYDL/JRR7KniA
ns09UYZRpi8RBn5gHmtM8JLbfMVsgP1SizJPosHZXbAE6xMAanWBjm0c2uzFqOtx
JI7/v97eEp4tG/MxweE8BNRjrcqCdEjl+nfMJuYK2VUT5K7cD0GF5Ro1Kuoy5Wte
eQA6CHt/2w29pWIIvA0mkAj7XY2wTFiZwvyJFd4IbhPYnvztx5pzQzM8h1oUrtLb
P4TM18UGIdDTdMJ98fXci0rIBHLRvxBG3cW5/67nsWp+StwRyb78ysaVYEiWMIwV
ujwnGbYKz6YRsCPscCnghBHKf5+TpsbTMW1AUeQJ4oAI4Kg8JV1JP4ToiCTm5z+n
YGLbQznVFP6btWdl2GG6lZK8qmZqXfD0X4WpoE2cX+lb6qf+OYUZYX1gVa9T6EVW
+8j2mtf7+HgZuyphcT2y8Gx7oFS+a/bP3viRJSD66IeIOPvanQPd+txBpjG7lftR
FMNur7RTdeUBfSW+Cgc+1rzkCYx37DnRZH4JhBkiJPexPKxR1/WDHkjZD14Y7Ng4
I+1X4rv8Pad4o/oiweDMmmatJsi9UT5nA5C47bVuofZRwaeBK+beQWDqpVpMzry+
DnUTf8FxAdIRexR1HV85
=O01t
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Oct_2012_14_00_32_+1100_oAlS627FKtqZruV9--
