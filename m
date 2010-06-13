Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0FMN33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 09:29:29 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38752 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab0FMN32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 09:29:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Someone Something <fordhaivat@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Help for a newbie
In-Reply-To: Your message of "Sat, 12 Jun 2010 23:32:36 EDT."
             <AANLkTilzq64CPECxFb77PEdjv1Pcj72622rmhPchz9L8@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTimmhzbgddTZBoaSy4iXpjB4Gdy6zTab0EjCM1IK@mail.gmail.com> <AANLkTinwQ5tUDyHIObolQrd0jESH5PGEBKqwk6a_jHWK@mail.gmail.com> <AANLkTilbMPLfd415EV32or8FZCM1sWi-RzeWtPAX95-o@mail.gmail.com>
            <AANLkTilzq64CPECxFb77PEdjv1Pcj72622rmhPchz9L8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1276435765_18203P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Jun 2010 09:29:25 -0400
Message-ID: <20766.1276435765@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4C14DD36.0186,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1276435765_18203P
Content-Type: text/plain; charset=us-ascii

On Sat, 12 Jun 2010 23:32:36 EDT, Someone Something said:

> 1) when you write userland apps, you usually include stuff like :
> sys/types.h or errono.h where are all these defined in the linux
> kernel because I would like to add a few syscalls of my own?

Look at any source files already in the kernel, they'll give you a good
hint of where the .h files are.  Keep in mind that in the kernel, we
tend to #include a lot of header files, depending on what exactly is needed.

Regarding adding syscalls - step 0 is doing a proper design and making sure
that in fact you need a new syscall.  What features do you want to add, and
why do they need syscalls?

It's usually a bad idea to add syscalls unless you *really* need to - most
of the time creating a loadable kernel module is a better idea (among other
things, you can compile a module against a distro kernel without rebuilding
the entire kernel, you can't do that with a syscall).

> 2) what are some bugs in the kernel that a beginner can fix?

Unfortunately, we're victims of our own sucess here.  There really aren't many
long-standing bugs left that a beginner can fix.  If you follow the linux-next
or Andrew Morton's -mm kernel, you'll find the occasional typo or messed up
code that has an #ifdef backwards so it doesn't build for all configs, and so
on.  But in general, if the bug has been there more than 12 hours or so, it
usually means that it's a nasty ugly mess and will require some real work to
fix.

That isn't to say that the developers don't appreciate all those little
one-line patches to make stuff work in your config that they didn't test.
They appreciate those a *lot*.  I just can't point you at any because the list
will be different by the time you read this mail.

> 3) is there any definitive guide to the kernel that you guys refer
> most newbies to? (like Programming Perl for perl)?

Robert Love's book and "Linux Device Drivers, 3rd ed" are both pretty good
overviews, although somewhat dated because the code is a moving target.
Once you got a handle on the major data structures, it's really "Use The
Source, Luke" time.

> 4) Where's the linux kernel headed to next? What higher level features
> (i.e. real features, not bug fixes) are going to implemented?

Well, I really can't say anything definite other than "read LKML or at least a
weekly scan of the Subject: lines to see what's new".  It's going to be the
same as it has for the last few years - code will be merged when it's written
by somebody who's scratching an itch.  We'll eventually merge *something* for
the Android power-management issue (because we really *do* need a solution in
that area), new file systems will be merged, device drivers will be written,
and so on. What will go in for 2.6.36 and later releases pretty much depends on
what code people feel motivated to write for submission.



--==_Exmh_1276435765_18203P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMFN01cC3lWbTT17ARAjnLAJ9y1aYAWnxkwRWF9jnDNixB96MjIQCg0iNM
fwaDfSlzscGBejc7FC3iapI=
=GmcK
-----END PGP SIGNATURE-----

--==_Exmh_1276435765_18203P--

