Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab2CIFkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 00:40:37 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48502 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2CIFkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 00:40:36 -0500
Date: Fri, 9 Mar 2012 16:40:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: manual merge of the driver-core tree with the powerpc
 tree
Message-Id: <20120309164025.dc16cfacaa2ee35cbeea14a8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_16_40_25_+1100_U=1YSxDOxbeLSt43"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_16_40_25_+1100_U=1YSxDOxbeLSt43
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/base/driver.c between commit fcd6f7620202 ("driver-core: remove
legacy iSeries hack") from the powerpc tree and commit 9875bb480cc8
("Eliminate get_driver() and put_driver()") from the driver-core tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/driver.c
index db4f54c,60e4f77..0000000
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@@ -123,34 -123,36 +123,6 @@@ void driver_remove_file(struct device_d
  }
  EXPORT_SYMBOL_GPL(driver_remove_file);
 =20
--/**
-  * get_driver - increment driver reference count.
-  * @drv: driver.
-  */
- struct device_driver *get_driver(struct device_driver *drv)
- {
- 	if (drv) {
- 		struct driver_private *priv;
- 		struct kobject *kobj;
-=20
- 		kobj =3D kobject_get(&drv->p->kobj);
- 		priv =3D to_driver(kobj);
- 		return priv->driver;
- 	}
- 	return NULL;
- }
- EXPORT_SYMBOL_GPL(get_driver);
-=20
- /**
-  * put_driver - decrement driver's refcount.
-  * @drv: driver.
-  */
- void put_driver(struct device_driver *drv)
- {
- 	kobject_put(&drv->p->kobj);
- }
- EXPORT_SYMBOL_GPL(put_driver);
-=20
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
  static int driver_add_groups(struct device_driver *drv,
  			     const struct attribute_group **groups)
  {

--Signature=_Fri__9_Mar_2012_16_40_25_+1100_U=1YSxDOxbeLSt43
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWZfJAAoJEECxmPOUX5FE2E8QAKURz+UgWmytKfksOiFGysqH
aA85hYHJB/oHtqyeEEeRxVWz1whNBqp/mbl3s9jSXTg/YY5Ug8ruk/Vul0fUYgwZ
qs2kd1uzGgBm4zNLgcXOXD+GQw50qzCA7TZ/TPB1+ZafiixoA2OnqRLwMRFACmxz
cc7AFvEKY3GyFH6aRAEnou7ni5Ly3RxdGmEy8BA5ZN9KWLLCpkpSakYSkPDfZDKA
Nt2bpyzFuDcrZ4xawYnqOO2asjyygqkKypEoCYYdDSV9C0NqO3kHlhxzoXmr4LkK
Jfwm2grvj2fDof1apQEpYla1xZ79nfTtxJq9xPLceTJE9sUNnjvv/heNNwSmpgm2
Q/4mfh23xd6jmnWOsHMtHdPMMe6Xkz3uU0G/Xm/A2xbncF72zMXzuN/DP3a+rh06
k0WMZCZrk2Qq6Y7QLbMev/i3x6SzbYVySKQZ2KuAW6gD6gM2ykVS1ReROLJtz064
q0Jq6ItPPa9OWlHeuXHGngCliFrDFo1dx1oPPfy4xfJK9oAvt2OKUK7Z6x00Pv4B
5/fVINgcjjXJlDBexzscReP9wOB8BEDlG83Qc8yd8uOBIirVxYilxy4iEVEHnw4/
MHNqELawmQ1lA/MXVDm1WUcIx0XQeZiOEp0zVF8k8T7WGZ9OwelgTeV0e0b9icsh
PsUD7dc410TWAU9MKrSW
=8PnO
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_16_40_25_+1100_U=1YSxDOxbeLSt43--
