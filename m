Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab2CMFwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:52:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45272 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759656Ab2CMFwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:52:35 -0400
Date: Tue, 13 Mar 2012 16:52:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the uprobes tree with the tip tree
Message-Id: <20120313165227.1eae0b68d51b93629128861b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_16_52_27_+1100_bp5bLoSvQvDaymX+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_16_52_27_+1100_bp5bLoSvQvDaymX+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

Today's linux-next merge of the uprobes tree got a conflict in
arch/x86/kernel/traps.c between commit c94082656dac ("x86: Use enum
instead of literals for trap values") from the tip tree and commit
b6d8245ec899 ("x86/trivial: rename trap_no to trap_nr in thread struct")
from the uprobes tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/traps.c
index 4310189,993f52f..0000000
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@@ -238,10 -233,10 +238,10 @@@ dotraplinkage void do_double_fault(stru
  	struct task_struct *tsk =3D current;
 =20
  	/* Return not checked because double check cannot be ignored */
 -	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
 +	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
 =20
  	tsk->thread.error_code =3D error_code;
- 	tsk->thread.trap_no =3D X86_TRAP_DF;
 -	tsk->thread.trap_nr =3D 8;
++	tsk->thread.trap_nr =3D X86_TRAP_DF;
 =20
  	/*
  	 * This is always a kernel trap and never fixable (and thus must
@@@ -269,7 -264,7 +269,7 @@@ do_general_protection(struct pt_regs *r
  		goto gp_in_kernel;
 =20
  	tsk->thread.error_code =3D error_code;
- 	tsk->thread.trap_no =3D X86_TRAP_GP;
 -	tsk->thread.trap_nr =3D 13;
++	tsk->thread.trap_nr =3D X86_TRAP_GP;
 =20
  	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
  			printk_ratelimit()) {
@@@ -296,9 -291,9 +296,9 @@@ gp_in_kernel
  		return;
 =20
  	tsk->thread.error_code =3D error_code;
- 	tsk->thread.trap_no =3D X86_TRAP_GP;
 -	tsk->thread.trap_nr =3D 13;
 -	if (notify_die(DIE_GPF, "general protection fault", regs,
 -				error_code, 13, SIGSEGV) =3D=3D NOTIFY_STOP)
++	tsk->thread.trap_nr =3D X86_TRAP_GP;
 +	if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
 +			X86_TRAP_GP, SIGSEGV) =3D=3D NOTIFY_STOP)
  		return;
  	die("general protection fault", regs, error_code);
  }

--Signature=_Tue__13_Mar_2012_16_52_27_+1100_bp5bLoSvQvDaymX+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXuCbAAoJEECxmPOUX5FE44kP/j4q0YnQqa/trIdgWNUTM4IY
O+0UnRIJUxC9SUpm4+6mrO+vRjG3pybn8njbzZ+Nu1M9pOE+QTgVRQVw6KABtiVw
Iy46C7ZDl7qEkfl4nPNUdoSJUHepHiSTq6xnwBiQsqtpWeNp7ukNMhW3q/D1yTVO
qWAYTA19H6Cjmbki0lu/G33ECbokr5cphbtaTZXDw1V+FHkV3yHxHYX2rRqcaqQr
nkdBW7VwJzGTi2ONwwOdov00ZgUnELrsu6cI3nsaUCYld7dJTMXzdtHE1F2evbLa
bGhgEtyDwuLZV3AvudrF7VCYpUc6XvpqLO5L9caDGixku+k0EQh77r9oOIMknulI
15FqGF29X8c3NZaSYENAzf21ukp0A9OegfqpNWk1qKeabCJZ5dzcWWESE+u0c2DO
inG+HDKNh6NySvwUStLLKCQgtMbwc+f4+PXZfT4a6xqhUwcqf7tX3M0780LtHT21
tg4OoRVYrmumoG5w10bCuUvrkWT111mSZLwV1HvIxcXF3DffJV1daaoaN99wdc/q
B0zOIkFOBo/3T9hjS1tCCFuBFVti7ZFxMdTJmMj9Km38cNOvMNqIPe/zwUQRw2DY
vrDtvvuc3PtlhZlrUorbXTS6btwIhkwA32UJ23eHn9LsDPghknEuCC4vMODkVVw5
0GDKyM2dI8zu/b+Vmp4X
=RqLn
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_16_52_27_+1100_bp5bLoSvQvDaymX+--
