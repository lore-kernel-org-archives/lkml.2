Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0KKBTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 20:19:10 -0500
Received: from ms01.sssup.it ([193.205.80.99]:41991 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932099Ab0KKBTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 20:19:09 -0500
Subject: Re: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
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
In-Reply-To: <1289420478.2084.54.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>  <1289420478.2084.54.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5gwlo6XnfACreUHY+GYc"
Date: Thu, 11 Nov 2010 02:18:55 +0100
Message-ID: <1289438335.13577.462.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5gwlo6XnfACreUHY+GYc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-10 at 21:21 +0100, Peter Zijlstra wrote:
> > +       if (dl_time_before(dl_se->deadline, rq->clock) ||
> > +           dl_entity_overflow(dl_se, rq->clock)) {
> > +               dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
> > +               dl_se->runtime =3D dl_se->dl_runtime;
> > +       }
> > +}=20
>=20
> Can't we loose runtime deficit this way?
>
No, this should not be the case (I hope!). The rationale is basically
the same of the other e-mail about new instances.

In fact, a task that goes to sleep with some available runtime will be
given new parameters or not, depending on the return value of
dl_entity_overflow, and that's fine, right?

On the other hand, a task blocking while in overrun will (at dequeue_*
and/or put_* time) trigger the bandwidth enforcement logic (which arms
dl_timer) so that:
 - if unblocking happens _before_ it becomes eligible again, the=20
   enqueue will be later handled by the dl_timer itself, when it'll
   fire, and the task will be given a replenishment starting from its
   negative runtime;
 - if unblocking happens _later_ than the firing of dl_timer, resetting
   the scheduling parameters should be just fine, from the bandwidth
   point of view.

Does it make sense?

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-5gwlo6XnfACreUHY+GYc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzbRH8ACgkQk4XaBE3IOsQdfACeLPzKkBqmCcWQUtNG3OcD+HWv
YVEAoInlzqHFnRU2WCezKWyz1156mXCW
=fVgX
-----END PGP SIGNATURE-----

--=-5gwlo6XnfACreUHY+GYc--

