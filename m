Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2F0BFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:05:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55660 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab2F0BFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:05:41 -0400
Date: Wed, 27 Jun 2012 11:05:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: linux-next: manual merge of the hid tree with Linus' tree
Message-Id: <20120627110530.07598da1fdaa9f84dfa09a3f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Jun_2012_11_05_30_+1000_VNAcRtOxY2EtbeBb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Jun_2012_11_05_30_+1000_VNAcRtOxY2EtbeBb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the hid tree got a conflict in
drivers/hid/Kconfig between commit 1f41a6a99476 ("HID: Fix the generic
Kconfig options") from Linus' tree and commit 1ccd7a2a33f2 ("HID: uhid:
introduce user-space I/O driver support for HID") from the hid tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hid/Kconfig
index bef04c1,96ac310..0000000
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@@ -53,6 -59,32 +53,27 @@@ config HIDRA
 =20
  	If unsure, say Y.
 =20
+ config UHID
+ 	tristate "User-space I/O driver support for HID subsystem"
+ 	depends on HID
+ 	default n
+ 	---help---
+ 	Say Y here if you want to provide HID I/O Drivers from user-space.
+ 	This allows to write I/O drivers in user-space and feed the data from
+ 	the device into the kernel. The kernel parses the HID reports, loads the
+ 	corresponding HID Device Driver or provides input devices on top of your
+ 	user-space device.
+=20
+ 	This driver cannot be used to parse HID-reports in user-space and write
+ 	special HID-drivers. You should use hidraw for that.
+ 	Instead, this driver allows to write the transport-layer driver in
+ 	user-space like USB-HID and Bluetooth-HID do in kernel-space.
+=20
+ 	If unsure, say N.
+=20
+ 	To compile this driver as a module, choose M here: the
+ 	module will be called uhid.
+=20
 -source "drivers/hid/usbhid/Kconfig"
 -
 -menu "Special HID drivers"
 -	depends on HID
 -
  config HID_GENERIC
  	tristate "Generic HID driver"
  	depends on HID

--Signature=_Wed__27_Jun_2012_11_05_30_+1000_VNAcRtOxY2EtbeBb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6lxaAAoJEECxmPOUX5FEt+cQAIER5tHdQkevWh3b7sGPV6HS
vLmlAKep8908EXJzdTVkIjV//Bqr/MGEMtYk/Nz+VrtNnWK0WHDVfrp2Z6URbv6r
DS2wwrWTfFh9HYHrO0ffZpujFrwizNfdrXqB/6ef7l4ekHW3dEDeellyxu4GaswR
0yZNeBJPUWkTkT+Q0pHfwcMqOK+C2Had0x6rm+QqOVhMhF7PVxqtmvymphFpmO3S
70Jd3MxaLxztHs4qYPBqb8hOv8u3pw4cEWm1Pztrm55qOvCMALAyLxstULMKMhxm
ruwbGkdZOJl8bnZvlMIU2DL77E7mOy211C2kMB8/xcXhVLFmT1/IDKIzTBLf34iK
0abIsQR/i0v48PUD060l/TubKXpbnMRUB1EZu0HjuQ7tJBCLGMnY2Dp+cGdA1EyW
nxsUXNlSwJzi3G31CSSdpAoChGRjBpXy7JBUblOTRPxRl265cBB6nfKnLnhGCnnX
4Xr7KWZ2ALdMsyDXdso165bgjn3nPSzlYsMTIOwWlhmp6gryW9SXk1gM4wAJysL4
K/lN4ot21GccPhVgzVU1D2rUGg+Ulr3Bpbrwb/NghtfvxoWANXkgpbv85ZG21azr
GF0vYXtEtfj9NJ8KzlZsSxpj2D4Y/vZe41gejQvJEAsGlklbpq/WDWn3U05mFJIL
P8teysR9aErFtZfLd33u
=L7Fw
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Jun_2012_11_05_30_+1000_VNAcRtOxY2EtbeBb--
