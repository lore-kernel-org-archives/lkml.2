Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1EFMKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:10:53 -0400
Received: from csamuel.org ([74.50.50.137]:57097 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab1EFMKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:10:52 -0400
From: Chris Samuel <chris@csamuel.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:x86/urgent] x86, setup: When probing memory with e801, use ax/bx as a pair
Date: Fri, 6 May 2011 22:10:32 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: mingo@redhat.com, hpa@zytor.com, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1303566747.12067.10.camel@localhost.localdomain> <201105062147.09398.chris@csamuel.org> <20110506120452.GB17112@elte.hu>
In-Reply-To: <20110506120452.GB17112@elte.hu>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@^SdaXtmdYGRq
	[>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<{n8m;X_
	g\Y9LQ=v/b5`)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)F!1M3=w:i9MsWp&v;%usOXL;w
	6kF?wAZjss.+y(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1720030.P3aMxPfWtl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201105062210.35963.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1720030.P3aMxPfWtl
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, 6 May 2011 10:04:52 PM Ingo Molnar wrote:

> * Chris Samuel <chris@csamuel.org> wrote:
>
> > Understood, I would guess that the SCSI one would map to the
> > introduction of the async scsi scanning patch in 2.6.19-rc2
> > and its enablement in later Ubuntu kernels.
>=20
> Yeah. Async SCSI scanning was not supposed to break any existing
> setup.

Well that'd be about my luck at the moment. ;-)

> > No idea on the APIC one but I'm happy to try and bisect both
> > cases if you'd like me to try ?
>=20
> I could definitely do something about the APIC regression if
> managed to narrow down the commit range (a specific guilty commit
> would be fantastic of course). If the regression got introduced
> after the e801 regression you'll need to run:
>=20
>   git cherry-pick 39b68976ac65
>=20
> at every bisection step that needs that fix - but still bisect as
> if that extra commit was not there. (bisection will throw away
> that cherry-picking temporary tree so you will have to re-pick the
> commit again and again)

That's great, will try and see what I can do.  It might take a little
bit of time due to work commitments prior to a (planned) trip to
hospital next Thursday.

> Note that during bisection the current tree might jump in and out
> of regions that need this fix, so be prepared to have to do the
> cherry-picking at random places. You can attempt the cherry-pick
> at every step and you will get a conflict and it will not succeed
> if the fix is not needed. You can throw away the conflicting state
> via 'git reset --hard'.

Understood, thanks!

> > Indeed - though at the moment you can't even install a current
> > Debian release as the boot loader on the install CD locks the
> > box up. :-(
>=20
> Is that hang due to one of these 3 regressions - or is it a fourth
> regression perhaps?

This is before it boots the kernel, so I'd guess something in
whatever they are using for the Squeeze install CD - perhaps
grub2 now ?

> While the installed base of your hardware is small, i think such
> old-hardware testing is still very valuable feedback to us: it
> gives us a feel for how corrosive our development process is to
> long-term (10+ years) stability.

Great, as long as this is more useful than just fixing my problems!

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1720030.P3aMxPfWtl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATcPlOI1yjaOTJg85AQKR/ggAgzFwst0URAx7YOzIvY4sbIqBZTw5zGDZ
KKEYp2IZQ3obDZC7r9IzKFNJOl3S36aH63zY9YBulCZCSrDq177DzCY94dR/VOiJ
9XoUtrf26+hrlqHrJBSscMafmBo4LG11U9vW0YoIScHRKbci6hMOfN2ZM/S9OQGL
WLLQD+EINjquRGot/l36DugpDPyUD2fY1DkQjHGXkio1Zowm3SwdlSyW1QTK5f+z
tilN1VY9yTZ8Uo+p1iCkQmvjZ1F5pDMrWi4szDOAGOk5YJ8unot5QPf79zTEBZk6
IT8AUvGerdX7YsukUWWPRIg8mr6UNkLVtSEyKFO88QLXY4o2xUMpng==
=k4uM
-----END PGP SIGNATURE-----

--nextPart1720030.P3aMxPfWtl--
