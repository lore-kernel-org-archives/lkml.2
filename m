Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab0KKNyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:54:21 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43778 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756159Ab0KKNyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:54:20 -0500
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
In-Reply-To: <1289482333.2084.102.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>  <1289410114.2084.23.camel@laptop>
	 <1289427476.13577.285.camel@Palantir>  <1289482333.2084.102.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lLRaCVA6WHHEuI6pBg2Q"
Date: Thu, 11 Nov 2010 14:54:08 +0100
Message-ID: <1289483648.6525.10.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lLRaCVA6WHHEuI6pBg2Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 14:32 +0100, Peter Zijlstra wrote:
> > BTW, as Dhaval was suggesting, are (after those changes) fine with this
> > new sched_param? Do we need some further mechanism to grant its
> > extendability?
> > Padding?
> > Versioning?
> > void *data field?
> > Whatever?
> >=20
> > :-O
> >=20
> > I'd like very much to have some discussion here, if you think it is
> > needed, in hope of avoiding future ABI issues as much as possible! :-P
>=20
> Right, so you mentioned doing s/_ex/2/ on all this stuff, which brings
> it more in line with that other syscalls have done.
>=20
Sure, this is necessary and easy to achieve. :-)

> The last three parameters look to be output only as I've not yet found
> code that reads it, and __getparam_dl() doesn't even appear to set
> used_runtime.
>=20
Yeah, just kind of statistical reporting of the task's behaviour. That's
why I was in agreement with Dhaval about using schedstats for those
(bumping the version, obviously). What do you think?

> One thing you can do is add some padding, versioning and void*
> extentions are doable for the setparam() path, but getparam() is going
> to be mighty interesting.
>=20
Mmm... So, tell me if I got it well: I remove the last three parameters
(e.g., moving them toward schedstats) and add (besides _var and _max)
some padding? It that correct?

what about the len <=3D=3D sizeof(struct sched_param2) in
sched_{set,get}{param,scheduler}2()... Does this still make sense, or
are we removing it?

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-lLRaCVA6WHHEuI6pBg2Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzb9YAACgkQk4XaBE3IOsSU+gCgp20y4JyQBxQxN1YEdTaAIggj
RF4AmgMaUGfcN/5uKWjVi3wJAX3l9yJH
=davI
-----END PGP SIGNATURE-----

--=-lLRaCVA6WHHEuI6pBg2Q--

