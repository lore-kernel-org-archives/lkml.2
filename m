Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2BTJJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:09:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab2BTJJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:09:13 -0500
Date: Mon, 20 Feb 2012 20:08:56 +1100
From: NeilBrown <neilb@suse.de>
To: Thomas Weber <thomas.weber.linux@googlemail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Ming Lei <tom.leiming@gmail.com>,
        balbi@ti.com, Linus Walleij <linus.walleij@stericsson.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Possible circular locking dependency (3.3-rc2)
Message-ID: <20120220200856.47db7e24@notabene.brown>
In-Reply-To: <4F41FF4E.7040000@gmail.com>
References: <20120208124147.GF16334@legolas.emea.dhcp.ti.com>
	<CACVXFVMfmabcH57da-prx=J950KEoFtfb-zsuBWn7VY3NaMUUQ@mail.gmail.com>
	<20120215200910.GE25779@ponder.secretlab.ca>
	<4F41FF4E.7040000@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/a4eQDnRG0G7dtX8boLjf8BA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/a4eQDnRG0G7dtX8boLjf8BA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Feb 2012 09:07:42 +0100 Thomas Weber
<thomas.weber.linux@googlemail.com> wrote:

> Hello,
>=20
> I applied the patch from Ming, but got also an error.
> I am ccing Neil, because I also applied some patches from him.

That looks like it is the third of the three patches I sent.

I needed some locking and there was a mutex available that seemed to be
available so I used it.  Apparently it causes problems.

I don't think I ever saw that myself ... I wonder why.

There is already a dependency between the mutex I used and s_active
in sysfs.  I guess that means I'll have to create a new lock just for
the purpose of keeping two threads from using the w1 bus at the same time...

Apart from this - which is just a warning, though maybe it could become a
real deadlock - is the bq27000 now working for you?

NeilBrown


