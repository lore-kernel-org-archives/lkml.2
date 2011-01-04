Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1ADLBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 06:01:51 -0500
Received: from ms01.sssup.it ([193.205.80.99]:47180 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751574Ab1ADLBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 06:01:49 -0500
Subject: Re: [PATCH resend] Reading POSIX CPU timer from outside the
 process.
From: Dario Faggioli <raistlin@linux.it>
To: torbenh <torbenh@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, john.stultz@linaro.org,
        roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <20101230174529.GE2086@siel.b>
References: <1293121303.3390.185.camel@Palantir>
	 <1293533742.2899.1028.camel@Palantir> <20101228163829.GA26533@redhat.com>
	 <1293572304.2899.1214.camel@Palantir> <20101229132130.GA16349@redhat.com>
	 <20101230174529.GE2086@siel.b>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-I13gWYr+tnuX7AeXg727"
Date: Tue, 04 Jan 2011 12:01:25 +0100
Message-ID: <1294138885.6169.136.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-I13gWYr+tnuX7AeXg727
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-12-30 at 18:45 +0100, torbenh wrote:=20
> > I think we should change glibc if clock_getcpuclockid() doesn't work,
> > please see below.
>=20
> http://www.kernel.org/doc/man-pages/online/pages/man3/pthread_getcpuclock=
id.3.html
>=20
> this one works.
> ok... it takes a pthread_t for identifying the thread.
> but it works.
>=20
Well, I knew this, I knew it very well, as you can see from the code on
the git I pointed to (it's part of one of the examples!).

the thing is that I believe there are situations where it could be
useful to sample CLOCK_THREAD_CPUTIME_ID from a _different_ process, and
in that case, you can't access that thread's pthread-id, can you? :-O

The jack2 code I saw could be one of these "potential user", and AFAICT
your jack1 might be another one, no?
Yeah, I know, whether you can/want use this or not also depends on other
issues, but you are in a _different_ process --and thus you can't use
pthread_* calls-- aren't you?

I'm now looking at Oleg's solution and into glibc as well... I'll come
out with something ASAP.

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-I13gWYr+tnuX7AeXg727
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0i/f8ACgkQk4XaBE3IOsSWiwCfTOHELiPVOWae/1bNsahsbNE8
ZrUAoIu+4Ogk2XJulVVIuEcvxBeLj1iC
=JFFt
-----END PGP SIGNATURE-----

--=-I13gWYr+tnuX7AeXg727--

