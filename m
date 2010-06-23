Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab0FWG4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:56:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39194 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab0FWG4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:56:09 -0400
Date: Wed, 23 Jun 2010 16:55:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       arnd@arndb.de, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: -next June 21: WARNING: at include/linux/tty.h
Message-Id: <20100623165557.d793dc41.sfr@canb.auug.org.au>
In-Reply-To: <4C204962.70208@in.ibm.com>
References: <20100621170056.2fcf10ad.sfr@canb.auug.org.au>
	<4C204962.70208@in.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jun_2010_16_55_57_+1000_7a2lrFlBTfpL5Lz="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jun_2010_16_55_57_+1000_7a2lrFlBTfpL5Lz=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Jun 2010 10:55:54 +0530 Sachin Sant <sachinp@in.ibm.com> wrote:
>
> With next-20100621 on a x86_64 box came across this warning :
>=20
> TCP cubic registered
> registered taskstats version 1
> ------------[ cut here ]------------
> WARNING: at include/linux/tty.h:589 tty_open+0x76/0x57a()
> Hardware name: BladeCenter LS21 -[79716AA]-
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.35-rc3-autotest-next-20100621 #1
> Call Trace:
>  [<ffffffff812428d8>] ? tty_open+0x76/0x57a
>  [<ffffffff8103cf39>] warn_slowpath_common+0x80/0xae
>  [<ffffffff8103cf7c>] warn_slowpath_null+0x15/0x17
>  [<ffffffff812428d8>] tty_open+0x76/0x57a
>  [<ffffffff810d4544>] ? exact_match+0x0/0x9
>  [<ffffffff810d491f>] chrdev_open+0x133/0x152
>  [<ffffffff810d47ec>] ? chrdev_open+0x0/0x152
>  [<ffffffff810d07b4>] __dentry_open+0x140/0x252
>  [<ffffffff810d0990>] nameidata_to_filp+0x3e/0x4f
>  [<ffffffff810db588>] do_last+0x51a/0x643
>  [<ffffffff810dd621>] do_filp_open+0x23d/0x5f8
>  [<ffffffff810c1ba8>] ? slab_node+0x3c/0x78
>  [<ffffffff810d05a1>] do_sys_open+0x5a/0xf0
>  [<ffffffff810d0660>] sys_open+0x1b/0x1d
>  [<ffffffff818e66fc>] kernel_init+0x1b3/0x220
>  [<ffffffff810036d4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff818e6549>] ? kernel_init+0x0/0x220
>  [<ffffffff810036d0>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace 108cb769a1c0e534 ]---
>=20
> This warning seem to have been introduced with next-20100617.
> The corresponding code is :
>=20
> 585 static inline void tty_lock(void) __acquires(kernel_lock)
> 586 {
> 587 #ifdef CONFIG_LOCK_KERNEL
> 588         /* kernel_locked is 1 for !CONFIG_LOCK_KERNEL */
> 589         WARN_ON(kernel_locked());
> 590 #endif
> 591         lock_kernel();
> 592 }
>=20
> which was added by commit 01510c869f9..
>=20
> tty: replace BKL with a new tty_lock

I am getting a similar (the same) warning on a Power7 box I boot test:

Badness at include/linux/tty.h:589
NIP: c000000000339244 LR: c00000000033922c CTR: c000000000339178
REGS: c0000007a606f690 TRAP: 0700   Not tainted  (2.6.35-rc3-autokern1-next=
-20100623)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24244022  XER: 20000010
TASK =3D c000000f970d8000[1] 'swapper' THREAD: c0000007a606c000 CPU: 0
GPR00: 0000000000000001 c0000007a606f910 c0000000009a1450 c0000000009105f0=
=20
GPR04: c0000007a585f200 c000000000a6e588 0000000000000000 c000000f9a002800=
=20
GPR08: 0000000000000017 c000000f970d8000 00000000007fffff c0000000003397c8=
=20
GPR12: 0000000024222028 c000000001fc3000 0000000000000000 ffffffffffffff9c=
=20
GPR16: 0000000002d80000 0000000000000000 c0000007a606fcd0 0000000000010002=
=20
GPR20: c0000000009105f0 ffffffffffffffff c0000007a606f980 fffffffffffff000=
=20
GPR24: c0000007a9028648 0000000000040001 0000000000000000 0000000000500001=
=20
GPR28: c0000007a585f200 c000000000a6e588 c00000000093fd68 0000000000000000=
=20
NIP [c000000000339244] .tty_open+0xcc/0x650
LR [c00000000033922c] .tty_open+0xb4/0x650
Call Trace:
[c0000007a606f910] [c00000000033922c] .tty_open+0xb4/0x650 (unreliable)
[c0000007a606fa10] [c00000000013eb20] .chrdev_open+0x230/0x278
[c0000007a606fad0] [c000000000138bc8] .__dentry_open+0x1e8/0x35c
[c0000007a606fb90] [c000000000148580] .do_last+0x5bc/0x764
[c0000007a606fc50] [c00000000014a8c8] .do_filp_open+0x26c/0x734
[c0000007a606fe30] [c0000000001388e4] .do_sys_open+0x84/0x154
[c0000007a606fee0] [c00000000083d4f8] .kernel_init+0x288/0x324
[c0000007a606ff90] [c0000000000261e0] .kernel_thread+0x54/0x70
Instruction dump:
60000001 7d1b0000 835c0038 7e83a378 92a10070 48264a25 60000000 575a05ee=20
e92d01b0 8009001c 7c0000f8 54000ffe <0b000000> ea5e80b0 ea3e80a8 38a0024f=20

I get this twice for each boot.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jun_2010_16_55_57_+1000_7a2lrFlBTfpL5Lz=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwhr/0ACgkQjjKRsyhoI8y6FQCdFR9qVhDSaXenCP0NkpxuB/qS
Da8AnA2RSwGyl23CYXqpUX29n3zmkoC6
=AwbS
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jun_2010_16_55_57_+1000_7a2lrFlBTfpL5Lz=--
