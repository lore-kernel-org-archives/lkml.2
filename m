Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2HPDtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 23:49:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39907 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2HPDtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 23:49:24 -0400
Date: Thu, 16 Aug 2012 13:49:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: linux-next: manual merge of the kvm tree with the s390 tree
Message-Id: <20120816134911.1acd403bd420ad64c8ad9ef5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Aug_2012_13_49_11_+1000_zWs0jqmZg_OxiI2e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Aug_2012_13_49_11_+1000_zWs0jqmZg_OxiI2e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/s390/include/asm/processor.h between commit 3c011c612acb
("s390/bpf,jit: BPF Just In Time compiler for s390") from the s390 tree
and commit 9b7fb990e080 ("s390, /dis: Instruction decoding interface") from
the kvm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/include/asm/processor.h
index d4477ba,eac4fb5..0000000
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@@ -140,7 -140,7 +140,8 @@@ extern int kernel_thread(int (*fn)(voi
  extern unsigned long thread_saved_pc(struct task_struct *t);
 =20
  extern void show_code(struct pt_regs *regs);
 +extern void print_fn_code(unsigned char *code, unsigned long len);
+ extern int insn_to_mnemonic(unsigned char *instruction, char buf[8]);
 =20
  unsigned long get_wchan(struct task_struct *p);
  #define task_pt_regs(tsk) ((struct pt_regs *) \

--Signature=_Thu__16_Aug_2012_13_49_11_+1000_zWs0jqmZg_OxiI2e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLG23AAoJEECxmPOUX5FEITwP+we3QuLSNmxsRDeE59TPSMmK
CjyMHrPwOK9PUiVGN/7KfkMEbNqc/Rc9wXY8dKbA1KjuumAPD2q0TcWbf+JVx6LX
A4IIKIPQALMUVkPWaVzyo6CrxGVNW1py8d2JiZN03gezPPV2nj68DsZdaRmKhaFJ
loQ05L02vzgwjZriW3gRGqzLQRy47AHJFdf4eWhh3zf79c9gJq9jiDe8JxqV3lgO
SymWZ0rWn59ZPeKDIFGPItQkyYPrvhFauaonn8mGLXZcn6Ok98JItNOO2b3BRuQG
++0H2U05aqXDnRzTnS567zytWEt9rQkUzD7amHk9Z6dqBXOASWandXn2rKKWzOpJ
6vMzUVArWPv2+b1N4jzzb1cY8Y5dqEK6qapAzX7wwuz+WlrUgGZJoAmxU2marM7M
scsRKxpNoFy5K0NjcXyTUwRhhpbWgRS28dhp+8lWEL355SixcQK/j60rpZMmg+Kw
+p3SkigW0GPYXpH5qjRjATGPYuYto3Ikow+gW36fekdltJglkpxHvkfejAxFthSe
nwziEP6vqk7ME/P/9qtSpfxUagyiq4vTgU9s7ZbtIbI3ndDpq6tUi9HCFM8h5MMD
fKgsvS++KmeDYdbYw9BExrapRIHZhl2RYUizapPkmXkY0/GxfJ8+Ex/BN90AXIFN
rydH5neht4wtNVHXPdxs
=dzfD
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Aug_2012_13_49_11_+1000_zWs0jqmZg_OxiI2e--
