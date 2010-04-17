Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0DQPDl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 11:03:41 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:37030 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0DQPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 11:03:39 -0400
Date: Sat, 17 Apr 2010 11:03:38 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH] vt6656: Rename hostap_set_hostapd, hostap_iotctl.
Message-ID: <20100417150338.GA2259@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <4BAB8362.7030005@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The functions hostap_set_hostapd, hostap_iotctl clashed with functions of t=
he
same name with CONFIG_HOSTAP=3Dy and/or CONFIG_VT6655=3Dy.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6656/hostap.c   |    8 ++++----
 drivers/staging/vt6656/hostap.h   |    4 ++--
 drivers/staging/vt6656/ioctl.c    |    4 ++--
 drivers/staging/vt6656/main_usb.c |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hosta=
p.c
index 1078d61..ca007c3 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -178,7 +178,7 @@ static int hostap_disable_hostapd(PSDevice pDevice, int=
 rtnl_locked)
  *
  */
=20
-int hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
+int vt6656_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
 {
 	if (val < 0 || val > 1)
 		return -EINVAL;
@@ -744,7 +744,7 @@ static int hostap_get_encryption(PSDevice pDevice,
=20
 /*
  * Description:
- *      hostap_ioctl main function supported for hostap deamon.
+ *      vt6656_hostap_ioctl main function supported for hostap deamon.
  *
  * Parameters:
  *  In:
@@ -756,7 +756,7 @@ static int hostap_get_encryption(PSDevice pDevice,
  *
  */
=20
-int hostap_ioctl(PSDevice pDevice, struct iw_point *p)
+int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 {
 	struct viawget_hostapd_param *param;
 	int ret =3D 0;
@@ -844,7 +844,7 @@ int hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 	    return -EOPNOTSUPP;
=20
 	default:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "hostap_ioctl: unknown cmd=3D%d\n",
+	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vt6656_hostap_ioctl: unknown cmd=
=3D%d\n",
 		       (int)param->cmd);
 		return -EOPNOTSUPP;
 		break;
diff --git a/drivers/staging/vt6656/hostap.h b/drivers/staging/vt6656/hosta=
p.h
index 8fd667b..9e366dc 100644
--- a/drivers/staging/vt6656/hostap.h
+++ b/drivers/staging/vt6656/hostap.h
@@ -61,8 +61,8 @@
 #define ARPHRD_IEEE80211 801
 #endif
=20
-int hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked);
-int hostap_ioctl(PSDevice pDevice, struct iw_point *p);
+int vt6656_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked);
+int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p);
=20
 #endif // __HOSTAP_H__
=20
diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index 6f33005..1ed2501 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -412,7 +412,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 			break;
 		};
 		if (sValue.dwValue =3D=3D 1) {
-            if (hostap_set_hostapd(pDevice, 1, 1) =3D=3D 0){
+            if (vt6656_hostap_set_hostapd(pDevice, 1, 1) =3D=3D 0){
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable HOSTAP\n");
             }
             else {
@@ -421,7 +421,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 			}
         }
         else {
-            hostap_set_hostapd(pDevice, 0, 1);
+            vt6656_hostap_set_hostapd(pDevice, 0, 1);
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable HOSTAP\n");
         }
=20
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/mai=
n_usb.c
index 49270db..c8afb66 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -2064,7 +2064,7 @@ static int  device_ioctl(struct net_device *dev, stru=
ct ifreq *rq, int cmd) {
 		    rc =3D 0;
 		}
=20
-		rc =3D hostap_ioctl(pDevice, &wrq->u.data);
+		rc =3D vt6656_hostap_ioctl(pDevice, &wrq->u.data);
         break;
=20
     case IOCTL_CMD_WPA:
--=20
1.6.0.4

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFLyc3KRO4fQQdv5AwRAogiAJ96T3bNbwKfyZwozErx+Q3k0/Dv4gCg0T1h
kOtP5RWS2Wbusyo+GUogK+o=
=nxbt
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
