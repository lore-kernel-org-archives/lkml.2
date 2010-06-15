Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab0FOLVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:21:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45062 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab0FOLVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:21:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=D0apqII2dlKac4476mHyp330Ni5HohFUpyIbAfGgk2nheHJY2aGSEOFOiZuX967TT/
         Fd+pMjtZGZXlv7UYe9XzFbIqx9q3U//O4x26HAJ5ypyI7HwaJGeiK95iy8K777o24OGS
         eUdB0hIQaz/ct9bfHYGYvrqxHcHtYg8EI2CVU=
Date: Tue, 15 Jun 2010 14:24:34 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Sage Weil <sage@newdream.net>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: inconsistent lock state
Message-ID: <20100615112434.GA3967@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

kernel: [ 3272.351191]=20
kernel: [ 3272.351194] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kernel: [ 3272.351199] [ INFO: inconsistent lock state ]
kernel: [ 3272.351204] 2.6.35-rc3-dbg-00106-ga75e02b-dirty #15
kernel: [ 3272.351206] ---------------------------------
kernel: [ 3272.351210] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
kernel: [ 3272.351215] X/3827 [HC0[0]:SC0[0]:HE1:SE1] takes:
kernel: [ 3272.351218]  (&(&new->fa_lock)->rlock){?.-...}, at: [<c10aefb4>]=
 kill_fasync+0x37/0x71
