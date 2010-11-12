Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab0KLPgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:36:48 -0500
Received: from ms01.sssup.it ([193.205.80.99]:36569 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757449Ab0KLPgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:36:47 -0500
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline
 tasks
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
In-Reply-To: <1289513573.2084.199.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334546.8661.161.camel@Palantir>  <1289513573.2084.199.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-M3nZZZ01IAa8N5GkzAMC"
Date: Fri, 12 Nov 2010 16:36:17 +0100
Message-ID: <1289576177.6525.509.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M3nZZZ01IAa8N5GkzAMC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 23:12 +0100, Peter Zijlstra wrote:
> > Therefore, this patch:
> >  - adds the flags for specyfing DEADLINE, RT or OTHER reclaiming
> >    behaviour;
> >  - adds the logic that changes the scheduling class of a task when
> >    it overruns, according to the requested policy.
>=20
> The first two definitely should require SYS_CAP_ADMIN because it allows
> silly while(1) loops again..=20
>
Sure, good point!

> but can we postpone this fancy feature as
> well?=20
>=20
As you wish, I'll keep backing it in my private tree...

> I'd much rather have the stochastic thing implemented that allows
> limited temporal overrun.
>
... But at this point I can't avoid asking. That model aims at _pure_
hard real-time scheduling *without* resource reservation capabilities,
provided it deals with temporal overruns by means of a probabilistic
analysis, right?
In this scheduler, we do have resource reservations to deal with
overruns, provided it can guarantee bandwidth isolation among tasks even
in case of overrun (which is very typical soft real-time solution, but
can provide hard guarantees as well, if the analysis is careful enough).

Are we sure the two approaches matches, and/or can live together?

That's because I'm not sure what we would do, at that point, while
facing a runtime overrun... Enforce the bandwidth by stopping the task
until its next deadline (as we do now)? Or allows it to overrun basing
of the statistical information we have? Or do we want somehow try to do
both?

I know we can discuss and decide the details later, after merging all
this... But I still think it's worth trying to have at least a basic
idea of how to do that, just to avoid doing something now that we will
regret then. :-)

Thanks,
Dario
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-M3nZZZ01IAa8N5GkzAMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdXvEACgkQk4XaBE3IOsT7LgCgq3TlGuRl6l/kjCWJxs/zWziG
gm8An2NfvVvvRRko66z1l4Esw/Eo4FvH
=T0St
-----END PGP SIGNATURE-----

--=-M3nZZZ01IAa8N5GkzAMC--

