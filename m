Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab1EZSY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:24:27 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42656 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab1EZSYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:24:25 -0400
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
In-Reply-To: Your message of "Thu, 26 May 2011 13:08:10 CDT."
             <BANLkTimhcqSyQjwbXTn00Huu_5++3MczDw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1305807728.11267.25.camel@gandalf.stny.rr.com> <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com> <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <20110525191152.GC19633@outflux.net> <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com> <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com> <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com> <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com> <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com> <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com> <17077.1306431502@turing-police.cc.vt.edu>
            <BANLkTimhcqSyQjwbXTn00Huu_5++3MczDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306434174_8338P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 26 May 2011 14:22:54 -0400
Message-ID: <19490.1306434174@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4DDE9A80.00C7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306434174_8338P
Content-Type: text/plain; charset=us-ascii

On Thu, 26 May 2011 13:08:10 CDT, Will Drewry said:

> Depending on the need, there is work involved, and there are many ways
> to determine your bounding box.  It can be very tight -- where you
> analyze normal workloads (perf,strace,objdump) and accept the fact
> that pathological workloads may result in process death -- or it can
> be quite loose and enable most system calls, just not newer ones,
> let's say.  In practice, you might get bit a few times if you're
> overly zealous (I know I have), but it's the difference between
> failing open and failing closed.  There are some scenarios where you
> never, ever want to fail-open even at the cost of process death and
> lack of solid insight into a valid failure path.

> Hope that makes sense and isn't too general,

Oh, I already understood all that. :)   I'd have to double-check the actual
patch, does it give a (hopefully rate-limited) printk or other hint which
syscall caused the issue, to help in making up the list of needed syscalls?

And we probably want a cleaned-up copy of the quoted paragraph in the
documentation for this feature when it hits the streets.  People tuning in late
will need guidance on how to use this in their projects.


--==_Exmh_1306434174_8338P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN3pp+cC3lWbTT17ARAqv7AKC/7Ty91KRh9UxgLpJLfaIp+P1EkwCgrXFh
5u0++YZ1HsENpqPXUvGhUYQ=
=tuk9
-----END PGP SIGNATURE-----

--==_Exmh_1306434174_8338P--

