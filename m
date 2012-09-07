Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab2IGFyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:54:03 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:48485 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755490Ab2IGFx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:53:59 -0400
Date: Fri, 7 Sep 2012 08:49:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-serial@vger.kernel.org, Sourav Poddar <sourav.poddar@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        alan@linux.intel.com
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
Message-ID: <20120907054932.GB3136@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
 <87harahiv6.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <87harahiv6.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 06, 2012 at 03:44:13PM -0700, Kevin Hilman wrote:
> Felipe Balbi <balbi@ti.com> writes:
>=20
> > Hi guys,
> >
> > here's v4 of the omap uart patchset. No changes other than a rebase on =
top of
> > Greg's tty-next branch and Tony's Acked-by being added to a couple patc=
hes
> >
> > Note: I'm resending the series with Vikram's Software Flow Control fix =
anyway
> > as it can just be ignored if it's decided it needs to go into this merge
> > window.
>=20
> Sorry to be late to the party... just getting back from some time off.
>=20
> I'm assuming that this was not tested with PM, so decided I better do it

you assumed wrong. See the previous versions of the series and you'll
see I mention all the basic pm testing I did.

> myself seeing that Greg is has already merge it.  To test, I merged
> Greg's tty-next branch with v3.6-rc4 and did some PM testing.
>=20
> The bad news is that it doesn't even compile (see reply to [PATCH v4
> 20/21]). =20

yeah, that was an automerge issue when rebasing on greg's tty-next
branch, plus me assuming omap serial was already enabled on my .config
and not checking the compile output. Sent a patch now.

> Also, there is a big WARNING on boot[1], which seems to be triggered by
> a new check added for v3.6-rc3[2].  This appears to be introduced by
> $SUBJECT series, because I don't see it on vanilla v3.6-rc4.
>=20
> The good news is that after hacking to fix up the compile problems,
> basic PM testing seems to be fine: idle to retention and off as well as
> suspend to retention and off work fine on 3430/n900, 3530/Overo,
> 3730/OveroSTORM, 3730/Beagle-xM.
>=20
> Kevin
>=20
>=20
> [1]
> [    8.745666] WARNING: at /work/kernel/omap/pm/drivers/tty/tty_io.c:1420=
 tty_init_dev+0x14c/0x17c()
> [    8.755218] tty_init_dev: ttyO driver does not set tty->port. This wil=
l crash the kernel later. Fix the driver!
> [    8.765991] Modules linked in:
> [    8.769287] [<c0013d90>] (unwind_backtrace+0x0/0xf0) from [<c0036eec>]=
 (warn_slowpath_common+0x4c/0x64)
> [    8.779327] [<c0036eec>] (warn_slowpath_common+0x4c/0x64) from [<c0036=
f98>] (warn_slowpath_fmt+0x30/0x40)
> [    8.789550] [<c0036f98>] (warn_slowpath_fmt+0x30/0x40) from [<c02c626c=
>] (tty_init_dev+0x14c/0x17c)
> [    8.799224] [<c02c626c>] (tty_init_dev+0x14c/0x17c) from [<c02c68a4>] =
(tty_open+0x11c/0x52c)
> [    8.808258] [<c02c68a4>] (tty_open+0x11c/0x52c) from [<c00f86ac>] (chr=
dev_open+0x90/0x15c)
> [    8.817108] [<c00f86ac>] (chrdev_open+0x90/0x15c) from [<c00f2b74>] (d=
o_dentry_open+0x1e8/0x270)
> [    8.826507] [<c00f2b74>] (do_dentry_open+0x1e8/0x270) from [<c00f2c30>=
] (finish_open+0x34/0x4c)
> [    8.835784] [<c00f2c30>] (finish_open+0x34/0x4c) from [<c0102028>] (do=
_last.isra.21+0x5b0/0xbbc)
> [    8.845184] [<c0102028>] (do_last.isra.21+0x5b0/0xbbc) from [<c01026dc=
>] (path_openat+0xa8/0x44c)
> [    8.854675] [<c01026dc>] (path_openat+0xa8/0x44c) from [<c0102d34>] (d=
o_filp_open+0x2c/0x80)
> [    8.863708] [<c0102d34>] (do_filp_open+0x2c/0x80) from [<c00f3b6c>] (d=
o_sys_open+0xe8/0x184)
> [    8.872711] [<c00f3b6c>] (do_sys_open+0xe8/0x184) from [<c000db20>] (r=
et_fast_syscall+0x0/0x3c)
> [    8.882019] ---[ end trace e9bf408c37051346 ]---

This doesn't seem to be caused by $SUBJECT at all. See that we are
calling uart_add_one_port() which will call tty_port_register_device()
which, in turn, will call tty_port_link_device() and that will set
driver->ports[index] correctly.

Have you checked if this doesn't happen without my series before waving
your blame hammer ? FWIW, that part of the code wasn't change by
$SUBJECT at all.

--=20
balbi

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQSYrsAAoJEIaOsuA1yqREavoP/R0QnNP2EK2/otekNmK8UlRv
Bp3veviNWtMya53uaXINu9J1udhsGBHU69cYGh7PVB4PGo/glqAhlgFQs15CV11R
WtJyzPVPuVCi8PeGcnptiEYzmFOpgAicBoRR/vXX/Rh5eh5+Ht8ZID4YyfsEqRwI
KQ4j/g4aplI2k1qke5FAzuKSgB2SHkKGmJA/KEbRAPh3+vuWDtnqTBMMCg8oXT17
9dFbe6CSUPOefR2oRQXjzhcoysJ3ro+ysVuBbi5cmAMvKjDgLNJS2F//7YW85srI
xmE8AOmmmz19uyIU+SFQwouinKEDmm6Ma0OAbozfimjfSMzIuq7CSTbUlcvFprOm
5yTIQQh27pw4LhLh+ECQo//yais4gzII7npnQGcUxA3iZ966/z46QBJhfW2E/pSa
aHoWlm+COeq2NCoJu1WXoR/eoXbnwPC6x/XcsyCAssl30TAr7XWsIYQc+GSf1o6B
yOj6tv0NHMrnzcgJ+iYF3PThj+FqqRyY7QmzmMT3l5rbYpqSli9Hcj0qe09qlTG2
feBYg8iF/vDpAaWXWQTjCM6YQJVuzfGYecdieXfsqkURG+SAtX9HxZuHQQiZ+yuH
fyls3OrvrH8i+YoH/f4ysrSyxO/Tmh1mA8MZgnPOqMSWu4firES60bx0dvt+pRYa
3zJ+YFZ1PyYH3c9WxOMP
=zxNy
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
