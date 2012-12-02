Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2LBWu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 17:50:56 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:52177 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2LBWuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 17:50:54 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sun, 2 Dec 2012 23:50:51 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
Message-ID: <20121202225051.GA13685@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Dimitrios Apostolou <jimis@gmx.net>,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Theodore Ts'o <tytso@mit.edu>
References: <1353855815.22969.20.camel@soupermouf>
 <1354452243.22969.48.camel@soupermouf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <1354452243.22969.48.camel@soupermouf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-11-25 Sun 23:59:55 +0100 Roland Eggner wrote:
>On 2012-11-25 Sunday at 21:30 +0200 Dimitrios Apostolou wrote:
> > On Sun, 2012-11-25 at 15:55 +0200, Dimitrios Apostolou wrote:
> > > on an old PIII-500MHz laptop, 128MB RAM, kernel 3.6.6, I started a
> > > backup process (tar|xz -4, nice'd and ionice'd -c3) from ext4 on local
> > > ATA disk to ext3 on external USB disk (USB-2.0 port on PCMCIA card).
> > > Even though earlier system load was minimal, free memory was plenty, =
the
> > > system now is unresponsive and is thrashing the disk, but the swapfile
> > > is rarely touched.
> >
> > I'm now having the same experience even though I replaced xz (which
> > needed ~50MB RAM) with gzip. Even though I feel the realtime root shell
> > is a bit more responsive than before, the OOM killer is out killing
> > small processes like syslog-ng and systemd-logind... The
> > ext4_inode_cache slab is taking almost all my memory (117MB). Please
> > advise!
>=20
> Hello Dimitrios,
>=20
> I would try a 2.6.27.* kernel, for following reasons:
>=20
> (1)  Kernel development since 2.6.27 achieved significant performance
> improvements at the cost of exploding memory consumption by the kernel for
> _internal_  data structures.  I am currently using a 3.2.34 kernel on a N=
otebook
> with 4 G RAM.  0,5 =E2=80=A6 1 G RAM is usually occupied just by kernel s=
lab [1];  this
> memory cannot be swapped, it cannot be released by other means than reboo=
ting,
> and there seems to be  _no_  adjustment to memory pressure.  I am surpris=
ed,
> that you have managed to boot a 3.6.* kernel at all with only 128 M RAM.
>=20
> (2)  At the time, when I used a PIII-Notebook, kernels 2.6.27 to 2.6.29 w=
here
> current.  Thus chances are good, that a 2.6.27.* kernel will support chip=
set,
> PCI bus and devices of your notebook.  2.6.27 got longterm maintainance, =
the
> latest release in the linux-stable git repository is 2.6.27.62.
> So Q @ LKML community:
> Does anybody know a x86 distribution or live-CD using a 2.6.27.* kernel?
>=20
>=20
> [1]  Picture described in my LKML message
> Date:  Fri, 20 Jan 2012 01:08:00 +0100
> Subject:  Re: [kmemleak report 1/2] kernel 3.1.6, x86_64: mm, xfs ?, vfs ?
> remained the same with  _every_  3.1.* and 3.2.* kernel tried so far.


On 2012-12-02 Sunday at 14:44 +0200 Dimitrios Apostolou wrote:
> Hi, the problem in the quoted message still happens, shouldn't all of
> ext4_inode_cache slab be emptied after "echo 3
> > /proc/sys/vm/drop_caches"? In my case slab uses too much memory even
> after all processes finish and system is in bad shape due to lack of
> physical RAM. CC'ing tytso and Catalin Marinas since I've not been able
> to track any leak with kmemleak.
>=20
> Kernel is booted with slub_debug=3D,ext4_inode_cache, as this is the only
> way to avoid for some time the following message. Nevertheless it has
> not been able to show any leak.
>=20
> kmemleak: Cannot allocate a kmemleak_object structure
> kmemleak: Automatic memory scanning thread ended
> kmemleak: Kernel memory leak detector disabled
>=20
> Please have a look at the log (archived at [1]).
>=20
> [1] http://lkml.indiana.edu/hypermail/linux/kernel/1211.3/00183.html


Hello Dimitrios!


Which part of =E2=80=A6

=E2=80=9C0,5 =E2=80=A6 1 G RAM is usually occupied just by kernel slab [1];=
  this
memory cannot be swapped, it cannot be released by other means than rebooti=
ng,
and there seems to be  _no_  adjustment to memory pressure.=E2=80=9D=20

=E2=80=A6 should I explain?


When tar or gzip writes to ext4 filesystem on your external disk, the kerne=
l=20
keeps all inode data in slab memory  _by design_ , not by memory leaks.
Several 100 M slab data cannot be stored within 128 M total RAM.
This cannot by solved by usage of /proc/sys/vm/drop_caches.
This cannot by solved by oom-killer-actions.
This cannot be solved by zram tricks.
Unmounting the external disk would release part of slab memory, but then you
cannot backup.
Reformatting the ext4 filesystem on your external disk with 128 byte inode =
size,=20
largest possible blocksize and with extents enabled might mitigate the memo=
ry=20
pressure slightly =E2=80=A6 probably not sufficient to get a working system=
 with 3.6=20
kernel.


One advantage of Linux compared to other OS is much more support for old=20
hardware, if a  _proper_  kernel version is selected.  Many years ago I used
a notebook with 40 M total RAM, with a 2.4 kernel, Blackbox window manager =
and
Opera web browser =E2=80=A6 it worked flawlessly =E2=80=A6 just rather slow=
ly due to swapping. =20
Your notebook has much more RAM than 40 M, thus there is surely a Linux sol=
ution=20
for you.  Try a 2.6.27.62 kernel, it supports ext4 (=E2=80=9Cext4dev=E2=80=
=9D), probably it=20
supports all devices of your notebook, and with a slim window manager e.g. =
=20
WindowMaker or OpenBox your notebook will probably =E2=80=9Cfly=E2=80=9D.


PS:  Please type your reply below the text you are replying to.

--=20
Roland

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlC720sACgkQdN/hKfT7G/LKUACfQQcG89JdUmPcYCpzMRP1LwZF
at0AnA59j9iUvBUONFBCo60jB6jn+P/T
=x35G
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
