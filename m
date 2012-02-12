Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2BLAiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 19:38:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35033 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2BLAiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 19:38:16 -0500
Date: Sun, 12 Feb 2012 11:38:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        gregkh@linuxfoundation.org
Subject: Boot failure with next-20120208
Message-Id: <20120212113805.c7e5d902c95a9d0f4037e12c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__12_Feb_2012_11_38_05_+1100_/LtzM4s0SpyBDpik"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__12_Feb_2012_11_38_05_+1100_/LtzM4s0SpyBDpik
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Just a quick note to say I got a boot OOPs with next-20120208 and 9 on a
Power7 blade (my other PowerPC boot tests are ok.  I'll investigate this
further on Monday.

The line referenced below is:

BUG_ON(!kobj || !kobj->sd || !attr);

in sysfs_create_file().

calling  .topology_init+0x0/0x1ac @ 1
initcall 7_.async_cpu_up+0x0/0x40 returned 0 after 9765 usecs
async_continuing @ 20 after 9765 usec
------------[ cut here ]------------
kernel BUG at fs/sysfs/file.c:573!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=3D32 NUMA pSeries
Modules linked in:
NIP: c00000000024a35c LR: c0000000004ee050 CTR: c00000000083ca24
REGS: c0000003fd9e7560 TRAP: 0700   Not tainted  (3.3.0-rc2-autokern1)
MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>  CR: 88002082  XER: 0000000f
CFAR: c00000000024a370
TASK =3D c0000003fd9e8000[20] 'kworker/u:6' THREAD: c0000003fd9e4000 CPU: 0
GPR00: 0000000000000001 c0000003fd9e77e0 c000000000d19bb8 0000000000000000=
=20
GPR04: c000000000bf37a8 0000000000000008 8000000002096400 0000000000000000=
=20
GPR08: 0000000000000000 c000000000f80028 c000000000d52bd8 0000000000000000=
=20
GPR12: 0000000048002088 c00000000f33b000 0000000001affa78 00000000009aa000=
=20
GPR16: 0000000000e1f3c8 0000000002d517f0 0000000001aff984 0000000000000060=
=20
GPR20: 0000000000000000 ffffffffffffffff 0000000000000000 c000000000c45128=
=20
GPR24: 0000000000000000 0000000000000008 0000000000000000 c000000000c44200=
=20
GPR28: c000000000f80028 0000000000000008 c000000000c85038 0000000000000002=
=20
NIP [c00000000024a35c] .sysfs_create_file+0x1c/0x40
LR [c0000000004ee050] .device_create_file+0x20/0x40
Call Trace:
[c0000003fd9e77e0] [c0000003fd9e78a0] 0xc0000003fd9e78a0 (unreliable)
[c0000003fd9e7850] [c00000000083c9a4] .register_cpu_online+0x1d0/0x250
[c0000003fd9e7900] [c00000000083ca8c] .sysfs_cpu_notify+0x68/0x28c
[c0000003fd9e79b0] [c00000000083769c] .notifier_call_chain+0x9c/0x100
[c0000003fd9e7a50] [c0000000000a5878] .__cpu_notify+0x38/0x80
[c0000003fd9e7ad0] [c00000000083e124] ._cpu_up+0x10c/0x178
[c0000003fd9e7b90] [c00000000083e2c8] .cpu_up+0x138/0x164
[c0000003fd9e7c20] [c000000000ba46d0] .async_cpu_up+0x28/0x40
[c0000003fd9e7ca0] [c0000000000d81ec] .async_run_entry_fn+0xbc/0x1f0
[c0000003fd9e7d50] [c0000000000c7cbc] .process_one_work+0x19c/0x590
[c0000003fd9e7e10] [c0000000000c8618] .worker_thread+0x188/0x4b0
[c0000003fd9e7ed0] [c0000000000ce57c] .kthread+0xbc/0xd0
[c0000003fd9e7f90] [c000000000021448] .kernel_thread+0x54/0x70
Instruction dump:
7fa3eb78 ebe1fff8 eba1ffe8 7c0803a6 4e800020 2c230000 41820024 e8630030=20
7c800074 7800d182 2fa30000 419e0014 <0b000000> 38a00002 4bfffebc e8630030=20
---[ end trace 31fd0ba7d8756001 ]---
initcall .topology_init+0x0/0x1ac returned 0 after 0 usecs
calling  .pcibios_init+0x0/0xe8 @ 1
PCI: Probing PCI hardware
PCI: Probing PCI hardware done
initcall .pcibios_init+0x0/0xe8 returned 0 after 0 usecs
calling  .add_system_ram_resources+0x0/0x140 @ 1
initcall .add_system_ram_resources+0x0/0x140 returned 0 after 0 usecs
calling  .__machine_initcall_powermac_pmac_i2c_create_platform_devices+0x0/=
0xc8 @ 1
initcall .__machine_initcall_powermac_pmac_i2c_create_platform_devices+0x0/=
0xc8 returned 0 after 0 usecs
calling  .opal_init+0x0/0x1cc @ 1
opal: Node not found
initcall .opal_init+0x0/0x1cc returned -19 after 0 usecs
calling  .__machine_initcall_pseries_ioei_init+0x0/0xa0 @ 1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__12_Feb_2012_11_38_05_+1100_/LtzM4s0SpyBDpik
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPNwntAAoJEECxmPOUX5FECT0P/20NbOeGObcLpIvqd0pZ4m5G
fhFmS1wJxAUSv75uDl/cGY7+QDxt9g4B9vFqvYGyByMCfzassoO5py/62SsiBSVJ
z8veRxRRS78Qw30/GfuOrYl2QbVhqH4M4YzSdUuFsxunPC5binyNcOVY8eL/nV72
KbuISrvOGgokAZhN4lcZ96e/82WF1cGZKvqWLrZCpUv6YFpkhm+oQPyU4uFVtMyL
VR4k2W7bDMn3eJQB/hwtvB4pbE+TTkBCI7leAVmL0ZtNevGPkbSEZp72x6IcZMc6
4NV6s49HJmnhprisUpfru2Ao53Cx5XANT647FfhZUo5vbWKaoCtz8Ecipgpq1DzI
vnyxbFohJgIY+VtxRCMgcQqT0fGgHwuO8HdoleaqbIptfwa8NztbSKL/OTcfDeR6
rgXX7IjpmfY0Qj1TFZwI++UtCz83p9RxF0vBpWU4UMnyHBK7dnIFzT6Zgyr0fmYh
h0OISq6PIb/w8GkuokXlO31yKfCq3J8eG0JAwMgyaf9IDoWHe4kWHEVHM9loSaP6
+hJ8j/nWH1pGWxD+4+lwyo20vTp6Z/7uXZRhIBUqmYbYqamtRJpw43CScyggP1GR
jORs8QTn0Sf2G3n/tinSaAjFocMVmFBwy/4obv0kKAkQ5ND2JbtL/IkqWeOxPdAU
ey5dX4LNNzvnvgoP/9kE
=WvEz
-----END PGP SIGNATURE-----

--Signature=_Sun__12_Feb_2012_11_38_05_+1100_/LtzM4s0SpyBDpik--
