Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab0KKR2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:28:11 -0500
Received: from ms01.sssup.it ([193.205.80.99]:42541 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751041Ab0KKR2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:28:09 -0500
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
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
In-Reply-To: <1289484531.2084.113.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>  <1289410114.2084.23.camel@laptop>
	 <1289427476.13577.285.camel@Palantir>  <1289482333.2084.102.camel@laptop>
	 <1289483648.6525.10.camel@Palantir>  <1289484531.2084.113.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hWW1icVQTuXn5tg+uJSC"
Date: Thu, 11 Nov 2010 18:27:56 +0100
Message-ID: <1289496476.6525.25.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hWW1icVQTuXn5tg+uJSC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 15:08 +0100, Peter Zijlstra wrote:
> I'm not really a fan of schedstat, esp if you have to use it very
> frequently, the overhead of open()+read()+close() + parsing text is
> quite high.
>=20
> Then again, if people are really going to use this (big if I guess) we
> could add yet another syscall for this or whatever.
>=20
Ok, we'll see at that time.

> grmbl, so I was going to say, just pad it to a nice 2^n size, but then I
> saw that struct timespec is defined as two long's, which means we're
> going to have to do compat crap.
>=20
> Thomas is there a sane time format in existence? I thought the whole
> purpose of timeval/timespec was to avoid having to use a u64, but then
> using longs as opposed to int totally defeats the purpose.=20
>=20
Fine, and u64 will be. Going for that...

> > what about the len <=3D=3D sizeof(struct sched_param2) in
> > sched_{set,get}{param,scheduler}2()... Does this still make sense, or
> > are we removing it?=20
>=20
> Since we're going for a constant sized structure we might as well take
> it out.
>
... and for that!

thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-hWW1icVQTuXn5tg+uJSC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzcJ5wACgkQk4XaBE3IOsSUwACfW0PJW1GkkaJBxazBn+6TRcZB
7+0AoJfjumi0ph1yJuulY88Ecz69et4t
=Lkft
-----END PGP SIGNATURE-----

--=-hWW1icVQTuXn5tg+uJSC--

