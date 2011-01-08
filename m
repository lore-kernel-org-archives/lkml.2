Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1AHLM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 06:12:59 -0500
Received: from ms01.sssup.it ([193.205.80.99]:47991 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751548Ab1AHLM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 06:12:58 -0500
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
From: Dario Faggioli <raistlin@linux.it>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        oleg <oleg@redhat.com>, john.stultz@linaro.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110107192809.05CFF40467@magilla.sf.frob.com>
References: <1293121303.3390.185.camel@Palantir>
	 <20110107192809.05CFF40467@magilla.sf.frob.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-z0oCkcVoUxemYB+ukVMr"
Date: Sat, 08 Jan 2011 12:12:23 +0100
Message-ID: <1294485143.28630.23.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-z0oCkcVoUxemYB+ukVMr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-01-07 at 11:28 -0800, Roland McGrath wrote:=20
> clock_getcpuclockid is the POSIX interface for using a process-wide CPU
> clock.  pthread_getcpuclockid is the POSIX interface for using a
> thread-specific CPU clock.  There is no POSIX interface for using the
> thread-specific clock of a thread in a different process because POSIX do=
es
> not have the notion of global identification of threads at all.
>
Sure, even just the fact that the tid is involved makes it unequivocally
a Linux extension to such interface.

> The very
> idea that you could know anything about an individual thread in a differe=
nt
> process is a Linuxism.  If you want to do something like that, then there
> is no reason to use the POSIX standard interfaces rather than just using
> the Linux-specific clockid_t generation macros in the first place.
>=20
And I'm perfectly fine with this, if there's a consensus around it! :-)

The whole point is that this is not possible right now, since the
clockid_t generators are not accessible from userspace... Should I go
for this?

> When the CPU clock interfaces were introduced to the kernel, it was
> considered a potential security issue (information leak) to be able to
> access the thread clocks of another process, because there had never been=
 a
> way for one process to access such information from another process befor=
e.
> We took the conservative route of permitting it only within the same
> process. =20
>=20
That crossed my mind as well (I think I mentioned at least in one of the
e-mail if not in the changelog). Then I thought that if it's possible to
access an arbitrary process' CPU timer, why it shouldn't be possible to
access the one of an arbitrary thread... But, as you, I'm not a
"security guy", and I would be the first one to suggest to drop this if
it is considered a security risk! :-)

> As well as the information leak, it is most certainly a DoS attack vector
> to allow one process to set CPU timers an another process or its threads.
> Setting timers causes the timed thread itself to do work proportional to
> the number of timers set.
>=20
Yep, but as said, no room for timer setting, neither with or without the
patch, due to the nature of the clock itlsef.

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-z0oCkcVoUxemYB+ukVMr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0oRpAACgkQk4XaBE3IOsS1aQCeOycg8qFqGKOaRdnAWY4WpAqk
l+sAniICmqlsn7p6uSmnHx8fxddAyZIW
=QGD9
-----END PGP SIGNATURE-----

--=-z0oCkcVoUxemYB+ukVMr--

