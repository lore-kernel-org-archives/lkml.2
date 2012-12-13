Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2LMAyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:54:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54495 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab2LMAyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:54:52 -0500
Date: Thu, 13 Dec 2012 11:54:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the cpuidle tree
Message-Id: <20121213115444.c500ea3bdb566b5acdc7c5ff@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Dec_2012_11_54_44_+1100_0b1Ca=q84RT4KBsq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Dec_2012_11_54_44_+1100_0b1Ca=q84RT4KBsq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

After merging the cpuidle tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from drivers/cpuidle/cpuidle.c:23:0:
drivers/cpuidle/cpuidle.h:74:20: error: redefinition of 'cpuidle_state_is_c=
oupled'
drivers/cpuidle/cpuidle.h:44:20: note: previous definition of 'cpuidle_stat=
e_is_coupled' was here
drivers/cpuidle/cpuidle.h:80:19: error: redefinition of 'cpuidle_enter_stat=
e_coupled'
drivers/cpuidle/cpuidle.h:50:19: note: previous definition of 'cpuidle_ente=
r_state_coupled' was here
drivers/cpuidle/cpuidle.h:86:19: error: redefinition of 'cpuidle_coupled_re=
gister_device'
drivers/cpuidle/cpuidle.h:56:19: note: previous definition of 'cpuidle_coup=
led_register_device' was here
drivers/cpuidle/cpuidle.h:91:20: error: redefinition of 'cpuidle_coupled_un=
register_device'
drivers/cpuidle/cpuidle.h:61:20: note: previous definition of 'cpuidle_coup=
led_unregister_device' was here
In file included from drivers/cpuidle/governor.c:15:0:
drivers/cpuidle/cpuidle.h:74:20: error: redefinition of 'cpuidle_state_is_c=
oupled'
drivers/cpuidle/cpuidle.h:44:20: note: previous definition of 'cpuidle_stat=
e_is_coupled' was here
drivers/cpuidle/cpuidle.h:80:19: error: redefinition of 'cpuidle_enter_stat=
e_coupled'
drivers/cpuidle/cpuidle.h:50:19: note: previous definition of 'cpuidle_ente=
r_state_coupled' was here
drivers/cpuidle/cpuidle.h:86:19: error: redefinition of 'cpuidle_coupled_re=
gister_device'
drivers/cpuidle/cpuidle.h:56:19: note: previous definition of 'cpuidle_coup=
led_register_device' was here
drivers/cpuidle/cpuidle.h:91:20: error: redefinition of 'cpuidle_coupled_un=
register_device'
drivers/cpuidle/cpuidle.h:61:20: note: previous definition of 'cpuidle_coup=
led_unregister_device' was here

Caused by a mismerge.  I applied the following merge fix:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 13 Dec 2012 11:52:10 +1100
Subject: [PATCH] cpuidle: fix mismerge

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/cpuidle/cpuidle.h |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index f67517e..ee97e96 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -63,34 +63,4 @@ static inline void cpuidle_coupled_unregister_device(str=
uct cpuidle_device *dev)
 }
 #endif
=20
-#ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
-bool cpuidle_state_is_coupled(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int state);
-int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int next_state);
-int cpuidle_coupled_register_device(struct cpuidle_device *dev);
-void cpuidle_coupled_unregister_device(struct cpuidle_device *dev);
-#else
-static inline bool cpuidle_state_is_coupled(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int state)
-{
-	return false;
-}
-
-static inline int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int next_state)
-{
-	return -1;
-}
-
-static inline int cpuidle_coupled_register_device(struct cpuidle_device *d=
ev)
-{
-	return 0;
-}
-
-static inline void cpuidle_coupled_unregister_device(struct cpuidle_device=
 *dev)
-{
-}
-#endif
-
 #endif /* __DRIVER_CPUIDLE_H */
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Dec_2012_11_54_44_+1100_0b1Ca=q84RT4KBsq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJQySdUAAoJEECxmPOUX5FEhTkP92D0ZQNpe3acyCAXhfaj3d2a
4cVpeJ4d6qr8PXFiTlr0Sr3NI8tBzc+9sgwJZ3zu+5patJwbWFZdDYPLCBy9JbwH
MeJf24ZibY157AgMtWZJee3SBLTW4e5Wpvr7PH5EfgcUdvVtul54pDHxuLY8AIp2
wkPHb81NPtfaX4FGt9bEt03sgsbTFqapbVY/Bl4anK/8fgpykDjb59nPJeSy5fKG
2KC7nL0v4cRNt8K0XecFqNll9AQOSo1YH55H+GK/93bYIdmHG3i/uyEA820hKHLH
SgH6XyNJHIkIJ3/I9VdHMMj3tejv89wc+o8OHq7AAxl2NdvDWkcqEaGqYfAe44Ih
37NnaEpWqx35Ul8lV21Sm/GWdRz7XHf8vU6NPs6+O1RAgVgbDjl+SVhAdyvohH/8
cEnhpCJuq7P7N4trvcX8J8FfYnGlnbOw4/mw6ylFXudJpSw7vN5qFZasUh1Uu7mX
a/3i7V6pS/4SGtdRvN+JwP+rnkAEuTWM4rUOOM3qWWTVlXv+6xSazMu6ybDFTfvt
lH6Qj3L3Ur1W13LVC9JLQhId/hr/fwlKOX8oSNcv/iitw0YxfT5YfQ/I/PYbFEsQ
jnMHZI4xE/4YvtWjcJYOxreoldS+cRWxlT0kW8ze3F7KOnXFSZz5CK/2+F70Yprs
IMrn3KeVADrULcvTd7A=
=phO5
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Dec_2012_11_54_44_+1100_0b1Ca=q84RT4KBsq--
