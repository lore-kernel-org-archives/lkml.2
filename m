Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab2GIEt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:49:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44856 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2GIEty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:49:54 -0400
Date: Mon, 9 Jul 2012 14:49:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: boot failure in next-20120705 and 20120706
Message-Id: <20120709144946.ada290480c0edc6a99f9c9c6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jul_2012_14_49_46_+1000_Y61R0fb_HGnoXJAN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jul_2012_14_49_46_+1000_Y61R0fb_HGnoXJAN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Boot testing next-20120705 and 20120706 one of my PowerPC machines get this=
 BUG:

(this one just after the console login prompt appeared.)

kernel BUG at arch/powerpc/kernel/irq.c:188!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=3D32 NUMA pSeries
Modules linked in: binfmt_misc dm_mirror dm_region_hash dm_log ibmveth
NIP: c00000000000f7d4 LR: c00000000000f838 CTR: c0000000007222a0
REGS: c000000000d17a30 TRAP: 0700   Not tainted  (3.5.0-rc5-autokern1)
MSR: 8000000000021032 <SF,ME,IR,DR,RI>  CR: 24000048  XER: 00000000
SOFTE: 0
TASK =3D c000000000c41a10[0] 'swapper/0' THREAD: c000000000d14000 CPU: 0
GPR00: 0000000000000001 c000000000d17cb0 c000000000d12d10 0000000000000500=
=20
GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000000=
=20
GPR08: 001752557ab9dd5b c000000007ffb000 0000000000000000 c000000000bf5200=
=20
GPR12: 0000000000000000 c000000007ffb000 0000000002b00000 00000000009d7000=
=20
GPR16: 0000000000d454f0 00000000027dc6f0 0000000001b5f994 0000000000000060=
=20
GPR20: 0000000000000000 ffffffffffffffff ffffffffffffffff 8000000000009032=
=20
GPR24: c000000000d14000 c000000000d30290 c000000000d30178 c000000000d30290=
=20
GPR28: c0000000008a6180 0000000000000008 c000000000c7e130 0000000000000001=
=20
NIP [c00000000000f7d4] .__check_irq_replay+0xc4/0xf0
LR [c00000000000f838] .arch_local_irq_restore+0x38/0x90
Call Trace:
[c000000000d17cb0] [c000000000d17d30] init_thread_union+0x3d30/0x4000 (unre=
liable)
[c000000000d17d40] [c00000000000f838] .arch_local_irq_restore+0x38/0x90
[c000000000d17db0] [c000000000015c60] .cpu_idle+0x230/0x2b0
[c000000000d17e70] [c00000000000b3f8] .rest_init+0x88/0xa0
[c000000000d17ef0] [c000000000b86c0c] .start_kernel+0x478/0x498
[c000000000d17f90] [c0000000000096f8] .start_here_common+0x20/0x28
Instruction dump:
4e800020 7da96b78 7beaf7e3 880901f3 38600500 5400e87e 5400183e 980901f3=20
4082ffcc 880d01f3 7c0000d0 78000fe0 <0b000000> 38600000 4bffffb4 38610070=20

This is:
	BUG_ON(local_paca->irq_happened !=3D 0);
in __check_irq_replay().

This only happens on my Power5+ machine.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__9_Jul_2012_14_49_46_+1000_Y61R0fb_HGnoXJAN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+mLqAAoJEECxmPOUX5FEXZ0P/1zzVSYQ128dySb3wWQED1mC
HSC7/d/Z3FK+VSuUUWWpgIHX7qN/MMG20P/TUA+P7Q1s6LfQRGwF6IQXvFVKguOf
x0CiMpAYhp98VPVLRyVij0/yA69h4ObEDXBi4URPhS/mK7ZscThsFphH86S+X0Zc
OLm8plD3RfLW+a1yH854Zn1NnvbV80iff77ob+oz4DkJw1D63jIXDdCTohoMLjL7
AO4is3CKkW5Pt5nJitsnCmJ+OT8z+AWBGfkBPc1TYFi0l3b6nENa3GZyZxce4B/q
z4c7Y4fgQN3XFtjGLiUzkfk+c0HrNNYj6FfPuWhQ+C75jfPc/4tWPLRAZIc0FkKK
LDlSJmqVc+YPfYsK3Z4m7ExwTGL+kifpV46CXOxFraCRPKITPO31Ol4rjsBLEIik
8sKSo4u5aCTQHSngixTn3ixbDb0FrjEu6nYULTWAeyauERGXbUAfAFV7zT3KRQ0n
ada8jjAhwNWdL8G2i4F4xEMvH16XZLt/sq7NUpWNpTLmHFEey4zDEecwdBncbYIc
EToZ/zC469K5YxM31tjDi179y02Jw5JvOMapH5tWlmekhqemwpBqnJ1cJYWXhSWg
Ahybw07ApCwQoxekRw2rZtpsoKVsRfu+ze+exCUY24vEyJ4S4FV/K9ATmTy2HE9R
1EN1gHotkszo7ydfMght
=ra6h
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jul_2012_14_49_46_+1000_Y61R0fb_HGnoXJAN--
