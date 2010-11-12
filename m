Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0KLNeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:34:09 -0500
Received: from ms01.sssup.it ([193.205.80.99]:46035 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730Ab0KLNeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:34:07 -0500
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
In-Reply-To: <1289504635.2084.179.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334050.8661.150.camel@Palantir>  <1289503054.2084.156.camel@laptop>
	 <1289503883.6525.107.camel@Palantir>  <1289504635.2084.179.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lc4TVFVlA0IWkdLQOPqE"
Date: Fri, 12 Nov 2010 14:33:47 +0100
Message-ID: <1289568827.6525.411.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lc4TVFVlA0IWkdLQOPqE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 20:43 +0100, Peter Zijlstra wrote:
> > Since you spotted it... The biggest issue here is admission control
> > test. Right now this is done against task's bandwidth, i.e.,
> > sum_i(runtime_i/period_i)<=3Dthreshold, but it is unfortunately wrong..=
.
> > Or at least very, very loose, to the point of being almost useless! :-(
>=20
> Right, I have some recollection on that.
>=20
:-)

> So sufficient (but not necessary) means its still a pessimistic approach
> but better than the one currently employed, or does it mean its
> optimistic and allows for unschedulable sets to be allowed in?
>=20
Tommaso already gave the best possible explanation of this! :-P

So, trying to recap:
 - using runtime/min(deadline,period) _does_ guarantee schedulability,
   but also rejects schedulable situations in UP/partitioning. Quite
   sure it _does_not_ guarantee schedulability in SMP/global, but
   *should* enable bounded tardiness;
 - using runtime/period _does_not_ guarantee schedulability nor in
   UP/partitioning neither in SMP/global, but *should* enable bounded
   tardiness for _both_.

The *should*-s come from the fact that I feel like I read it somewhere,
but right now I can't find the paper(s), not even following the
references indicated by Bjorn and Jim in previous e-mails and threads
(i.e., I can't find anything _explicitly_ considering deadline!=3Dperiod,
but it might be my fault)... :-(

Thus, all this being said, what do you want me to do? :-D

Since we care about bounded tardiness more than 100%-guaranteed
schedulability (which, BTW, neither min{} could give us, at least for
SMPs), should we stay with runtime/period? Tommaso, Luca, do you think
it would be so bad?

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-lc4TVFVlA0IWkdLQOPqE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdQjsACgkQk4XaBE3IOsRcoQCfSm4lp9t+FZeg2z4q3VOT4iNk
jM8An2VMZMw4FyPu/n9PigDTwRMj1ats
=+apZ
-----END PGP SIGNATURE-----

--=-lc4TVFVlA0IWkdLQOPqE--

