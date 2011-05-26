Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab1EZRjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:39:54 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51973 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005Ab1EZRjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:39:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Will Drewry <wad@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@verbum.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
In-Reply-To: Your message of "Thu, 26 May 2011 12:02:45 CDT."
             <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1305807728.11267.25.camel@gandalf.stny.rr.com> <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com> <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <20110525191152.GC19633@outflux.net> <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com> <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com> <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com> <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com> <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
            <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306431502_8338P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 26 May 2011 13:38:22 -0400
Message-ID: <17077.1306431502@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4DDE9012.0195,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306431502_8338P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 26 May 2011 12:02:45 CDT, Will Drewry said:

> Absolutely - that was what I meant :/  The patches do not currently
> check creds at creation or again at use, which would lead to
> unprivileged filters being used in a privileged context.  Right now,
> though, if setuid() is not allowed by the seccomp-filter, the process
> will be immediately killed with do_exit(SIGKILL) on call -- thus
> avoiding a silent failure.

How do you know you have the bounding set correct?

This has been a long-standing issue for SELinux policy writing - it's usu=
ally
easy to get 95% of the bounding box right (you need these rules for share=
d
libraries, you need these rules to access the user's home directory, you =
need
these other rules to talk TCP to the net, etc).  There's a nice tool that=

converts any remaining rejection messages into rules you can add to the p=
olicy.

The problem is twofold: (a) that way you can never be sure you got *all* =
the
rules right and (b) the missing rules are almost always in squirrelly lit=
tle
error-handling code that gets invoked once in a blue moon.  So in this ca=
se,
you end up with trying to debug the SIGKILL that happened when the proces=
s was
already in trouble for some other reason...

=22Wow. Who would have guessed that program only called gettimeofday() in=

the error handler for when it was formatting its crash message?=22

Exactly.


--==_Exmh_1306431502_8338P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN3pAOcC3lWbTT17ARArcQAKC5eiB9i2Z/MRiW4pNAPuhksCXrLACeOpjk
Y2jUCxr9WAbWhihFLVEVZxw=
=in7z
-----END PGP SIGNATURE-----

--==_Exmh_1306431502_8338P--

