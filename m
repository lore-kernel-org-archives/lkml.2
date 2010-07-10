Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab0GJHuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 03:50:39 -0400
Received: from ms01.sssup.it ([193.205.80.99]:35897 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751527Ab0GJHui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 03:50:38 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278685951.1900.215.camel@laptop>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685951.1900.215.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UebN3eRwJQsxfGhkHQ1e"
Date: Sat, 10 Jul 2010 09:50:27 +0200
Message-ID: <1278748227.4390.26.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UebN3eRwJQsxfGhkHQ1e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-07-09 at 16:32 +0200, Peter Zijlstra wrote:
> On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
> >  - do you think it could be useful to have a different syscall to deal
> >    with the period parameter (if it's different from deadline), e.g.,
> >    something useful to make the task periodic as you have (if I remembe=
r
> >    well) in Xenomai or RTAI?
> >    If you think it's worth doing that, do you think the
> >    task_wait_interval() syscall that we already added could/should do
> >    the job?=20
>=20
> Again, I'm afraid I need some extra education here in order to make a
> sensible comment.
>=20
Hey, fine, where's the problem? :-P

> What are the exact semantics of this extra proposed syscall?
>=20
Right now, it is:
task_wait_interval(t) --> "wake me up at the first instant after t when=20
			   you can give me my full runtime"

> What exactly are the benefits over not having it, and simply rely on the
> task to not wake up more often, but if it does have it run into the lack
> of budget and sort it that way?
>
What you're saying obviously will always work, and it is actually a
quite common usage pattern (we use it like that a lot! :-)).

The new syscall might help when it is important for a task to
synchronize with the budget provisioning mechanism. It might be
uncommon, but there could be situations --more in hard than in soft
scenarios-- where you want to be sure that you're next job (and all the
subsequent ones, if you behave well) will get its full runtime, even if
this means waiting a little bit.

what I was wondering was if this semantic should be modified by the
introduction of the "period", but I also agree with Luca that we must do
our best to avoid confusion!

Regards,
Dario
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-UebN3eRwJQsxfGhkHQ1e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw4JkMACgkQk4XaBE3IOsTkmgCeOOrO4PBhLw9E2C2uCtXEpkJI
av8AnAry/CRpPIergtm9R/RWFUGqI7AU
=qxx8
-----END PGP SIGNATURE-----

--=-UebN3eRwJQsxfGhkHQ1e--