kernel: [ 3272.351232] {IN-HARDIRQ-W} state was registered at:
kernel: [ 3272.351235]   [<c104e95c>] __lock_acquire+0x281/0xbe1
kernel: [ 3272.351243]   [<c104f652>] lock_acquire+0x59/0x70
kernel: [ 3272.351248]   [<c12c6c48>] _raw_spin_lock+0x25/0x34
kernel: [ 3272.351255]   [<c10aefb4>] kill_fasync+0x37/0x71
kernel: [ 3272.351261]   [<fd220c81>] evdev_event+0x135/0x190 [evdev]
kernel: [ 3272.351275]   [<c1232003>] input_pass_event+0x6f/0xae
kernel: [ 3272.351283]   [<c1232ef5>] input_handle_event+0x38d/0x396
kernel: [ 3272.351288]   [<c1232fbf>] input_event+0x4f/0x62
kernel: [ 3272.351293]   [<c12368e4>] input_sync+0xe/0x11
kernel: [ 3272.351299]   [<c1236d72>] atkbd_interrupt+0x48b/0x541
kernel: [ 3272.351304]   [<c122ecb2>] serio_interrupt+0x35/0x68
kernel: [ 3272.351309]   [<c122fbff>] i8042_interrupt+0x264/0x26e
kernel: [ 3272.351314]   [<c106bb02>] handle_IRQ_event+0x1d/0x98
kernel: [ 3272.351321]   [<c106d506>] handle_edge_irq+0xc0/0x107
kernel: [ 3272.351326]   [<c10045ca>] handle_irq+0x1a/0x20
kernel: [ 3272.351332]   [<c100435f>] do_IRQ+0x43/0x8d
kernel: [ 3272.351337]   [<c1002d75>] common_interrupt+0x35/0x3c
kernel: [ 3272.351342]   [<c124723d>] cpuidle_idle_call+0x6a/0xa0
kernel: [ 3272.351349]   [<c100170d>] cpu_idle+0x89/0xbe
kernel: [ 3272.351354]   [<c12b6d11>] rest_init+0xb5/0xba
kernel: [ 3272.351361]   [<c148a7bf>] start_kernel+0x33b/0x340
kernel: [ 3272.351368]   [<c148a0c9>] i386_start_kernel+0xc9/0xd0
kernel: [ 3272.351374] irq event stamp: 54104917
kernel: [ 3272.351377] hardirqs last  enabled at (54104917): [<c12c70f2>] _=
raw_spin_unlock_irqrestore+0x36/0x5b
kernel: [ 3272.351384] hardirqs last disabled at (54104916): [<c12c6ced>] _=
raw_spin_lock_irqsave+0x13/0x42
kernel: [ 3272.351391] softirqs last  enabled at (54104732): [<c1032cf2>] _=
_do_softirq+0xfd/0x10c
kernel: [ 3272.351398] softirqs last disabled at (54104703): [<c1032d30>] d=
o_softirq+0x2f/0x47
kernel: [ 3272.351404]=20
kernel: [ 3272.351405] other info that might help us debug this:
kernel: [ 3272.351409] 3 locks held by X/3827:
kernel: [ 3272.351412]  #0:  (rcu_read_lock){.+.+..}, at: [<c124fdfa>] rcu_=
read_lock+0x0/0x26
kernel: [ 3272.351423]  #1:  (rcu_read_lock){.+.+..}, at: [<c124d5d9>] rcu_=
read_lock+0x0/0x26
kernel: [ 3272.351432]  #2:  (rcu_read_lock){.+.+..}, at: [<c10ae429>] rcu_=
read_lock+0x0/0x26
kernel: [ 3272.351442]=20
kernel: [ 3272.351443] stack backtrace:
kernel: [ 3272.351448] Pid: 3827, comm: X Not tainted 2.6.35-rc3-dbg-00106-=
ga75e02b-dirty #15
kernel: [ 3272.351451] Call Trace:
kernel: [ 3272.351456]  [<c12c4ff1>] ? printk+0xf/0x11
kernel: [ 3272.351462]  [<c104e51a>] valid_state+0x133/0x141
kernel: [ 3272.351468]  [<c104e5f7>] mark_lock+0xcf/0x1b3
kernel: [ 3272.351473]  [<c104e54e>] ? mark_lock+0x26/0x1b3
kernel: [ 3272.351479]  [<c104dfd2>] ? check_usage_backwards+0x0/0x68
kernel: [ 3272.351484]  [<c104e9d0>] __lock_acquire+0x2f5/0xbe1
kernel: [ 3272.351489]  [<c104ea44>] ? __lock_acquire+0x369/0xbe1
kernel: [ 3272.351495]  [<c104ea44>] ? __lock_acquire+0x369/0xbe1
kernel: [ 3272.351502]  [<c102ab40>] ? try_to_wake_up+0x2a8/0x2bb
kernel: [ 3272.351508]  [<c104f652>] lock_acquire+0x59/0x70
kernel: [ 3272.351513]  [<c10aefb4>] ? kill_fasync+0x37/0x71
kernel: [ 3272.351519]  [<c12c6c48>] _raw_spin_lock+0x25/0x34
kernel: [ 3272.351524]  [<c10aefb4>] ? kill_fasync+0x37/0x71
kernel: [ 3272.351529]  [<c10aefb4>] kill_fasync+0x37/0x71
kernel: [ 3272.351534]  [<c124d694>] sock_wake_async+0x77/0x83
kernel: [ 3272.351540]  [<c124fe4d>] sk_wake_async+0x2d/0x32
kernel: [ 3272.351545]  [<c1250004>] sock_def_readable+0x45/0x51
kernel: [ 3272.351551]  [<c12b0247>] unix_stream_sendmsg+0x1e2/0x269
kernel: [ 3272.351557]  [<c124fe6e>] ? rcu_read_unlock+0x1c/0x1e
kernel: [ 3272.351562]  [<c124cf1a>] __sock_sendmsg+0x51/0x5a
kernel: [ 3272.351567]  [<c124cff7>] sock_aio_write+0xd4/0xdd
kernel: [ 3272.351575]  [<c10a4d95>] do_sync_readv_writev+0x84/0xb7
kernel: [ 3272.351582]  [<c10a4288>] ? copy_from_user+0x8/0xa
kernel: [ 3272.351587]  [<c10a4e69>] ? rw_copy_check_uvector+0x55/0xc7
kernel: [ 3272.351594]  [<c1164082>] ? security_file_permission+0xf/0x11
kernel: [ 3272.351599]  [<c10a47e5>] ? rw_verify_area+0x90/0xac
kernel: [ 3272.351605]  [<c10a4f58>] do_readv_writev+0x7d/0xdf
kernel: [ 3272.351610]  [<c124cf23>] ? sock_aio_write+0x0/0xdd
kernel: [ 3272.351615]  [<c1164082>] ? security_file_permission+0xf/0x11
kernel: [ 3272.351621]  [<c10a47e5>] ? rw_verify_area+0x90/0xac
kernel: [ 3272.351626]  [<c10a4ff3>] vfs_writev+0x39/0x42
kernel: [ 3272.351632]  [<c10a5102>] sys_writev+0x3b/0x8c
kernel: [ 3272.351637]  [<c10027d3>] sysenter_do_call+0x12/0x32


	Sergey

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwXYvIACgkQfKHnntdSXjTyvgP+MMnZrH5XNmd38khKnSLYhbOz
MMqFvmGfSXs2x9Q6mM6+Fc0ND3oN2W4wFpCy7QQ4IVTSfVIbKAuni6fg50fIophD
OjT+AAwtRN7Q3f8kx26uKTDBxnctpayeXjBNpsjiaT/YYSmF/ZziDX8oYSgwcs1Q
PgWOduJ5WSzXQHkx37E=
=8LN3
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
