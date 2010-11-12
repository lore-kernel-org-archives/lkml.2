Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab0KLVLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:11:24 -0500
Received: from ms01.sssup.it ([193.205.80.99]:46124 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755264Ab0KLVLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:11:22 -0500
Subject: Re: [RFC][PATCH 07/22] sched: SCHED_DEADLINE push and pull logic
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
In-Reply-To: <1289578673.2084.314.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333935.8661.148.camel@Palantir>  <1289578673.2084.314.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VvY7PFzAlRnJK8oljeIV"
Date: Fri, 12 Nov 2010 22:11:05 +0100
Message-ID: <1289596265.6525.766.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VvY7PFzAlRnJK8oljeIV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-12 at 17:17 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:32 +0200, Raistlin wrote:
> > Add dynamic migrations to SCHED_DEADLINE, so that tasks can
> > be moved among CPUs when necessary. It is also possible to bind a
> > task to a (set of) CPU(s), thus restricting its capability of
> > migrating, or forbidding migrations at all.
> >=20
> > The very same approach used in sched_rt is utilised:
> >  - -deadline tasks are kept into CPU-specific runqueues,
> >  - -deadline tasks are migrated among runqueues to achieve the
> >    following:
> >     * on an M-CPU system the M earliest deadline ready tasks
> >       are always running;
> >     * affinity/cpusets settings of all the -deadline tasks is
> >       always respected.=20
>=20
> I haven't fully digested the patch, I keep getting side-tracked and its
> a large patch..=20
>
Yeah, I know, take your time. :-)

> however, I thought we would only allow 2 affinities,
> strict per-cpu and full root-domain?
>=20
Yes, we do! Writing a better changelog for this already noted for next
version.

> Keep 2 per-cpu utilization counts, a hard-rt and a soft-rt, and ensure
> the sum stays <=3D 1. Use the hard-rt one for the planned SF_HARD_RT flag=
,
> use the soft-rt one for !SF_HARD_RT with nr_cpus_allowed =3D=3D 1, and us=
e
> \Sum (1-h-s) over the root domain for nr_cpus_allowed !=3D 1.
>=20
As agreed during LPC, that's exactly what I'll do. Let's hope to don't
screw up while trying to do the math! :-P

Thanks,
Dario
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-VvY7PFzAlRnJK8oljeIV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdrWkACgkQk4XaBE3IOsRI0QCfcVGBsW4+5MgvXHqSvTngfUr4
gr4Anitb77PwopYf+3NVt3w/TEOdP1wt
=L1UL
-----END PGP SIGNATURE-----

--=-VvY7PFzAlRnJK8oljeIV--

