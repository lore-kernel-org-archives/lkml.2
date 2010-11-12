Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0KLTYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:24:37 -0500
Received: from ms01.sssup.it ([193.205.80.99]:37926 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932261Ab0KLTYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:24:36 -0500
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
From: Raistlin <raistlin@linux.it>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
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
In-Reply-To: <1289579924.12418.404.camel@gandalf.stny.rr.com>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>
	 <1289579924.12418.404.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-r542jvNpACaLIOO/YGha"
Date: Fri, 12 Nov 2010 20:24:21 +0100
Message-ID: <1289589861.6525.725.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-r542jvNpACaLIOO/YGha
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-12 at 11:38 -0500, Steven Rostedt wrote:
> A while ago I implemented an EDF scheduler for a client (before working
> with Red Hat), and one thing they asked about was having a "soft group",
> which was basically: This group is guaranteed X runtime in Y period, but
> if the system is idle, let the group run, even if it has exhausted its X
> runtime.
>=20
Sounds reasonable...

> Is this supported?
>=20
Yep, as both Tommaso and Peter were saying, patch 18 gives you exactly
that. In some more details, after X is over, you can chose (just by
setting a flag in sched_param2 and calling setscheduler2()) if you want
to keep running as a -deadline task (but without hurting other -deadline
tasks), or if you want to still be able to compete for CPU, but as a -rt
or -fair task.

However, we're delaying this for now. It won't be hard to add it back if
we change our mind. :-)

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-r542jvNpACaLIOO/YGha
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdlGUACgkQk4XaBE3IOsQw6gCfTobWvgr5PwgiJHCVS2CZhgkt
BwkAoK86/lxJgGeehUCQ5O1fifOml3zE
=6lda
-----END PGP SIGNATURE-----

--=-r542jvNpACaLIOO/YGha--

