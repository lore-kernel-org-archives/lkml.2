Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0GTGl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 02:41:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34226 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab0GTGlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 02:41:55 -0400
Date: Tue, 20 Jul 2010 16:41:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: OOPS at boot time
Message-Id: <20100720164145.e06242b3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__20_Jul_2010_16_41_45_+1000_s.dqRGPPDIEJB74W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Jul_2010_16_41_45_+1000_s.dqRGPPDIEJB74W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

All of my PowerPC boot tests are getting this after getting to user mode
(sometimes several times):

------------[ cut here ]------------
kernel BUG at fs/inode.c:1244!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=3D128 NUMA pSeries
last sysfs file: /sys/kernel/uevent_seqnum
Modules linked in: ehea xt_tcpudp iptable_filter ip_tables nfnetlink nf_con=
ntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT x_tables dm_mir=
ror dm_region_hash dm_log dm_zero dm_snapshot parport_pc parport dm_multipa=
th autofs4
NIP: c000000000168074 LR: c000000000168064 CTR: 0000000000000000
REGS: c0000000063d39f0 TRAP: 0700   Not tainted  (2.6.35-rc5-autokern1)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 22008422  XER: 20000001
TASK =3D c000000003a25840[4995] 'rm' THREAD: c0000000063d0000 CPU: 2
GPR00: 0000000000000001 c0000000063d3c70 c000000000bfdea0 c0000000015f2090=
=20
GPR04: 0000000000000003 0000000000000001 c0000000063d3bd0 c000000000c5a388=
=20
GPR08: 80c0000000000000 0000000000000006 6000000000000000 8000000000000000=
=20
GPR12: c0000000056c0598 c0000000074d6400 0000000003100000 0000000000779b68=
=20
GPR16: 00000000007782f0 0000000010018875 00000000ff9c74b8 0000000000000000=
=20
GPR20: 0000000000000000 0000000000000000 0000000010010000 0000000010010000=
=20
GPR24: 0000000000000001 00000000fffba994 0000000000000002 000000001001a038=
=20
GPR28: c000000006617800 c000000000aefd40 c000000000b586b8 c0000000056c0748=
=20
NIP [c000000000168074] .iput+0x288/0x2d0
LR [c000000000168064] .iput+0x278/0x2d0
Call Trace:
[c0000000063d3c70] [c000000000168064] .iput+0x278/0x2d0 (unreliable)
[c0000000063d3d00] [c00000000015e964] .do_unlinkat+0x124/0x1b8
[c0000000063d3e30] [c000000000008554] syscall_exit+0x0/0x40
Instruction dump:
38000000 f81f0008 f81f0000 e87e8090 48457d8d 60000000 7fe3fb78 4bfff339=20
e81f03b0 68000060 3120ffff 7c090110 <0b000000> 38210090 7fe3fb78 e8010010=20
---[ end trace 9ace9d3884bc0aac ]---
Trace/breakpoint trap
------------[ cut here ]------------

This is:
	BUG_ON(inode->i_state !=3D (I_FREEING | I_CLEAR));
in iput_final().

That BUG_ON was added by commit c0ae81f2 ("Make ->drop_inode() just
return whether inode needs to be dropped").

Has anyone seen this or something similar?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Jul_2010_16_41_45_+1000_s.dqRGPPDIEJB74W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMRUUpAAoJEDMEi1NhKgbsE/4H/0fzqd6GrZ/oPJYAnrvsKd27
dLs2wLvTBJCEfHCuXHp7yjO6i16Sr9W3n8dtM6ymRLiYw8tJefS87GNTr+cge6RJ
7dWhns+NNdq+K14nLdp0jSDCtP/ZVvGfeDMi6fVKnPWf3XZUZz8MIU7dPMbFpkj4
8VZ54D62i8gl3PtF+RUvv7vc/QAuANCsaDYtcGj94SpRiWz6ZN9Pil1rUOiUsmms
jx5HL7XoJ19GXKt+e5IpZSYETe6KZRPEpo9IZEwv39NA8Mncc4DLDLJ3DTa4seaa
olL1qrUEtV/Gws1Ty05arUmWX8IvlQ/rCPaEjpHHq4TZj5xh8o5Csr2O2sT/J9A=
=BBdx
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Jul_2010_16_41_45_+1000_s.dqRGPPDIEJB74W--
