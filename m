Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0KKPuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:50:18 -0500
Received: from ms01.sssup.it ([193.205.80.99]:46735 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753034Ab0KKPuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:50:16 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2010 10:50:16 EST
Subject: Re: [RFC][PATCH 06/22] sched: SCHED_DEADLINE handles spacial
 kthreads
From: Dario Faggioli <faggioli@gandalf.sssup.it>
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
In-Reply-To: <1289485861.2084.122.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333876.8661.147.camel@Palantir>  <1289485861.2084.122.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F943yZMdYrWF4hgFk7IB"
Date: Thu, 11 Nov 2010 15:50:02 +0100
Message-ID: <1289487002.6525.22.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F943yZMdYrWF4hgFk7IB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 15:31 +0100, Peter Zijlstra wrote:
> > Since SCHED_DEADLINE is now the highest priority scheduling class
> > these tasks have to be handled therein, but it is not obvious how
> > to choose a runtime and a deadline that guarantee what explained
> > above. Therefore, we need a mean of recognizing system tasks inside
> > the -deadline class and always run them as soon as possible, without
> > any kind of runtime and bandwidth limitation.
>=20
> Yet in the previous patch you had this hunk:
>=20
> > +++ b/kernel/sched_stoptask.c
> > @@ -81,7 +81,7 @@ get_rr_interval_stop(struct rq *rq, struct
> > task_struct *task)
> >   * Simple, special scheduling class for the per-CPU stop tasks:
> >   */
> >  static const struct sched_class stop_sched_class =3D {
> > -       .next                   =3D &rt_sched_class,
> > +       .next                   =3D &dl_sched_class,
> > =20
> >         .enqueue_task           =3D enqueue_task_stop,
> >         .dequeue_task           =3D dequeue_task_stop,
>=20
Yep. And (as said on IRC) this needs serious cleanup, in favour of
stop_task!

I'll completely drop patch 06 for next releases.

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-F943yZMdYrWF4hgFk7IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzcApoACgkQk4XaBE3IOsRLeQCgnt+wJvCRSSBS8pOzRxB6I3qC
pOkAoKTidqthRhKRzaHmIQTeQ0+wWxgU
=FYgs
-----END PGP SIGNATURE-----

--=-F943yZMdYrWF4hgFk7IB--

