Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0GJOtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 10:49:23 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49944 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753333Ab0GJOtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 10:49:22 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bjoern Brandenburg <bbb@email.unc.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1278757684.1998.26.camel@laptop>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685133.1900.201.camel@laptop>
	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
	 <1278693304.1900.266.camel@laptop>  <1278752489.4390.97.camel@Palantir>
	 <1278757684.1998.26.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hQnWTME5eO86aon7EcRL"
Date: Sat, 10 Jul 2010 16:49:08 +0200
Message-ID: <1278773348.4390.358.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hQnWTME5eO86aon7EcRL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-07-10 at 12:28 +0200, Peter Zijlstra wrote:
> > Mmm... I see... Are you thinking of another scheduling class? Or maybe
> > just another queue with "higher priority" inside the same scheduling
> > class (sched_dl.c)?
>=20
> Inside the same class, since as you say that would allow sharing lots of
> things, also conceptually it makes sense as the admission tests would
> really have to share a lot of data between them anyway.
>=20
Ok, fine. So my plan is to let what I have out really as fast as I can
so that you can see the progresses we made, and then start working on
this new thing...

> Right, so that's a good point, I'm wondering if we should use two
> separate policies or use the one policy, SCHED_DEADLINE, and use flags
> to distinguish between these two uses.
>
> Anyway, that part is the easy part to implement and shouldn't take more
> than a few minutes to flip between one and the other.
>=20
Yes, that will be need very low effort to change.

> But if you have a per-cpu bandwidth, and the number of cpus, you also
> have the total amount of bandwidth available to G-EDF, no?
>=20
That's for sure true. If you like that I can add something like it quite
easily... I'll try to do that on a per-domain basis, instead of truly
fully global.

> So it really doesn't matter how we specify the group budget, one global
> clock or one clock per cpu, if we have the number of cpus involved we
> can convert between those.
>=20
>    (c) use a 'global' bw pool and be blissfully ignorant of the
>        per-cpu things?
>=20
Ok, if it's not a problem having a global pool I think I'll keep the per
CPU bw specification as well as per CPU bw availability. Not only
because I like multiplication more than divisions, but since I think
they could be useful if someone want to achieve a partitioned behaviour
through setting affinities accordingly.

> > Ok, that seems possible to me, but since I have to write the code you
> > must tell me what you want the semantic of (syswide and per-group)
> > sched_dl_{runtime,period} to become and how should I treat them! :-)
>=20
> Right, so for the system-wide and group bandwidth limits I think we
> should present them as if there's one clock, and let the scheduler sort
> out how many cpus are available to make it happen.
>=20
As said above, I agree and I'll do exactly that...

> So we specify bandwidth as if we were looking at our watch, and say,
> this here group can consume 30 seconds every 2 minutes. If the
> load-balance domains happen to be larger than 1 cpu, hooray we can run
> more tasks and the total available bandwidth simply gets multiplied by
> the number of available cpus.
>=20
> Makes sense?
>=20
Yep. Thanks! :-)

Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-hQnWTME5eO86aon7EcRL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw4iGQACgkQk4XaBE3IOsTAhACgn7K8AlRL9cNoD5cvoHqHsnV7
HxUAoKqObTqsJypGvYwaF/QQKOeCp2BF
=YKc3
-----END PGP SIGNATURE-----

--=-hQnWTME5eO86aon7EcRL--

