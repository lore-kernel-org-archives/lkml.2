Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2AKD5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 22:57:22 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34562 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2AKD5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 22:57:21 -0500
Date: Wed, 11 Jan 2012 14:57:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: linux-next: manual merge of the xen tree with Linus' tree
Message-Id: <20120111145709.77ef7d68996cd5fa724326e5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Jan_2012_14_57_09_+1100_3.I5m9WLz+XWRtAh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Jan_2012_14_57_09_+1100_3.I5m9WLz+XWRtAh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen tree got a conflict in
arch/x86/xen/Kconfig between commit 10fe570fc167 ("Revert "xen/debug:
WARN_ON when identity PFN has no _PAGE_IOMAP flag set."") from Linus'
tree and commit 23757fb5d678 ("xen: add CPU microcode update driver")
from the xen tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/xen/Kconfig
index fdce49c,4d04d4f..0000000
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@@ -50,3 -50,14 +50,6 @@@ config XEN_DEBUG_F
  	  Enable statistics output and various tuning options in debugfs.
  	  Enabling this option may incur a significant performance overhead.
 =20
 -config XEN_DEBUG
 -	bool "Enable Xen debug checks"
 -	depends on XEN
 -	default n
 -	help
 -	  Enable various WARN_ON checks in the Xen MMU code.
 -	  Enabling this option WILL incur a significant performance overhead.
 -
+ config MICROCODE_XEN
+        def_bool y
+        depends on XEN_DOM0 && MICROCODE

--Signature=_Wed__11_Jan_2012_14_57_09_+1100_3.I5m9WLz+XWRtAh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPDQiVAAoJEECxmPOUX5FEG7AP/Rssqi+tUaxgVskTmlim2KNY
kWhpjgiZ0j6Hq1gNncJa/YntMH+GP2IAaCOkXqf2KSzfi6/2ZxpB64qhpwUv6m7x
Vy7qag1Qw6hIZ20jue9IdkI2Zw5nmk3kPwpvE9pYbvd8zUqTS2RSUyk4dxLTd2A2
2YRqEGfGsJQ4axMLX5y2S4bTzIezUNWuw0z+SXs3wpiaiXUWl7Ge2XQfnN/gkNiu
7bGw7nTwZirdZ5d70As5EEDmb42rEJ7OtU+3VSj4R90d/2m22a0IZyfwbcEFOYn+
hzd1boox/8nWEHQXVYsWMvnD3b71c57ydcb1MBbJ+mxX0NLEwKQBzemwKywFafwV
7mx4a58NkkvKvGQ4IDRry7gCzM+/8osI0rukLivLji6plJDLvwnB3Q2T+vI/G+dj
gBZAIdwEjlry6Y4YmOu9EbGw4Cq/DRb5t+EcvGFKzfcE41tXdhVhBeL7W+gKaE1J
844Yvfm2xtbthYv4tDjVer+gQr8IbVZ1IMfvS+A/TDqJqHzJKN1dL1wrAyKLKtAX
EnrlfGr9dnS68yhR89bCCTfDCGJ8KN/FSIaHSlhHg+8dzHim2l6NAnuroI0ROJvt
UVfjgNYNVtj1XJMFgoCo+w3wbonrF71bFh3TRRCE3Eb9jt3VQjar5QRVBQjxOT5m
r3D7nPvrJGUr9G5pUvvl
=NhaO
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Jan_2012_14_57_09_+1100_3.I5m9WLz+XWRtAh--
