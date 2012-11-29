Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422635Ab2K2EDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:03:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54155 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab2K2EDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:03:43 -0500
Date: Thu, 29 Nov 2012 15:03:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: linux-next: manual merge of the driver-core tree with the pci tree
Message-Id: <20121129150340.768fdffc941d501c9975c2be@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_03_40_+1100_C3QrtJZRubTu+WMZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_03_40_+1100_C3QrtJZRubTu+WMZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/pci/pci.h between commit 4e15c46bdc4d ("PCI: Add pci_device_type
to pdev's device struct") from the pci tree and commit b40b97ae736c
("PCI: Remove CONFIG_HOTPLUG ifdefs") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/pci.h
index 11a713b,e253881..0000000
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@@ -159,12 -158,7 +158,8 @@@ static inline int pci_no_d1d2(struct pc
  }
  extern struct device_attribute pci_dev_attrs[];
  extern struct device_attribute pcibus_dev_attrs[];
 +extern struct device_type pci_dev_type;
- #ifdef CONFIG_HOTPLUG
  extern struct bus_attribute pci_bus_attrs[];
- #else
- #define pci_bus_attrs	NULL
- #endif
 =20
 =20
  /**

--Signature=_Thu__29_Nov_2012_15_03_40_+1100_C3QrtJZRubTu+WMZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtt6cAAoJEECxmPOUX5FEv98P/3C2+yRQf2QVahkMgA5Zcerp
ixbK/u6bdxEOzXCemZLrDlsincOWeVrB6wVWkEAHI7h6JQWdnLK+b75pTFLzVUsc
do4TRgRxQPSyN2gFxv0UFAnpNWLck63g6+9NYUAZtaFmm9aaks2qIbIBYIGE2m5w
KgzSNHhsvXRtw/eCNJdRVC2zqdVkChbnnJnlcbMkY3iAvjdUL0hkC9z5kqqAoR6O
ngyyXaA8MTC3cEeEVdWxhYORUTLbuJjpyS06mrUl7Ba+rx4uEvuatDbE+KzAej4h
vvHeqGkHoOtunhwMw4ih4TYpS1ZZSAW1aOK8vNC1BgoRHvl6Edpg2iIfVX3Xpxvb
2enc0h+5i8vUU3gKxhpFsehxm5D8i9M0rXeBpTrXdoSSPwaEMCQ9rmkHZzGdCP6Q
HM7ryP6eor8erKaaXbf14R1hQY26k3re8aU6g+vBSRCiwWe6SdHmP2YsXiKXOTfq
zpWbSAtfp/b+jGFmJIpnGxt26veDk4B3zqCDlO9Wgsz+Ak46WVY4hkyzMlQ0/HkI
hsHIADb0LSEwDBPPLrbDHL4EmcUh0392PLbYwog1kUHEZDoCC7RGIPpxWShAzlwM
P+QAvnpUSYhFpKbdoXIlY4qVBUJtMT7UxrSYKCkT+PrqxzEiUYaXekmRkm24fybQ
rhZcBVKcUdwLufXEeFtN
=+cQX
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_03_40_+1100_C3QrtJZRubTu+WMZ--
