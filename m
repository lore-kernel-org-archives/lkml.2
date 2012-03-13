Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701Ab2CMFwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:52:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43436 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759669Ab2CMFwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:52:40 -0400
Date: Tue, 13 Mar 2012 16:52:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the uprobes tree with the tip tree
Message-Id: <20120313165238.ce66d34101e5af9898bb2277@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_16_52_38_+1100_Pr6Fs6Iuy3PYqthJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_16_52_38_+1100_Pr6Fs6Iuy3PYqthJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

Today's linux-next merge of the uprobes tree got a conflict in
arch/x86/kernel/signal.c between commit c5a373942bbc ("x32:
Signal-related system calls") from the tip tree and commit 1e1e2cddc33d
("x86/trivial: use is_ia32_compat_task") from the uprobes tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/signal.c
index 5134e17,907d483..0000000
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@@ -37,7 -37,15 +38,8 @@@
  #include <asm/syscalls.h>
 =20
  #include <asm/sigframe.h>
+ #include <asm/compat.h>
 =20
 -#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 -
 -#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
 -			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
 -			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
 -			 X86_EFLAGS_CF)
 -
  #ifdef CONFIG_X86_32
  # define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
  #else
@@@ -628,22 -637,6 +629,16 @@@ static int signr_convert(int sig
 =20
  #else /* !CONFIG_X86_32 */
 =20
- #ifdef CONFIG_IA32_EMULATION
- #define is_ia32	test_thread_flag(TIF_IA32)
- #else /* !CONFIG_IA32_EMULATION */
- #define is_ia32	0
- #endif /* CONFIG_IA32_EMULATION */
-=20
 +#ifdef CONFIG_X86_X32_ABI
 +#define is_x32	test_thread_flag(TIF_X32)
 +
 +static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
 +			      siginfo_t *info, compat_sigset_t *set,
 +			      struct pt_regs *regs);
 +#else /* !CONFIG_X86_X32_ABI */
 +#define is_x32	0
 +#endif /* CONFIG_X86_X32_ABI */
 +
  int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
  		sigset_t *set, struct pt_regs *regs);
  int ia32_setup_frame(int sig, struct k_sigaction *ka,

--Signature=_Tue__13_Mar_2012_16_52_38_+1100_Pr6Fs6Iuy3PYqthJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXuCmAAoJEECxmPOUX5FEvjUP/2u+JvJs9uKafWYiFXUbwjzp
FeUXGpq2HH0HEIWUuJjEu8fk8YJSg8vBKCL9NAmZKcziI+8rr6EVAb2iXxcCvK72
kNlgBmvikpy50spCE5uHnUl3pG4aETpsTGFxn0N4xGBdDGBLajr84pK4TxGKoyIv
nfSllsU6+G3LY0r/U8avB2avvZFh/I5zhHPJryVMwxxPXdoXZ9fQGIJjmryQ4yg7
lWxyEYzPEawfyjyIq2XSSKyUZvTIYZcCv46LaG9qdCmRaPmvsWfFUQXAtdtEUJHj
2Ka2hWixQk8IU6dyrAvPdpaGa92M0OXgX7WVshJfPmtnjXotq35Rjtc7K40NePrU
tshpkrh5tMMC/ctYVbJ0wGIQc9JMV1j0MJouFXn2X36MuXdindRw72mAJL9pV/jh
/TOOXQrH2VDICmc4tWmvtrmX3RmwKctJ+5sOPWdtw8wD5R9qjiLtCBt52USbdyGi
7HDzmXiL5M/c9iMWCTr59W7bckym+vDEb/nIb9SpSsszmLnVjekf1o+94J9BB7lv
5RzlTxC5kesyGVhqwWyuPGJ7w/EoHA9vO6hjkQow9r4+HnG7eocuqz5vSg7o4J3p
U4cPrQREhRV5bRqKxaAwlumS/pFWvtZdGegWwiLfyTKqI5d9MnQGmfz4nZcx2r9f
He8OhTbscMw9w6R5zmwX
=d/Pf
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_16_52_38_+1100_Pr6Fs6Iuy3PYqthJ--
