Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1FUPmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:42:11 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:4494 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1FUPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:42:08 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zzzz1202hzz15d4R8275bh8275dhz32i668h839h34h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LN5CV4-01-8OI-02
X-M-MSG: 
Date: Tue, 21 Jun 2011 17:41:31 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei Muenchen; Geschaeftsfuehrer: Alberto Bozzo; Sitz: Dornach, Gemeinde
 Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/6rx4aeHefSe8roliy0JUua6";
	protocol="application/pgp-signature"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6rx4aeHefSe8roliy0JUua6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

the commit 797390d8554b1e07aabea37d0140933b0412dba0 breaks 32bit on AMD
with native NUMA and fakeNUMA.

Native NUMA still boots, when the kernel parameter numa=3Doff is added to
the cmdline.

[    0.000000] BUG: unable to handle kernel paging request at 000012b0
[    0.000000] IP: [<c1aa13ce>] memmap_init_zone+0x6c/0xf2
[    0.000000] *pdpt =3D 0000000000000000 *pde =3D f000eef3f000ee00
[    0.000000] Oops: 0000 [#1] SMP
[    0.000000] last sysfs file:
[    0.000000] Modules linked in:
[    0.000000]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.39-rc5-00164-g797390d =
#1 To Be Filled By O.E.M. To Be Filled By O.E.M./E350M1
[    0.000000] EIP: 0060:[<c1aa13ce>] EFLAGS: 00010012 CPU: 0
[    0.000000] EIP is at memmap_init_zone+0x6c/0xf2
[    0.000000] EAX: 00000000 EBX: 000a8000 ECX: 000a7fff EDX: f2c00b80
[    0.000000] ESI: 000a8000 EDI: f2c00800 EBP: c19ffe54 ESP: c19ffe34
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000000] Process swapper (pid: 0, ti=3Dc19fe000 task=3Dc1a07f60 task.=
ti=3Dc19fe000)
[    0.000000] Stack:
[    0.000000]  00000002 00000000 0023f000 00000000 10000000 00000a00 f2c00=
000 f2c00b58
[    0.000000]  c19ffeb0 c1a80f24 000375fe 00000000 f2c00800 00000800 00000=
100 00000030
[    0.000000]  c1abb768 0000003c 00000000 00000000 00000004 00207a02 f2c00=
800 000375fe
[    0.000000] Call Trace:
[    0.000000]  [<c1a80f24>] free_area_init_node+0x358/0x385
[    0.000000]  [<c1a81384>] free_area_init_nodes+0x420/0x487
[    0.000000]  [<c1637323>] ? printk+0x14/0x16
[    0.000000]  [<c102489e>] ? memory_present+0x66/0x6f
[    0.000000]  [<c1a79326>] paging_init+0x114/0x11b
[    0.000000]  [<c101742f>] ? native_apic_mem_read+0x8/0x19
[    0.000000]  [<c1a6cb13>] setup_arch+0xb37/0xc0a
[    0.000000]  [<c1638f6d>] ? _raw_spin_unlock_irqrestore+0x19/0x25
[    0.000000]  [<c1638f6d>] ? _raw_spin_unlock_irqrestore+0x19/0x25
[    0.000000]  [<c1637323>] ? printk+0x14/0x16
[    0.000000]  [<c1a69554>] start_kernel+0x76/0x316
[    0.000000]  [<c1a690a8>] i386_start_kernel+0xa8/0xb0
[    0.000000] Code: 0a c1 e0 1d 89 45 ec 8b 45 e4 03 3c 85 e8 5b a6 c1 e9 =
8a 00 00 00 89 f0 89 f3 c1 e8 0e 0f be 80 a8 57 a6 c1 8b 04 85 e8 5b a6 c1 =
<2b> 98 b0 12 00 00 c1 e3 05 03 98 ac 12 00 00 8b 03 25 ff ff ff
[    0.000000] EIP: [<c1aa13ce>] memmap_init_zone+0x6c/0xf2 SS:ESP 0068:c19=
ffe34
[    0.000000] CR2: 00000000000012b0
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] Pid: 0, comm: swapper Tainted: G      D     2.6.39-rc5-00164=
-g797390d #1
[    0.000000] Call Trace:
[    0.000000]  [<c1637213>] panic+0x55/0x151
[    0.000000]  [<c10507c9>] ? blocking_notifier_call_chain+0x11/0x13
[    0.000000]  [<c1038340>] do_exit+0x99/0x6fa
[    0.000000]  [<c1638f6d>] ? _raw_spin_unlock_irqrestore+0x19/0x25
[    0.000000]  [<c10356de>] ? kmsg_dump+0x3c/0xbe
[    0.000000]  [<c163a569>] oops_end+0x97/0x9f
[    0.000000]  [<c101e9a4>] no_context+0x144/0x14e
[    0.000000]  [<c101eada>] __bad_area_nosemaphore+0x12c/0x134
[    0.000000]  [<c1a83a75>] ? memblock_add_region+0xbf/0x4af
[    0.000000]  [<c101eaf4>] bad_area_nosemaphore+0x12/0x15
[    0.000000]  [<c163beb0>] do_page_fault+0x1e8/0x3c8
[    0.000000]  [<c1a82c5e>] ? __alloc_memory_core_early+0x86/0x94
[    0.000000]  [<c163bcc8>] ? spurious_fault+0xf2/0xf2
[    0.000000]  [<c1639c6b>] error_code+0x5f/0x64
[    0.000000]  [<c163bcc8>] ? spurious_fault+0xf2/0xf2
[    0.000000]  [<c1aa13ce>] ? memmap_init_zone+0x6c/0xf2
[    0.000000]  [<c1a80f24>] free_area_init_node+0x358/0x385
[    0.000000]  [<c1a81384>] free_area_init_nodes+0x420/0x487
[    0.000000]  [<c1637323>] ? printk+0x14/0x16
[    0.000000]  [<c102489e>] ? memory_present+0x66/0x6f
[    0.000000]  [<c1a79326>] paging_init+0x114/0x11b
[    0.000000]  [<c101742f>] ? native_apic_mem_read+0x8/0x19
[    0.000000]  [<c1a6cb13>] setup_arch+0xb37/0xc0a
[    0.000000]  [<c1638f6d>] ? _raw_spin_unlock_irqrestore+0x19/0x25
[    0.000000]  [<c1638f6d>] ? _raw_spin_unlock_irqrestore+0x19/0x25
[    0.000000]  [<c1637323>] ? printk+0x14/0x16
[    0.000000]  [<c1a69554>] start_kernel+0x76/0x316
[    0.000000]  [<c1a690a8>] i386_start_kernel+0xa8/0xb0



