Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2A3Ivk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:51:40 -0500
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:60084 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2A3Ivj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:51:39 -0500
Message-ID: <1327913505.2285.3.camel@scapa>
Subject: Re: [3.2+] BUG: scheduling while atomic: swapper/0/0/0x10000100
From: Yves-Alexis Perez <corsac@debian.org>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Date: Mon, 30 Jan 2012 09:51:45 +0100
In-Reply-To: <87hazi56rw.wl%kuninori.morimoto.gx@renesas.com>
References: <1327587732.2296.25.camel@scapa>
	 <20120126161539.GA2098@kroah.com>
	 <20120126163130.GB8665@legolas.emea.dhcp.ti.com>
	 <1327595767.2062.7.camel@scapa>
	 <20120126164512.GD8665@legolas.emea.dhcp.ti.com>
	 <87hazi56rw.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-OsyW8M8FugFk1QTEdmkm"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OsyW8M8FugFk1QTEdmkm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(dropping linux-usb and relevant people from CC:)

On jeu., 2012-01-26 at 16:27 -0800, Kuninori Morimoto wrote:
> Hi All
>=20
> > > > Specially when you consider the fact that
> > > > it's very recently that we dropped the ARCH dependency with commit
> > > > d242c110c43b55aaf3ebb3ceac1eeab0d452a177
> > > >=20
> > > > > Kuninori, any thoughts about this?  Should I revert this from the
> > > > > tree?
> > > >=20
> > > > I don't think so, I think this was a bad bisection.
> > > >=20
> > > Maybe (especially since the first bad commit is a merge commit, so I'=
m
> > > not completely sure I did correctly the second bisect). But I'm puzzl=
ed
> > > why reverting the commit on top of 3.2.1 fixes that. And now that Fel=
ipe
> > > mentions it, USB Gadget is not even compiled, so I'm completely lost.
> >=20
> > Hehehe :-) That's fun... Maybe it's some other instability and it just
> > didn't kick when you reverted that commit. It could be that the problem
> > is somewhere completely different and you just didn't fully debug it ye=
t
> > :-)
>=20
> I was very much surprised at this issue.
> As Felipe explained, renesas_usbhs was for SuperH system.
> x86 can not use it,
> but, if your PC has "renesas_usbhs.ko" as kernel module,
> and loaded it somehow...
>=20

I redid the bisect a bit more thoroughly, using the (original) exact
same config as the Debian kernel. I get:

git bisect bad
ec7ae517537ae5c7b0b2cd7f562dfa3e7a05b954 is the first bad commit

with:

corsac@scapa: git bisect log
# bad: [805a6af8dba5dfdd35ec35dc52ec0122400b2610] Linux 3.2
# good: [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
git bisect start 'v3.2' 'v3.1'
# good: [68d99b2c8efcb6ed3807a55569300c53b5f88be5] Merge branch 'for-linus'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good 68d99b2c8efcb6ed3807a55569300c53b5f88be5
# bad: [0de9adf284ec20454ecf37ffd98e7e98ba7292d6] MAINTAINERS: Update eCryp=
tfs maintainer address
git bisect bad 0de9adf284ec20454ecf37ffd98e7e98ba7292d6
# bad: [b4beb4bf9934d151bf4581a54ae028927374cb2a] Merge branch 'for-linus/i=
2c-3.2' of git://git.fluff.org/bjdooks/linux
git bisect bad b4beb4bf9934d151bf4581a54ae028927374cb2a
# bad: [df9d6985be2a7e7683c46e4c6ea608fc69f02b45] mm: do not drain pagevecs=
 for mlockall(MCL_FUTURE)
git bisect bad df9d6985be2a7e7683c46e4c6ea608fc69f02b45
# good: [b57287ba497b63a0d87a058631bbddfed9392e9f] video: platinumfb: Add _=
_devexit_p at necessary place
git bisect good b57287ba497b63a0d87a058631bbddfed9392e9f
# bad: [41684f67af75b04152a1714e1a5375dfb00ee3da] Merge branch 'gpio/next' =
of git://git.secretlab.ca/git/linux-2.6
git bisect bad 41684f67af75b04152a1714e1a5375dfb00ee3da
# good: [ffaac8f45bfb2dffb78179baa5740de34058eef8] [SCSI] libsas: Allow exp=
ander T-T attachments
git bisect good ffaac8f45bfb2dffb78179baa5740de34058eef8
# good: [d4a759a954072dcb0a0bbd64ec4bc5252182d032] [SCSI] megaraid_sas: Fix=
 mismatch in megasas_reset_fusion() mutex lock-unlock
