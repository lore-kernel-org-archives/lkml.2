Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1LVAV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:21:27 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43449 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab1LVAVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:21:25 -0500
Date: Thu, 22 Dec 2011 11:21:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: linux-next: boot failure for next-20111216
Message-Id: <20111222112118.d93f4b31c0c5beaeb62244c6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Dec_2011_11_21_18_+1100_Yejhgkup8I_LdVFB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Dec_2011_11_21_18_+1100_Yejhgkup8I_LdVFB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

next-20111216 (and all later so far) fails to boot on a Power7 blade
server like this:

calling  .serial8250_init+0x0/0x1e0 @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
INFO: rcu_sched detected stalls on CPUs/tasks: { 3 4 6 7 8 9 10 11 12 13 14=
 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31} (detected by 5, t=3D60=
02 jiffies)
Call Trace:
[c0000003fd9e74e0] [c000000000015054] .show_stack+0x74/0x1c0 (unreliable)
[c0000003fd9e7590] [c00000000012ad2c] .__rcu_pending+0x49c/0x4b0
[c0000003fd9e7650] [c00000000012ae94] .rcu_check_callbacks+0x154/0x250
[c0000003fd9e76f0] [c0000000000b8ab4] .update_process_times+0x44/0xa0
[c0000003fd9e7780] [c0000000000fcdbc] .tick_sched_timer+0x7c/0x100
[c0000003fd9e7820] [c0000000000d5b38] .__run_hrtimer+0xb8/0x270
[c0000003fd9e78d0] [c0000000000d6068] .hrtimer_interrupt+0x138/0x2d0
[c0000003fd9e79e0] [c00000000001e4d0] .timer_interrupt+0x130/0x300
[c0000003fd9e7a90] [c0000000000038e4] decrementer_common+0x164/0x180
--- Exception: 901 at .arch_local_irq_restore+0xd8/0x140
    LR =3D .cpu_idle+0x180/0x220
[c0000003fd9e7d80] [c000000000c7c368] wireless_seq_fops+0x109a8/0x2f418 (un=
reliable)
[c0000003fd9e7e20] [c000000000017970] .cpu_idle+0x180/0x220
[c0000003fd9e7ed0] [c0000000008369e8] .start_secondary+0x3a4/0x3b0
[c0000003fd9e7f90] [c0000000000093f4] .start_secondary_prolog+0x10/0x14

There are quite a few more rcu stalls after this and the boot never
completes (at least not before our automated test system steps in and
reboots the server).

So the obvious first place to point the finger would be changes to the
8250 code ... but there is nothing too obvious there.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Dec_2011_11_21_18_+1100_Yejhgkup8I_LdVFB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8nf+AAoJEECxmPOUX5FEgTUP/2KFNiVv8yEDma0s62tYzFEr
9Q+puo+tr1kSd6WazEPJ/THJvTSSuHZ5K1PmhrJe6n6pXxt4b88FuQXwv4vtjBCu
DpH6/Z8S45nQAQmEzrfJgnKsAYnxQqL+PK/4IHsX4VNFAezOWj26eknJQVjsKRbU
8mqpI+nCgLTknYpmbwpzEus970BN4imItA3PdT+xiT950xijAmk//whd+LggVcBB
3tqbLGm5FVE1bY6sOOnyFWLWkv6OywY4NQlQoHF9ihM3s55tZYUid9Vj4PS7AJp2
Xfvf84nZOkhDaNBQDVE4vlMMlkOwJCGn5wlvVDuYj1kUN9/oRTJ4cnu243a4hafN
zEmW+ijeFnbQkV1zox+CdhVHGiWAMBLYwBdVzl4ATWBa5V3rtvVrMkqIJI8SIPRk
MA3z1baushcSkGOsuFKWSp89JfKyQmjkJw1Clnhlohq4fQGuFORwzOUczk0HCxKp
gLk8vtOjdO5AoZQ38JHQBD+Ue7hqr8/3qq8clZyH0u4/TYr8sSfs5qkUEvu/qO+U
7fK3/bHeNJVvNkyffqV9As7MlqEtLa51+O1lHq1+5GtUe82C/tyUBwuyM/3banbR
xCcceZJw+Yz4RRQpXTH0CSRTR6lgE0E1Xx1jTdhJaDKB0xd5QyfPnv3gfd+pgtCr
owI1Ns/HUI87NUtJsuxf
=Frim
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Dec_2011_11_21_18_+1100_Yejhgkup8I_LdVFB--