commit 797390d8554b1e07aabea37d0140933b0412dba0
Author: Tejun Heo <tj@kernel.org>
Date:   Mon May 2 14:18:52 2011 +0200

    x86-32, NUMA: use sparse_memory_present_with_active_regions()

    Instead of calling memory_present() for each region from NUMA init,
    call sparse_memory_present_with_active_regions() from paging_init()
    similarly to x86-64.

    For flat and numaq, this results in exactly the same memory_present()
    calls.  For srat, if there are multiple memory chunks for a node,
    after this change, memory_present() will be called separately for each
    chunk instead of being called once to encompass the whole range, which
    doesn't cause any harm and actually is the better behavior.

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Yinghai Lu <yinghai@kernel.org>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: "H. Peter Anvin" <hpa@zytor.com>


##
##################################################################
# Email : conny.seidel@amd.com            GnuPG-Key : 0xA6AB055D #
# Fingerprint: 17C4 5DB2 7C4C C1C7 1452 8148 F139 7C09 A6AB 055D #
##################################################################
# Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach      #
# General Managers: Alberto Bozzoi                               #
# Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen #
#               HRB Nr. 43632                                    #
##################################################################

--Sig_/6rx4aeHefSe8roliy0JUua6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4Au6sACgkQ8Tl8CaarBV2r7wCgyZRC2Yn9ggJDAVLdTi2mRyoM
0LgAmwcSMhkyHhVFshoT4FTnZGH1fxQ/
=YxKo
-----END PGP SIGNATURE-----

--Sig_/6rx4aeHefSe8roliy0JUua6--
