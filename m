Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1KKCMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 21:12:02 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60630 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1KKCMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 21:12:00 -0500
Date: Fri, 11 Nov 2011 13:11:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the input tree with the s5p tree
Message-Id: <20111111131147.3f7ab8c9f14a7d87cc83b5ac@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Nov_2011_13_11_47_+1100__4zMnpzn28wz4kWm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Nov_2011_13_11_47_+1100__4zMnpzn28wz4kWm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next merge of the input tree got a conflict in
drivers/input/keyboard/samsung-keypad.c between commit 532f74540134
("input: samsung-keypad: Add device tree support") from the s5p tree and
commit 400bf2995be6 ("Input: samsung-keypad - switch to using
SIMPLE_DEV_PM_OPS") from the input tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/keyboard/samsung-keypad.c
index 8a0060c,1a2b755..0000000
--- a/drivers/input/keyboard/samsung-keypad.c
+++ b/drivers/input/keyboard/samsung-keypad.c
@@@ -21,10 -21,8 +21,10 @@@
  #include <linux/module.h>
  #include <linux/platform_device.h>
  #include <linux/slab.h>
 +#include <linux/of.h>
 +#include <linux/of_gpio.h>
  #include <linux/sched.h>
- #include <plat/keypad.h>
+ #include <linux/input/samsung-keypad.h>
 =20
  #define SAMSUNG_KEYIFCON			0x00
  #define SAMSUNG_KEYIFSTSCLR			0x04
@@@ -578,24 -440,11 +578,22 @@@ static int samsung_keypad_resume(struc
 =20
  	return 0;
  }
-=20
- static const struct dev_pm_ops samsung_keypad_pm_ops =3D {
- 	.suspend	=3D samsung_keypad_suspend,
- 	.resume		=3D samsung_keypad_resume,
- };
  #endif
 =20
 +#ifdef CONFIG_OF
 +static const struct of_device_id samsung_keypad_dt_match[] =3D {
 +	{ .compatible =3D "samsung,s3c6410-keypad" },
 +	{ .compatible =3D "samsung,s5pv210-keypad" },
 +	{},
 +};
 +MODULE_DEVICE_TABLE(of, samsung_keypad_dt_match);
 +#else
 +#define samsung_keypad_dt_match NULL
 +#endif
 +
+ static SIMPLE_DEV_PM_OPS(samsung_keypad_pm_ops,
+ 			 samsung_keypad_suspend, samsung_keypad_resume);
+=20
  static struct platform_device_id samsung_keypad_driver_ids[] =3D {
  	{
  		.name		=3D "samsung-keypad",
@@@ -614,10 -463,7 +612,8 @@@ static struct platform_driver samsung_k
  	.driver		=3D {
  		.name	=3D "samsung-keypad",
  		.owner	=3D THIS_MODULE,
 +		.of_match_table =3D samsung_keypad_dt_match,
- #ifdef CONFIG_PM
  		.pm	=3D &samsung_keypad_pm_ops,
- #endif
  	},
  	.id_table	=3D samsung_keypad_driver_ids,
  };

--Signature=_Fri__11_Nov_2011_13_11_47_+1100__4zMnpzn28wz4kWm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOvIRjAAoJEECxmPOUX5FE6cwP/j7IpBR0T7qRyyHwwm77TCoH
7WMdOSC8EInlhZ5dodzMMPYAwzGMtYa++S8ATEAildAWCbN0WACIuiehjyboHu+l
Whq2PS6jtM9PyoCwBPtYzu/dUFeuy032WX6oIfvCyxqrL9ac6GXhDooL43V/tC2X
qnfOFvu6QTMkGnPy/OqFAtaSV+sK9rU/m0I5SDYgHFGlvNMnu7Lc7jzzMUwct1ST
Ks3hrbv94q9QxfR+dU12NSX+cRtXSelfWtJrbNd8Uhobw2H/gORnuo1JH9ZXgLGc
Bz4S3fo+ybvyr2ljKtZwE7glO6jLbMs130nQoXVoHz00b1cA+dvIYSBNQYLbHO2x
jOMouF5oleBsVOjIGtR6IsV3VL63F2YgiH2MJQV6ZyHAMW9QldH8bpBy/YLNnKwY
q+anrLH/4JgJQfC8PQPuQaZ83oUknmRohhpWo7abBkEpamXAQFxLHcHQZAE+TEmW
pktgzMKu0UGk2xFhwZyE1P8D58d52ZA0sxBVytmznwUHU//EzUugcko+dKvaU3dd
ISfdRSqDohTJLd9Xm16ukNAQUQb1lTsJQA9WMUyUPuWnsACeGJHXd7oYYF6Id1dR
jNyrzFhBkOXYKhYb5ModDxrY5JOd8BYIhpC/8jjeX6J5DgVuCIO/BKF4mnvTyuZ9
LX7SwhGeBKOM2K1Ic1ej
=38Al
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Nov_2011_13_11_47_+1100__4zMnpzn28wz4kWm--
