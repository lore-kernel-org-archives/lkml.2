Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2CHEo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:44:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46465 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2CHEnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:43:45 -0500
Date: Thu, 8 Mar 2012 15:41:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] driver-core: remove legacy iSeries hack
Message-Id: <20120308154109.774ae0231cee1a98d41a7b94@canb.auug.org.au>
In-Reply-To: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_15_41_09_+1100_Qh28XMvZSrBtVnLc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_15_41_09_+1100_Qh28XMvZSrBtVnLc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The PowerPC legacy iSeries plateform is being removed along with the
"one looney iseries driver", so this code can now be removed as well.

cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/driver.c  |   30 ------------------------------
 include/linux/device.h |    4 ----
 2 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index b631f7c..db4f54c 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -124,36 +124,6 @@ void driver_remove_file(struct device_driver *drv,
 EXPORT_SYMBOL_GPL(driver_remove_file);
=20
 /**
- * driver_add_kobj - add a kobject below the specified driver
- * @drv: requesting device driver
- * @kobj: kobject to add below this driver
- * @fmt: format string that names the kobject
- *
- * You really don't want to do this, this is only here due to one looney
- * iseries driver, go poke those developers if you are annoyed about
- * this...
- */
-int driver_add_kobj(struct device_driver *drv, struct kobject *kobj,
-		    const char *fmt, ...)
-{
-	va_list args;
-	char *name;
-	int ret;
-
-	va_start(args, fmt);
-	name =3D kvasprintf(GFP_KERNEL, fmt, args);
-	va_end(args);
-
-	if (!name)
-		return -ENOMEM;
-
-	ret =3D kobject_add(kobj, &drv->p->kobj, "%s", name);
-	kfree(name);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(driver_add_kobj);
-
-/**
  * get_driver - increment driver reference count.
  * @drv: driver.
  */
diff --git a/include/linux/device.h b/include/linux/device.h
index b63fb39..46baa1f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -264,10 +264,6 @@ extern int __must_check driver_create_file(struct devi=
ce_driver *driver,
 extern void driver_remove_file(struct device_driver *driver,
 			       const struct driver_attribute *attr);
=20
-extern int __must_check driver_add_kobj(struct device_driver *drv,
-					struct kobject *kobj,
-					const char *fmt, ...);
-
 extern int __must_check driver_for_each_device(struct device_driver *drv,
 					       struct device *start,
 					       void *data,
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_15_41_09_+1100_Qh28XMvZSrBtVnLc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWDhlAAoJEECxmPOUX5FECgYQAKGih4RohPu6oJpWijB8zSOZ
4ZrMdkvFMxB33gyjUXw+UEcJtRcSHHKdV7HIYeB/s0xKZO5IEhv4O+gzHZasDO7f
54ayxQw7g98oWQNC0vuNORS7901RDm48/aoFBP3ijqmfxtZnR7cRwVf8XihRmheq
mTkRMUJrSxphvqqit/3XkbWPeSbD2zA8+i9Bgqk06TNnvAIDkLgkXASIikmnrOKB
Z1/etjXoMhv9Cv3AR5RH0L/vibCNrLARxAaIEqJeSBhEfaSJlPUDcqJKeXJnuYwJ
YBGMljRNZ2kqw2ReS37nDGYPMO0t81oNiqMkMR1MVUkQ0AJh394Xaf2c+xcVhYqA
ovgMw6uhE4tGUU4hBm53GXz+B5EvHq2lcOhYOCBpNZP812FrnZs82mVeYJthY5Vq
YY53PuY9KEHrFvL/8MVNoLan8Ow54JL0Rx93M5iNPtYtIuXb6iDimqGQFdeT49cy
D1rbhoapnWrVbtMGrM99IOlDpxfC9fI8jGCnTZ3HuCTK33NXp+0oGydxoRbhy5O6
jTk5QJjSw7/YC+EUvW+fCZkWWysGc61MV6lddSNHQEqxQifx8SdHKtG2WLPJEVc7
0dRXy0o5At1nbsWRpt44ZaLDgJO3lxrOZvzYusQ6EyuMpahJwGgHYHOLj8Gk1rgm
RUULIOQqezk5XGIL4OR+
=umxQ
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_15_41_09_+1100_Qh28XMvZSrBtVnLc--
