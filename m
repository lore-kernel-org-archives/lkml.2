Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0IQMxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 08:53:55 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:18229 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab0IQMxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 08:53:53 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zzzz1202hzz8275bh15d4Rz32i2a8h34h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8W6H8-01-5OJ-02
X-M-MSG: 
Date: Fri, 17 Sep 2010 14:56:25 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "borislav.petkov@" <amd.com.borislav.petkov@amd.com>
Subject: 7ad6e9435596f692ff65f399da12816c94960185 breaks AMD f10h.
Message-ID: <20100917145625.75d2a412@marah.osrc.amd.com>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei Muenchen; Geschaeftsfuehrer: Alberto Bozzo, Andrew Bowd; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/gh_RH+AL9mtlDKAVtkAcIzn";
	protocol="application/pgp-signature"
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gh_RH+AL9mtlDKAVtkAcIzn
Content-Type: multipart/mixed; boundary="MP_/VtI7/Lp4QoPxr9tXWR21cki"

--MP_/VtI7/Lp4QoPxr9tXWR21cki
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Kernel v2.6.36-rc4-134-g03a7ab0 breaks with the OOPS below.

Reverting the commitid in the subject fixes the issue.
This is because APEI is selected by default on X86 (X86 && ACPI),
maybe a vendor check in the hest_init() might make sense.

Kernel config is attached.

Thx,
Conny

