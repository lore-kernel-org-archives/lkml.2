Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab1DOEIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 00:08:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60141 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab1DOEIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 00:08:35 -0400
Date: Fri, 15 Apr 2011 14:08:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Len Brown <len.brown@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: Fix build on ARM and SH
Message-Id: <20110415140821.ca2b727d.sfr@canb.auug.org.au>
In-Reply-To: <4D9D523F.4090506@codeaurora.org>
References: <1301894612-10471-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<4D9D523F.4090506@codeaurora.org>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Apr_2011_14_08_21_+1000_cpdhumeZA0kLCMRU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Apr_2011_14_08_21_+1000_cpdhumeZA0kLCMRU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

Sorry for the delay.

On Wed, 06 Apr 2011 22:57:19 -0700 Stephen Boyd <sboyd@codeaurora.org> wrot=
e:
>
> On 4/3/2011 10:23 PM, Mark Brown wrote:
> > Commit 5f8cf82 (cpuidle: stop using pm_idle) converted arches to use
> > cpuidle_idle_call() but contained typos on ARM and SH transposing the
> > function name into cpuidle_call_idle().
> >
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>=20
> When will this patch get into linux-next? Every ARM and SH build has
> failed for the past 3 days presumably due to this. Stephen, can you pick
> it up for the time being?
>=20
> > ---
> >  arch/arm/kernel/process.c |    2 +-
> >  arch/sh/kernel/idle.c     |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> > index dc9d685..f47660e 100644
> > --- a/arch/arm/kernel/process.c
> > +++ b/arch/arm/kernel/process.c
> > @@ -197,7 +197,7 @@ void cpu_idle(void)
> >  				cpu_relax();
> >  			} else {
> >  				stop_critical_timings();
> > -				if (cpuidle_call_idle())
> > +				if (cpuidle_idle_call())
> >  					pm_idle();
> >  				start_critical_timings();
> >  				/*
> > diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
> > index 9c7099e..1db1968 100644
> > --- a/arch/sh/kernel/idle.c
> > +++ b/arch/sh/kernel/idle.c
> > @@ -101,7 +101,7 @@ void cpu_idle(void)
> >  			local_irq_disable();
> >  			/* Don't trace irqs off for idle */
> >  			stop_critical_timings();
> > -			if (cpuidle_call_idle())
> > +			if (cpuidle_idle_call())
> >  				pm_idle();
> >  			/*
> >  			 * Sanity check to ensure that pm_idle() returns

I fished the patch of LKML and have applied it from today.  However, I
think SH may need a further patch for this errors:

arch/sh/kernel/idle.c:25: error: static declaration of 'pm_idle' follows no=
n-static declaration
include/linux/pm.h:34: error: previous declaration of 'pm_idle' was here

Len, can you please get these fixed up in your idle-test tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__15_Apr_2011_14_08_21_+1000_cpdhumeZA0kLCMRU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNp8S1AAoJEDMEi1NhKgbscwkH/i/bb0FF5RvW3/lRC4l51VLB
8XVW4l4s/anRi2fkH14nBic+aslZcyjRwgYuUuhOFGPI3r9f+lczvTIyYODPsk7Z
fsNGx+1GZzLYt/ojAMHmLAd+lCBF//2ueK2gVYfwxM54re9MffCjO4KgtMugc/Zu
s3ErroCMhPU9QShM61G/LsXFhfJTrMJXA5/GPnVtdKXPBb3DKHhRVEt4NyT6Mbbj
kjqqNwW1K+GiJXtRofBrpZbRFCNyFMhqNXipSZplmJ79aYpL0fX+ssKgbs6O7hf6
sr3/Ai1HyJdRW3KjMpN6U4Y3B9kH88SI2X9sq1bjJRwhDp7aDxNhOU3ZxTih+AE=
=juoQ
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Apr_2011_14_08_21_+1000_cpdhumeZA0kLCMRU--
