Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2D0F7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:59:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43469 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab2D0F7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:59:20 -0400
Date: Fri, 27 Apr 2012 14:31:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: linux-next: manual merge of the staging tree with the driver-core
 tree
Message-Id: <20120427143114.d141038158ea4923399d1d1a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Apr_2012_14_31_14_+1000_fd_HQX._5YADc/9r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Apr_2012_14_31_14_+1000_fd_HQX._5YADc/9r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/Kconfig drivers/Makefile between commit de55d8716ac5 ("Extcon
(external connector): import Android's switch class and modify") from the
driver-core tree and commits a980e046098b ("IIO: Move the core files to
drivers/iio") and db3b9e990e75 ("Staging: VME: move VME drivers out of
staging") from the staging tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/Kconfig
index 0233ad9,e245779..0000000
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@@ -140,6 -140,8 +140,10 @@@ source "drivers/virt/Kconfig
 =20
  source "drivers/devfreq/Kconfig"
 =20
 +source "drivers/extcon/Kconfig"
 +
+ source "drivers/iio/Kconfig"
+=20
+ source "drivers/vme/Kconfig"
+=20
  endmenu
diff --cc drivers/Makefile
index c41dfa9,08b78e0..0000000
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@@ -134,4 -134,5 +134,6 @@@ obj-$(CONFIG_VIRT_DRIVERS)	+=3D virt
  obj-$(CONFIG_HYPERV)		+=3D hv/
 =20
  obj-$(CONFIG_PM_DEVFREQ)	+=3D devfreq/
 +obj-$(CONFIG_EXTCON)		+=3D extcon/
+ obj-$(CONFIG_IIO)		+=3D iio/
+ obj-$(CONFIG_VME_BUS)		+=3D vme/

--Signature=_Fri__27_Apr_2012_14_31_14_+1000_fd_HQX._5YADc/9r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPmiESAAoJEECxmPOUX5FEDckP/j8vbTDs1btSim37rZziYzQt
YYFy2JMoDSeZuO+PYrj2cXlB85/U9oZTcIGD596LPY5T+k2VWkePxLkTkjiNXDQF
gFix1ofDg/1ixsPHOGRLR62F5v43J3WjRI9fdSyT6PkIL/QqwC31JN3p06ZJEHVy
ZCGPjrDRXD6bM9b9KvsHn5uCZdDTRBO8b7O8KbcmCWoiKLTy6EuhBEDsFGdtsNJ7
q97gRkbHmPbhzBuMuOuwec+PGjw6eAP5hpBJRMhAIOTXqPkmaOp6JJXUKfDBK1NA
towIr30k/7DrMpy49dbyvTI2oit5TG3E08VJnBrjzABlGFDvBHlTPHDdO3CZxxsY
1dp7SkPFBkuo2ySeF/F2N4J6I16nWonFANk30aPTApuwV00qRymup+76ZdJ5zU3G
UMVAjGpGbrlBy23cyZ45YEEoleRhSJXvLBZ1XrMXBKVG5qpkX/dXHrGSmgeWS+Cz
cWmJ/aY4yrejRdAaHKrdsSs63zkMTM8GOGHgW7PlwlAowc5QQEG2WKfgCmfuBhD7
PXslTkOa/QBPciLHXvMqxge9o7Tye3ueQYNHuiqv18SBpbTIUqYc20PwGAgiWv/V
uLgfhvvWDvtD5G0t+BPhj6Lqdi4LHrPEFFbDM6MG7Wdzm7Kn+qC9eDRxrP6Jh0DM
yrqx8tdVNM4DAbCHSp61
=3Mgs
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Apr_2012_14_31_14_+1000_fd_HQX._5YADc/9r--
