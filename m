Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2B1D3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 22:29:37 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35385 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab2B1D3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 22:29:19 -0500
Date: Tue, 28 Feb 2012 14:29:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: manual merge of the driver-core tree with the pci tree
Message-Id: <20120228142909.48fa1eea6980eaffa27abfdc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_Feb_2012_14_29_09_+1100_BPmzFf==W/MQNg4M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Feb_2012_14_29_09_+1100_BPmzFf==W/MQNg4M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
include/linux/pci.h between commit 6754b9e9c335 ("PCI: Rename
pci_remove_behind_bridge to pci_stop_and_remove_behind_bridge") from the
pci tree and commit aad4f4000cec ("PCI: Add helper macro for
pci_register_driver boilerplate") from the driver-core tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/pci.h
index 5584aac,d4afd70..0000000
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@@ -947,7 -946,20 +947,20 @@@ int __must_check __pci_register_driver(
  	__pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
 =20
  void pci_unregister_driver(struct pci_driver *dev);
+=20
+ /**
+  * module_pci_driver() - Helper macro for registering a PCI driver
+  * @__pci_driver: pci_driver struct
+  *
+  * Helper macro for PCI drivers which do not do anything special in module
+  * init/exit. This eliminates a lot of boilerplate. Each module may only
+  * use this macro once, and calling it replaces module_init() and module_=
exit()
+  */
+ #define module_pci_driver(__pci_driver) \
+ 	module_driver(__pci_driver, pci_register_driver, \
+ 		       pci_unregister_driver)
+=20
 -void pci_remove_behind_bridge(struct pci_dev *dev);
 +void pci_stop_and_remove_behind_bridge(struct pci_dev *dev);
  struct pci_driver *pci_dev_driver(const struct pci_dev *dev);
  int pci_add_dynid(struct pci_driver *drv,
  		  unsigned int vendor, unsigned int device,

--Signature=_Tue__28_Feb_2012_14_29_09_+1100_BPmzFf==W/MQNg4M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTEoFAAoJEECxmPOUX5FE3b8P/2j2QSwUfAgpJGPeROzfhhw7
snQT6CCz4FQ9oBdNUINH1g6MdCwrMcw5l7kBPqi2XTX3ZnInijePxN68N+CAkF01
HFXXEB+age1bYl3gfjDpBYygtsw+W97EvbT8B/7V9tIyVt9gZBNYH/a4qiKH4mBE
rZRoHFmTROfZhZIBOsYNH4lGsCvvUTcVqlUmFoY2zRYzMx3KnlMII1NZI6Pi9pc8
WBUvuQ6Z7dyO1IVDgxpf+Jy84xPk8yjSnpmicft/P4pnWltgJrVFPAhK5eaFRIwr
yYyYdWiFBzsyX8AWhAEzAr2021zb1Jp+FO/3aGogtq6vFsqa6WOyHB+qN75cGvmK
YiFHFOcHsgaoGAaYDJPe/FidcRF2i8etZRzgXOc0VFZ+a8xu8L8g9FdLD8tgkNc9
oymqqJNSDRDDVu9MBOLnsRCzIIMbzC+behjvNwY+ZVo/7t0+otxJ1+7H8qvKXo88
NnMafmLo4qdteGTACYaj81aWlWZ7AeGsxKyvHMXkVwp1liA6ZCEROFmInmJIuFm/
bXCvJt8XkNiDVLmG1mOi5uNoV8FsCiVhC39Tbdq+bY1lwnAmCzK71ooU/ZpFV6Sz
S6DfwMZia+dl+MkkYOOOWHO8UeF0NN5ke+F6kBzC77+f5cxtNtA15vrOAVXkIHsc
E3bG0yjAQBc01EgOLpg3
=3ckH
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Feb_2012_14_29_09_+1100_BPmzFf==W/MQNg4M--
