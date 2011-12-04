Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1LDK7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 05:59:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab1LDK7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 05:59:20 -0500
Date: Sun, 4 Dec 2011 21:58:59 +1100
From: NeilBrown <neilb@suse.de>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] MFD: TWL: add power off functionality
Message-ID: <20111204215859.695b31aa@notabene.brown>
In-Reply-To: <4EDB43DC.2050000@compulab.co.il>
References: <1321177790-5886-1-git-send-email-grinberg@compulab.co.il>
	<4ED205F9.3070908@compulab.co.il>
	<20111203123516.5ebb057b@notabene.brown>
	<4EDB43DC.2050000@compulab.co.il>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/W5PWILTS=WLrGgDoJNJrcbh"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/W5PWILTS=WLrGgDoJNJrcbh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 04 Dec 2011 11:56:44 +0200 Igor Grinberg <grinberg@compulab.co.il>
wrote:

> Hi Neil,
>=20
> On 12/03/11 03:35, NeilBrown wrote:
> > On Sun, 27 Nov 2011 11:42:17 +0200 Igor Grinberg <grinberg@compulab.co.=
il>
> > wrote:
> >=20
> >> ping!
> >=20
> > pong ...
> >=20
> >=20
> > Hi,
> >  I've been trying this patch out on my GTA04 with 3.2-rc4 and it doesn't
> >  work :-(
>=20
> Probably, v3.2-rc4 is not the best to try things out...
> This patch is based on v3.1, can you try v3.1, so at least we can
> check the that the patch itself has no problems?
> Also, CC'ing linux-omap.

I think I'll be able to give 3.1 a try - I'll let you know.


>=20
> >=20
> >  As soon as it tries to touch the i2c controller to send the power-down
> >  message I get:
> >=20
> > [   96.130920] Unhandled fault: external abort on non-linefetch (0x1028=
) at 0xfa070008
> > [   96.138885] Internal error: : 1028 [#1] PREEMPT
> > [   96.143585] Modules linked in: bluetooth ipv6 g_ether hso rfkill
> > [   96.149841] CPU: 0    Not tainted  (3.2.0-rc4+ #145)
> > [   96.155029] PC is at omap_i2c_wait_for_bb+0xc4/0x100
> > [   96.160186] LR is at omap_i2c_wait_for_bb+0xac/0x100
> > [   96.165344] pc : [<c02e84d4>]    lr : [<c02e84bc>]    psr: 60000013
> > [   96.165344] sp : d4a1ddc0  ip : d4a1dd20  fp : 00000002
> > [   96.177246] r10: 00000002  r9 : c0d1f2c8  r8 : dbda9c00
> > [   96.182678] r7 : c05d2a88  r6 : dbda9c00  r5 : ffff9aa8  r4 : c0d1f4=
58
> > [   96.189453] r3 : 00000008  r2 : 00000002  r1 : fa070000  r0 : 000000=
01
> > [   96.196228] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Seg=
ment user
> > [   96.203643] Control: 10c5387d  Table: 8bdc8019  DAC: 00000015
> > [   96.209625] Process poweroff (pid: 722, stack limit =3D 0xd4a1c2f0)
> >=20
> > The call trace is=20
> > [   96.373413] [<c02e84d4>] (omap_i2c_wait_for_bb+0xc4/0x100) from [<c0=
2e8aa8>] (omap_i2c_xfer+0x34/0x4fc)
> > [   96.383178] [<c02e8aa8>] (omap_i2c_xfer+0x34/0x4fc) from [<c02e6978>=
] (i2c_transfer+0xac/0x130)
> > [   96.392211] [<c02e6978>] (i2c_transfer+0xac/0x130) from [<c0259d20>]=
 (twl_i2c_read+0xd8/0x12c)
> > [   96.401153] [<c0259d20>] (twl_i2c_read+0xd8/0x12c) from [<c025ba0c>]=
 (twl4030_power_off+0x34/0x124)
> > [   96.410583] [<c025ba0c>] (twl4030_power_off+0x34/0x124) from [<c000f=
130>] (machine_power_off+0x1c/0x28)
> > [   96.420349] [<c000f130>] (machine_power_off+0x1c/0x28) from [<c004ad=
94>] (sys_reboot+0x124/0x1e0)
> > [   96.429565] [<c004ad94>] (sys_reboot+0x124/0x1e0) from [<c000e780>] =
(ret_fast_syscall+0x0/0x3c)
>=20
> Have you modified the patch?
> Because, there is no twl_i2c_read() call in twl4030_power_off() function.=
..
> Are there any other changes we need to be aware of?

Yes I did, but with the unaltered patch I still got the crash in
omap_i2c_wait_for_bb.  I was just seeing if reading would work when writing
didn't.


>=20
> >=20
> >=20
> > It has accessed this same address 0xfa070008 multiple times during norm=
ally
> > running, but here at shutdown it gets an external abort.
> > Presumably something is being turned of earlier in the shutdown sequenc=
e so
> > that i2c is no longer available, but I have no idea what.
>=20
> What distro are you using?

Debian

> Does it do any kernel related sub systems power games?

I don't think so, no.


>=20
> >=20
> > Do you have any idea what might be being disabled/turned-off/unmapped/
> > cleared/whatever that could cause this?
>=20
> No idea currently, I need to examine the changes between v3.1 and v3.2-rc=
4.
>=20
> >=20
> > I see:
> > [   96.029968] twl 1-0048: shutdown
> > [   96.038604] i2c i2c-1: shutdown
> >=20
> > amongst the messages, but as far as I can tell there is no actual shutd=
own
> > method for these to call so they don't do anything.
> >=20
> > Ideas?
>=20
> I haven't seen those messages in my v3.1.
> I will try to look at this, but it will take time
> as I'm on something else right now.
>=20

These messages are generated by having CONFIG_DEBUG_DRIVER defined.
It's just showing that device_shutdown() had tried to shut these things dow=
n.


Thanks,
NeilBrown

--Sig_/W5PWILTS=WLrGgDoJNJrcbh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTttSeTnsnt1WYoG5AQKY5g/+J5OX1pc9ZKFy4B23WSU5mB01Lvjh8DJE
jY3/aqX3k5wtGGu3X9IYfAS4wYW1TqOu8ZGhyexLvm1eX5kiEkzEA4pFN4n5vL4o
tqY9YphUg6DDoAD9c3zdqzAKtPyf4DB0yHB2IDGykN1Qp0D9DsNjUTJM1dY7CaHU
SSJd9tObKHHDDj1RvqeCDkHH12UCG6e+6KOlTQmionhltbn9TySr3qCh/NzHB6T4
Fca0ZYdp1/IO4Vre1bpYc2vLYjTEDIZu3MbnBwlM56R/3WxnnGiCy0ShzUqkWXsF
48GyJeAqsXxWka5IGZVnZJf3nlrOEm26p417alcoO+jmAfblLVF/3vuClK1hyN+c
LfFnoUdXrfazQ71BHsThI+PPaH8GysCmqWFul7sy8XJKUvqTeNJkA4EwcSoM3Llw
PuhkbG/j8+uQfNbRO/E3PL+o/kp0Y4BihGWUNw6SFzoZOB40v7GwZUsCIbIzAqlt
J0yjgZkkhtwq8UfAt9vCTMvJiEtjnBaCtbQHDT3vL1bGjwbXe/0MGJ1dHimvf3SX
NK3tRTG3aNnbT0Q8JmDCT0qqo9YEhJdiP37lR7npAzr8/yKgerjMtmPK8kVZXcGZ
pRt51UEnvaJVsQbjIs/cHJMGt+/szW1ut6fe3vkyFa4UOkYGJAMsFJu1tSUTLn0d
GgbY+rUM/eg=
=xk7y
-----END PGP SIGNATURE-----

--Sig_/W5PWILTS=WLrGgDoJNJrcbh--
