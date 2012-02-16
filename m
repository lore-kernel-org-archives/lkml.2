Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2BPBET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 20:04:19 -0500
Received: from ozlabs.org ([203.10.76.45]:49638 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab2BPBEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 20:04:16 -0500
Message-ID: <1329354245.6976.25.camel@concordia>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Arnd Bergmann <arnd@arndb.de>
Cc: qemu-devel@nongnu.org, Alexander Graf <agraf@suse.de>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>,
        Scott Wood <scottwood@freescale.com>, Avi Kivity <avi@redhat.com>
Date: Thu, 16 Feb 2012 12:04:05 +1100
In-Reply-To: <201202152221.36154.arnd@arndb.de>
References: <4F2AB552.2070909@redhat.com>
	 <1328597934.6802.6.camel@concordia>
	 <F1B17875-23E2-4965-BE05-6A3858995D21@suse.de>
	 <201202152221.36154.arnd@arndb.de>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-xIbcLUSlXIG2kPgm1IXr"
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xIbcLUSlXIG2kPgm1IXr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-15 at 22:21 +0000, Arnd Bergmann wrote:
> On Tuesday 07 February 2012, Alexander Graf wrote:
> > On 07.02.2012, at 07:58, Michael Ellerman wrote:
> >=20
> > > On Mon, 2012-02-06 at 13:46 -0600, Scott Wood wrote:
> > >> You're exposing a large, complex kernel subsystem that does very
> > >> low-level things with the hardware.  It's a potential source of expl=
oits
> > >> (from bugs in KVM or in hardware).  I can see people wanting to be
> > >> selective with access because of that.
> > >=20
> > > Exactly.
> > >=20
> > > In a perfect world I'd agree with Anthony, but in reality I think
> > > sysadmins are quite happy that they can prevent some users from using
> > > KVM.
> > >=20
> > > You could presumably achieve something similar with capabilities or
> > > whatever, but a node in /dev is much simpler.
> >=20
> > Well, you could still keep the /dev/kvm node and then have syscalls ope=
rate on the fd.
> >=20
> > But again, I don't see the problem with the ioctl interface. It's nice,=
 extensible and works great for us.
> >=20
>=20
> ioctl is good for hardware devices and stuff that you want to enumerate
> and/or control permissions on. For something like KVM that is really a
> core kernel service, a syscall makes much more sense.

Yeah maybe. That distinction is at least in part just historical.

The first problem I see with using a syscall is that you don't need one
syscall for KVM, you need ~90. OK so you wouldn't do that, you'd use a
multiplexed syscall like epoll_ctl() - or probably several
(vm/vcpu/etc).

Secondly you still need a handle/context for those syscalls, and I think
the most sane thing to use for that is an fd.

At that point you've basically reinvented ioctl :)

I also think it is an advantage that you have a node in /dev for
permissions. I know other "core kernel" interfaces don't use a /dev
node, but arguably that is their loss.

> I would certainly never mix the two concepts: If you use a chardev to get
> a file descriptor, use ioctl to do operations on it, and if you use a=20
> syscall to get the file descriptor then use other syscalls to do operatio=
ns
> on it.

Sure, we use a syscall to get the fd (open) and then other syscalls to
do operations on it, ioctl and kvm_vcpu_run. ;)

But seriously, I guess that makes sense. Though it's a bit of a pity
because if you want a syscall for any of it, eg. vcpu_run(), then you
have to basically reinvent ioctl for all the other little operations.

cheers

--=-xIbcLUSlXIG2kPgm1IXr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJPPFYFAAoJEFHr6jzI4aWAnxYP+QGUAtzWO6Pz341fZMhMqwQc
oxDEOW2Wnpa7+yPfpNyCG6TUagfvxoQQ7hJfuSTLS2b/6JDtRd0dXBSD8YLqz4pV
CtBYZ6LbfZdwWo8R7JElbMlyHiSPYD2w2DgWsh64Q3nT5dn9jBxq++zHM1W/x3Et
6/oZIT1Dm3hvrgeRE5Ly5WWopTpin/GnX82czlv6Wd3+XGCDpzHQa9ibHyMvP28U
mb+9WpG0BpQrjynqUCG/gyK/1i+3vV8E/AbiPhJKatH51YdHrKeKJTrlGBPJPxUO
MVIMQMIaetrAneMDdbpBKROTDyVXS5YuppdDNYm9Kbym/NQYHR+mYpkptk/XGMgx
YpaWwEgnKYHsY/9BGHHOFDWt6EZ0vCW7fUX6wmyYwXMPaP0tEgQsoy0XUWkH2m/n
8NF//68+YSvIX4ht7ldnDwDApSC27MqmZanNuY8zZDYIY9zS2epjdUIejwT+A6tk
Yx6gfpUw/cMJS8BhdbYsv+gyyzYCUH747g/dJcGIdiix8Qf/pJdD2G+eSdDib0wC
516nQoDcuCv6CmL3NgISoUKDyqCMyaKw4ouy/D2pWdfEqCXCk2msacSF9Ug2ZNd7
JCFU3j4GZInJQv25adeB7zzxOnX37dcsQqn5wvFpqj2hnOgXcyJcDuWUjlPL9Yhl
ZsOmNw2PQeVx0+MmR2og
=EYya
-----END PGP SIGNATURE-----

--=-xIbcLUSlXIG2kPgm1IXr--

