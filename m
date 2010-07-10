Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0GJHIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 03:08:41 -0400
Received: from ms01.sssup.it ([193.205.80.99]:39153 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751609Ab0GJHIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 03:08:39 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Raistlin <raistlin@linux.it>
To: Bjoern Brandenburg <bbb@email.unc.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685133.1900.201.camel@laptop>
	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DvTp6D+xSOBAvF0/AUTx"
Date: Sat, 10 Jul 2010 09:08:26 +0200
Message-ID: <1278745706.4390.2.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DvTp6D+xSOBAvF0/AUTx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-07-09 at 16:51 +0200, Bjoern Brandenburg wrote:
> > Happen to have a paper handy that explains all this in a concise way?=20
> >=20
>=20
> Sounds confusing, but this is actually not that complicated.
>=20
> - If the period exceeds the deadline of a task, then it is said to have a=
 constrained deadline, and is said to be a constrained task.
>=20
> - The density of a task is the ratio budget/min(period, relative deadline=
). The density of a task is at most its utilization (budget/period).
>=20
> - There exists a simple *sufficient* (but not necessary) test for uniproc=
essor EDF for constrained tasks: if the sum of all task densities is at mos=
t one (on each processor), then all jobs will meet their deadlines. (Of cou=
rse, this assumes that the budget is only replenished at the beginning at e=
ach period and does not take self-suspensions due to I/O etc. into account.=
)
>=20
Right, I think Bjoern made it much more clear than how you can find it
in many of the existing papers! :-)

Just to make a simple UP example, if you have two tasks with the
following parameters (where T_i=3D(C_i, P_i, D_i)):

 T_1 =3D (4, 10, 5)
 T_2 =3D (4, 10, 5)

Then the test Sum_i(C_i/P_i)<1 will say "go!" (4/10+4/10<1), but
one of the tasks can miss its deadline by 3 time units in the worst case
(if, and if yes which one, depends on the order with witch they arrive).

Using D_i instead of P_i in the test will make things better in this
case (4/5+4/5>1 =3D=3D> "no go!"), but its overly pessimistic (i.e., only
sufficient). In fact for this task set:

T_1 =3D (1, 10, 2)
T_2 =3D (2, 20, 4)
T_3 =3D (3, 50, 6)

which has small utilization (Sum_i(C_i/P_i)=3D.26) and *is schedulable*,
even if 1/2+2/4+3/6=3D1.5>1.

Hope this helped in clarifying things even more! :-D
Btw, another nice survey about schedulability tests for global EDF I
know (and you'll forgive me if I point you to something from my
institution :-)) is this http://retis.sssup.it/~marko/papers/ICPP09.pdf.

> As a side note, almost all global EDF hard real-time admission tests can =
handle tasks with constrained deadlines transparently. However, as far as I=
 can tell, they do not apply to SCHED_DEADLINE.
>=20
This is the only part I am not sure I got... Can you explain me what do
you mena by "they do not apply" ?

> PS: My responses will be delayed, I'm off to the airport...
>=20
Yep, so will be mine one, including this one! :-P

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org


--=-DvTp6D+xSOBAvF0/AUTx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw4HGIACgkQk4XaBE3IOsRUtQCfYyvnlZiqvFC/BWDefOF6VxFA
XccAmgOp3ksCGXU38UZXS9erFWomz4EZ
=fNRM
-----END PGP SIGNATURE-----

--=-DvTp6D+xSOBAvF0/AUTx--

