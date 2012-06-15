Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab2FOAOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:14:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54933 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2FOAOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:14:21 -0400
Date: Fri, 15 Jun 2012 10:14:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure in Linus' tree
Message-Id: <20120615101407.369c754da872e18c854ab481@canb.auug.org.au>
In-Reply-To: <20120614034036.GE27673@linux-sh.org>
References: <20120614114722.0fd16fb906b6a5503cfbc51a@canb.auug.org.au>
	<20120614030606.GC27673@linux-sh.org>
	<20120614034036.GE27673@linux-sh.org>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Jun_2012_10_14_07_+1000_LCohWgJvg8PQxLyg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Jun_2012_10_14_07_+1000_LCohWgJvg8PQxLyg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 14 Jun 2012 12:40:36 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
>
> (adding Arnd to Cc, who I forgot to include previously)
>=20
> On Thu, Jun 14, 2012 at 12:06:06PM +0900, Paul Mundt wrote:
> > On Thu, Jun 14, 2012 at 11:47:22AM +1000, Stephen Rothwell wrote:
> > > While building Linus' tree, today's linux-next build (powerpc
> > > ppc64_defconfig) failed like this:
> > >=20
> > > In file included from include/asm-generic/bug.h:5:0,
> > >                  from arch/powerpc/include/asm/bug.h:127,
> > >                  from arch/powerpc/kernel/head_64.S:31:
> > > include/linux/kernel.h:44:0: warning: "ALIGN" redefined [enabled by d=
efault]
> > > include/linux/linkage.h:57:0: note: this is the location of the previ=
ous definition
> > > include/linux/sysinfo.h: Assembler messages:
> > > include/linux/sysinfo.h:7: Error: Unrecognized opcode: `struct'
> > > include/linux/sysinfo.h:8: Error: Unrecognized opcode: `__kernel_long=
_t'
> > >=20
> > > And it went downhill from there :-(
> > >=20
> > > Caused by commit 3777808873b0 ("bug.h: need linux/kernel.h for
> > > TAINT_WARN") which, unfortunately never made it into linux-next.
> > >=20
> > > I have reverted that commit for today (which presumably means that sh
> > > builds will be broken again).
> >=20
> > I'm still unsure as to the best way to fix this, and there was no
> > response to the original mail I posted about it either:
> >=20
> > http://marc.info/?l=3Dlinux-kernel&m=3D133879579014853&w=3D2
> >=20
> > I'll fetch a powerpc cross compiler and see if I can figure out what we=
nt
> > wrong.
> >=20
> Ok, it's because the asm-generic/bug.h __ASSEMBLY__ guarding is
> completely bogus. This should hopefully fix it once and for all.
> Sorry for the trouble.
>=20
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

Can you create a proper commit message and send this to Linus, please?  I
have included it in my fixes tree in linux-next for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Jun_2012_10_14_07_+1000_LCohWgJvg8PQxLyg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP2n5PAAoJEECxmPOUX5FEC3gP/1l7eBViE0oeJXToHhD4xrUX
rIq65+BSEyK0w6qL/J0MasEMH9lwFqzkoHOKJfCqvLFSjG3qcR33G8KRgt75ZeYU
2n57qssAZEhvwYK98Sg9zbDNWpQf8aP8sXN3ln7cv2FRO6TArgTe423OetOOoPB2
dECJlp3AMrvIrGMwq/Jb5jseuEgApBQoTqni0GRepM/tzoujOOpedYqI0LPpAAgB
tvX9VPkldlyaaOPKdGsIUokx3r6xY10/Aq8GksCrfS1aUWt9IYBYJuqIqC7pHhDK
6QXKzWGEMv43IgNQfqq7FhlBDJl1mTGAef6r5DBVlgtSTZaQ2+2u/Z7J3G2Oues+
468lV3V4RYYEdVHTRdeqhH+cBzoWezr+yr2ZNOf4/srBBlA1KUYTZvfH5U4mS5Fg
PRVHVEBWYFcnyZ4lIntYun157u7iBhn6k+6y3uvHUSJFiD1PNLFvdruf7GJMDuBs
lwgnL2exHZpbjUt+g8MtM7MmS3FiQxQjhvVBbHGeJsWqK75NJ6nYytb9tNVZ58FZ
jCryfkKxFh3/URPYO03JqqXEomdktqYfQyQeTEYjSD8RwWjmVVv8Vmv3jAo4ZLH9
nOuiJ9+i/8Et6tNnmk77f357bE4fxObFGUkZRsLZ2AM90BwKQ/EJsIRZv+PIf7A5
W0R5zVZv5xpy/SJsgogY
=RaL1
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Jun_2012_10_14_07_+1000_LCohWgJvg8PQxLyg--
