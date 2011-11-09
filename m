Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab1KIAP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:15:29 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:38983 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933450Ab1KIAP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:15:27 -0500
Date: Wed, 9 Nov 2011 11:15:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: manual merge of the m68knommu tree with the m68k tree
Message-Id: <20111109111519.7d8969103ab32e7e8193c018@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Nov_2011_11_15_19_+1100_HBh9YW2PVH5EyQEc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Nov_2011_11_15_19_+1100_HBh9YW2PVH5EyQEc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the m68knommu tree got a conflict in
arch/m68k/Kconfig between commit d890d7399525 ("m68k/irq: Remove obsolete
m68k irq framework") from the m68k tree and commit 4e8a9e70dfe8 ("m68k:
selection of GENERIC_ATOMIC64 is not MMU specific") from the m68knommu
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/m68k/Kconfig
index 361d540,26ed01b..0000000
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@@ -3,9 -3,8 +3,8 @@@ config M68
  	default y
  	select HAVE_IDE
  	select HAVE_AOUT if MMU
- 	select GENERIC_ATOMIC64 if MMU
 -	select HAVE_GENERIC_HARDIRQS if !MMU
 -	select GENERIC_IRQ_SHOW if !MMU
 +	select HAVE_GENERIC_HARDIRQS
 +	select GENERIC_IRQ_SHOW
  	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 =20
  config RWSEM_GENERIC_SPINLOCK

--Signature=_Wed__9_Nov_2011_11_15_19_+1100_HBh9YW2PVH5EyQEc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOucYXAAoJEECxmPOUX5FEHaIP/2vaj8sV9qleSFdaqT2UVEbN
MqsOOClR+YnpAZKEmJp7VwUPaq3Dm8ZClLk0AVyiLr3zAqQzgrv5C6CMccy7RkfV
9NTb14UrRWdpZz3ZjiYPDckzjPvVKM+WtVI5o9HTSRLcZ6qK6zqBBUYTdRrOqhE5
F23DJ8YXnKuZ/EmR0L7wr9/teGJhBYjiArKzT4GBLG7WKAQBy/m/SUFL/iLWeWWl
roSCmqS2HtpFW0RLu+cvLNUFLU51vud+a20kUMwTlpkG8O8g+4jot/THgCvZct0R
bFVu6ChJP+/E3dT12+BWfqR0UAv+PbYZ9P0AlR2KCNJq2FS3rYY4aTDUR5hI4RDq
6RBSCLFhl7lcfeFjS2dJ+KzYjP6zbXgvmDuj+4m7XCmcU+L7RvL9aPCNCRuJkyNP
xswWPIAI8/Go1wm7jmMpIBkOdqfoR6jMYJ46fTEAwS/YD5fHedFb2rhQbJhUG/B4
fNd+6MODxss4ppNawfxn3ivP6pkCZJME+3uYKc3fYNs1GBL2IkpTXnj60nWu3NVE
Gd+cuhgJVpw687R7DvscJpBF0N9fp/snXFbSSddwcU5K65b0EJTOx3xYyPaKL4D4
wq0cZtT2XQM94HG4jX/16BZ7CFprSSxV9imZ/TbVpfjhX0WJYhk4/lBtbr9AI9JI
efR60tAhPzkBwLwsQyGu
=vCtf
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Nov_2011_11_15_19_+1100_HBh9YW2PVH5EyQEc--
