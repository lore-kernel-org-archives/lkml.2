Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab2ECQRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:17:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55722 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2ECQRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:17:45 -0400
Date: Thu, 3 May 2012 11:17:38 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: dustin.kirkland@gazzang.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ecryptfs@vger.kernel.org
Subject: Re: ecryptfs: Kernel BUG when closing device
Message-ID: <20120503161736.GA16993@boyd>
References: <1336024803.10945.5.camel@lappy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <1336024803.10945.5.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-05-03 08:00:03, Sasha Levin wrote:
> Hi all,
>=20
> After some fuzzing using trinity inside a KVM guest, I've stumbled on the=
 following:

Hi Sasha - Thanks for reporting this issue. Is there any way to get
trinity to reproduce this fuzzing sequence?

Tyler

>=20
> [ 2674.118324] ------------[ cut here ]------------
> [ 2674.119028] kernel BUG at fs/ecryptfs/miscdev.c:155!
> [ 2674.119028] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 2674.119028] CPU 0=20
> [ 2674.119028] Pid: 12745, comm: trinity Tainted: G        W    3.4.0-rc5=
-next-20120501-sasha-00003-gfaa6ef1 #106
> [ 2674.119028] RIP: 0010:[<ffffffff813722f6>]  [<ffffffff813722f6>] ecryp=
tfs_miscdev_release+0x66/0x120
> [ 2674.119028] RSP: 0018:ffff88006ed19be8  EFLAGS: 00010282
> [ 2674.119028] RAX: 00000000ffffffea RBX: ffff88006eee8000 RCX: ffff88001=
a109d88
> [ 2674.119028] RDX: ffffffff83a3cd00 RSI: 000000009a6561a0 RDI: ffff88006=
ed19bf0
> [ 2674.119028] RBP: ffff88006ed19c08 R08: f2fd966b13e561a0 R09: 400000000=
0000000
> [ 2674.119028] R10: 0000000000000000 R11: 0d00000000000000 R12: 000000009=
a6561a0
> [ 2674.119028] R13: ffff88000c834ab0 R14: ffff88000d02d030 R15: ffff88000=
c834ab0
> [ 2674.119028] FS:  00007f7689f4e700(0000) GS:ffff88000d800000(0000) knlG=
S:0000000000000000
> [ 2674.119028] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2674.119028] CR2: 0000000000000ffc CR3: 0000000003a1c000 CR4: 000000000=
00407f0
> [ 2674.119028] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [ 2674.119028] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
> [ 2674.119028] Process trinity (pid: 12745, threadinfo ffff88006ed18000, =
task ffff88006eee8000)
> [ 2674.119028] Stack:
> [ 2674.119028]  0000000000000008 ffff88001a109d88 ffff8800199b2680 000000=
0000000008
> [ 2674.119028]  ffff88006ed19c58 ffffffff811ebcea ffff8800199b2690 ffff88=
00406b0020
> [ 2674.119028]  ffff88006ed19c58 ffff8800199b2680 ffff88000cc55a00 000000=
0000000000
> [ 2674.119028] Call Trace:
> [ 2674.119028]  [<ffffffff811ebcea>] __fput+0x11a/0x2c0
> [ 2674.119028]  [<ffffffff811ebea5>] fput+0x15/0x20
> [ 2674.119028]  [<ffffffff811e81c2>] filp_close+0x82/0xa0
> [ 2674.119028]  [<ffffffff810ba5c4>] close_files+0x1b4/0x200
> [ 2674.119028]  [<ffffffff810ba410>] ? wait_task_stopped+0x3c0/0x3c0
> [ 2674.119028]  [<ffffffff810ba631>] put_files_struct+0x21/0x180
> [ 2674.119028]  [<ffffffff82d93820>] ? _raw_spin_unlock+0x30/0x60
> [ 2674.119028]  [<ffffffff810ba7dd>] exit_files+0x4d/0x60
> [ 2674.119028]  [<ffffffff810bc85b>] do_exit+0x27b/0x460
> [ 2674.119028]  [<ffffffff810e74d1>] ? get_parent_ip+0x11/0x50
> [ 2674.119028]  [<ffffffff810bcae1>] do_group_exit+0xa1/0xe0
> [ 2674.119028]  [<ffffffff810ccf98>] get_signal_to_deliver+0x348/0x3a0
> [ 2674.119028]  [<ffffffff8104daf2>] do_signal+0x42/0x120
> [ 2674.119028]  [<ffffffff8104e58f>] ? do_divide_error+0xaf/0xc0
> [ 2674.119028]  [<ffffffff82d93fff>] ? retint_signal+0x11/0x92
> [ 2674.119028]  [<ffffffff8104dc24>] do_notify_resume+0x54/0xa0
> [ 2674.119028]  [<ffffffff82d9403b>] retint_signal+0x4d/0x92
> [ 2674.119028] Code: f1 4f d6 ff 48 8b 83 40 06 00 00 48 8d 7d e8 48 8b 9=
0 88 00 00 00 44 89 e6 e8 37 f0 ff ff 85 c0 75 09 48 8b 7d e8 48 85 ff 75 1=
2 <0f> 0b 0f 1f 84 00 00 00 00 00 eb fe 66 0f 1f 44 00 00 48 83 c7=20
> [ 2674.119028] RIP  [<ffffffff813722f6>] ecryptfs_miscdev_release+0x66/0x=
120
> [ 2674.119028]  RSP <ffff88006ed19be8>
> [ 2674.319199] ---[ end trace 44593438a59a9537 ]---
>=20
> For reference, here are other error messages thrown out during that run:
>=20
> [  103.989497] ecryptfs_miscdev_open: pid [0xffff8800346dfdc0] has regist=
ered with euid [0], but pid [0xffff88000c3aec40] has attempted to open the =
handle instead
> [  347.692999] ecryptfs_miscdev_write: Acceptable packet size range is [6=
-531], but amount of data written is [10376].120000 iterations.
> [ 1920.665966] ecryptfs_miscdev_write: Acceptable packet size range is [6=
-531], but amount of data written is [37505].1117000 iterations.
> [ 2168.232502] ecryptfs_miscdev_write: Acceptable packet size range is [6=
-531], but amount of data written is [31302].1220000 iterations.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPoq+fAAoJENaSAD2qAscKlTkP+wSsHZuknkbqh4iO0tdELoCh
SbDk+ci8pjeOc57rmiOdByuipD/IJCtJqWTeJoMpTmZ/p/dolPBEFXljcerblRTG
puWOgcNg/d6UvjGcmVks9DMEKTIqXc+98x7hRzPvXm7tq3aavtm0XYRHsIqJ0DPD
rYPjcdeLZl5Zfl9Xa00n4FuL66z3Cm556pg3MRul9VjY5R7PPAQX/PjFQt/Cmaia
T813IOsy8DYBa4jT4bGjeZJ6RCosFC6QKv77YhZncTJQp25mTmKpWpQiOvzROWmM
UbMbQEiHIIIYMt1ArGrbpBqQoBFLsC1QUNPlI3uvSyLC1uQqUIhUa7ArScPItUgm
1ooCw58YeSkoP442/eaGyrxhvRvJNjORVwU0Hut1N4agTzcs/NhD8etmuQgO/ljz
ImJI+lED/A/X6KsHOSbtrOLtDBviFSBCMnambKzihRlRKYfYeek4Ph4JxiLhySP0
PEFfSwufPF3P8MaqaB76103ZXnk0zeyGELi7KscLzE8D3gKWBI5m/Y5e+Mcfgjxg
GiIMcaS/7ZTnIAhlbT/oz4b5thQ2B8VLwgF5RZ8Gw1cnmAL8IduaCMf+am9qS76l
yQ5yDFq7kzE9JAqCbjRWHIibgqTCjYLVmaIHabtSStfYASG80w6mUmEK/dOXLO6o
g8TVeit0aEyI0pIR6ukE
=dU+f
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
