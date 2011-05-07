Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1EGKjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 06:39:23 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:54975 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab1EGKjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 06:39:20 -0400
Date: Sat, 7 May 2011 12:39:07 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Cc: nikola.ciprich@linuxbox.cz, stable@kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: 2.6.32.28 - md resync + pvmove - crash
Message-ID: <20110507103907.GA2712@nik-comp.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5092150 records (last update: 20110507)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
first, I'm sorry for crossposting and also CCing stable@, if that's not OK,=
 please let me knows.
Anyways, we've experienced hang of system running 2.6.32.28.
After upgrading to 2.6.32 and replacing failed disk, md resync has started.=
 Then when the technician started pvmove, dome deadlock must have occured, =
because all disk requests started to hang and the whole system had to be re=
booted...

here's the backtrace:

[ 1229.645028] alg: No test for stdrng (krng)
[ 1229.668172] alg: No test for authenc(hmac(sha1),cbc(des3_ede)) (authenc(=
hmac(sha1-generic),cbc(des3_ede-generic)))
[ 1531.585167] md: bind<sda2>
[ 1531.927846] raid1: raid set md2 active with 1 out of 2 mirrors
[ 1531.934613] md2: detected capacity change from 0 to 2000133029888
[ 1549.850444] md1: bitmap file is out of date (0 < 439231) -- forcing full=
 recovery
