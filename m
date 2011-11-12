Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab1KLHpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 02:45:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56578 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1KLHpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 02:45:19 -0500
Date: Sat, 12 Nov 2011 10:48:59 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Subject: khugepaged blocks suspend2ram (3.2.0-rc1-00252-g8f042aa)
Message-ID: <20111112104859.7744b282@sf.home>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J=43ocn+nKvPRU9psMLPaZV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/J=43ocn+nKvPRU9psMLPaZV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

$ cat /sys/kernel/mm/transparent_hugepage/enabled
[always] madvise never

$ echo mem > /sys/power/state

[ 4036.239222] PM: Syncing filesystems ... done.
[ 4040.198755] PM: Preparing system for mem sleep
[ 4040.625898] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[ 4040.637103] Freezing remaining freezable tasks ...=20
[ 4060.646142] Freezing of tasks failed after 20.00 seconds (1 tasks refusi=
ng to freeze, wq_busy=3D0):
[ 4060.646180] khugepaged      S 0000000000000000     0   514      2 0x0080=
0000
[ 4060.646194]  ffff88007b231c70 0000000000000046 ffff88007b231c00 ffffffff=
00000000
[ 4060.646209]  ffff88007bb40000 0000000000010ac0 ffff88007b231fd8 ffff8800=
7b230000
[ 4060.646222]  0000000000010ac0 0000000000004000 ffff88007b231fd8 00000000=
00010ac0
[ 4060.646235] Call Trace:
[ 4060.646254]  [<ffffffff810af8b1>] ? try_to_free_pages+0x71/0x80
[ 4060.646265]  [<ffffffff8103eaf1>] ? get_parent_ip+0x11/0x50
[ 4060.646275]  [<ffffffff8103ec9d>] ? add_preempt_count+0x9d/0xd0
[ 4060.646286]  [<ffffffff81432f3a>] schedule+0x3a/0x50
[ 4060.646294]  [<ffffffff81433408>] schedule_timeout+0x158/0x230
[ 4060.646304]  [<ffffffff81052db0>] ? init_timer_deferrable_key+0x20/0x20
[ 4060.646314]  [<ffffffff81433539>] schedule_timeout_interruptible+0x19/0x=
20
[ 4060.646324]  [<ffffffff810de107>] khugepaged_alloc_hugepage+0xc7/0xf0
[ 4060.646334]  [<ffffffff81063700>] ? wake_up_bit+0x40/0x40
[ 4060.646344]  [<ffffffff814351f2>] ? _raw_spin_unlock_irqrestore+0x12/0x40
[ 4060.646353]  [<ffffffff810de5ad>] khugepaged+0x9d/0x1240
[ 4060.646364]  [<ffffffff81063700>] ? wake_up_bit+0x40/0x40
[ 4060.646372]  [<ffffffff810de510>] ? prepare_pmd_huge_pte.clone.29+0x60/0=
x60
[ 4060.646382]  [<ffffffff81063266>] kthread+0x96/0xa0
[ 4060.646392]  [<ffffffff81436f54>] kernel_thread_helper+0x4/0x10
[ 4060.646403]  [<ffffffff810631d0>] ? kthread_worker_fn+0x190/0x190
[ 4060.646412]  [<ffffffff81436f50>] ? gs_change+0xb/0xb
[ 4060.646521]=20
[ 4060.646525] Restarting tasks ... done.
[ 4060.660646] video LNXVIDEO:00: Restoring backlight state

$ echo never > /sys/kernel/mm/transparent_hugepage/enabled
$ cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]

$ echo mem > /sys/power/state
suspended/resumed fine

$ uname -a
Linux sf 3.2.0-rc1-00252-g8f042aa #159 SMP PREEMPT Sat Nov 12 09:28:53 FET =
2011 x86_64 Intel(R) Core(TM)2 Duo CPU U7600 @ 1.20GHz GenuineIntel GNU/Lin=
ux

Tried to reproduce 2 times. Both are successful

--=20

  Sergei

--Sig_/J=43ocn+nKvPRU9psMLPaZV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk6+JPEACgkQcaHudmEf86ps7ACfdfpRwHLGGYG5YH+6Rh+RSVMx
0VQAn3lqdvT5KTiKSDJHgUcgP7k9Er+t
=cDog
-----END PGP SIGNATURE-----

--Sig_/J=43ocn+nKvPRU9psMLPaZV--
