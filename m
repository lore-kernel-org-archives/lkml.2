Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0LHSaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:30:22 -0500
Received: from zucker.schokokeks.org ([78.46.69.5]:49767 "EHLO
	zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0LHSaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:30:20 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Dec 2010 13:30:20 EST
From: Hanno =?utf-8?q?B=C3=B6ck?= <hanno@hboeck.de>
To: lenb@kernel.org
Subject: [PATCH] acpi: const-ify functions
Date: Wed, 8 Dec 2010 19:25:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.1; KDE/4.5.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7784889.8XrazIs9Ki";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012081925.10292.hanno@hboeck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7784889.8XrazIs9Ki
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Will const a couple of functions and variables. This is extracted
from grsecurity (with only a slight modification to limit a line
to 80 chars).

Patch is against linux-acpi-2.6 git.

Similar patches have been sent in the past but not applied,
supposedly because they weren't sent to subsystem maintainers.
(I may continue to send similar extracts to other subsystems)

=2D--
Signed-off-by: Hanno Boeck <hanno@hboeck.de>
diff -Naurp linux-acpi-1//drivers/acpi/battery.c linux-acpi-2/drivers/acpi/=
battery.c
=2D-- linux-acpi-1//drivers/acpi/battery.c	2010-12-08 18:42:26.187000005 +0=
100
+++ linux-acpi-2/drivers/acpi/battery.c	2010-12-08 18:42:53.595000204 +0100
@@ -851,7 +851,7 @@ DECLARE_FILE_FUNCTIONS(alarm);
 	}
