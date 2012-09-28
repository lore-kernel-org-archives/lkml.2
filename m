Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2I1DeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:34:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50783 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2I1DeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:34:09 -0400
Date: Fri, 28 Sep 2012 13:33:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: manual merge of the tip tree with the rr tree
Message-Id: <20120928133341.5697fbecc1674b2143101f52@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Sep_2012_13_33_41_+1000_tjy2c38w=8GLtZRr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Sep_2012_13_33_41_+1000_tjy2c38w=8GLtZRr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in arch/Kconfig
between commit 9a9d5786a5e7 ("Make most arch asm/module.h files use
asm-generic/module.h") from the rr tree and commits fdf9c356502a
("cputime: Make finegrained irqtime accounting generally available") and
2b1d5024e17b ("rcu: Settle config for userspace extended quiescent
state") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/Kconfig
index 3450115,a62965d..0000000
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@@ -281,23 -294,23 +294,42 @@@ config SECCOMP_FILTE
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
+ config HAVE_VIRT_CPU_ACCOUNTING
+ 	bool
+=20
+ config HAVE_IRQ_TIME_ACCOUNTING
+ 	bool
+ 	help
+ 	  Archs need to ensure they use a high enough resolution clock to
+ 	  support irq time accounting and then call enable_sched_clock_irqtime().
+=20
  source "kernel/gcov/Kconfig"

--Signature=_Fri__28_Sep_2012_13_33_41_+1000_tjy2c38w=8GLtZRr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQZRqVAAoJEECxmPOUX5FEWOQP/3O5F7yVqjKKKEEGdMU/Q6Fr
Fe9WJm07yw7OvgldY4ELJ1C656iE7jE+hC45mh9fttVGVNULeBJfetHyrAon89oh
ZXSMEgwUFRn5T02DUMFYLeKRN3rPkleADai7UUR9opsNViAUKtdqO626n3Z7L6Wh
GxmNpy1H8jJpc1YND0S8KLNMCeAt7FPhaZYpjUckWqCsufVT0Xv3aA3GGX+w0IlD
setJhcFDhPIFNRMJSIrnrUdE5aKs8e7SGVGMHdd2DRwuYxn/eS8Xb49m5NnzshIa
cgaYzpSq2k6hptG2jUd9Uo3VsdquPVJMJY5zILH9u6oqiuW7e91svZtvyESMMCdq
ca0O7F5PXoyq++QT3W18/oDTN3sgWE/Mwj4ol2jFASZsAgS8OJkw33CgBXFNIE0i
pC2t6FsgBk7CC9whh1NvJguFVv0VJzMUMEembOT9lPAApFgK/XwPrF5bM+ZaXqzQ
Q8UaQgcATqGSY7FI6ySCc7M82b6Pau+K6ae+O9gacOcfHPVqzknXvkMhofMQoa0Q
uYLLzKTAeUXGLIGTW9VHe4h/txHBbHuvac7FCFX8fznv10FcUpU6j9wf2w4NSvyH
ZkVCeIoYjoUUbpLun4GI7Kk6RdP5apBYa6Y1vKEFMU5Qgz3Z5OveFoPA7jz2LwhX
V4u183nhYNkpf3BjaU2w
=Wmq7
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Sep_2012_13_33_41_+1000_tjy2c38w=8GLtZRr--
