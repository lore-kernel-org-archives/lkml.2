Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2KYW74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 17:59:56 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:53113 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2KYW7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 17:59:55 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sun, 25 Nov 2012 23:59:55 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
Message-ID: <20121125225954.GA14653@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Dimitrios Apostolou <jimis@gmx.net>,
	linux-kernel@vger.kernel.org
References: <1353851735.22969.18.camel@soupermouf>
 <1353871800.22969.28.camel@soupermouf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <1353871800.22969.28.camel@soupermouf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-11-25 Sunday at 21:30 +0200 Dimitrios Apostolou wrote:
> On Sun, 2012-11-25 at 15:55 +0200, Dimitrios Apostolou wrote:
> > on an old PIII-500MHz laptop, 128MB RAM, kernel 3.6.6, I started a
> > backup process (tar|xz -4, nice'd and ionice'd -c3) from ext4 on local
> > ATA disk to ext3 on external USB disk (USB-2.0 port on PCMCIA card).
> > Even though earlier system load was minimal, free memory was plenty, the
> > system now is unresponsive and is thrashing the disk, but the swapfile
> > is rarely touched.
>=20
> I'm now having the same experience even though I replaced xz (which
> needed ~50MB RAM) with gzip. Even though I feel the realtime root shell
> is a bit more responsive than before, the OOM killer is out killing=20
> small processes like syslog-ng and systemd-logind... The
> ext4_inode_cache slab is taking almost all my memory (117MB). Please
> advise!

Hello Dimitrios,

I would try a 2.6.27.* kernel, for following reasons:

(1)  Kernel development since 2.6.27 achieved significant performance=20
improvements at the cost of exploding memory consumption by the kernel for=
=20
_internal_  data structures.  I am currently using a 3.2.34 kernel on a Not=
ebook=20
with 4 G RAM.  0,5 =E2=80=A6 1 G RAM is usually occupied just by kernel sla=
b [1];  this=20
memory cannot be swapped, it cannot be released by other means than rebooti=
ng,=20
and there seems to be  _no_  adjustment to memory pressure.  I am surprised=
,=20
that you have managed to boot a 3.6.* kernel at all with only 128 M RAM.

(2)  At the time, when I used a PIII-Notebook, kernels 2.6.27 to 2.6.29 whe=
re=20
current.  Thus chances are good, that a 2.6.27.* kernel will support chipse=
t,=20
PCI bus and devices of your notebook.  2.6.27 got longterm maintainance, th=
e=20
latest release in the linux-stable git repository is 2.6.27.62.
So Q @ LKML community:
Does anybody know a x86 distribution or live-CD using a 2.6.27.* kernel?


[1]  Picture described in my LKML message
Date:  Fri, 20 Jan 2012 01:08:00 +0100
Subject:  Re: [kmemleak report 1/2] kernel 3.1.6, x86_64: mm, xfs ?, vfs ?
remained the same with  _every_  3.1.* and 3.2.* kernel tried so far.


--=20
Roland

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCyouoACgkQdN/hKfT7G/K2wQCgxKUX7QbffPw5jeWzEhpqSe6C
5rQAnjjvzn9z9ETD10pmvUa2yrdYs0JX
=ok37
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