=20
 static struct battery_file {
=2D	struct file_operations ops;
+	const struct file_operations ops;
 	mode_t mode;
 	const char *name;
 } acpi_battery_file[] =3D {
diff -Naurp linux-acpi-1//drivers/acpi/dock.c linux-acpi-2/drivers/acpi/doc=
k.c
=2D-- linux-acpi-1//drivers/acpi/dock.c	2010-12-08 18:42:26.147999998 +0100
+++ linux-acpi-2/drivers/acpi/dock.c	2010-12-08 18:42:53.608999978 +0100
@@ -77,7 +77,7 @@ struct dock_dependent_device {
 	struct list_head list;
 	struct list_head hotplug_list;
 	acpi_handle handle;
=2D	struct acpi_dock_ops *ops;
+	const struct acpi_dock_ops *ops;
 	void *context;
 };
=20
@@ -589,7 +589,8 @@ EXPORT_SYMBOL_GPL(unregister_dock_notifi
  * the dock driver after _DCK is executed.
  */
 int
=2Dregister_hotplug_dock_device(acpi_handle handle, struct acpi_dock_ops *o=
ps,
+register_hotplug_dock_device(acpi_handle handle,
+			     const struct acpi_dock_ops *ops,
 			     void *context)
 {
 	struct dock_dependent_device *dd;
diff -Naurp linux-acpi-1//drivers/acpi/sleep.c linux-acpi-2/drivers/acpi/sl=
eep.c
=2D-- linux-acpi-1//drivers/acpi/sleep.c	2010-12-08 18:42:27.559999989 +0100
+++ linux-acpi-2/drivers/acpi/sleep.c	2010-12-08 18:42:53.615000007 +0100
@@ -319,7 +319,7 @@ static int acpi_suspend_state_valid(susp
 	}
 }
=20
=2Dstatic struct platform_suspend_ops acpi_suspend_ops =3D {
+static const struct platform_suspend_ops acpi_suspend_ops =3D {
 	.valid =3D acpi_suspend_state_valid,
 	.begin =3D acpi_suspend_begin,
 	.prepare_late =3D acpi_pm_prepare,
@@ -347,7 +347,7 @@ static int acpi_suspend_begin_old(suspen
  * The following callbacks are used if the pre-ACPI 2.0 suspend ordering h=
as
  * been requested.
  */
=2Dstatic struct platform_suspend_ops acpi_suspend_ops_old =3D {
+static const struct platform_suspend_ops acpi_suspend_ops_old =3D {
 	.valid =3D acpi_suspend_state_valid,
 	.begin =3D acpi_suspend_begin_old,
 	.prepare_late =3D acpi_pm_pre_suspend,
@@ -498,7 +498,7 @@ static void acpi_pm_thaw(void)
 	acpi_enable_all_runtime_gpes();
 }
=20
=2Dstatic struct platform_hibernation_ops acpi_hibernation_ops =3D {
+static const struct platform_hibernation_ops acpi_hibernation_ops =3D {
 	.begin =3D acpi_hibernation_begin,
 	.end =3D acpi_pm_end,
 	.pre_snapshot =3D acpi_pm_prepare,
@@ -541,7 +541,7 @@ static int acpi_hibernation_begin_old(vo
  * The following callbacks are used if the pre-ACPI 2.0 suspend ordering h=
as
  * been requested.
  */
=2Dstatic struct platform_hibernation_ops acpi_hibernation_ops_old =3D {
+static const struct platform_hibernation_ops acpi_hibernation_ops_old =3D {
 	.begin =3D acpi_hibernation_begin_old,
 	.end =3D acpi_pm_end,
 	.pre_snapshot =3D acpi_pm_pre_suspend,
diff -Naurp linux-acpi-1//drivers/acpi/video.c linux-acpi-2/drivers/acpi/vi=
deo.c
=2D-- linux-acpi-1//drivers/acpi/video.c	2010-12-08 18:42:27.627999905 +0100
+++ linux-acpi-2/drivers/acpi/video.c	2010-12-08 18:42:53.621000001 +0100
@@ -260,7 +260,7 @@ static int acpi_video_set_brightness(str
 				vd->brightness->levels[request_level]);
 }
=20
=2Dstatic struct backlight_ops acpi_backlight_ops =3D {
+static const struct backlight_ops acpi_backlight_ops =3D {
 	.get_brightness =3D acpi_video_get_brightness,
 	.update_status  =3D acpi_video_set_brightness,
 };
diff -Naurp linux-acpi-1//include/acpi/acpi_drivers.h linux-acpi-2/include/=
acpi/acpi_drivers.h
=2D-- linux-acpi-1//include/acpi/acpi_drivers.h	2010-12-08 18:42:33.0990000=
02 +0100
+++ linux-acpi-2/include/acpi/acpi_drivers.h	2010-12-08 18:42:53.628000001 =
+0100
@@ -119,8 +119,8 @@ void pci_acpi_crs_quirks(void);
                                   Dock Station
   ------------------------------------------------------------------------=
=2D- */
 struct acpi_dock_ops {
=2D	acpi_notify_handler handler;
=2D	acpi_notify_handler uevent;
+	const acpi_notify_handler handler;
+	const acpi_notify_handler uevent;
 };
=20
 #if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
@@ -128,7 +128,7 @@ extern int is_dock_device(acpi_handle ha
 extern int register_dock_notifier(struct notifier_block *nb);
 extern void unregister_dock_notifier(struct notifier_block *nb);
 extern int register_hotplug_dock_device(acpi_handle handle,
=2D					struct acpi_dock_ops *ops,
+					const struct acpi_dock_ops *ops,
 					void *context);
 extern void unregister_hotplug_dock_device(acpi_handle handle);
 #else
@@ -144,7 +144,7 @@ static inline void unregister_dock_notif
 {
 }
 static inline int register_hotplug_dock_device(acpi_handle handle,
=2D					       struct acpi_dock_ops *ops,
+					       const struct acpi_dock_ops *ops,
 					       void *context)
 {
 	return -ENODEV;


=2D-=20
Hanno B=C3=B6ck		Blog:		http://www.hboeck.de/
GPG: 3DBD3B20		Jabber/Mail:	hanno@hboeck.de

http://schokokeks.org - professional webhosting

--nextPart7784889.8XrazIs9Ki
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkz/zYYACgkQr2QksT29OyCqHwCdHz4lGBfCJehsprMDSiguEN1p
zUcAn1Xl7+bW2Hn9OKXyxr7P6mkIfwPc
=RGYT
-----END PGP SIGNATURE-----

--nextPart7784889.8XrazIs9Ki--
