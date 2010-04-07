Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab0DGU0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:26:50 -0400
Received: from atreides.gradator.net ([212.85.155.42]:53656 "EHLO
	atreides.gradator.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0DGU0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 16:26:46 -0400
Date: Wed, 7 Apr 2010 21:57:24 +0200
From: Sylvain Rochet <gradator@gradator.net>
To: linux-kernel@vger.kernel.org
Message-ID: <20100407195724.GA4830@gradator.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: gradator@atreides.gradator.net
Subject: PATCH: 2.4.37.9 MTU change for TUN/TAP interfaces
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on atreides.gradator.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

This patch add the ability to change the MTU of TUN/TAP interfaces for=20
the 2.4.x kernels series.

Best regards,
Sylvain

--y0ulUmNC+osPPQO6
Content-Type: text/x-diff; charset=iso-8859-15
Content-Disposition: attachment; filename="tuntap-change-mtu-2.4.37.9.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru linux-2.4.36.6.a/drivers/net/tun.c linux-2.4.36.6.b/drivers/net/t=
un.c
--- linux-2.4.36.6.a/drivers/net/tun.c	2008-06-06 18:25:34.000000000 +0200
+++ linux-2.4.36.6.b/drivers/net/tun.c	2010-04-07 17:51:33.000000000 +0200
@@ -118,6 +118,17 @@
 	return &tun->stats;
 }
=20
+#define MIN_MTU 68
+#define MAX_MTU 65535
+
+static int tun_net_change_mtu(struct net_device *dev, int new_mtu)  {
+	if (new_mtu < MIN_MTU || new_mtu + dev->hard_header_len > MAX_MTU)
+		return -EINVAL;
+	dev->mtu =3D new_mtu;
+	return 0;
+}
+
+
 /* Initialize net device. */
 int tun_net_init(struct net_device *dev)
 {
@@ -156,6 +167,7 @@
 		break;
 	};
=20
+	dev->change_mtu =3D tun_net_change_mtu;
 	return 0;
 }
=20

--y0ulUmNC+osPPQO6--

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFLvOOkDFub3qtEsS8RAt6CAKCUBiOMthSa4Lcq9OBWtRjfwxCE2QCeKUGc
kYZ7dhH0W8lCCzNHH8+OfFA=
=0lad
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
