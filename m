Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab2BXDfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:35:00 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46221 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2BXDe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:34:58 -0500
Date: Fri, 24 Feb 2012 14:34:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20120224143443.a3e0d14296f20c5facbcfb0b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Feb_2012_14_34_43_+1100_aEf=mY1zmeo9pCYn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Feb_2012_14_34_43_+1100_aEf=mY1zmeo9pCYn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64_allmodconfig)
failed like this:

/opt/cross/gcc-4.6-nolibc/x86_64-linux/bin/x86_64-linux-objcopy:arch/x86/vd=
so/vdso-note-x32.o: Invalid bfd target

I appears that we need a 2.22 binutils :-(

$ /opt/cross/gcc-4.6-nolibc/x86_64-linux/bin/x86_64-linux-objcopy --version
GNU objcopy (GNU Binutils) 2.21
$ /opt/cross/gcc-4.6-nolibc/x86_64-linux/bin/x86_64-linux-objcopy --help
	.
	.
/opt/cross/gcc-4.6-nolibc/x86_64-linux/bin/x86_64-linux-objcopy: supported =
targets: elf64-x86-64 elf32-i386 a.out-i386-linux pei-i386 pei-x86-64 elf64=
-l1om elf64-little elf64-big elf32-little elf32-big srec symbolsrec verilog=
 tekhex binary ihex

I have applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 24 Feb 2012 14:27:17 +1100
Subject: [PATCH] x86: mark X86_X32_ABI broken for now until I get a better
 binutils

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 59c5b9c..e63a4dd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2159,7 +2159,7 @@ config IA32_AOUT
=20
 config X86_X32_ABI
 	bool "x32 ABI for 64-bit mode (EXPERIMENTAL)"
-	depends on X86_64 && IA32_EMULATION && EXPERIMENTAL
+	depends on X86_64 && IA32_EMULATION && EXPERIMENTAL && BROKEN
 	---help---
 	  Include code to run binaries for the x32 native 32-bit ABI
 	  for 64-bit processors.  An x32 process gets access to the
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__24_Feb_2012_14_34_43_+1100_aEf=mY1zmeo9pCYn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPRwVTAAoJEECxmPOUX5FEXUIQAJp15P/bl98TvnmyN2r2V26h
05H5PqUJqlsZ+wf72Xg4xLpPxmS59GSdjJe+qQ/RWy4YQepKSiGOJkXr3Tg0ZbZK
aCpPfUhN9GXL/pUievMWNyceDG2LTmjB1sOBo5NTwdg3KWOun73ZKVcvP5KxGy6r
j3+yNMbJqtiKTDOIyhriLHarVnz80XnBFfKijYdfMRBXOrFkEVGrjMPf1LNcwCHW
j/+9iW2sKGG1S7K5RU/wg+Otu19pPTWV1O0XRKKA+hB/jucSgIrAj7ULJb6/aZPe
ctvnbVzMrUG91Ijo7ZIG/wv0ojJoR4RBsSxiZSYUkfBr1P2L+olfXgqvh3bEIbnv
GiFLCf75/V/Bibp3iepl++Q/K88tPaeTU7ZTNzbWxYI6cxHXnyXpGQF7Q0m0W55c
hnms+HSkyjmazYNrq/ie3lBqrqnLg9y+HDPv3axQfYJAAAOmOm7dmzj4QpXMNvna
aHjNseMRKOpb09HzwfJ+RFaOqiOrMFWnyNphkchVmC6kiusmfBTAO39Tw4kahRNg
ox7H8/G2QHsO2nzWIG9lFFMezwNeYARGOwOUa1OJN1R0/8QeqMhCcOXYifFFPwIJ
AWxGxwMGlY5xEHh8djYEY3ZHQGe4YublPvRJ/Ny4aKKBKxiRNyy/d8rIvj7u7U9m
6c8S6XzCBV5Vear1T9vT
=1wig
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Feb_2012_14_34_43_+1100_aEf=mY1zmeo9pCYn--