git bisect good d4a759a954072dcb0a0bbd64ec4bc5252182d032
# good: [590134fa78fbdbe5fea78c7ae0b2c3364bc9572f] [SCSI] qla4xxx: export a=
ddress/port of connection (fix udev disk names)
git bisect good 590134fa78fbdbe5fea78c7ae0b2c3364bc9572f
# good: [76c05c8a0d56faf210cb9681786bb3e17cd59793] gpio: pl061: add DT bind=
ing support
git bisect good 76c05c8a0d56faf210cb9681786bb3e17cd59793
# good: [83eaea22bdfc9e1cec88f81be5b64f30f6c37e8b] Revert "ceph: don't trun=
cate dirty pages in invalidate work thread"
git bisect good 83eaea22bdfc9e1cec88f81be5b64f30f6c37e8b
# good: [3310f7541f0c991b51324a7712db51fb8f912601] ceph: fix 32-bit ino num=
bers
git bisect good 3310f7541f0c991b51324a7712db51fb8f912601
# good: [97d2eb13a019ec09cc1a7ea2d3705c0b117b3c0d] Merge branch 'for-linus'=
 of git://ceph.newdream.net/git/ceph-client
git bisect good 97d2eb13a019ec09cc1a7ea2d3705c0b117b3c0d
# good: [d92ef29a6fa971d9e314e412cd9c09757906411a] h8300: Move gpio.h to gp=
io-internal.h
git bisect good d92ef29a6fa971d9e314e412cd9c09757906411a
# bad: [ec7ae517537ae5c7b0b2cd7f562dfa3e7a05b954] Merge git://git.kernel.or=
g/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
git bisect bad ec7ae517537ae5c7b0b2cd7f562dfa3e7a05b954

As the first bad commit is again a merge commit, I'll redo the bisect
with both ends commit (so 97d2eb1 590134f afaict).

Regards,
--=20
Yves-Alexis

--=-OsyW8M8FugFk1QTEdmkm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJPJlohAAoJEDBVD3hx7wuomYwQAM/Wt1FmMQSaA0b4yQQlR45J
GVd4e07qwpJ8RYxwfFIWPoDnmK+tXrdqNEYY6CdTUJ/mVNX//7uawBo/bFmW6d+V
P6ZeEGWmRODa5zvLhdmXDUkkLe9lGf1mZ6VzRORsiWYyZ+YpGokwDYEqIgXKVZIQ
dPV9zGcSGoi29DI6OF3QeZaxvTsyXWq6rvPSoEk8V66Akn7OhdfmeBkJmkLs5QI6
aWqM2gGUK6xdypV7qruz2u3IuttheuzeQl3eozgcZ7iFdu1S6iZolNN0/3ueUe30
D3PAbKpgd7vO/ig3u0FES9Jw6cIdBy+DgHnOl3JX2DJrptX49GRAX74jpjaEeEtO
iR98zakKpv/EfbpmV1rVJZG3juXUqTOb1wiMA1GoENOA7m47W3LdEAhEPPsKieip
jiTwabgWs3LmGZk653YDwCu10jr303MK+MN/5P69AGzVkekAepRsR/r6G+UsCS4E
y3X5AVbiSxJG9gpwggdh1oSoeJekX8JRWphL9+Sl+ndHKR/Vp5AuZxIz6w8OnYbe
pQWE5OVxwsTOYKlf4tQ2e496SkjtmcTg5/AyGvLwr5YF0fUB9egp8mSjNDir3aY+
srO1sX4/HRkogOhtJqKZ4bF0gwDGaGA0NY+yC4g/vAi4mjrVIpiqADosRA1p5v/9
9LftzSE1TtGX9aiUQmRX
=Kb9V
-----END PGP SIGNATURE-----

--=-OsyW8M8FugFk1QTEdmkm--