>=20
> Regards,
> Thomas
>=20
> > [    6.229370] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [    6.235870] [ INFO: possible circular locking dependency detected ]
> > [    6.242431] 3.3.0-rc4-00020-ga02b31a #10 Not tainted
> > [    6.247650] -------------------------------------------------------
> > [    6.254241] udevadm/596 is trying to acquire lock:
> > [    6.259277]  (&dev->mutex#2){+.+.+.}, at: [<c0308af0>] w1_bq27000_re=
ad+0x1c/0x48
> > [    6.267120]=20
> > [    6.267120] but task is already holding lock:
> > [    6.273254]  (s_active#11){++++.+}, at: [<c01463d4>] sysfs_write_fil=
e+0xdc/0x180
> > [    6.281097]=20
> > [    6.281127] which lock already depends on the new lock.
> > [    6.281127]=20
> > [    6.289703]=20
> > [    6.289703] the existing dependency chain (in reverse order) is:
> > [    6.297576]=20
> > [    6.297576] -> #1 (s_active#11){++++.+}:
> > [    6.303283]        [<c007b3c8>] lock_acquire+0xa0/0x128
> > [    6.308807]        [<c0147b50>] sysfs_addrm_finish+0xf4/0x148
> > [    6.314880]        [<c0146184>] sysfs_hash_and_remove+0x4c/0x88
> > [    6.321136]        [<c0146cec>] sysfs_remove_file+0x30/0x38
> > [    6.326995]        [<c0275bec>] device_del+0xf0/0x17c
> > [    6.332336]        [<c0275c84>] device_unregister+0xc/0x18
> > [    6.338104]        [<c0306b28>] w1_slave_detach+0xac/0xcc
> > [    6.343811]        [<c0306e5c>] w1_reconnect_slaves+0xc0/0x10c
> > [    6.349945]        [<c0307924>] w1_register_family+0x90/0xa0
> > [    6.355926]        [<c0008760>] do_one_initcall+0x34/0x174
> > [    6.361694]        [<c054980c>] kernel_init+0x94/0x11c
> > [    6.367126]        [<c00148b0>] kernel_thread_exit+0x0/0x8
> > [    6.372924]=20
> > [    6.372924] -> #0 (&dev->mutex#2){+.+.+.}:
> > [    6.378845]        [<c007a980>] __lock_acquire+0x1678/0x1ad4
> > [    6.384826]        [<c007b3c8>] lock_acquire+0xa0/0x128
> > [    6.390319]        [<c03c7b24>] mutex_lock_nested+0x48/0x2bc
> > [    6.396301]        [<c0308af0>] w1_bq27000_read+0x1c/0x48
> > [    6.401977]        [<c03098d4>] bq27000_read_platform+0x2c/0x124
> > [    6.408325]        [<c030a004>] bq27x00_battery_get_property+0x1cc/0=
x3cc
> > [    6.415374]        [<c0309154>] power_supply_show_property+0x4c/0x224
> > [    6.422180]        [<c0309468>] power_supply_uevent+0xe4/0x224
> > [    6.428314]        [<c0276b60>] dev_uevent+0xb4/0x170
> > [    6.433654]        [<c01f4b84>] kobject_uevent_env+0x1d8/0x478
> > [    6.439819]        [<c027603c>] store_uevent+0x50/0x54
> > [    6.445220]        [<c0274f58>] dev_attr_store+0x18/0x24
> > [    6.450805]        [<c01463f8>] sysfs_write_file+0x100/0x180
> > [    6.456787]        [<c00e96a0>] vfs_write+0xa8/0x138
> > [    6.462036]        [<c00e9910>] sys_write+0x40/0x6c
> > [    6.467163]        [<c00138e0>] ret_fast_syscall+0x0/0x3c
> > [    6.472869]=20
> > [    6.472869] other info that might help us debug this:
> > [    6.472900]=20
> > [    6.481292]  Possible unsafe locking scenario:
> > [    6.481292]=20
> > [    6.487518]        CPU0                    CPU1
> > [    6.492248]        ----                    ----
> > [    6.497009]   lock(s_active#11);
> > [    6.500427]                                lock(&dev->mutex#2);
> > [    6.506683]                                lock(s_active#11);
> > [    6.512756]   lock(&dev->mutex#2);
> > [    6.516357]=20
> > [    6.516357]  *** DEADLOCK ***
> > [    6.516357]=20
> > [    6.522583] 2 locks held by udevadm/596:
> > [    6.526702]  #0:  (&buffer->mutex){+.+.+.}, at: [<c0146320>] sysfs_w=
rite_file+0x28/0x180
> > [    6.535278]  #1:  (s_active#11){++++.+}, at: [<c01463d4>] sysfs_writ=
e_file+0xdc/0x180
> > [    6.543579]=20
> > [    6.543579]=20
> > [    6.543579] stack backtrace:
> > [    6.548217] [<c0019e9c>] (unwind_backtrace+0x0/0xf8) from [<c03c3544=
>] (print_circular_bug+0x2c8/0x2d4)
> > [    6.558105] [<c03c3544>] (print_circular_bug+0x2c8/0x2d4) from [<c00=
7a980>] (__lock_acquire+0x1678/0x1ad4)
> > [    6.568267] [<c007a980>] (__lock_acquire+0x1678/0x1ad4) from [<c007b=
3c8>] (lock_acquire+0xa0/0x128)
> > [    6.577789] [<c007b3c8>] (lock_acquire+0xa0/0x128) from [<c03c7b24>]=
 (mutex_lock_nested+0x48/0x2bc)
> > [    6.587310] [<c03c7b24>] (mutex_lock_nested+0x48/0x2bc) from [<c0308=
af0>] (w1_bq27000_read+0x1c/0x48)
> > [    6.597015] [<c0308af0>] (w1_bq27000_read+0x1c/0x48) from [<c03098d4=
>] (bq27000_read_platform+0x2c/0x124)
> > [    6.607086] [<c03098d4>] (bq27000_read_platform+0x2c/0x124) from [<c=
030a004>] (bq27x00_battery_get_property+0x1cc/0x3cc)
> > [    6.618499] [<c030a004>] (bq27x00_battery_get_property+0x1cc/0x3cc) =
from [<c0309154>] (power_supply_show_property+0x4c/0x224)
> > [    6.630401] [<c0309154>] (power_supply_show_property+0x4c/0x224) fro=
m [<c0309468>] (power_supply_uevent+0xe4/0x224)
> > [    6.641357] [<c0309468>] (power_supply_uevent+0xe4/0x224) from [<c02=
76b60>] (dev_uevent+0xb4/0x170)
> > [    6.650909] [<c0276b60>] (dev_uevent+0xb4/0x170) from [<c01f4b84>] (=
kobject_uevent_env+0x1d8/0x478)
> > [    6.660430] [<c01f4b84>] (kobject_uevent_env+0x1d8/0x478) from [<c02=
7603c>] (store_uevent+0x50/0x54)
> > [    6.670013] [<c027603c>] (store_uevent+0x50/0x54) from [<c0274f58>] =
(dev_attr_store+0x18/0x24)
> > [    6.679107] [<c0274f58>] (dev_attr_store+0x18/0x24) from [<c01463f8>=
] (sysfs_write_file+0x100/0x180)
> > [    6.688720] [<c01463f8>] (sysfs_write_file+0x100/0x180) from [<c00e9=
6a0>] (vfs_write+0xa8/0x138)
> > [    6.697967] [<c00e96a0>] (vfs_write+0xa8/0x138) from [<c00e9910>] (s=
ys_write+0x40/0x6c)
> > [    6.706390] [<c00e9910>] (sys_write+0x40/0x6c) from [<c00138e0>] (re=
t_fast_syscall+0x0/0x3c)


--Sig_/a4eQDnRG0G7dtX8boLjf8BA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0INqDnsnt1WYoG5AQL6/w/+MgsU7iOl4MQIc7X8cbomLGxLfspT2VF7
Rr81vznWGCUqP5MJ3lkzkcOAaOQW0ftXWdDvx3+byY1wintcfbCr5i7lkrhfWibf
dz2ptbdfDlMTc9rSB+9LWntyZDXZwUTifdsN4kduOklWUOizFiMYG8aoOGak3qrl
vNwhvqoBmU5/5BrZqSA4BCDIEqTM8Nb55uB5TjhmZ6OO4rws2pYl3zlCn2pLBQKF
7s5ianpayKtOlfV1mguUqPg5U1M7qoJRUtRlVy/q4JabtO+kOA6iQZp+xBQxcWwl
hB3UBlWgcnQ/hfLEHTzDBPgoKz7izZZZOF2wuc3vwfDJPntEAE2vckYRW8PavtlI
OKQB9G8CjadEHB9eZmI3y627OOruXL2/WlhEkwFYLoGxtwpEJ5oTeIJYxkhyHFsY
PhcMbYsaqiaN/5bDQOrJ2yGFltgwBXoZrR5MCVCWD88qV2QbOcPSU8/epwOo1t6N
2CGj9q0hZnlBtNhmPNO0joXl0fBuNXTof/jRZZ0x6dk5M12kkK9SlCz4zcXtcEcC
cJXlZo8hlrfkgQCOynUGUd8gH5/7saX3DOH60gTYxd1D2IcfICbIyX8BCxa7ZzTJ
GXz8hwgaD6GTebPaFQJVL8DplsjkeSDmpvPf+UAnw2VVvHJOYPGktc68dL/R8sk5
dctRwE4wsVE=
=FRE8
-----END PGP SIGNATURE-----

--Sig_/a4eQDnRG0G7dtX8boLjf8BA--
