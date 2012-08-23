Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab2HWDB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 23:01:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39741 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab2HWDBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 23:01:55 -0400
Date: Thu, 23 Aug 2012 13:01:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the rcu tree with the tip tree
Message-Id: <20120823130143.86cb19b5c9799d138cdb0b07@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_Aug_2012_13_01_43_+1000_1wCCR6CWZH=Fah2Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Aug_2012_13_01_43_+1000_1wCCR6CWZH=Fah2Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the rcu tree got a conflict in arch/Kconfig
between commit b952741c8079 ("cputime: Generalize
CONFIG_VIRT_CPU_ACCOUNTING") from the tip tree and commit 3dbdfc26e27f
("rcu: Settle config for userspace extended quiescent state") from the
rcu tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/Kconfig
index 07db929,1c7c9be..0000000
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@@ -294,26 -274,14 +294,36 @@@ config SECCOMP_FILTE
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
 +config HAVE_VIRT_CPU_ACCOUNTING
 +	bool
 +
+ config HAVE_RCU_USER_QS
+ 	bool
+ 	help
+ 	  Provide kernel entry/exit hooks necessary for userspace
+ 	  RCU extended quiescent state. Syscalls need to be wrapped inside
+ 	  rcu_user_exit()-rcu_user_enter() through the slow path using
+ 	  TIF_NOHZ flag. Exceptions handlers must be wrapped as well. Irqs
+ 	  are already protected inside rcu_irq_enter/rcu_irq_exit() but
+ 	  preemption or signal handling on irq exit still need to be protected.
+=20
  source "kernel/gcov/Kconfig"

--Signature=_Thu__23_Aug_2012_13_01_43_+1000_1wCCR6CWZH=Fah2Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNZ0XAAoJEECxmPOUX5FE+esQAJ/jU9lACctiBOfeKoQteAWL
dNRqDduPPGMNQfxfJEtMH+741YuBNUUAEW3F+dXWDTn5sCjaDoIul7E55gnJPpOx
Nz/FcvJqCLonpcYXdSKV7tX5xCP4UFOsbPP70eK01u0SSWx2zTmyN26Reidhdfuz
TIraKQxHzB7u0371PzRjQlzB/Le5mcNS/UcoXScdYxrslxag1lhg1rWAcO3a2EUk
P6x3bJ9EtzO5yzyj3mQN6HuzNh2rpfY7fBVOEOp0lTdP9dxn5+jOHLflXurGWCIS
7D53T3ZbyRsjHG1Om4W+eqPAKYO9dFLABckXGsco1fGj+Ds6Tj5IKoIYxQvrPpi9
jm4Rdc1DPMRZr2zv1FXcJot1w4G//l/YSc0cIB1AZWpiY2847b+c+MYTMGTZvc38
bZ8OsFxYQ9deXcGbtDV8BCWyUqIjyOu5vDAM6zudFlquqp6P8IUg7hzC+6UBLuTD
bNdypoEH9ZKMVBcVEriKUSSYWbsOd1bu/sYzm/VDFYWRNRdMFQtsNN0dDkhzyMDa
9u/oyfW43v1CcyNjoz3Ssm+wx0l3vNBHOlpz8eFSRQN1i1p7x6tXWXxFzZaNqnK0
GHyNMpGeJ7AO+WQYkoWOdBk2LtFVCfYlhLxRkWUHBnI9qUSnbAJ9ewpnWf2moQhg
2h3sMJ3LxWbg/AdszxHA
=zHqc
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Aug_2012_13_01_43_+1000_1wCCR6CWZH=Fah2Q--
