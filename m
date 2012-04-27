Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855Ab2D0RRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:17:03 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54314 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760562Ab2D0RRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:17:01 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
Date: Fri, 27 Apr 2012 13:18:52 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc1; KDE/4.6.5; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Arnd Bergmann <arnd@arndb.de>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com> <201204271217.50048.vapier@gentoo.org> <20120427165306.GC14743@mudshark.cambridge.arm.com>
In-Reply-To: <20120427165306.GC14743@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1732173.JHaWXRmoi4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201204271318.54712.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1732173.JHaWXRmoi4
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday 27 April 2012 12:53:06 Will Deacon wrote:
> On Fri, Apr 27, 2012 at 05:17:47PM +0100, Mike Frysinger wrote:
> > On Friday 27 April 2012 06:42:55 Will Deacon wrote:
> > > The {read,write}s{b,w,l} functions are not defined across all
> > > architectures and therefore shouldn't be used by portable drivers. We
> > > should encourage driver writers to use the io{read,write}{8,16,32}_rep
> > > functions instead.
> >=20
> > well, that isn't true today as a grep of the drivers/ tree shows.=20
> > perhaps we should fix that first ?  quite a number of architectures do
> > implement these.
>=20
> Sure, and architectures can continue to implement these if they're using
> drivers that require them (I'll reintroduce them for blackfin). They
> shouldn't be used for new architectures though, so any drivers that are
> required by folks using asm-generic/io.h will need converting.

will they though ?  or without documentation, will they simply copy & paste=
=20
the interfaces from another arch to build the driver ?  most people doing a=
rch=20
ports (especially new ones) don't have the experience or confidence to push=
=20
back and update the driver rather than squirreling away 6 #define's into th=
eir=20
arch-specific asm/io.h.

> > > This patch removes the {read,write} string functions for the generic =
IO
> > > header as they have no place in a new architecture port.
> >=20
> > i don't see any file anywhere that describes what the baseline API is
> > supposed to be, and what each set of funcs are for.  there is just the
> > random ugliness in each arch's asm/io.h cobbled together until things
> > work.  i think that also needs to be addressed before we go
> > extending/contracting the API provides by asm-generic/io.h.
>=20
> I agree that it's a bit of a mess, but if we can keep the asm-generic
> interfaces clean then it can help driver writers see what we have as a
> common base. If a driver is not portable (maybe for some
> architecture-specific device) then they could use extra accessors if they
> really need to.
>=20
> The point of removing these functions is to make it clear that they're not
> part of the baseline API and instead encourage people to use other
> accessors instead if they want to write portable code.

maybe i'm pessimistic, but without addressing the underlying problem (writi=
ng=20
clear documentation on what should exist, what they're for, and specificall=
y=20
what functions *shouldn't* exist), we're just playing a losing game of whac=
k-
a-mole.  you remove an interface that appears to be mostly common, then=20
someone else posts a patch to add some other set of interfaces and people=20
don't notice, and we just keep flip-flopping.
=2Dmike

--nextPart1732173.JHaWXRmoi4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPmtT+AAoJEEFjO5/oN/WB2cIP/1F8CQ4pFw4xeF+IaaF6Njzp
SbHUo3wz8Myo0E3ZfJgalAbcG34iDh5kBRhlGcg+wi8Dxjto/UlO+1CgbtXUfQ0L
fjcdIjK5G2z+G1s5jB+pCtBW80obeWIPq8w1EzglFRto/exFvm0puxvXsxWyko1q
vg9Jao+0pa+yaIpelrp2+QHkqXoN8R7TVUph0DDnHHkaIsH9fFrDKyVvnCxbni6Q
QvyUd7tzlOHrrO+dmD87UvyzUEEkloUgQXBRbW6APjY05uUWM8NDzWslqIocGMZH
tePUqYX4SnWAZsQA+UN3boGoRSlw9qiJV9G6ttUUs3yyO6QWgDDf9sGtY2snmNgq
QU7q2m5yr5G4uUPnNlqCVIIBoy7a0Z1pgUuGUNgEJQVkePhJUgfr4tx+quCm3FIe
ykwdAX2q2d89GQRrovlzP0tPiy/RuRMtVuRRcVjxcAI/4HRBMN53PbqBsoIu03rt
F5QVlqQihTYC/RWynR6lOR+4qdXZGCMujcBhe21GGjhAVUHZ5yVvH99u7BB/IRQ1
e3Q2qBAfWsCitIYuUBULLZcMylp27cbThJ0rkWw7tNl1QUOsOlbIT1JkEC2dlIGN
UosR1g0iSbbdcUF4oUyNSs6CytVV01LaA+IpRorqNOlwd21dHNOAqkZEqM+nsVxA
cGyel6VegIYKVFh5opMo
=t0TV
-----END PGP SIGNATURE-----

--nextPart1732173.JHaWXRmoi4--
