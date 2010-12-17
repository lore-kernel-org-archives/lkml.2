Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0LQSyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:54:13 -0500
Received: from ms01.sssup.it ([193.205.80.99]:47504 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751376Ab0LQSyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:54:11 -0500
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Harald Gustafsson <hgu1972@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1292596194.2266.283.camel@twins>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	 <1292596194.2266.283.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TXCBgddAQHrUlmoH/lfA"
Date: Fri, 17 Dec 2010 19:56:06 +0100
Message-ID: <1292612166.2697.68.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TXCBgddAQHrUlmoH/lfA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-12-17 at 15:29 +0100, Peter Zijlstra wrote:=20
> Solving the CPUfreq problem involves writing a SCHED_DEADLINE aware
> CPUfreq governor. The governor must know about the constraints placed on
> the system by the task-set. You simply cannot lower the frequency when
> your system is at u=3D1.
>=20
We already did the very same thing (for another EU Project called
FRESCOR), although it was done in an userspace sort of daemon. It was
also able to consider other "high level" parameters like some estimation
of the QoS of each application and of the global QoS of the system.

However, converting the basic mechanism into a CPUfreq governor should
be easily doable... The only problem is finding the time for that! ;-P=20

> The simple solution would be to slow down the runtime accounting of
> SCHED_DEADLINE tasks by freq/max_freq. So instead of having:
>=20
>   dl_se->runtime -=3D delta;
>=20
> you do something like:
>=20
>   dl_se->runtime -=3D (freq * delta) / max_freq;
>=20
> Which auto-magically grows the actual bandwidth, and since the deadlines
> are wall-time already it all works out nicely. It also keeps the
> overhead inside SCHED_DEADLINE.
>=20
And, at least for the meantime, this seems a very very nice solution.
The only thing I don't like is that division which would end up in being
performed at each tick/update_curr_dl(), but we can try to find out a
way to mitigate this, what do you think Harald?

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-TXCBgddAQHrUlmoH/lfA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0LskYACgkQk4XaBE3IOsTTjwCgpmYF1P66YqZlcFqKw44HxzCy
RnQAoI7P0g5A2mVIuAiDu+vH3+ILJ4bJ
=lAUr
-----END PGP SIGNATURE-----

--=-TXCBgddAQHrUlmoH/lfA--

