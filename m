Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0L2OKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:10:36 -0500
Received: from ms01.sssup.it ([193.205.80.99]:38567 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752890Ab0L2OKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:10:33 -0500
Subject: Re: [PATCH resend] Reading POSIX CPU timer from outside the
 process.
From: Dario Faggioli <raistlin@linux.it>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <20101229132130.GA16349@redhat.com>
References: <1293121303.3390.185.camel@Palantir>
	 <1293533742.2899.1028.camel@Palantir> <20101228163829.GA26533@redhat.com>
	 <1293572304.2899.1214.camel@Palantir>  <20101229132130.GA16349@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+3EyyFiaKKpF9aFly4/z"
Date: Wed, 29 Dec 2010 15:10:14 +0100
Message-ID: <1293631815.2899.1238.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+3EyyFiaKKpF9aFly4/z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-12-29 at 14:21 +0100, Oleg Nesterov wrote:=20
> > > How so? For example, with this change
> > > clock_getres(MAKE_THREAD_CPUCLOCK(pid_of_sub_thread)) won't work, no?
> > >
> > I tested all the clock_getres() calls that came to my mind (at least th=
e
> > one that are possible from an userspace program), and they always worke=
d
> > because of this (still in check_clock):
> >
> >         const pid_t pid =3D CPUCLOCK_PID(which_clock);
> >
> >         if (pid =3D=3D 0)
> >                 return 0;
> >
> > Which triggers all the times,
>=20
> No, please note pid_of_sub_thread above.
>=20
Sure, I saw that... I was referring to all the clock_getres() and
clock_{get,set}time() I was able to call without using directly
MAKE_THREAD_CPUCLOCK.

> > Which won't work because CPUCLOCK_PERTHREAD(which_clock) is always fals=
e
> > in this case.
>=20
> I guess, this is because glibc passes MAKE_PROCESS_CLOCK() id, right?
> But we shouldn't add the hacks to the kernel to hide the limitations
> in glibc.
>=20
Exactly. Actually, I didn't noticed this too when I first started with
this patch, and the fact that my first version worked -- which was by
chance, I can say it now :-P -- made me think it was worthwhile to bend
the semantic a bit, to enable this new capability... But making it work
is hackish, I see it now. Sorry. :-)

> BTW. What is the test-case? I am looking at http://gitorious.org/clockid,
> I guess it is clockid.c...
>=20
Yep. A very trivial one, I agree, but it's just to show the issue.

> You do not need clock_getcpuclockid() at all. In fact I do not really
> understand what this helper should actually do, probably it is only
> needed to validate the pid. You can simply use MAKE_THREAD_CPUCLOCK()
> to sample a single thread via clock_gettime().
>=20
Fine, but, is that macro available for an application developer? Because
I can find it in kernel and glibc sources, but not in my /usr/include/*,
which is the motivation behind this attempt... But it might be my
fault! :-P

> IOW. Unless I missed something, with this patch, the only problem
> is that getcpuclockid() always assumes MAKE_PROCESS_CPUCLOCK(),
> I do not think this is the kernel problem.
>=20
Agreed, sorry for wasting (hopefully not too much) people's time. :-(

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-+3EyyFiaKKpF9aFly4/z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0bQUAACgkQk4XaBE3IOsQjOgCfWfU1pqOtQIbxdwiLBEPlP2kH
Q9wAmgMWEjQ6DuqDYiPDGoNF6tnf1Dus
=UH+7
-----END PGP SIGNATURE-----

--=-+3EyyFiaKKpF9aFly4/z--

