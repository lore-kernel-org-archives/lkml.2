Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2CNDqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 23:46:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45570 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2CNDqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 23:46:43 -0400
Date: Wed, 14 Mar 2012 14:46:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the tip tree with the s390 tree
Message-Id: <20120314144633.947d650e8b2904625df53416@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Mar_2012_14_46_33_+1100_Bg0ow0f52Y7+54xT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Mar_2012_14_46_33_+1100_Bg0ow0f52Y7+54xT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/s390/kernel/smp.c between commit 8b646bd75908 ("[S390] rework smp
code") from the s390 tree and commit 5fbd036b552f ("sched: Cleanup
cpu_active madness") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/kernel/smp.c
index 64ebbcb,b0e28c4..0000000
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@@ -714,12 -544,12 +714,6 @@@ static void __cpuinit smp_start_seconda
  	ipi_call_lock();
  	set_cpu_online(smp_processor_id(), true);
  	ipi_call_unlock();
- 	/*
- 	 * Wait until the cpu which brought this one up marked it
- 	 * active before enabling interrupts.
- 	 */
- 	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
- 		cpu_relax();
 -	__ctl_clear_bit(0, 28); /* Disable lowcore protection */
 -	S390_lowcore.restart_psw.mask =3D
 -		PSW_DEFAULT_KEY | PSW_MASK_BASE | PSW_MASK_EA | PSW_MASK_BA;
 -	S390_lowcore.restart_psw.addr =3D
 -		PSW_ADDR_AMODE | (unsigned long) psw_restart_int_handler;
 -	__ctl_set_bit(0, 28); /* Enable lowcore protection */
  	local_irq_enable();
  	/* cpu_idle will call schedule for us */
  	cpu_idle();

--Signature=_Wed__14_Mar_2012_14_46_33_+1100_Bg0ow0f52Y7+54xT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYBSZAAoJEECxmPOUX5FENpoP/Ar0QIYNOoNxnDpmWw1emPJW
qn3DjbSQN84xXtdopyjS59dlfJahvCm1PkbkrJygiJCu8CN8KdAaWxlQAoVIhPOs
sS6QqN5X0ySxbSgUaG4r7/fkOlETIAfyc019qvWmDMmy/1uc6dnbPBUojjyLiFLB
yDfCP1iV3wanZsXfN3klwkAP7gUSzkCKaUJArzNYm3dlaz/h5yhtmDU+EsRvaQKm
PTlRTGwbvdDX2aBP+0wMqVXnhU8tPzU4M3fvJNLbJnNWl8a0Fjhrs6sScA8nFM90
hyhyxeUUT7DiCdThhjEg4yUfIJcV3vaI3AeZKzA+vFpXNrTeSAjlSl7r5V9YI4g3
WwechzPmO9tQrWxIDtIvsISHrUq8LWSrOz5aD5pprsE1QMNXDNjxNfXmS/DpH5Tr
gizRbTACcLsXEDd6Rhqh1AUQGqSDOEHJvF3spmu9k65yoHYE7a1Knmy83sBWZZHF
yT1xVr3bgtdiZNx1C5ahzV1qci+bd3ZX9V8GY9jqnWa46t5YCa0KTz9vT0MTWDYG
/XZ+S0Y+rr3WieDksRpoZIc7PUn1q5Ed6Z6hknkBOnZoN0w92BTtf1gLWIqbrPNq
z0yLNs7nsMYp6TJPMMB7NVC+p7Kqe5r2xEmJtiR9ujvSS0XRrF0DbJsdOtmYrpd3
rWDkPALSCySgFqw37xd8
=/3s/
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Mar_2012_14_46_33_+1100_Bg0ow0f52Y7+54xT--
