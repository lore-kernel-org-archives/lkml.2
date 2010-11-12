Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab0KLPjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:39:48 -0500
Received: from ms01.sssup.it ([193.205.80.99]:36831 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932209Ab0KLPjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:39:47 -0500
Subject: Re: [RFC][PATCH 17/22] sched: add signaling overrunning -deadline
 tasks.
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
In-Reply-To: <1289512701.2084.197.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334428.8661.158.camel@Palantir>  <1289512701.2084.197.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zr/D79Q8OLhxN4K599Of"
Date: Fri, 12 Nov 2010 16:39:32 +0100
Message-ID: <1289576372.6525.512.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zr/D79Q8OLhxN4K599Of
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 22:58 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:40 +0200, Raistlin wrote:
> > +static inline void __dl_signal(struct task_struct *tsk, int which)
> > +{
> > +       struct siginfo info;
> > +       long long amount =3D which =3D=3D SF_SIG_DMISS ? tsk->dl.stats.=
last_dmiss :
> > +                          tsk->dl.stats.last_rorun;
> > +
> > +       info.si_signo =3D SIGXCPU;
> > +       info.si_errno =3D which;
> > +       info.si_code =3D SI_KERNEL;
> > +       info.si_pid =3D 0;
> > +       info.si_uid =3D 0;
> > +       info.si_value.sival_int =3D (int)amount;
> > +
> > +       /* Correctly take the locks on task's sighand */
> > +       __group_send_sig_info(SIGXCPU, &info, tsk);
> > +       /* Log what happened to dmesg */
> > +       printk(KERN_INFO "SCHED_DEADLINE: 0x%4x by %Ld [ns] in %d (%s)\=
n",
> > +              which, amount, task_pid_nr(tsk), tsk->comm);
> > +}=20
>=20
> This being a G-EDF like scheduler with a u<=3D1 schedulability test, we'r=
e
> firmly in soft-rt territory which means the above will be very easy to
> trigger.. Maybe not spam dmesg?
>
Ok, right. Maybe, if I add the SF_HARD_RT flag (and force the hard tasks
to run on a single CPU they must specify) I can keep the notification
for those tasks only. What do you think?

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-zr/D79Q8OLhxN4K599Of
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdX7QACgkQk4XaBE3IOsStSgCcCUyoK92sibqFHwUCdIgTrieR
CnMAni5o9vsC6ipwpEKGBOR8IwCcfhX8
=J8Eu
-----END PGP SIGNATURE-----

--=-zr/D79Q8OLhxN4K599Of--

