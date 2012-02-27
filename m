Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2B0Fom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:44:42 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46182 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2B0Fok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:44:40 -0500
Date: Mon, 27 Feb 2012 16:44:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. J. Lu" <hjl.tools@gmail.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120227164423.53eb106e611d5b3a66806f82@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_16_44_23_+1100_ugcHOe=3QSTYvY6F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_16_44_23_+1100_ugcHOe=3QSTYvY6F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/Kconfig between commit 5fd92e65a68b ("x32: Allow x32 to be
configured") from the tip tree and commit "ipc: provide generic compat
versions of IPC syscalls" from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/Kconfig
index 14b78d7,6f6807d..0000000
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -2206,22 -2206,10 +2206,23 @@@ config IA32_AOU
  	---help---
  	  Support old a.out binaries in the 32bit emulation.
 =20
 +config X86_X32_ABI
 +	bool "x32 ABI for 64-bit mode (EXPERIMENTAL)"
 +	depends on X86_64 && IA32_EMULATION && EXPERIMENTAL && BROKEN
 +	---help---
 +	  Include code to run binaries for the x32 native 32-bit ABI
 +	  for 64-bit processors.  An x32 process gets access to the
 +	  full 64-bit register file and wide data path while leaving
 +	  pointers at 32 bits for smaller memory footprint.
 +
 +	  You will need a recent binutils (2.22 or later) with
 +	  elf32_x86_64 support enabled to compile a kernel with this
 +	  option set.
 +
  config COMPAT
  	def_bool y
 -	depends on IA32_EMULATION
 +	depends on IA32_EMULATION || X86_X32_ABI
+ 	select ARCH_WANT_OLD_COMPAT_IPC
 =20
  config COMPAT_FOR_U64_ALIGNMENT
  	def_bool COMPAT

--Signature=_Mon__27_Feb_2012_16_44_23_+1100_ugcHOe=3QSTYvY6F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSxg3AAoJEECxmPOUX5FE8eYP/1J62PAtOD4xR/HcLYSfOdT9
iHym+CzspWHoti1TMwBeLnJ2u83dQwt/JyRfwFz6BK6jX7dn6RznrlPEEUv6Dmmw
vIbYU+xBPfj+j0XUnRxeW4IurzIgFUHkxtHZRYe9Tosh2fQ1pJdn1XQcsRtNzRBa
vT7cFdbVfBkaJ8vy1wOfeXcVppAa9BAGLlJHrIei/WRIHdMayFio1N5i+EHvMmSS
lKUf3GXDzhC63jHkLQ8n9vSfhcoWj8+tezKQQs8Vee7BBR+3fbcYFuTwayg/AS1G
BOxg5Uiyu358FmNx2syu9thHntwQi0GPRwW4z6miyfExUby895tFk9TZ16+wl3G6
z45Y6YFvVCyd0lu3dpk1TsbtFiTZXt0633iH1AGRb19YVwn8y7sX0HneW+9oiXHE
7GGnnOAxcyiVMq+iq/mBRTzOnkH3cy6JjOFpddDOKJo+u4/ocDwmKb5+pZ4pvp4R
lux4uYHznaRLoMwqMmjgdgvYl4JqwykjEOnUeZoVnn9KnowlSaMhjelgn4aDZZB2
Yet/wa1kPOgDIxmT3otg6ZF18H9Aacv0Ecjx7VVLPV1qkOGOOFbk+FnyV7WA3izL
+Geu4bcP1sg2zDS5P4ZIqpVo/mhBAR+Swpjc70uep2ChD4eAzHmAEHsfV3f3qLml
Yg4uNitEVN9aCFYrTVY9
=f7WA
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_16_44_23_+1100_ugcHOe=3QSTYvY6F--
