Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0K2RHC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:07:02 -0500
Received: from ms01.sssup.it ([193.205.80.99]:57384 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752763Ab0K2RHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:07:00 -0500
Subject: Re: [tip:sched/core] sched: Do not account irq time to current task
From: Raistlin <raistlin@linux.it>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20101129142213.GA2573@zhy>
References: <1286237003-12406-7-git-send-email-venki@google.com>
	 <tip-305e6835e05513406fa12820e40e4a8ecb63743c@git.kernel.org>
	 <AANLkTin-U-kzr27ArR60K=eE5Jq+sPdTQ7JNhQg711c7@mail.gmail.com>
	 <1291031990.32004.24.camel@laptop>  <20101129142213.GA2573@zhy>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lfwgdNT7xycOxHX3qf05"
Date: Mon, 29 Nov 2010 18:06:35 +0100
Message-ID: <1291050395.2697.259.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lfwgdNT7xycOxHX3qf05
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-11-29 at 22:22 +0800, Yong Zhang wrote:
> > If you still want to throttle RT tasks simply ensure their bandwidth
> > constraint is lower than the available time.
>=20
> But the available time is harder to calculated than before.
>
Well, it shouldn't... I would say it makes it easier! :-P

> IRQ is random, so as to the irq_time.
>
Well, that's definitely true, as it is true that the time needed to deal
with IRQ is now somehow "lost" or "hidden" (meaning that it is not
accounted to anyone).

> But the unthrottle(do_sched_rt_period_timer()) runs in fixed
> period which is based on hard clock.
>=20
> Is that what we want?
>=20
I'm not sure I'm getting what the issue is here... Do you have an
example do discuss?
Because, referring to the one in your first e-mail, if in the last
period (of 1sec) we spent 900ms running -rt tasks and 50ms servicing
interrupts, given a limit was 950ms for sched_rt, why should we throttle
them? :-O

Well, I see that this could mean that all we'd do in that period will be
servicing interrupts and running -rt tasks (for _their_ last 50ms) but,
also means (at least to me) that your system needs some more design
effort.
Then I can also agree on the point that it might make sense to think a
bit on how to take the 50ms from interrupts somehow into account, but
just charging -rt tasks for that time seems quite arbitrary... :-O

Something that I've done recently is trying to figure out, if interrupts
handler have their own threads (as in PREEMPT_RT), what happens if you
try constraining the bandwidth of those thread, using proper scheduling
mechanisms (such as deadline scheduling, but rt-throttling could also be
a "reasonable approximation" :-P)... But it's just preliminary research
results.

BTW, having handlers in threads could actually be the solution per-se
here, since they would then consume -rt bandwidth (if set to -rt) and
contribute to throttling... :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-lfwgdNT7xycOxHX3qf05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzz3ZsACgkQk4XaBE3IOsQRCACfdVz+hkWXKH0i3HI3nVUp0yem
QTcAn2c8aOHaIQKf/IMU/fbP9nIlFVvN
=iRac
-----END PGP SIGNATURE-----

--=-lfwgdNT7xycOxHX3qf05--

