Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1LADkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:40:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60507 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1LADkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:40:08 -0500
Date: Thu, 1 Dec 2011 14:40:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, Jiri Kosina <jikos@jikos.cz>
Subject: linux-next: manual merge of the staging tree with the hid tree
Message-Id: <20111201144005.2df26a6aad60f946e68bbd4c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Dec_2011_14_40_05_+1100_gM7ESx92pKVOXDWu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Dec_2011_14_40_05_+1100_gM7ESx92pKVOXDWu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/hv/Makefile and drivers/staging/hv/Kconfig between
commits b95f5bcb811e ("HID: Move the hid-hyperv driver out of staging")
and 045b1684bc21 ("Staging: hv: mousevsc: Remove the mouse driver from
the staging tree") from the hid tree and commit 95fa0405c599 ("staging:
hv: move hv_netvsc out of staging area") from the staging tree.

I fixed them up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/hv/Kconfig
index 6c0dc30,8a51166..0000000
--- a/drivers/staging/hv/Kconfig
+++ b/drivers/staging/hv/Kconfig
@@@ -3,9 -3,9 +3,3 @@@ config HYPERV_STORAG
  	depends on HYPERV && SCSI
  	help
  	 Select this option to enable the Hyper-V virtual storage driver.
--
- config HYPERV_NET
- 	tristate "Microsoft Hyper-V virtual network driver"
- 	depends on HYPERV && NET
- 	help
- 	  Select this option to enable the Hyper-V virtual network driver.
 -config HYPERV_MOUSE
 -	tristate "Microsoft Hyper-V mouse driver"
 -	depends on HYPERV && HID
 -	help
 -	  Select this option to enable the Hyper-V mouse driver.
diff --cc drivers/staging/hv/Makefile
index fbe9a42,6c97747..0000000
--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@@ -1,5 -1,4 +1,3 @@@
  obj-$(CONFIG_HYPERV_STORAGE)	+=3D hv_storvsc.o
- obj-$(CONFIG_HYPERV_NET)	+=3D hv_netvsc.o
 -obj-$(CONFIG_HYPERV_MOUSE)	+=3D hv_mouse.o
 =20
  hv_storvsc-y :=3D storvsc_drv.o
- hv_netvsc-y :=3D netvsc_drv.o netvsc.o rndis_filter.o

--Signature=_Thu__1_Dec_2011_14_40_05_+1100_gM7ESx92pKVOXDWu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1vcVAAoJEECxmPOUX5FEaQEP/RdrCIo+c0o5yj4UawBo3E6e
otuZvVSQ0inEvPz8njmZrKL1Co5P+pZQcTUn6b9kDKZEPsm2wlOoSNIqm/TTzeoT
mHp0setnF66lWp8MHT5hi0MWG3vPPFmYPtqc/sBeknl4pSL+QhcfobgRlHLUSzMJ
lQ7i3SELkc6ipC3eHKqT+LhYPjjF/13nRg+5GM7VatM2zB6aHe2fvpjm5UAt92oX
T4EeHjHnAeUvE24tkt0dntXHjJzWwLARJ4dKlhfyQotVk9eZJqLDD7+/9nnpq+7Y
S1Y78A6Z2dFLh/jgPY2Skfx07zbOAqJPxo9C/k1aMT4s6wvH+4YXdeDtqCIbOnMO
WE0xQUKxvQOOw8B0FwQ7AUmDfcyXYmGbfa+H34ZBodaY5pHaJmNK2+lv67hSUPMb
osaJWhRw7JJCKCgXqtHisCdDQukyU58m+BuTlIfE2CDn3vdk0GK7dNv40hC5ncyD
AUZFwZr5/mffebc1mD3CmqzdQHps1DDxAt2F/+3W2fn9f3XCY9aIY2bwoW81O4Do
kPcQmP+CH7mkyX/+9mfb7DJSe0cSAWP97FG3U1WGjKUzDZbGosP0QUPc2u5sPkiY
FDdEwN33f4eXKcM4Xhv7B59+9TIZen1s5CFUNuofjesaU1ZL/0MaXkExG93Zow8s
+MxJ5OnFg2Gg4bwg6ZhG
=EPIu
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Dec_2011_14_40_05_+1100_gM7ESx92pKVOXDWu--
