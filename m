Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab0KJWYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:24:17 -0500
Received: from ms01.sssup.it ([193.205.80.99]:45370 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757208Ab0KJWYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:24:16 -0500
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289410114.2084.23.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>  <1289410114.2084.23.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZzycIuNKBkgH0kTNLgxF"
Date: Wed, 10 Nov 2010 23:24:05 +0100
Message-ID: <1289427845.13577.292.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZzycIuNKBkgH0kTNLgxF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-10 at 18:28 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:27 +0200, Raistlin wrote:
> > +struct sched_param_ex {
> > +       int sched_priority;
> > +       struct timespec sched_runtime;
> > +       struct timespec sched_deadline;
> > +       struct timespec sched_period;
> > +       unsigned int sched_flags;
> > +
> > +       struct timespec curr_runtime;
> > +       struct timespec used_runtime;
> > +       struct timespec curr_deadline;
> > +};=20
>
> I would suggest we add at least one more field so we can implement the
> stochastic model from UNC, sched_runtime_dev or sched_runtime_var or
> somesuch.
>=20
Moreover, I really think that the capability of reporting back current
and used runtime (and deadline) would be very useful for implementing
more complex (and effective) scheduling behaviour in userspace... And in
fact I added them here.

Something I was not so sure, and thus about what I wanted your opinion,
was if I should put these things here --so that they are retrievable by
a sched_getparam[_ex, 2], or either add yet another syscall specific for
that? Thoughts?

Thanks,
Dario
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-ZzycIuNKBkgH0kTNLgxF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzbG4UACgkQk4XaBE3IOsQzcACfSdRsoXf+W/J1tOqFCA/fGyCL
L5cAnjXyBDXUlXczN1EzCi2pyL8zjkN5
=yE+K
-----END PGP SIGNATURE-----

--=-ZzycIuNKBkgH0kTNLgxF--

