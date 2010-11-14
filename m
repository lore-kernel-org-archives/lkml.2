Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0KNMAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 07:00:54 -0500
Received: from ms01.sssup.it ([193.205.80.99]:32968 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755320Ab0KNMAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 07:00:51 -0500
Subject: Re: [RFC][PATCH 20/22] sched: drafted deadline inheritance logic
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
In-Reply-To: <1289513715.2084.201.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334618.8661.162.camel@Palantir>  <1289513715.2084.201.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qaJhQ2HkwP/0qQIUWc8Z"
Date: Sun, 14 Nov 2010 13:00:35 +0100
Message-ID: <1289736035.6632.171.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qaJhQ2HkwP/0qQIUWc8Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 23:15 +0100, Peter Zijlstra wrote:
> > Acting this way, we provide some kind of boosting to the lock-owner,
> > still by using the existing (actually, slightly modified by the previou=
s
> > commit) pi-architecture.
>=20
> Right, so this is the trivial priority ceiling protocol extended to
> bandwidth inheritance and we basically let the owner overrun its runtime
> to release the shared resource.
>=20
We can call it that way. Basically, what we do is scheduling the
lock-owner with the parameters, i.e., runtime and deadline, of the
earliest deadline task blocked on it. As soon as such runtime depletes,
we (1) _do_ postpone that deadline (again, according to earliest
deadline lock-owner's relative deadline), but we also (2) immediately
replenish the runtime _immediately_.

Acting like this we ensure the lock-owner won't hurt the guarantees
provided to tasks with deadline earlier than all the tasks in its
blocking chains (by means of (1)), and we also enable a quicker release
of the lock (by means of (2)).

> Didn't look at it too closely, but yeah, that is a sensible first
> approximation band-aid to keep stuff working.
>=20
I'll keep going this way then. :-)

Thanks,
Dario
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-qaJhQ2HkwP/0qQIUWc8Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzfz2MACgkQk4XaBE3IOsQFuwCgg1jW0W9HXHab+/Os2/o97PJ9
Z9IAnA5tovn6Spx0+Rjn+sPUWOjlO8kq
=kTkE
-----END PGP SIGNATURE-----

--=-qaJhQ2HkwP/0qQIUWc8Z--

