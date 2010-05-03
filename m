Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186Ab0ECNr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:47:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33711 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab0ECNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HsTuU4mhThMTfp81g+67ajoARv9iBnh0bSCGoloQdnrCVBJLnp/4pFYV+ddPM2/1QW
         0RPszP2tva4LzBF3ILk54mSRKunWv3RG1jZRGCt5yHA73PfsgPeqc06OxSv/Az459Ti3
         /6XRlPfLEvCkxOhMK5ucWwt41yeP6MrquKsGA=
Date: Mon, 3 May 2010 15:47:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] lockdep updates
Message-ID: <20100503134748.GB5497@nowhere>
References: <1272648859-7203-1-git-send-regression-fweisbec@gmail.com> <20100503072331.GD6642@elte.hu> <20100503130035.GA19763@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503130035.GA19763@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 03:00:35PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Ingo,
> > > 
> > > Please pull the core/locking branch that can be found at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > > 	core/locking
> > > 
> > > Note there is also a merge of v2.6.34-rc6 because these patches
> > > depend on older per cpu updates.
> > > 
> > > Thanks,
> > > 	Frederic
> > > ---
> > > 
> > > Frederic Weisbecker (2):
> > >       lockdep: Fix redundant_hardirqs_on incremented with irqs enabled
> > >       lockdep: Simplify debug atomic ops
> > > 
> > > 
> > >  kernel/lockdep.c           |    7 ++++++-
> > >  kernel/lockdep_internals.h |   10 ++--------
> > >  2 files changed, 8 insertions(+), 9 deletions(-)
> 
> this one is causing:
> 
> kernel/lockdep.c:2306: error: 'lockdep_stats' undeclared (first use in this function)
> kernel/lockdep.c:2306: error: (Each undeclared identifier is reported only once
> kernel/lockdep.c:2306: error: for each function it appears in.)
> 
> with these settings:
> 
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_LOCKDEP is not set
> # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> 
> Thanks,
> 
> 	Ingo


Ah, I unconditionally deref lockdep_stats there. Ok, will
fix.

I'm not home yet, but once I can, will send the fix asap.

Thanks.

