Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab1AUOoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:44:55 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:52348 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1AUOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:44:52 -0500
X-Spam-ASN: 
Date: Fri, 21 Jan 2011 17:44:38 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PPS parport boot lockup: INFO: HARDIRQ-READ-safe ->
 HARDIRQ-READ-unsafe lock order detected
Message-ID: <20110121174438.7521539f@tornado.gnet>
In-Reply-To: <20110119083916.GA2166@elte.hu>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	<20110119083916.GA2166@elte.hu>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/q0JljmA5E1L95jIZFgKLmdb"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/q0JljmA5E1L95jIZFgKLmdb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 19 Jan 2011 09:39:16 +0100
Ingo Molnar <mingo@elte.hu> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

>=20
> .38-rc1 allyes64 bootup locks up soft, but first produces this lockdep sp=
lat:
>=20
> [   73.524088] pps_ldisc: PPS line discipline registered
> [   73.529156] initcall pps_tty_init+0x0/0xa4 returned 0 after 4950 usecs
> [   73.535691] calling  pps_parport_init+0x0/0x60 @ 1
> [   73.540491] pps_parport: parallel port PPS client
> [   73.545219]=20
> [   73.545220] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   73.549198] [ INFO: HARDIRQ-READ-safe -> HARDIRQ-READ-unsafe lock orde=
r detected ]
> [   73.549198] 2.6.38-rc1-tip-01889-g7ca14ab-dirty #86514
> [   73.549198] ------------------------------------------------------
> [   73.549198] swapper/1 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [   73.549198]  (&(&tmp->waitlist_lock)->rlock){+.+...}, at: [<ffffffff81=
8f7ef4>] parport_claim+0x1c3/0x22f
> [   73.549198]=20
> [   73.549198] and this task is already holding:
> [   73.549198]  (&tmp->cad_lock){.-....}, at: [<ffffffff818f7d86>] parpor=
t_claim+0x55/0x22f
> [   73.549198] which would create a new lock dependency:
> [   73.549198]  (&tmp->cad_lock){.-....} -> (&(&tmp->waitlist_lock)->rloc=
k){+.+...}
> [   73.549198]=20
> [   73.549198] but this new dependency connects a HARDIRQ-READ-irq-safe l=
ock:
> [   73.549198]  (&tmp->cad_lock){.-....}
> [   73.549198] ... which became HARDIRQ-READ-irq-safe at:
> [   73.549198]   [<ffffffff810cef78>] __lock_acquire+0x2b9/0xdcf
> [   73.549198]   [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
> [   73.549198]   [<ffffffff82dc602a>] _raw_read_lock+0x39/0x6e
> [   73.549198]   [<ffffffff818f7d07>] parport_irq_handler+0x26/0x50
> [   73.549198]   [<ffffffff81104158>] handle_IRQ_event+0x61/0x13d
> [   73.549198]   [<ffffffff81106426>] handle_edge_irq+0xe3/0x12f
> [   73.549198]   [<ffffffff810423b9>] handle_irq+0x88/0x90
> [   73.549198]   [<ffffffff82dccbdd>] do_IRQ+0x4d/0xa5
> [   73.549198]   [<ffffffff82dc6493>] ret_from_intr+0x0/0x1a
> [   73.549198]   [<ffffffff81b43553>] ppa_d_pulse+0x2d/0x52
> [   73.549198]   [<ffffffff81b43c04>] ppa_disconnect.clone.1+0x1a/0x43
> [   73.549198]   [<ffffffff81b44115>] __ppa_attach+0x238/0x64d
> [   73.549198]   [<ffffffff81b44538>] ppa_attach+0xe/0x10
> [   73.549198]   [<ffffffff818f8474>] parport_register_driver+0x3e/0x86
> [   73.549198]   [<ffffffff849e7a80>] ppa_driver_init+0x25/0x27
> [   73.549198]   [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
> [   73.549198]   [<ffffffff84989e5e>] kernel_init+0x199/0x222
> [   73.549198]   [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
> [   73.549198]=20
> [   73.549198] to a HARDIRQ-READ-irq-unsafe lock:
> [   73.549198]  (&(&tmp->waitlist_lock)->rlock){+.+...}
> [   73.549198] ... which became HARDIRQ-READ-irq-unsafe at:
> [   73.549198] ...  [<ffffffff810cf02a>] __lock_acquire+0x36b/0xdcf
> [   73.549198]   [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
> [   73.549198]   [<ffffffff82dc57c3>] _raw_spin_lock+0x36/0x69
> [   73.549198]   [<ffffffff818f8916>] parport_unregister_device+0xc7/0x154
> [   73.549198]   [<ffffffff818fb7a3>] parport_close+0xe/0x10
> [   73.549198]   [<ffffffff818fc34f>] parport_device_id+0x713/0x728
> [   73.549198]   [<ffffffff818fbb6a>] parport_daisy_init+0x3b0/0x42b
> [   73.549198]   [<ffffffff818f8358>] parport_announce_port+0x16/0xf4
> [   73.549198]   [<ffffffff818fdb77>] parport_pc_probe_port+0xb27/0xbaf
> [   73.549198]   [<ffffffff818fdf90>] parport_pc_pnp_probe+0x17f/0x1a7
> [   73.549198]   [<ffffffff817927f2>] pnp_device_probe+0x81/0xab
> [   73.549198]   [<ffffffff819037bf>] driver_probe_device+0x11d/0x1e5
> [   73.549198]   [<ffffffff819038d6>] __driver_attach+0x4f/0x70
> [   73.549198]   [<ffffffff8190282e>] bus_for_each_dev+0x5c/0x88
> [   73.549198]   [<ffffffff819033e4>] driver_attach+0x1e/0x20
> [   73.549198]   [<ffffffff81902fdd>] bus_add_driver+0xc7/0x21e
> [   73.549198]   [<ffffffff81903b39>] driver_register+0x9b/0x108
> [   73.549198]   [<ffffffff8179256b>] pnp_register_driver+0x21/0x23
> [   73.549198]   [<ffffffff849dcf49>] parport_pc_init+0x282/0x311
> [   73.549198]   [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
> [   73.549198]   [<ffffffff84989e5e>] kernel_init+0x199/0x222
> [   73.549198]   [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
> [   73.549198]=20
> [   73.549198] other info that might help us debug this:
> [   73.549198]=20
> [   73.549198] 2 locks held by swapper/1:
> [   73.549198]  #0:  (registration_lock){+.+.+.}, at: [<ffffffff818f8465>=
] parport_register_driver+0x2f/0x86
> [   73.549198]  #1:  (&tmp->cad_lock){.-....}, at: [<ffffffff818f7d86>] p=
arport_claim+0x55/0x22f
[snip]
>=20
> That's probably one of these commits:
>=20
>  563558b2c735: pps: add parallel port PPS signal generator
>  46b402a0e5e4: pps: add parallel port PPS signal generator
>  a10203c691ea: pps: add parallel port PPS client
>=20
> Plus CONFIG_PPS_CLIENT_PARPORT=3Dy.
>=20
> This feature seems rather untested - this is a plain whitebox PC with a p=
arallel=20
> port.

Well, I only see that there could be a problem with parport's
waitlist_lock because it is used:
 * in parport_claim which can be called from an irq handler
 * in parport_unregister_device without disabling interrupts

But parport_unregister_device should probably never be called while
parport interrupts are enabled (in hardware). So this is a false
positive. Is this right?

But I also see here that there is probably a contention for the port
between ppa and pps_parport. So maybe I shouldn't use
parport_claim_or_block because it blocks forever and therefore can
lock up the thread that loads the module. It's strange however that
this function is used in lots of other modules without trouble.

Can you please check if the lockup is caused by parport_claim_or_block
in pps_parport/pps_gen_parport? I built 2.6.38-rc1 kernel with
allyesconfig but it locks up long before pps_parport gets loaded.

--=20
  Alexander

--Sig_/q0JljmA5E1L95jIZFgKLmdb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNOZvWAAoJEElrwznyooJbMbAH/1IClSvahsfo+8fuEh6nc5UH
bQ/CYOvCZ1bKljMsA02ki57SMKai5RUUbeBsBwAdIeL3Eo4ljiwE/7fd8lgfbEzz
VO1iF3I+v/Zljf1uPLeaAFxc++481GHdPxzUhQ92angYvnFwE4YE7uYhvpLdDhC8
ZB4FFiEXlw7mMcph8Yezgto6TyNTi8h1gJeFSyDNFuIUBRYEApZwElP8M6cTgfB9
A6k8t/Yt0aOGFv8Ol/ZCVtxekVHhc+IuLlubLnK0DJoh1jseFW/gdSiDZ9BJahHJ
bAllo14V58akeLTaFRqmNZ0J+1y2TpY4/c/7Bx5IoJ7to0P/XPlscoefmPVA8AM=
=8zCh
-----END PGP SIGNATURE-----

--Sig_/q0JljmA5E1L95jIZFgKLmdb--
