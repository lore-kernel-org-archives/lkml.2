Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1ADSMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:12:07 -0500
Received: from ms01.sssup.it ([193.205.80.99]:52080 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022Ab1ADSME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:12:04 -0500
Subject: Re: [RFC][PATCH 0/3] Refactoring sched_entity and sched_rt_entity.
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Darren Hart <darren@dvhart.com>, oleg <oleg@redhat.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, pjt@google.com,
        bharata@linux.vnet.ibm.co, lucas.de.marchi@gmail.com
In-Reply-To: <1294157944.2016.166.camel@laptop>
References: <1294156524.6169.147.camel@Palantir>
	 <1294157944.2016.166.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JJN1jRdSWc3EFqaSXoxC"
Date: Tue, 04 Jan 2011 19:11:40 +0100
Message-ID: <1294164700.6169.197.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JJN1jRdSWc3EFqaSXoxC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-01-04 at 17:19 +0100, Peter Zijlstra wrote:=20
> > OTOH, groups are always considered both fair _and_ RT entities, for
> > example they're always queued in _both_ an RT run_list and a fair
> > rb-tree. So I can't put them in an union, because I need both at the
> > same time!
>=20
> Just like its now, keep a sched_entity per class.
>=20
> struct task_group {
>=20
> #ifdef CONFIG_FAIR_GROUP_SCHED
> 	struct sched_entity **cfs_se;
> 	...
> #endif
>=20
> #ifdef CONFIG_RT_GROUP_SCHED
> 	struct sched_entity **rt_se;
> 	...
> #endif
>=20
> }
>=20
Well, sure this can be done. But what about the common fields? I guess
you're suggesting to use something like `struct sched_entity_common' and
putting them there, aren't you?

If yes, I'm fine with that, although it'll add one more level of
indirection for those fields (e.g., p->se.comm.on_rq). Are we cool with
this?

> I see once clash with my current ttwu patch set though, see:
>=20
>   http://lkml.org/lkml/2011/1/4/228
>=20
> But that should be easy to resolve.
>
It's based on current tip, and yes, I plan to keep it updated and solve
the clashes as soon as I run into them. :-)

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-JJN1jRdSWc3EFqaSXoxC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0jYtwACgkQk4XaBE3IOsTBmgCfUhQ5kMtOI4XRVzX1fHmZO7zm
KIcAn3at/U7WnABnSl6KMndxECEqhBNb
=6Fx5
-----END PGP SIGNATURE-----

--=-JJN1jRdSWc3EFqaSXoxC--

