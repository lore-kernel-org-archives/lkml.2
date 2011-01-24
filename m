Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1AXVcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:32:35 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:35134 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab1AXVce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:32:34 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: libc-ports@sourceware.org
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Mon, 24 Jan 2011 16:32:22 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.5; x86_64; ; )
Cc: Roland McGrath <roland@redhat.com>, linasvepstas@gmail.com,
        Chris Metcalf <cmetcalf@tilera.com>, Arnd Bergmann <arnd@arndb.de>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <20110124210514.AB18918020B@magilla.sf.frob.com>
In-Reply-To: <20110124210514.AB18918020B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1382858.2mkS44ceiO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201101241632.24425.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1382858.2mkS44ceiO
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Monday, January 24, 2011 16:05:14 Roland McGrath wrote:
> POSIX says "A null pathname shall not be successfully resolved."  This
> applies to relative pathnames too, and a file name argument to an *at
> function using AT_FDCWD is a relative pathname.  So I think there is no
> situation at all in which the empty string should resolve to anything.
> It's generally in the domain of the kernel to enforce these kinds of rule=
s,
> so I think that having the kernel fail with ENOENT for all empty-string
> cases is the right thing to do.

typically, Linux isnt hard pressed to enforce POSIX semantics.  that barrie=
r=20
is the realm of glibc.  the *at functions as implemented by Linux can provi=
de=20
neat semantics where you can open a directory, process a bunch of files via=
=20
that fd, and then turn around and operate on the dir itself with NULL or ""=
=20
paths.  plus, once Linux has shipped with a syscall behavior set, Linus rea=
lly=20
doesnt let people change it.  which means it's back on glibc's head to prov=
ide=20
POSIX semantics to application.
=2Dmike

--nextPart1382858.2mkS44ceiO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNPe/oAAoJEEFjO5/oN/WBSooQAMeq8V/oOwy5tMLX33EwmzZ/
6CFWH3zsgOSNX54k03zRpg2vSQyPHv8ZdMTZ4BelyXzYEnlC9fRQiY0LHH1Ld3tA
4Z4QCmFCtEtNN50ExvrgM6XiX47/YPJJZEgPeozNFgIf7YMnyLtRMUncMHi2j70A
yuuIs1Gev+y8K8LzVidiijPjI/BFI/YWm9ITtEl+SMLOM1bGNH3UkLFdvton9i1O
866stiHjFyPbJEycSavS+4ik/e/G4eSR1mu0C3eGqucZr06oaD+tEGm5JsGppSCy
WnKE1cAHwo5CxOArIn0rtg0sKZ8UnJpXCCzbXidU42e4bfkzOd1lgpB7b1+Ifhs6
MMEkjLpl70ivAcS857PNunAglmxReDpnPWkR5RtKa3JNgiabWK8uPvPFHIZZfQLz
2jB8DsD20tdXku90xR+GkMTCHXgfpVZV4xTkI7a0ZqKBEYyMJbkzNL6VqkbRpMPj
PR9nyqSFGq1r+sVIDlyCWTyhoM76GI+CdHOvWY17+bUo6rGNj3y89C1nVEA48ZWE
yPfPvNL/nOac00T00vPgA/VErHZygH0CyUsfXBMFm2oqAamzBeUsUJI7ccv+SGNq
YVPqOx13zaGTA8hnZUjyrKdyx5Z5aBDH8Swj/oYqQh/OriQrdk9RCbnUlQN34lQy
+3Vq1CqSoBwS8H1sJuvo
=WokD
-----END PGP SIGNATURE-----

--nextPart1382858.2mkS44ceiO--
