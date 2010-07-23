Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0GWAWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 20:22:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44545 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab0GWAWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 20:22:09 -0400
Date: Fri, 23 Jul 2010 10:22:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: OOPS at bot time
Message-Id: <20100723102202.871a3131.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Jul_2010_10_22_02_+1000_Ng6==zwgoL4i4RRU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Jul_2010_10_22_02_+1000_Ng6==zwgoL4i4RRU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

My Power7 boot test paniced like this: (next-20100722)

%GQLogic Fibre Channel HBA Driver: 8.03.03-k0
qla2xxx 0002:01:00.2: enabling device (0144 -> 0146)
qla2xxx 0002:01:00.2: Found an ISP8001, irq 35, iobase 0xd000080080014000
------------[ cut here ]------------
kernel BUG at drivers/pci/msi.c:205!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=3D128 NUMA pSeries
last sysfs file: /sys/devices/virtual/tty/ptyz8/uevent
Modules linked in: qla2xxx(+)
NIP: c0000000002fcd54 LR: c000000000048d9c CTR: 0000000000000001
REGS: c00000000278aff0 TRAP: 0700   Not tainted  (2.6.35-rc5-autokern1-next=
-20100721)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 28422488  XER: 20000008
TASK =3D c000000002008000[2226] 'modprobe' THREAD: c000000002788000 CPU: 12
GPR00: 0000000000000001 c00000000278b270 c0000000009a36d0 c0000000009b8900=
=20
GPR04: c00000000278b2e8 ffffffffffffffff 0000000000000000 0000000000020000=
=20
GPR08: 00000000000033e7 c00000000a38b280 0000000000000000 0000000000000000=
=20
GPR12: 0000000088422488 c00000000f331800 00000fff921750a0 0000000000000000=
=20
GPR16: 0000000010033110 00000000100334b8 0000000000000000 0000000000000000=
=20
GPR20: d000080080018000 0000000000022225 c0000000009f7bb4 0000000000010200=
=20
GPR24: 000000002000020d 0000000000000025 c00000000278b2e0 c00000000278b2e8=
=20
GPR28: 0000000000000001 c00000000d0ac5f8 c000000000af8f00 c00000000a38b280=
=20
NIP [c0000000002fcd54] .read_msi_msg_desc+0x24/0x3c
LR [c000000000048d9c] .rtas_setup_msi_irqs+0x1d8/0x254
Call Trace:
[c00000000278b270] [c000000000048d9c] .rtas_setup_msi_irqs+0x1d8/0x254 (unr=
eliable)
[c00000000278b360] [c00000000002a9cc] .arch_setup_msi_irqs+0x34/0x4c
[c00000000278b3e0] [c0000000002fd3fc] .pci_enable_msix+0x49c/0x4ac
[c00000000278b4c0] [d0000000001a5e30] .qla2x00_request_irqs+0x158/0x5b4 [ql=
a2xxx]
[c00000000278b580] [d0000000001cb41c] .qla2x00_probe_one+0xeac/0x63b0 [qla2=
xxx]
[c00000000278b6f0] [c0000000002f5c4c] .local_pci_probe+0x34/0x48
[c00000000278b760] [c0000000002f6078] .pci_device_probe+0xe8/0x130
[c00000000278b810] [c00000000036e648] .driver_probe_device+0xdc/0x1a4
[c00000000278b8a0] [c00000000036e7a4] .__driver_attach+0x94/0xd8
[c00000000278b930] [c00000000036dabc] .bus_for_each_dev+0x7c/0xe0
[c00000000278b9e0] [c00000000036e410] .driver_attach+0x28/0x40
[c00000000278ba60] [c00000000036d134] .bus_add_driver+0x144/0x310
[c00000000278bb10] [c00000000036ec28] .driver_register+0xd8/0x198
[c00000000278bbb0] [c0000000002f63d0] .__pci_register_driver+0x60/0x10c
[c00000000278bc50] [d0000000001ca520] .qla2x00_module_init+0x150/0x1a0 [qla=
2xxx]
[c00000000278bce0] [c00000000000947c] .do_one_initcall+0x80/0x1a8
[c00000000278bd90] [c0000000000a4364] .SyS_init_module+0xd8/0x244
[c00000000278be30] [c00000000000852c] syscall_exit+0x0/0x40
Instruction dump:
ebe1fff8 7c0803a6 4e800020 e9230028 81490030 80090034 81690038 7d400378=20
7c005b78 7c000034 5400d97e 78000020 <0b000000> 81690038 e8090030 91640008=20
---[ end trace f67a78811ed47c60 ]---
%Gudevd-work[1379]: '/sbin/modprobe -b pci:v00001077d00008001sv00001077sd00=
00017Fbc0Csc04i00' unexpected exit with status 0x0005

That line number is this:

	BUG_ON(!(entry->msg.address_hi | entry->msg.address_lo |
		 entry->msg.data));

in read_msi_msg_desc().  That BUG_ON was added by commit
2ca1af9aa3285c6a5f103ed31ad09f7399fc65d7 ("PCI: MSI: Remove unsafe and
unnecessary hardware access") from the pci tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_Jul_2010_10_22_02_+1000_Ng6==zwgoL4i4RRU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMSOCqAAoJEDMEi1NhKgbskVkH/2d5cz/G+OoYpHB2zL2wdma5
1lZeCKVukrHBt5Sf03bSNBa374GI6GtwW2kArMUfHO1msPHrH0mPuo8I368+Ra6J
XZ8YvpVWQf/PNyknvLeimPiQRARBM24mMY0/Gip7ak6PdQ7gRd1FNXSnkmPfs2gv
63g5RRswmn09MRl/0e/NTjI2WZuwso3xLeGXlurORGKdl1FS5fCzX9vS6fk9JFL9
Rb51YKenB8aZ8bWrsDWtZNROPycwzrbbe5adifxCmqn1kNnWdJPe/jwte+huuWb7
wjs/npsAnUd4N8oLZZS3E+DV7RG5FOH17zXL9Iyf/JXW53wFDQZxi7XT2dPXGCQ=
=GbAz
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Jul_2010_10_22_02_+1000_Ng6==zwgoL4i4RRU--
