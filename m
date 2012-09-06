Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2IFFmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:42:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58283 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2IFFmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:42:51 -0400
Date: Thu, 6 Sep 2012 15:42:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Stigge <stigge@antcom.de>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20120906154240.12f7e0c01686559dd43744fa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Sep_2012_15_42_40_+1000_ZkN2pFZDkQHk4EIV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Sep_2012_15_42_40_+1000_ZkN2pFZDkQHk4EIV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/usb/host/Kconfig between commit 952230d774bb ("usb: ohci: Fix
Kconfig dependency on USB_ISP1301") from the usb tree and commit
d684f05f2d55 ("ARM: mach-pnx4008: Remove architecture") from the arm-soc
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
required).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/host/Kconfig
index 13cd6d5,276add2..0000000
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@@ -292,7 -292,7 +292,7 @@@ config USB_OHCI_HC
  	depends on USB && USB_ARCH_HAS_OHCI
  	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
  	select USB_OTG_UTILS if ARCH_OMAP
- 	depends on USB_ISP1301 || !(ARCH_LPC32XX || ARCH_PNX4008)
 -	select USB_ISP1301 if ARCH_LPC32XX
++	depends on USB_ISP1301 || !ARCH_LPC32XX
  	---help---
  	  The Open Host Controller Interface (OHCI) is a standard for accessing
  	  USB 1.1 host controller hardware.  It does more in hardware than Intel=
's

--Signature=_Thu__6_Sep_2012_15_42_40_+1000_ZkN2pFZDkQHk4EIV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQSDfQAAoJEECxmPOUX5FEwwMP/0sKFvQ4+E7qgtMyLw5A9hYD
EVvRwXPmjI1hQgQjg8olomYbHsPfhzKnSXobsp1GQfZmdVLV73shJpk87GoLa7yG
39gzmyho8lAFULPJjXQ3PR/9odZ5YXo8otKiQGwecle3YsUHhyGlUp4sbm3qj7oq
lMD7vG6a5Qf2Oza+0ifa407fkQL6ix/xHuyuw7eA9AUd6ovra8De9oyhd50oz46O
ICVYbF1e6czEopH4i7NWCSwu83NRy9sLEAZWvbNgGD8LFeHIAIZQLAOF3VVJ4HJQ
VP1nrpDyENlJ7Ctdk4p7UeqmCW4hMVAqAbCuYi6h9KI4OetTw9lztSxvTOHtdsqB
wxuzYAb+Ie5TE41OEE1FMb3ra1OABRTzqRWJluXrwipJNk7iAoWtGaURIuHNflWd
gOTZCdsbMA5TmFNvMQO6blEMraryhX6gCOqOMl2BpZQ0UaxoxX9ybaGcZ0KUka5R
foPwTJP4g+hQfftWr60xii4rS5NbRdON+7u6GyRx/FZTGV0OPI3XACnideFRD/+X
2RxTBKBz867pXGbzFVRcKCOYwlnQSj/zGC+gVH+GRcstbJ/7HkRRRXQesyxt6qVa
b2aN62XTLUhXJvxTHwnqYbCq1/pmFMdMgTJWyFVSLYL+bHguv03jUC2/jlAk7jbG
YzbVegJlRwndV6jmhUyT
=3NNF
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Sep_2012_15_42_40_+1000_ZkN2pFZDkQHk4EIV--
