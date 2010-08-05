Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab0HEM3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:29:45 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:49664 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0HEM3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:29:42 -0400
X-Spam-ASN: 
Date: Thu, 5 Aug 2010 16:29:34 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCHv3 13/16] pps: capture MONOTONIC_RAW timestamps as well
Message-ID: <20100805162934.688280c6@desktopvm.lvknet>
In-Reply-To: <20100804162907.5c4e6345.akpm@linux-foundation.org>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<7e78eaffb92829465df0237fa7e4d1b183a1a511.1280952801.git.lasaine@lvk.cs.msu.su>
	<20100804162907.5c4e6345.akpm@linux-foundation.org>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/jWtUsy2FGp_YR.T8tfgpc61"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jWtUsy2FGp_YR.T8tfgpc61
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 4 Aug 2010 16:29:07 -0700
Andrew Morton <akpm@linux-foundation.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu,  5 Aug 2010 01:06:50 +0400
> Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:
>=20
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -286,6 +286,40 @@ void ktime_get_ts(struct timespec *ts)
> >  EXPORT_SYMBOL_GPL(ktime_get_ts);
> > =20
> >  /**
> > + * getnstime_raw_and_real - Returns both the time of day an raw
> > + * monotonic time in a timespec format
> > + * @ts_mono_raw:	pointer to the timespec to be set to raw
> > + *			monotonic time
> > + * @ts_real:		pointer to the timespec to be set to the time
> > + *			of day
> > + */
> > +void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *=
ts_real)
> > +{
> > +	unsigned long seq;
> > +	s64 nsecs_raw, nsecs_real;
> > +
> > +	WARN_ON(timekeeping_suspended);
>=20
> I suspect that if this warning ever triggers, it'll trigger at some
> high frequency making a complete mess all over the floor.
>=20
> WARN_ON_ONCE, perhaps?  Or just remove it?

Well, getnstime_raw_and_real() is actually just a merge of
getnstimeofday() and getrawmonotonic(). The warning came from
getnstimeofday(). Usually this code should be called once a second but
the frequency can be higher. IMHO other functions like getnstimeofday()
and ktime_get_ts() would be a bigger problem anyway because they have
the same checks.

So I'm ok with either choice.
Hmm, will use WARN_ON_ONCE then if nobody objects.

--=20
  Alexander

--Sig_/jWtUsy2FGp_YR.T8tfgpc61
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJMWq6vAAoJEElrwznyooJb7acH/2k8RwHuJEEuejERWgxQB43k
kf14+m7Zrr6wPmkCYVjU9LKyXvTQGWo4S4uS0rtTLsFJNwYhLogSqfIOLcL1/fmI
fS/OPROGWkMSEASpHB0QlgiN9wztvQllWnP97Q+Fd5ejTaeWQWBW9DdxfxC10y3v
NwtJ4HgmfGlNSbc5ubmA/eJnBNEDAsshYQe+zoE6AfNDjR0h68DVhU543O3jpX7W
EHnKjwZS4ZZeqknVdVOjWE3yx9dAsuvRIeuTr7+i5BAOe6mCQ85cbjbraAFsmb20
J/Bsj/59jJ8O36IvEAlcFw+OOm3oCVGA8Vp2xpEvxFfvmAcJGh94h4Mdbmye95s=
=nTcp
-----END PGP SIGNATURE-----

--Sig_/jWtUsy2FGp_YR.T8tfgpc61--
