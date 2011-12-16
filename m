Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab1LPE5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:57:17 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:36677 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab1LPE5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:57:16 -0500
Date: Fri, 16 Dec 2011 15:56:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
        Dimitri Sivanich <sivanich@sgi.com>
Subject: linux-next: manual merge of the akpm tree with the driver-core tree
Message-Id: <20111216155654.238e65a67263d1ca5884e74a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Dec_2011_15_56_54_+1100_XD.OR=_5WWSA2eVd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Dec_2011_15_56_54_+1100_XD.OR=_5WWSA2eVd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/base/sys.c between commit ca22e56debc5 ("driver-core: implement
'sysdev' functionality for regular devices and buses") from the
driver-core tree and commit "tick-sched: add specific do_timer_cpu value
for nohz off mode" from the scsi-post-merge tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/sys.c
index 409f5ce,67d81a2..0000000
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@@ -331,8 -331,14 +331,6 @@@ void sysdev_unregister(struct sys_devic
  EXPORT_SYMBOL_GPL(sysdev_register);
  EXPORT_SYMBOL_GPL(sysdev_unregister);
 =20
- #define to_ext_attr(x) container_of(x, struct sysdev_ext_attribute, attr)
-=20
 -int __init system_bus_init(void)
 -{
 -	system_kset =3D kset_create_and_add("system", NULL, &devices_kset->kobj);
 -	if (!system_kset)
 -		return -ENOMEM;
 -	return 0;
 -}
 -
  ssize_t sysdev_store_ulong(struct sys_device *sysdev,
  			   struct sysdev_attribute *attr,
  			   const char *buf, size_t size)

--Signature=_Fri__16_Dec_2011_15_56_54_+1100_XD.OR=_5WWSA2eVd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6s+WAAoJEECxmPOUX5FEJqYP/1whTK9cxsueG4dt15ijENIK
0PfOf0xzDXw6XXO4tAHr26R54X3Rxe1WFt3qTvnPcXqJi4HBHoUOf3eZuIUBtd/4
iET24PuaUABT8HSGEzgUbAsIkoxFFJmPhe2Hb84yzTaI18km70C0/x9aQVK7WVzB
nErI6XJkg58D+nR6yZ1HbTjFvpNYSYoeOVmjdl6cVyL/g19poJGBmvv5gNK3/kbP
WkerfYBbxwjmmccnccmAP4pjXlW13LHIuzTBohgVKFY8QSQ9TsWBIIYdSJyTbvJo
IOiuRlmhLyZcq+RW4GMQlzkyWQa/+lNI82/eOthIbeyjQSACwoxhZ46xbUuQwdzs
KuHCqlpb77fiSJjpwZeI+kw5svsLnQJYu0CuqiptXE6kgF2Nlz8+YfWluZPZ5jk2
Tm3mDErGpihgPfjk2K+Osf7Ud/Lx5+bi9haqQkKo+r3reHCNnxOGfge/XNGOiS2R
OVnBsIJ6VrWn0//2Q+lB9HtKtpW/fx71E/w9SX0mtXZy4xJnKrJwMwHALvtybnQp
NBz0AL4kLHMETRwt7nt/4ysKzDH94zAfYB+ikWDdwJZvtkglnkL9Raagk/6LOczh
iOn39PCoSbe5o1NIynkf1ReCpVlPLE/TPtzdulch/XUsKFwjnWqBUvElgkQC+z/U
aaBS6JpH1r8YqWcy4uNT
=RsvE
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Dec_2011_15_56_54_+1100_XD.OR=_5WWSA2eVd--
