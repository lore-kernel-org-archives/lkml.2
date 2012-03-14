Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2CNDwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 23:52:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48297 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2CNDwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 23:52:20 -0400
Date: Wed, 14 Mar 2012 14:52:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>, "H. J. Lu" <hjl.tools@gmail.com>
Subject: linux-next: manual merge of the tip tree with the tile tree
Message-Id: <20120314145214.b41adef6a73ef6bbdc64dd56@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Mar_2012_14_52_14_+1100_lx.veHD/O8EttEUX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Mar_2012_14_52_14_+1100_lx.veHD/O8EttEUX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/Kconfig between commit ca3a3d347e23 ("ipc: provide generic
compat versions of IPC syscalls") from the tile tree and commits
5fd92e65a68b ("x32: Allow x32 to be configured") and 0bf6276392e9 ("x32:
Warn and disable rather than error if binutils too old") from the tip
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/Kconfig
index 0ca57e0,21ec4bf..0000000
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -2174,10 -2195,22 +2194,23 @@@ config IA32_AOU
  	---help---
  	  Support old a.out binaries in the 32bit emulation.
 =20
+ config X86_X32
+ 	bool "x32 ABI for 64-bit mode (EXPERIMENTAL)"
+ 	depends on X86_64 && IA32_EMULATION && EXPERIMENTAL
+ 	---help---
+ 	  Include code to run binaries for the x32 native 32-bit ABI
+ 	  for 64-bit processors.  An x32 process gets access to the
+ 	  full 64-bit register file and wide data path while leaving
+ 	  pointers at 32 bits for smaller memory footprint.
+=20
+ 	  You will need a recent binutils (2.22 or later) with
+ 	  elf32_x86_64 support enabled to compile a kernel with this
+ 	  option set.
+=20
  config COMPAT
  	def_bool y
- 	depends on IA32_EMULATION
+ 	depends on IA32_EMULATION || X86_X32
 +	select ARCH_WANT_OLD_COMPAT_IPC
 =20
  config COMPAT_FOR_U64_ALIGNMENT
  	def_bool COMPAT

--Signature=_Wed__14_Mar_2012_14_52_14_+1100_lx.veHD/O8EttEUX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYBXuAAoJEECxmPOUX5FErRgQAI32MEQuwla5PQjmrYN2YtHq
KFuJFnmrdh7YaXENV3/3hj+dULAn/eVw8v/gKhDb783haIJvvgW8JbytBiBy883m
Niy2Xfopm5I/EXJAAC3vEYQaXQNVtfIAePsn9zeXAK7uMMHY4n+C/040ccRAGJn4
7Vxdw44AfwR6+a6/TmN3C18LZjzqBi/AMX5Cg1Vvz6a1EzSeVncRYdnfuU+qFAOA
828QQ1tNREp8fQQD9QyFmiPpKufueFDiwbZdigKY4qrp5mF2IBPipE8+vFlcz09M
S2EJiUIIOt9sj6RF+LQA6sg688giEFY55GkITIII/er97iuY4vm/rTvo3c1e0ZUO
BOKSOkOP29i1HvNO9vncE7skkjigoBTE5ZLPjLUuKEp+hQhgGTebifEgVT6eS0m0
8NLVYwGU5DVZJ4rCPTS96J3xJvTFkp1Ss8CjNmJTVEOUX1MUJk60TPWZULsnFjWt
Xv/+uVqYq7x0CKzNHpJO7KTBmVL6yLdhqfIiEb6pTvGoxypmZtMIuUOQ2E1bB6pt
DBRzsO2sFe+8VZcaXo9EvzeXj5REa2wcjzmW4iZX80BcOMHzoc2UIqCgfIUXiRsb
+37bwy+ALT5aUFH5k2QVltDWZJ4AFX7koCDbq30oXe2s5f4V/R6TkR1OJ10QERme
PI5u8G+ESx+j5LUfJuag
=9F6R
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Mar_2012_14_52_14_+1100_lx.veHD/O8EttEUX--
