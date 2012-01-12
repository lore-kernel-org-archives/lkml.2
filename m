Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab2ALBHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 20:07:06 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55424 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2ALBHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 20:07:03 -0500
Date: Thu, 12 Jan 2012 12:06:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Donggeun Kim <dg77.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, NeilBrown <neilb@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20120112120652.cdc2db032dcedfd402e61b34@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Jan_2012_12_06_52_+1100_Vp5lvUZ1crmWP4C="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Jan_2012_12_06_52_+1100_Vp5lvUZ1crmWP4C=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/leds/Kconfig between commit a6d511e51554 ("leds: add driver for
TCA6507 LED controller") from Linus' tree and commit 8584cb82f151 ("leds:
Add suuport for MAX8997-LED driver") from the mfd tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/leds/Kconfig
index 897a77d,c0e30e8..0000000
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@@ -388,14 -387,13 +388,21 @@@ config LEDS_RENESAS_TP
  	  pin function. The latter to support brightness control.
  	  Brightness control is supported but hardware blinking is not.
 =20
 +config LEDS_TCA6507
 +	tristate "LED Support for TCA6507 I2C chip"
 +	depends on LEDS_CLASS && I2C
 +	help
 +	  This option enables support for LEDs connected to TC6507
 +	  LED driver chips accessed via the I2C bus.
 +	  Driver support brightness control and hardware-assisted blinking.
 +
+ config LEDS_MAX8997
+ 	tristate "LED support for MAX8997 PMIC"
+ 	depends on LEDS_CLASS && MFD_MAX8997
+ 	help
+ 	  This option enables support for on-chip LED drivers on
+ 	  MAXIM MAX8997 PMIC.
+=20
  config LEDS_TRIGGERS
  	bool "LED Trigger support"
  	depends on LEDS_CLASS

--Signature=_Thu__12_Jan_2012_12_06_52_+1100_Vp5lvUZ1crmWP4C=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPDjIsAAoJEECxmPOUX5FEXeAP+we9vN3A479KPoY416WMRkJM
F61dOQnvxhTOWXISrAz97k5adOLI9QLKW4kJyHS56TZ59gnqXLGVOnj+OxOog2ic
4u3NxjwmRyTp5KzzSEyKVJpOfDse4ZLTwjPqlQac0Nt8ERMrnhQ0NSY28GbMce+U
BUjwmlpw1g+yR9Hd5Vzait7pODAfXC0cfHB9cL1mTqjKQeLR1Vy0XtVWLt1ii4wj
ngoSJPFiEjzETFfIHKRxwLrbENvZGToKiOrIHzyQPK3oYZbj1m7/4UbzbuBTJ1q/
LyjoYdxOfdvsudnwkhyh1hu5oiW1Pu0ioRLu5jdFIxinjew1DZP5LtrI13u2+iFO
ZHDG+i0cB7K4GhHbhvZaYTtxze+OOQZiR6DF3YMhXZR2k+TIf6kXBAgjV2YjJ15H
/Gl9ZsATd+IRiU0Cx28mFFLOz5rnrBOgORa6snLiom4p1C0r99XCWRk7b5yPmaEa
B0lkuW0+EuBMHnlRCBiO83MeHated9sYr7rENJajOKBQhP9vEZU619A+fVjsJ/Az
my7qC1XqAXNgzFbQwbTblw6GK8e/YjHrDa8If59cyxoU+JpTmHyhHvb81Xyqq6FF
Ui7p/l4HTpY2UiF1GUP2OYaNu6OiIdcIG7q4QLml+wH11hpp+KLqr+EQINC1teTu
tR6EjkIzakaoqexn2J9D
=IZYp
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Jan_2012_12_06_52_+1100_Vp5lvUZ1crmWP4C=--