[ 1549.858719] md1: bitmap file is out of date, doing full recovery
[ 1550.068105] md1: bitmap initialized from disk: read 11/11 pages, set 357=
576 bits
[ 1550.076054] created bitmap (175 pages) for device md1
[ 1561.449841]  md2: unknown partition table
[ 1561.501645] md2: bitmap file is out of date (0 < 4) -- forcing full reco=
very
[ 1561.509999] md2: bitmap file is out of date, doing full recovery
[ 1562.158515] md2: bitmap initialized from disk: read 15/15 pages, set 476=
869 bits
[ 1562.167764] created bitmap (233 pages) for device md2
[ 2400.956019] INFO: task kjournald:1038 blocked for more than 120 seconds.
[ 2400.963280] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 2400.971356] kjournald     D ffff8800016ac400     0  1038      2 0x000000=
00
[ 2400.978621]  ffff88003cc33c60 0000000000000046 ffff88003cc33bd0 ffffffff=
8119ba6f
[ 2400.986513]  0000000000013780 ffff88003f9746b0 ffff88003f9745f0 ffff8800=
3ea2c5f0
[ 2400.994426]  ffff88003f9749a0 ffff88003cc33fd8 ffff88003d65b000 ffff8800=
35600a00
[ 2401.002415] Call Trace:
[ 2401.005024]  [<ffffffff8119ba6f>] ? blk_unplug+0x2f/0xa0
[ 2401.010530]  [<ffffffff81076bb4>] ? ktime_get_ts+0xa4/0xd0
[ 2401.016182]  [<ffffffff8133773e>] io_schedule+0x6e/0xc0
[ 2401.021643]  [<ffffffff81136afe>] sync_buffer+0x3e/0x50
[ 2401.027029]  [<ffffffff81337c75>] __wait_on_bit+0x55/0x80
[ 2401.032638]  [<ffffffff81136ac0>] ? sync_buffer+0x0/0x50
[ 2401.038177]  [<ffffffff81136ac0>] ? sync_buffer+0x0/0x50
[ 2401.043659]  [<ffffffff81337d18>] out_of_line_wait_on_bit+0x78/0x90
[ 2401.050129]  [<ffffffff8106e070>] ? wake_bit_function+0x0/0x30
[ 2401.056143]  [<ffffffff81136a36>] __wait_on_buffer+0x26/0x30
[ 2401.062077]  [<ffffffffa002a097>] journal_commit_transaction+0x657/0x13c=
0 [jbd]
[ 2401.069693]  [<ffffffff8105e104>] ? try_to_del_timer_sync+0x44/0x110
[ 2401.076212]  [<ffffffff81339ddd>] ? _spin_unlock_irqrestore+0x1d/0x50
[ 2401.082831]  [<ffffffffa002e893>] kjournald+0xe3/0x260 [jbd]
[ 2401.088708]  [<ffffffff8106e030>] ? autoremove_wake_function+0x0/0x40
[ 2401.095369]  [<ffffffffa002e7b0>] ? kjournald+0x0/0x260 [jbd]
[ 2401.101337]  [<ffffffff8106deee>] kthread+0x8e/0xa0
[ 2401.106354]  [<ffffffff8100c30a>] child_rip+0xa/0x20
[ 2401.111477]  [<ffffffff8106de60>] ? kthread+0x0/0xa0
[ 2401.116598]  [<ffffffff8100c300>] ? child_rip+0x0/0x20
[ 2401.121893] INFO: task flush-253:2:3168 blocked for more than 120 second=
s.
[ 2401.128983] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 2401.137114] flush-253:2   D 0000000000000002     0  3168      2 0x000000=
00
[ 2401.144318]  ffff88002c245a40 0000000000000046 ffff880035601600 ffff8800=
2f621840
[ 2401.152248]  0000000000013780 ffff88003ceb9810 ffff88003ceb9750 ffff8800=
3ea2c5f0
[ 2401.160169]  ffff88003ceb9b00 ffff88002c245fd8 ffff88002c245a00 ffff8800=
35601600
[ 2401.168048] Call Trace:
[ 2401.170608]  [<ffffffff81076bb4>] ? ktime_get_ts+0xa4/0xd0
[ 2401.176303]  [<ffffffff8133773e>] io_schedule+0x6e/0xc0
[ 2401.181723]  [<ffffffff810ccb56>] sync_page+0x36/0x50
[ 2401.186970]  [<ffffffff81337b3e>] __wait_on_bit_lock+0x4e/0xa0
[ 2401.192991]  [<ffffffff810ccb20>] ? sync_page+0x0/0x50
[ 2401.198287]  [<ffffffff810ccb05>] __lock_page+0x65/0x70
[ 2401.203687]  [<ffffffff8106e070>] ? wake_bit_function+0x0/0x30
[ 2401.209687]  [<ffffffff810d4366>] write_cache_pages+0x3d6/0x490
[ 2401.215802]  [<ffffffff810d3da0>] ? __writepage+0x0/0x40
[ 2401.221291]  [<ffffffff810d4442>] generic_writepages+0x22/0x30
[ 2401.227327]  [<ffffffff810d4476>] do_writepages+0x26/0x30
[ 2401.232965]  [<ffffffff8112fa24>] writeback_single_inode+0xa4/0x290
[ 2401.239412]  [<ffffffff811304e2>] writeback_inodes_wb+0x2d2/0x420
[ 2401.245715]  [<ffffffff81130756>] wb_writeback+0x126/0x1e0
[ 2401.251360]  [<ffffffff81130a84>] wb_do_writeback+0x1a4/0x1c0
[ 2401.257287]  [<ffffffff81130ad5>] bdi_writeback_task+0x35/0xd0
[ 2401.263317]  [<ffffffff810e5cf0>] ? bdi_start_fn+0x0/0xf0
[ 2401.268886]  [<ffffffff810e5d71>] bdi_start_fn+0x81/0xf0
[ 2401.274370]  [<ffffffff810e5cf0>] ? bdi_start_fn+0x0/0xf0
[ 2401.279947]  [<ffffffff8106deee>] kthread+0x8e/0xa0
[ 2401.285000]  [<ffffffff8100c30a>] child_rip+0xa/0x20
[ 2401.290120]  [<ffffffff8106de60>] ? kthread+0x0/0xa0
[ 2401.295247]  [<ffffffff8100c300>] ? child_rip+0x0/0x20
[ 2401.300586] INFO: task reiserfs/0:3204 blocked for more than 120 seconds.
[ 2401.307590] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 2401.315682] reiserfs/0    D ffff880016fdad48     0  3204      2 0x000000=
00
[ 2401.322884]  ffff88002f1b1d10 0000000000000046 ffff88000180dda0 ffff8800=
0180dec0
[ 2401.330754]  0000000000013780 ffff88003ea180c0 ffff88003ea18000 ffff8800=
2f43aea0
[ 2401.338683]  ffff88003ea183b0 ffff88002f1b1fd8 ffff88002f1b1cd0 ffffffff=
81048960
[ 2401.346684] Call Trace:
[ 2401.349252]  [<ffffffff81048960>] ? update_curr+0xb0/0x170
[ 2401.354983]  [<ffffffff813384f7>] __mutex_lock_slowpath+0x107/0x310
[ 2401.361480]  [<ffffffff81338727>] mutex_lock+0x27/0x50
[ 2401.366791]  [<ffffffffa0358b27>] flush_commit_list+0x137/0x6d0

I can't 100% separate out some hardware problem, but this system has been r=
unning 2.6.27.x rock solid for years till then..
Can somebody see something interesting in those backtraces?
If I can provide further information, I'll be glad to assist...
BR
nik


--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--huq684BweRXVnRxX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3FIUsACgkQ3xdJJrLygV6+twCfWE+92qK/CCSR+mmDCvSrHvfL
3hcAoL93OACppARVrlXuDIIuGdsvnUGV
=EfAI
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
