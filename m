Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2HOOL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:11:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59661 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065Ab2HOOLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:11:55 -0400
Message-ID: <1345039901.824.221.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 20/82] ARM: 7467/1: mutex: use generic xchg-based
 implementation for ARMv6+
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@linaro.org>, Shan Kang <kangshan0910@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Wed, 15 Aug 2012 15:11:41 +0100
In-Reply-To: <20120815140808.GD22871@kroah.com>
References: <20120813201746.448504360@linuxfoundation.org>
	 <20120813201748.202917513@linuxfoundation.org>
	 <1345038982.824.216.camel@deadeye.wl.decadent.org.uk>
	 <20120815140808.GD22871@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2jV9f2W6gcBJ7KGJ9yIY"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2jV9f2W6gcBJ7KGJ9yIY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-08-15 at 07:08 -0700, Greg Kroah-Hartman wrote:
> On Wed, Aug 15, 2012 at 02:56:22PM +0100, Ben Hutchings wrote:
> > On Mon, 2012-08-13 at 13:18 -0700, Greg Kroah-Hartman wrote:
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > >=20
> > > 3.5-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Will Deacon <will.deacon@arm.com>
> > >=20
> > > commit a76d7bd96d65fa5119adba97e1b58d95f2e78829 upstream.
> > >=20
> > > The open-coded mutex implementation for ARMv6+ cores suffers from a
> > > severe lack of barriers, so in the uncontended case we don't actually
> > > protect any accesses performed during the critical section.
> > >=20
> > > Furthermore, the code is largely a duplication of the ARMv6+ atomic_d=
ec
> > > code but optimised to remove a branch instruction, as the mutex fastp=
ath
> > > was previously inlined. Now that this is executed out-of-line, we can
> > > reuse the atomic access code for the locking (in fact, we use the xch=
g
> > > code as this produces shorter critical sections).
> > >=20
> > > This patch uses the generic xchg based implementation for mutexes on
> > > ARMv6+, which introduces barriers to the lock/unlock operations and a=
lso
> > > has the benefit of removing a fair amount of inline assembly code.
> > [...]
> >=20
> > Here also, I think this should be deferred.
>=20
> "also"?  Am I missing some context here?  Why should we deferr this one?
> What do we need to wait for?

This is the same as 3.4.9-rc1 patch 10/65, which I queried as it
apparently caused a regression.

Will Deacon wrote:
> The additional patch should also be CC'd to stable and is sitting in -tip
> somewhere I believe, so it shouldn't be long before it does hit mainline.
>=20
> Without this patch there's a memory-ordering bug (which we seem to have h=
it
> once in > 5 years). With the patch there's a mutex lockup issue on SMP sy=
stems
> that I can provoke with enough hackbenching, so you may want to hold off =
for
> now.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-2jV9f2W6gcBJ7KGJ9yIY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCuuHue/yOyVhhEJAQroRQ/8DQHuFDUGRP+8fBVJ6Gmrk4NWH+avFF9t
muyGGpMce3lJVAALrNYF++aQOPxElt0KxbUlGglzI43nv40S9131S8mHWY+BHy9c
1sc7jNzCgoGWuTmpnbC4Iqfj0dJ/OeIKDXN/5GKQfUbl53yzzcPaFKyV4+KLbc98
99QI3SFV3XlSxUzNgM6+85FaTJVYuy9m+IHPf3SochwEWTA/8cqsfLW/ugPCbLod
23RRvlaK06cwJ4C7tLGPsHp1kcVZHVjSxCjFi9jYbAXeuw/xWD7GBXaXBc1murzK
AGhLFE2UrmuqF87BycWj51DFsRIkCr09w/PJZvAh5KRbT4RZmKOxAsQBgA0Vys5G
1GHgl5SnSUUtMJuZ60OjOiX+gfxgcqSUOQk5BPyKnaJEppMuAi6QD8YDlCS6wYfx
JSi7NIbLS02nB4cNIiQchvOhVr8kVywOHiJwnepU3L0HtFg/cWm0AEkmEtOiIeW6
8Ok39v/X5wfFYhbs9ELq+soq3WU5HxaNeCQrzGzCA6K5dq+yC+6y/By9w5UeF+43
XhlMmd++1OplYleA4hOvYDGR7Z+Czh7A4FIO1cxGdqxjDxOim3b13q3eyLW9c4Sd
UN2WGwpBpPnspRMB7m96FCXCu27O8t6YUPuJ1WeHhHt5h2td4pwyUAL9xxGiyWVn
FyPMWt2UPik=
=o5Wl
-----END PGP SIGNATURE-----

--=-2jV9f2W6gcBJ7KGJ9yIY--
