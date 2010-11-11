Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0KKTbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:31:38 -0500
Received: from ms01.sssup.it ([193.205.80.99]:52644 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754528Ab0KKTbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:31:35 -0500
Subject: Re: [RFC][PATCH 09/22] sched: add period support for -deadline
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
In-Reply-To: <1289503054.2084.156.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334050.8661.150.camel@Palantir>  <1289503054.2084.156.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H5XB7jjvsaSTvND5EAIH"
Date: Thu, 11 Nov 2010 20:31:23 +0100
Message-ID: <1289503883.6525.107.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H5XB7jjvsaSTvND5EAIH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 20:17 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:34 +0200, Raistlin wrote:
> > Make it possible to specify a period (different or equal than
> > deadline) for -deadline tasks.
> >=20
> I would expect it to be:
>=20
> runtime <=3D deadline <=3D period
>=20
Well, apart from that really unhappy comment/changelog, it should be
like that in the code, and if it's not, it is what I meant and I'll
change to that as soon as I can! :-)

Since you spotted it... The biggest issue here is admission control
test. Right now this is done against task's bandwidth, i.e.,
sum_i(runtime_i/period_i)<=3Dthreshold, but it is unfortunately wrong...
Or at least very, very loose, to the point of being almost useless! :-(

The more correct --in the sense that it at least yield a sufficient (not
necessary!) condition-- thing to do would be
sum_i(runtime_i/min{deadline_i,period_i})<=3Dthreshold.

So, what you think we should do? Can I go for this latter option?

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-H5XB7jjvsaSTvND5EAIH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzcRIsACgkQk4XaBE3IOsQ4dQCfU72e53LUHlOhXXvNah6aJBjc
E70AnjdUx25730ZX1KwoLBzGVuKjlzRq
=sx+N
-----END PGP SIGNATURE-----

--=-H5XB7jjvsaSTvND5EAIH--

