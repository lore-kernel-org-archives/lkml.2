Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1JXTxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:53:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56311 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1JXTxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:53:19 -0400
Date: Mon, 24 Oct 2011 21:53:13 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Kletzing <devzero@web.de>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Artem.Bityutskiy@nokia.com,
        linux-mtd@lists.infradead.org
Subject: Re: [BUG] Re: mtd_stresstest module bricked my dockstar
Message-ID: <20111024195313.GA6326@pengutronix.de>
References: <69501156.1798237.1319395066798.JavaMail.fmail@mwmweb003>
 <20111024055705.GA4020@1wt.eu>
 <B10F15EA8AB74E698DC0D94563A30BE7@samsungnetbook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <B10F15EA8AB74E698DC0D94563A30BE7@samsungnetbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2011 at 09:32:42PM +0200, Roland Kletzing wrote:

CCing the mtd-list...

> Hello,
>=20
> cc`ing correct email of Adrian Hunter and i found that
> mtd_torturetest (and the
> other modules) have the same issue and there is another author i
> could find the
> email for.
>=20
> >If you can't restore it with JTAG, it means the hardware is really dead.
> >JTAG is used when you blank the flash, and is supposed to work. I don't
> >know what the module does, but I fail to see how to could wear the flash
> >that fast. At worst it could have wiped it, or the flash was already bad.
>=20
> Yes, i think accidentally insmodding  "mtd_stresstest" has just
> wiped it, not killed.
> The problem is, that it is important stuff for booting and you can`t
> pull it out and
> re-write externally, like a disk. Sorry, i that was probably not
> clearly stated.
>=20
> Anyway - what would people think if linux had a kernel module  which wipes
> /dev/sda1 when loaded ? :)
>=20
> >I got one Iomega Iconnect with a faulty flash that I got replaced for a
> >good one, so it's more likely the case here.
>=20
> Yes, i could give debricking with JTAG a try. But what about the
> cost for the JTAG
> and the work to be spent with it? I could buy another Dockstar for that..=
=2E..
>=20
> >I agree with you. I remember the very old ISA NE2000 driver who used to
> >scan various addresses to find a NIC, causing some of them to reconfigure
> >their address to *none* and definitely stop responding on the bus to any
> >reconfiguration request. That was pretty annoying too. After killing a
> >few, I stopped using Linux on a machine with such a NIC for a long time!
>=20
> Oh, that could be an explanation why i had 2 broken NE2000 NICs in
> the nineties.. ;)
>=20
> >You should keep it and retry the JTAG adapter. You just need a boot load=
er
> >so if you manage to find a usable memory location that you can select by
> >soldering two pins together, you could manage to store it and bood from
> >another device.
>=20
> I`m sure debricking with JTAG is possible and it would be an
> interesting task.
> Maybe i like to spend some money and time with this one day. For now
> i don`t.
>=20
> In the meantime i`d rather being interested in what can be done to add mo=
re
> safety to the mtd tests.
>=20
> By writing these lines and looking into the source, i started
> getting curious -  i
> see there is dev param with that module(s), but i did not pass a
> device number,
> nor did i pass anything to it.
>=20
> in
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dblob;f=
=3Ddrivers/mtd/tests/mtd_stresstest.c;h=3D63920476b57a24c7e61563303eb3abb77=
3b73fdf;hb=3D7163cea15f7b362795b858e7c130cd617aecc0aa
>=20
> i see:
>=20
> static int dev;   <-!
> module_param(dev, int, S_IRUGO);
> MODULE_PARM_DESC(dev, "MTD device number to use");
>=20
> static int count =3D 10000;
> module_param(count, int, S_IRUGO);
> MODULE_PARM_DESC(count, "Number of operations to do (default is 10000)");
>=20
> and then
>=20
> static int __init mtd_stresstest_init(void)
> {
> 	int err;
> 	int i, op;
> 	uint64_t tmp;
>=20
> 	printk(KERN_INFO "\n");
> 	printk(KERN_INFO "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D\n");
> 	printk(PRINT_PREF "MTD device: %d\n", dev);
>=20
> 	mtd =3D get_mtd_device(NULL, dev);
> 	if (IS_ERR(mtd)) {
> 		err =3D PTR_ERR(mtd);
> 		printk(PRINT_PREF "error: cannot get MTD device\n");
> 		return err;
> 	}
>=20
>=20
>=20
> My kernel log showed:
>=20
> mtd_stresstest: MTD device: 0
> mtd_stresstest: MTD device size 1048576 etc...
>=20
> So, apparenly the module accidentally picked mtd0 instead of exiting
> cleanly (as
> i did not pass a device number)
>=20
> I`m not a programmer, but doesn`t look that like an "unitialized
> variable" issue ?
>=20
> If yes, then i would call my Dockstar "victim of a bug".

No, that's okay. Check http://en.wikipedia.org/wiki/.bss

I wonder though, if it makes sense to initialize it with -EINVAL or somethi=
ng,
so a user is forced to use the dev-module parameter?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6lwikACgkQD27XaX1/VRsesACaAyoGsChHwmsCA22KPaF/fWGf
1CYAn3VmB16sfVSGsUk54ZNzvgU7C0Hp
=FkRp
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
