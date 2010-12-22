Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0LVNcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:32:03 -0500
Received: from virgo.iok.hu ([212.40.97.103]:59581 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab0LVNcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:32:01 -0500
Date: Wed, 22 Dec 2010 14:31:55 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, shenghui <crosslonelyover@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
Message-ID: <20101222133154.GS10557@genesis.frugalware.org>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
 <1277808215.1868.5.camel@laptop>
 <20101219020313.GJ31750@genesis.frugalware.org>
 <20101222002248.GP10557@genesis.frugalware.org>
 <1293006589.2170.41.camel@laptop>
 <1293007311.11370.172.camel@marge.simson.net>
 <1293008842.2170.70.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlsYxwg8UDQn+EKZ"
Content-Disposition: inline
In-Reply-To: <1293008842.2170.70.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlsYxwg8UDQn+EKZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 22, 2010 at 10:07:22AM +0100, Peter Zijlstra <peterz@infradead.=
org> wrote:
> On Wed, 2010-12-22 at 09:41 +0100, Mike Galbraith wrote:
> > On Wed, 2010-12-22 at 09:29 +0100, Peter Zijlstra wrote:
> > > On Wed, 2010-12-22 at 01:22 +0100, Miklos Vajna wrote:
> > > > Please let me know if you need more info.
> > >=20
> > > What distro are you using? it looks like systemd is involved and I'm
> > > actively avoiding anything using that crap.

First, sorry about the systemd list, I did not know it's
subscriber-only.

This is Frugalware Linux, and it's disabled by default here as well.

> > Heh, gearing up to hunt a bug it triggers, just doing all I had to do to
> > get the thing built and installed blew my box _all up_.  I still have
> > smoldering bits lying about a week later.
>=20
> There's a reason I was asking for a qemu image ;-), I'm not letting that
> stuff anywhere near my regular machines.

Sure - here is a qcow image (871M):

http://frugalware.org/~vmiklos/files/systemd.img

Here is how I started it:

qemu-kvm -vnc :0 -m 1G -hda systemd.img

$ qemu-kvm -version
QEMU PC emulator version 0.12.3 (qemu-kvm-0.12.3), Copyright (c) 2003-2008 =
Fabrice Bellard

There are two menu entries in grub config - first is sysvinit, that
boots up correctly here, you can login using root / root. The second is
systemd, that just panics here almost all the time. In case it would
not, use 'systemctl emergency' as root and that will trigger the bug. :)

If you need more packages in the virtual machine and the pacman package
manager sounds exotic, here is a quick help:

http://frugalware.org/docs/pacman-g2#_apt_pacman_g2_cross_reference

Thanks,

Miklos

--UlsYxwg8UDQn+EKZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0R/coACgkQe81tAgORUJbeNQCfene0h38HZsRYHWavdKPKrjPC
UhUAni/5sEqmhHjk0DSTV5ttMWfV0PSa
=x5FW
-----END PGP SIGNATURE-----

--UlsYxwg8UDQn+EKZ--
