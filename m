Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2A3QB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:01:58 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:47789 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab2A3QB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:01:56 -0500
Date: Mon, 30 Jan 2012 11:01:55 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH 3/4 V10] Add ioctl for KVMCLOCK_GUEST_STOPPED
Message-ID: <20120130160155.GC6875@mgebm.net>
References: <1326825641-15765-1-git-send-email-emunson@mgebm.net>
 <1326825641-15765-4-git-send-email-emunson@mgebm.net>
 <4F26B220.9050101@redhat.com>
 <20120130153244.GA6875@mgebm.net>
 <4F26BC1A.8060002@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <4F26BC1A.8060002@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jan 2012, Avi Kivity wrote:

> On 01/30/2012 05:32 PM, Eric B Munson wrote:
> > >=20
> > > Can you point me to the discussion that moved this to be a vm ioctl? =
 In
> > > general vm ioctls that do things for all vcpus are racy, like here.=
=20
> > > You're accessing variables that are protected by the vcpu mutex, and =
not
> > > taking the mutex (nor can you, since it is held while the guest is
> > > running, unlike most kernel mutexes).
> > >=20
> >
> > Jan Kiszka suggested that becuase there isn't a use case for notifying
> > individual vcpus (can vcpu's be paused individually?
>=20
> They can, though the guest will grind to a halt very soon.
>=20
> > ) that it makes more sense
> > to have a vm ioctl.
> >
> > http://thread.gmane.org/gmane.comp.emulators.qemu/131624
> >
> > If the per vcpu ioctl is the right choice I can resend those patches.
>=20
> The races are solvable but I think it's easier in userspace.  It's also
> more flexible, though I don't really see a use for this flexibility.
>=20

Okay, I will rebase the per vcpu patches and resend those.

Eric

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJr7yAAoJEKhG9nGc1bpJQhsP/RkU11sX0jurHXtYNTRWpHtS
I3L784GLjY3FMOIE5Ox12+m0MMzTXXlnr5cA7wYB0MNYwp6jf6RazIOwv6j6LrKJ
d1a3AWwluQ5ZZ6a8B223m4BXVz5aDifIhcUGQZFzcpdQVQFvn6i8O961u0zRxwCi
IGezhs16e18KgJywKt02DUnfZvbZiok2LXFRtFwdu4gOGUmIhF0D5kGqBTUdZwnF
Mtim2ibSZT3Ccp1PzoZnFIWuwhmqbXV/ozm+/SA29Wj7M1LSgiYIer/M3XkaSvE6
hE16Fr7IKPZjRX/SbGJRUnMk/UKPyo8UfJyGlbkF5cBt4/zC354elKqPru67vuSe
SpCMeWqQDTYDyFmd+g/uUyCm/lmyxdtvrLgLtZN2K0jhjglrN4zdSd4dphchAIFn
FmJLcs+ygP58ViLGacU+jriSmYomNKoP1CbtV6i5fQaP9Ob1xpjH3CyPlY/o1lDE
JN8ilRDdTYNrIg1mwuJFZX02aMMnthSF2WvbhLVPPabYArNHVQHkhEqZ/Vkx0WzW
0MgSQMhAo/zW4K2lgqAIIJmeGld9aIG/RJkQJVrVCdu1JoiEL4b5oDM0Njrghdi0
mKWzgepBep6pxpSurOzQcgJ0VTuJ5c7tjt3Nz5WI0UmxRIEX80QLhz3l2VbQkAjq
70N4vkfD35GeHruWGLS/
=geGP
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
