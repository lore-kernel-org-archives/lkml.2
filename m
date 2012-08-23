Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2HWCoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:44:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55217 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2HWCn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:43:59 -0400
Date: Thu, 23 Aug 2012 12:43:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: manual merge of the tip tree with the rr tree
Message-Id: <20120823124348.831760a775f7bcb9c8e26219@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_Aug_2012_12_43_48_+1000_Lnm5QgazjX=mkLQ6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Aug_2012_12_43_48_+1000_Lnm5QgazjX=mkLQ6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in arch/Kconfig
between commit bd029f48459a ("Make most arch asm/module.h files use
asm-generic/module.h") from the rr tree and commit b952741c8079
("cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/Kconfig
index 3450115,ea5feb6..0000000
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@@ -281,23 -294,7 +294,26 @@@ config SECCOMP_FILTE
 =20
  	  See Documentation/prctl/seccomp_filter.txt for details.
 =20
 +config HAVE_MOD_ARCH_SPECIFIC
 +	bool
 +	help
 +	  The arch uses struct mod_arch_specific to store data.  Many arches
 +	  just need a simple module loader without arch specific data - those
 +	  should not enable this.
 +
 +config MODULES_USE_ELF_RELA
 +	bool
 +	help
 +	  Modules only use ELF RELA relocations.  Modules with ELF REL
 +	  relocations will give an error.
 +
 +config MODULES_USE_ELF_REL
 +	bool
 +	help
 +	  Modules only use ELF REL relocations.  Modules with ELF RELA
 +	  relocations will give an error.
 +
+ config HAVE_VIRT_CPU_ACCOUNTING
+ 	bool
+=20
  source "kernel/gcov/Kconfig"

--Signature=_Thu__23_Aug_2012_12_43_48_+1000_Lnm5QgazjX=mkLQ6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNZjkAAoJEECxmPOUX5FEP7MP/1vzSQTiEwI1PoW9ehjDfeIp
HCKUt6W4ci+aS1owhtmlEP7oWIdN+0EAW0uLNQYIiA4cE0du0/KU+6hfF4JvOWz1
1yceDvvpz+CMq+X8Z7HMKdttrcWXqwCqtHIx549itW3laLeYQm6xUDWaEnlkfoZ1
s1kX+Gog71SQdfGNOLm8IIYMrniVbDOQbSIfR7yGYwpf6VlRt+vS2UY8Lgt3auWF
CkmGc9glzoXhuVkJRdbl4kADy/nRBdlU7VpaDk3+SZetOfIetDigBt6cgkhygiTZ
6piwwwGlfeTZH0oUfoAXTGXYRIKAFvG2a5emz6HKD985RPKlSgA7Vmwl10swAgPM
MKNF60MgrkYNuxKAurmvlgIGHBGCVh1BgU9vpbFUDAllG6B2E6+w+Z5MJtWvaZ3a
jqFVJJNFLy8sECkt3UopITv1JGDXFiHq8TnxFNEqtM6j0/HO+kXphqZ6YfBZCPRL
pD0nSXys0ieYzwHIyDCF5rciGmYNdmL/Uya3Hu/yxc/I5f0DIyCYiCXR09pv4Br6
x5BSfsmB1j8pcnd2VfJMOTlZd3vbQ0q52enTv58DK1LZOi7lDaGDPaQZRThyPYnJ
0g5KdSyPzrym013R1FjGsAUsA7FD+UqZky9L1DWBy0mQupaEgGhe0xh30P+kDWtG
Jqlgv94+qstdFxbrXQeI
=5Q7A
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Aug_2012_12_43_48_+1000_Lnm5QgazjX=mkLQ6--
