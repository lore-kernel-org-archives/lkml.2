Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0GJJU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 05:20:59 -0400
Received: from ms01.sssup.it ([193.205.80.99]:32810 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827Ab0GJJU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 05:20:58 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Raistlin <raistlin@linux.it>
To: Luca Abeni <lucabe72@email.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278745761.5248.15.camel@localhost>
References: <1278682707.6083.227.camel@Palantir>
	 <1278745761.5248.15.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iZTBRcqCK9zTSiMGsGjp"
Date: Sat, 10 Jul 2010 11:20:47 +0200
Message-ID: <1278753647.4390.109.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iZTBRcqCK9zTSiMGsGjp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-07-10 at 09:09 +0200, Luca Abeni wrote:
> >  - do you think it could be useful to have a different syscall to deal
> >    with the period parameter (if it's different from deadline), e.g.,
> >    something useful to make the task periodic as you have (if I remembe=
r
> >    well) in Xenomai or RTAI?
> Maybe I am confused because I missed the initial part of the discussion,
> but here I think there is the risk to mix two different concepts: the
> "reservation period" (that is, the period P used to postpone the
> scheduling deadline when the budget arrives to 0), and the "task
> period" (which has to do with the periodicity of tasks activations).=20
>
Agree, this is also what I fear...

> For
> implementing a periodic behaviour in the task (this is, AFAIK, what RTAI
> similar API provide), no new syscall is needed: clock_nanosleep() is
> enough. See http://www.disi.unitn.it/~abeni/RTOS/rtapi.pdf for a
> (stupid) example.
>
Yep, agree again, just wanted to see what other folks' thoughts
were. :-)

> >    If you think it's worth doing that, do you think the
> >    task_wait_interval() syscall that we already added could/should do
> >    the job?
> I do not remember what task_wait_interval() does :)
> Is it the syscall you added to indicate the end of a job?
>=20
Yep. And it can be useful for that purpose, or not being used at all.

> I think if you want a different P_i and D_i you can use D_i for
> generating new scheduling deadlines on task arrivals as "d =3D t + D_i",
> and P_i to postpone the scheduling deadlines as "d =3D d + T_i" when the
> budget is 0.
>
Yes, that's exactly what we wanted to do, considered it's also a very
small and easy to achieve behavioural change...

> Depending on the replenishment amount you use, you might need to modify
> the admission test as "Sum_i(Q_i/min{P_i,D_i}) < 1" or not (if you
> always replenish to Q_i, then you need a modified admission test;
> otherwise, you can compute the replenishment amount so that the
> admission test is unaffected).
>=20
Well, as I tried to point out in the other e-mails, there also are other
problems with the admission test... Let's see if we find a consensus on
how to proceed... :-)

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-iZTBRcqCK9zTSiMGsGjp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw4O28ACgkQk4XaBE3IOsRQFwCeLK7Za80qkDXPMawzxLjobFYe
NVwAoJc0lmIM+VHN9fekIPhrI1MtaoZE
=ifIU
-----END PGP SIGNATURE-----

--=-iZTBRcqCK9zTSiMGsGjp--