[    2.280657] ------------[ cut here ]------------
[    2.284611] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x87/0x9b()
[    2.290001] Hardware name: Toonie
[    2.293298] sysfs: cannot create duplicate filename '/devices/platform/G=
HES.9'
[    2.300001] Modules linked in:
[    2.303053] Pid: 1, comm: swapper Not tainted 2.6.36-rc2-autotest #1
[    2.310001] Call Trace:
[    2.312437]  [<ffffffff810f8a32>] ? sysfs_add_one+0x87/0x9b
[    2.320005]  [<ffffffff81032b86>] warn_slowpath_common+0x80/0x99
[    2.325983]  [<ffffffff81032c35>] warn_slowpath_fmt+0x41/0x43
[    2.330002]  [<ffffffff810f8a32>] sysfs_add_one+0x87/0x9b
[    2.335374]  [<ffffffff810f9364>] create_dir+0x6a/0xa9
[    2.340002]  [<ffffffff810f9437>] sysfs_create_dir+0x94/0xb0
[    2.345636]  [<ffffffff811e3b55>] kobject_add_internal+0x129/0x204
[    2.350002]  [<ffffffff811e3d08>] kobject_add_varg+0x41/0x4d
[    2.360002]  [<ffffffff811e3dcf>] kobject_add+0x64/0x66
[    2.365202]  [<ffffffff811e39bd>] ? kobject_get+0x1a/0x21
[    2.370004]  [<ffffffff812644f9>] device_add+0x13c/0x64c
[    2.375291]  [<ffffffff8126a3cb>] ? pm_runtime_init+0xdd/0xe1
[    2.380002]  [<ffffffff812685de>] platform_device_add+0x14e/0x1aa
[    2.386066]  [<ffffffff8122b7e3>] hest_parse_ghes+0x4a/0x7f
[    2.390002]  [<ffffffff8122b799>] ? hest_parse_ghes+0x0/0x7f
[    2.395632]  [<ffffffff8122b773>] apei_hest_parse+0xc3/0xe9
[    2.400004]  [<ffffffff81bacdd6>] ? hest_init+0x0/0x12f
[    2.405202]  [<ffffffff81baceaf>] hest_init+0xd9/0x12f
[    2.410004]  [<ffffffff81000212>] do_one_initcall+0x7c/0x130
[    2.420004]  [<ffffffff81b8367a>] kernel_init+0x131/0x1ba
[    2.425378]  [<ffffffff81003614>] kernel_thread_helper+0x4/0x10
[    2.430002]  [<ffffffff81b83549>] ? kernel_init+0x0/0x1ba
[    2.435375]  [<ffffffff81003610>] ? kernel_thread_helper+0x0/0x10
[    2.440006] ---[ end trace 4eaa2a86a8e2da22 ]---
[    2.444602] kobject_add_internal failed for GHES.9 with -EEXIST, don't t=
ry to register things with the same name in the same directory.
[    2.450001] Pid: 1, comm: swapper Tainted: G        W   2.6.36-rc2-autot=
est #1
[    2.460001] Call Trace:
[    2.462434]  [<ffffffff811e3bff>] kobject_add_internal+0x1d3/0x204
[    2.470002]  [<ffffffff811e3d08>] kobject_add_varg+0x41/0x4d
[    2.480002]  [<ffffffff811e3dcf>] kobject_add+0x64/0x66
[    2.485202]  [<ffffffff811e39bd>] ? kobject_get+0x1a/0x21
[    2.490002]  [<ffffffff812644f9>] device_add+0x13c/0x64c
[    2.495287]  [<ffffffff8126a3cb>] ? pm_runtime_init+0xdd/0xe1
[    2.500002]  [<ffffffff812685de>] platform_device_add+0x14e/0x1aa
[    2.506064]  [<ffffffff8122b7e3>] hest_parse_ghes+0x4a/0x7f
[    2.510001]  [<ffffffff8122b799>] ? hest_parse_ghes+0x0/0x7f
[    2.520003]  [<ffffffff8122b773>] apei_hest_parse+0xc3/0xe9
[    2.525547]  [<ffffffff81bacdd6>] ? hest_init+0x0/0x12f
[    2.530002]  [<ffffffff81baceaf>] hest_init+0xd9/0x12f
[    2.535114]  [<ffffffff81000212>] do_one_initcall+0x7c/0x130
[    2.540002]  [<ffffffff81b8367a>] kernel_init+0x131/0x1ba
[    2.545375]  [<ffffffff81003614>] kernel_thread_helper+0x4/0x10
[    2.550002]  [<ffffffff81b83549>] ? kernel_init+0x0/0x1ba
[    2.555374]  [<ffffffff81003610>] ? kernel_thread_helper+0x0/0x10
[    2.560006] BUG: unable to handle kernel paging request at ffffeae380055=
3b0
[    2.566959] IP: [<ffffffff810a8dfb>] kfree+0x42/0x22f
[    2.570000] PGD 0
[    2.570000] Oops: 0000 [#1] SMP
[    2.570000] last sysfs file:
[    2.570000] CPU 0
[    2.570000] Modules linked in:
[    2.570000]
[    2.570000] Pid: 1, comm: swapper Tainted: G        W   2.6.36-rc2-autot=
est #1 Toonie/Toonie
[    2.570000] RIP: 0010:[<ffffffff810a8dfb>]  [<ffffffff810a8dfb>] kfree+0=
x42/0x22f
[    2.570000] RSP: 0018:ffff8804364b9d20  EFLAGS: 00010082
[    2.570000] RAX: ffffeae3800553b0 RBX: ffff880435cde400 RCX: ffff8804367=
2e780
[    2.570000] RDX: ffffea0000000000 RSI: 0000000000000037 RDI: ffffc900018=
5a8a4
[    2.570000] RBP: ffff8804364b9d70 R08: ffff8804364b9b40 R09: ffff8804364=
b99f0
[    2.570000] R10: 0000000000000000 R11: ffff880435cde410 R12: ffff880435c=
de458
[    2.570000] R13: ffffffff81b03730 R14: ffff88043676e600 R15: 00000000000=
00000
[    2.570000] FS:  0000000000000000(0000) GS:ffff880001e00000(0000) knlGS:=
0000000000000000
[    2.570000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.570000] CR2: ffffeae3800553b0 CR3: 0000000001acf000 CR4: 00000000000=
006f0
[    2.570000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    2.570000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[    2.570000] Process swapper (pid: 1, threadinfo ffff8804364b8000, task f=
fff8804364b77d0)
[    2.570000] Stack:
[    2.570000]  ffff880437c030c0 ffffc9000185a8a4 0000000000000282 00000000=
ffffffea
[    2.570000] <0> ffff8804364b9da0 ffff880435cde400 ffff880435cde458 fffff=
fff81b03730
[    2.570000] <0> ffff88043676e600 0000000000000000 ffff8804364b9d90 fffff=
fff81268764
[    2.570000] Call Trace:
[    2.570000]  [<ffffffff81268764>] platform_device_release+0x1c/0x34
[    2.570000]  [<ffffffff812632f1>] device_release+0x49/0x7e
[    2.570000]  [<ffffffff811e38c3>] kobject_release+0xf9/0x1d9
[    2.570000]  [<ffffffff811e37ca>] ? kobject_release+0x0/0x1d9
[    2.570000]  [<ffffffff811e4b6a>] kref_put+0x43/0x4f
[    2.570000]  [<ffffffff811e3729>] kobject_put+0x47/0x4c
[    2.570000]  [<ffffffff81263253>] put_device+0x12/0x14
[    2.570000]  [<ffffffff8126878e>] platform_device_put+0x12/0x14
[    2.570000]  [<ffffffff8122b807>] hest_parse_ghes+0x6e/0x7f
[    2.570000]  [<ffffffff8122b799>] ? hest_parse_ghes+0x0/0x7f
[    2.570000]  [<ffffffff8122b773>] apei_hest_parse+0xc3/0xe9
[    2.570000]  [<ffffffff81bacdd6>] ? hest_init+0x0/0x12f
[    2.570000]  [<ffffffff81baceaf>] hest_init+0xd9/0x12f
[    2.570000]  [<ffffffff81000212>] do_one_initcall+0x7c/0x130
[    2.570000]  [<ffffffff81b8367a>] kernel_init+0x131/0x1ba
[    2.570000]  [<ffffffff81003614>] kernel_thread_helper+0x4/0x10
[    2.570000]  [<ffffffff81b83549>] ? kernel_init+0x0/0x1ba
[    2.570000]  [<ffffffff81003610>] ? kernel_thread_helper+0x0/0x10
[    2.570000] Code: 7d b8 0f 86 01 02 00 00 9c 8f 45 c0 fa 48 8b 7d b8 e8 =
36 d1 f7 ff 48 c1 e8 0c 48 ba 00 00 00 00 00 ea ff ff 48 6b c0 38 48 01 d0 =
<66> 83 38 00 79 04 48 8b 40 10 66 83 38 00 79 04 48 8b 40 10 80
[    2.570000] RIP  [<ffffffff810a8dfb>] kfree+0x42/0x22f
[    2.570000]  RSP <ffff8804364b9d20>
[    2.570000] CR2: ffffeae3800553b0
[    2.570000] ---[ end trace 4eaa2a86a8e2da23 ]---
[    2.570006] Kernel panic - not syncing: Attempted to kill init!
[    2.580002] Pid: 1, comm: swapper Tainted: G      D W   2.6.36-rc2-autot=
est #1
[    2.587187] Call Trace:
[    2.589622]  [<ffffffff8168455d>] panic+0x8c/0x196
[    2.590003]  [<ffffffff81035c8f>] do_exit+0x70/0x6c1
[    2.594943]  [<ffffffff8103398f>] ? kmsg_dump+0x116/0x130
[    2.600003]  [<ffffffff81687a89>] oops_end+0xb2/0xba
[    2.604944]  [<ffffffff810228d9>] no_context+0x1f3/0x202
[    2.610002]  [<ffffffff81022aa2>] __bad_area_nosemaphore+0x1ba/0x1e0
[    2.620002]  [<ffffffff81003610>] ? kernel_thread_helper+0x0/0x10
[    2.626067]  [<ffffffff816846a3>] ? printk+0x3c/0x3e
[    2.630004]  [<ffffffff8104c0b4>] ? up+0x34/0x39
[    2.634599]  [<ffffffff81003610>] ? kernel_thread_helper+0x0/0x10
[    2.640003]  [<ffffffff8105843b>] ? __module_text_address+0xd/0x5b
[    2.646155]  [<ffffffff81022ad6>] bad_area_nosemaphore+0xe/0x10
[    2.650003]  [<ffffffff816899dd>] do_page_fault+0x1d7/0x3b9
[    2.660002]  [<ffffffff810052aa>] ? dump_trace+0x316/0x328
[    2.665462]  [<ffffffff81686f5f>] page_fault+0x1f/0x30
[    2.670002]  [<ffffffff810a8dfb>] ? kfree+0x42/0x22f
[    2.674943]  [<ffffffff81268764>] platform_device_release+0x1c/0x34
[    2.680002]  [<ffffffff812632f1>] device_release+0x49/0x7e
[    2.685462]  [<ffffffff811e38c3>] kobject_release+0xf9/0x1d9
[    2.690001]  [<ffffffff811e37ca>] ? kobject_release+0x0/0x1d9
[    2.695720]  [<ffffffff811e4b6a>] kref_put+0x43/0x4f
[    2.700002]  [<ffffffff811e3729>] kobject_put+0x47/0x4c
[    2.705202]  [<ffffffff81263253>] put_device+0x12/0x14
[    2.710002]  [<ffffffff8126878e>] platform_device_put+0x12/0x14
[    2.720002]  [<ffffffff8122b807>] hest_parse_ghes+0x6e/0x7f
[    2.725548]  [<ffffffff8122b799>] ? hest_parse_ghes+0x0/0x7f
[    2.730002]  [<ffffffff8122b773>] apei_hest_parse+0xc3/0xe9
[    2.735546]  [<ffffffff81bacdd6>] ? hest_init+0x0/0x12f
[    2.740002]  [<ffffffff81baceaf>] hest_init+0xd9/0x12f
[    2.745114]  [<ffffffff81000212>] do_one_initcall+0x7c/0x130
[    2.750002]  [<ffffffff81b8367a>] kernel_init+0x131/0x1ba
[    2.755374]  [<ffffffff81003614>] kernel_thread_helper+0x4/0x10
[    2.760003]  [<ffffffff81b83549>] ? kernel_init+0x0/0x1ba
[    2.770002]  [<ffffffff81003610>] ? kernel_thread_helper+0x0/0x10


##
##################################################################
# Email : conny.seidel@amd.com            GnuPG-Key : 0xA6AB055D #
# Fingerprint: 17C4 5DB2 7C4C C1C7 1452 8148 F139 7C09 A6AB 055D #
##################################################################
# Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach      #
# General Managers: Alberto Bozzo, Andrew Bowd                   #
# Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen #
#               HRB Nr. 43632                                    #
##################################################################

--MP_/VtI7/Lp4QoPxr9tXWR21cki
Content-Type: application/x-gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=config.gz

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
AA==

--MP_/VtI7/Lp4QoPxr9tXWR21cki--

--Sig_/gh_RH+AL9mtlDKAVtkAcIzn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyTZXkACgkQ8Tl8CaarBV3P1QCcCn3022ZokQ28cglwLYrsdIB1
C2AAoIteoiHUjm8a3KGeQHJRujjwOPqp
=7NF4
-----END PGP SIGNATURE-----

--Sig_/gh_RH+AL9mtlDKAVtkAcIzn--
