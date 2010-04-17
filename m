Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0DQPDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 11:03:51 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:37037 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0DQPDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 11:03:48 -0400
Date: Sat, 17 Apr 2010 11:03:47 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH] vt6655: Rename hostap_set_hostapd, hostap_iotctl.
Message-ID: <20100417150347.GB2259@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <4BAB8362.7030005@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The functions hostap_set_hostapd, hostap_iotctl clashed with functions of t=
he
same name with CONFIG_HOSTAP=3Dy and/or CONFIG_VT6656=3Dy.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6655/device_main.c |    4 ++--
 drivers/staging/vt6655/hostap.c      |    8 ++++----
 drivers/staging/vt6655/hostap.h      |    4 ++--
 drivers/staging/vt6655/ioctl.c       |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/=
device_main.c
index 18f4dfe..ef3135c 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1242,7 +1242,7 @@ device_release_WPADEV(pDevice);
     }
 #ifdef HOSTAP
     if (dev)
-        hostap_set_hostapd(pDevice, 0, 0);
+        vt6655_hostap_set_hostapd(pDevice, 0, 0);
 #endif
     if (dev)
         unregister_netdev(dev);
@@ -3523,7 +3523,7 @@ static int  device_ioctl(struct net_device *dev, stru=
ct ifreq *rq, int cmd) {
     case IOCTL_CMD_HOSTAPD:
=20
=20
-	rc =3D hostap_ioctl(pDevice, &wrq->u.data);
+	rc =3D vt6655_hostap_ioctl(pDevice, &wrq->u.data);
         break;
=20
     case IOCTL_CMD_WPA:
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hosta=
p.c
index 58abf44..9e07a40 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -183,7 +183,7 @@ KeyvInitTable(&pDevice->sKey,pDevice->PortOffset);
  *
  */
=20
-int hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
+int vt6655_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
 {
 	if (val < 0 || val > 1)
 		return -EINVAL;
@@ -746,7 +746,7 @@ static int hostap_get_encryption(PSDevice pDevice,
=20
 /*
  * Description:
- *      hostap_ioctl main function supported for hostap deamon.
+ *      vt6655_hostap_ioctl main function supported for hostap deamon.
  *
  * Parameters:
  *  In:
@@ -758,7 +758,7 @@ static int hostap_get_encryption(PSDevice pDevice,
  *
  */
=20
-int hostap_ioctl(PSDevice pDevice, struct iw_point *p)
+int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 {
 	struct viawget_hostapd_param *param;
 	int ret =3D 0;
@@ -846,7 +846,7 @@ int hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 	    return -EOPNOTSUPP;
=20
 	default:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "hostap_ioctl: unknown cmd=3D%d\n",
+	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vt6655_hostap_ioctl: unknown cmd=
=3D%d\n",
 		       (int)param->cmd);
 		return -EOPNOTSUPP;
 		break;
diff --git a/drivers/staging/vt6655/hostap.h b/drivers/staging/vt6655/hosta=
p.h
index 8fd667b..55db555 100644
--- a/drivers/staging/vt6655/hostap.h
+++ b/drivers/staging/vt6655/hostap.h
@@ -61,8 +61,8 @@
 #define ARPHRD_IEEE80211 801
 #endif
=20
-int hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked);
-int hostap_ioctl(PSDevice pDevice, struct iw_point *p);
+int vt6655_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked);
+int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p);
=20
 #endif // __HOSTAP_H__
=20
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index d9a5fd2..f29ed9f 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -429,7 +429,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 			break;
 		};
 		if (sValue.dwValue =3D=3D 1) {
-            if (hostap_set_hostapd(pDevice, 1, 1) =3D=3D 0){
+            if (vt6655_hostap_set_hostapd(pDevice, 1, 1) =3D=3D 0){
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable HOSTAP\n");
             }
             else {
@@ -438,7 +438,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 			}
         }
         else {
-            hostap_set_hostapd(pDevice, 0, 1);
+            vt6655_hostap_set_hostapd(pDevice, 0, 1);
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable HOSTAP\n");
         }
=20
--=20
1.6.0.4

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFLyc3TRO4fQQdv5AwRAhaUAJ4zwYDXuIhetocw/MjZU0nADRKwfwCgjEfq
XovEulOykVq6ocUccNfECi4=
=eNhZ
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
