Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0LXLg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 06:36:26 -0500
Received: from ms01.sssup.it ([193.205.80.99]:47197 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752134Ab0LXLgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 06:36:24 -0500
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
From: Dario Faggioli <raistlin@linux.it>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, roland@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dhaval Giani <dhaval.giani@gmail.com>
In-Reply-To: <1293125901.2748.10.camel@Palantir>
References: <1293121303.3390.185.camel@Palantir>
	 <20101223164453.GA13111@redhat.com>  <1293125901.2748.10.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tp4cMpbvnrZKQ6AQ8Nle"
Date: Fri, 24 Dec 2010 12:36:12 +0100
Message-ID: <1293190572.2944.2.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tp4cMpbvnrZKQ6AQ8Nle
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-12-23 at 18:38 +0100, Dario Faggioli wrote:=20
> > >  	rcu_read_lock();
> > >  	p =3D find_task_by_vpid(pid);
> > > -	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
> > > -		   same_thread_group(p, current) : has_group_leader_pid(p))) {
> > > +	if (!p)
> > >  		error =3D -EINVAL;
> > > -	}
> >=20
> > This changes the behaviour of sys_clock_settime(). Probably doesn't
> > matter since it does nothing, but perhaps !CPUCLOCK_PERTHREAD &&
> > !group_leader should result in -EINAVL as before.
> >=20
> Oops, sure, you're right, I can fix this. :-)
>=20
Mmm... This is trickier than I remembered expected. Apparently, glibc
always gives us a !CPUCLOCK_PERTHREAD() clockid, since it uses
MAKE_PROCESS_CLOCK() when clock_cpugetclockid is called.

Therefore, the take two of this thing will be a little different from
this first posting...

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org


--=-tp4cMpbvnrZKQ6AQ8Nle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0UhaUACgkQk4XaBE3IOsQPYgCfRyX2ya75PmordBHszOXuSqB6
lncAoJ4tROSBur6LXxf1nvJDuBf/LuIU
=sWfa
-----END PGP SIGNATURE-----

--=-tp4cMpbvnrZKQ6AQ8Nle--

