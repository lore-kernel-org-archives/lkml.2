Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842Ab0FQXEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:04:35 -0400
Received: from ozlabs.org ([203.10.76.45]:33714 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab0FQXEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:04:23 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix capacity calculations for SMT4
In-reply-to: <1276152536.2046.2479.camel@twins>
References: <20100608045702.21D03CC895@localhost.localdomain> <tip-9d5efe05eb0c904545a28b19c18b949f23334de0@git.kernel.org> <12629.1276124617@neuling.org> <1276152536.2046.2479.camel@twins>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Thu, 10 Jun 2010 08:48:56 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 18 Jun 2010 09:04:22 +1000
Message-ID: <15364.1276815862@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1276152536.2046.2479.camel@twins> you wrote:
> On Thu, 2010-06-10 at 09:03 +1000, Michael Neuling wrote:
> > Peter,
> >=20
> > It looks like when this was pushed to Ingo, some of the logic was
> > changed.  rt_freq_influence() became fix_small_capacity() but the return
> > values for these two functions are opposite (return 1 =3D> return 0 and
> > visa versa]]).
> >=20
> > This was changed in the sibling test (return 1 =3D> return 0), but the
> > check for the change in cpu power due to freq and rt was not.
> >=20
> > So either the return values need to be changed at the end of
> > fix_small_capacity() or the cpu_power test needs to be the other way
> > around.  Below changes the cpu_power test as it brings it more inline
> > with the comment above it.
> >=20
> > Without this the asymmetric packing doesn't work.
> 
> D'oh fully my fault for cleaning up.
> 
> Thanks, I'll make sure it gets fixed.

Peter,

I've not see this fix (or the doc/comment update patch from here
https://patchwork.kernel.org/patch/105256/) hit Ingo tip tree as yet.
When you are likely to push it to him?

Mikey

> 
> > Subject: sched: fix the CPU power test for fix_small_capacity
> >=20
> > The CPU power test is the wrong way around in fix_small_capacity.
> >=20
> > This was due to a small changes made in the posted patch on lkml to what
> > was was taken upstream.
> >=20
> > This patch fixes asymmetric packing for POWER7.
> >=20
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> >=20
> > Index: linux-2.6-ozlabs/kernel/sched_fair.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6-ozlabs.orig/kernel/sched_fair.c
> > +++ linux-2.6-ozlabs/kernel/sched_fair.c
> > @@ -2354,7 +2354,7 @@ fix_small_capacity(struct sched_domain *
> >  	/*
> >  	 * If ~90% of the cpu_power is still there, we're good.
> >  	 */
> > -	if (group->cpu_power * 32 < group->cpu_power_orig * 29)
> > +	if (group->cpu_power * 32 > group->cpu_power_orig * 29)
> >  		return 1;
> > =20
> >  	return 0;
> >=20
> 
