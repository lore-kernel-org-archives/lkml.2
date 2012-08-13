Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab2HMJOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 05:14:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58684 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925Ab2HMJOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 05:14:11 -0400
Date: Mon, 13 Aug 2012 10:13:49 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
Message-ID: <20120813091349.GA19113@mudshark.cambridge.arm.com>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208090029460.5231@xanadu.home>
 <20120809144953.GC18486@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208091201380.5231@xanadu.home>
 <alpine.LFD.2.02.1208091243080.5231@xanadu.home>
 <1344845704.31459.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344845704.31459.11.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Aug 13, 2012 at 09:15:04AM +0100, Peter Zijlstra wrote:
> On Thu, 2012-08-09 at 12:57 -0400, Nicolas Pitre wrote:
> > 
> > In other words, I think this should look like this:
> > 
> > diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
> > index 580a6d35c7..44a66c99c8 100644
> > --- a/include/asm-generic/mutex-xchg.h
> > +++ b/include/asm-generic/mutex-xchg.h
> > @@ -25,8 +25,11 @@
> >  static inline void
> >  __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
> >  {
> > -       if (unlikely(atomic_xchg(count, 0) != 1))
> > -               fail_fn(count);
> > +       if (unlikely(atomic_xchg(count, 0) != 1)) {
> > +               /* Mark lock contention explicitly */
> > +               if (likely(atomic_xchg(count, -1) != 1))
> > +                       fail_fn(count);
> > +       }
> >  } 
> 
> OK, I like this.. Thanks guys! Will will you send a final and complete
> patch?

I sent one out on Friday but somehow managed to drop you from CC -- sorry
about that:

  http://thread.gmane.org/gmane.linux.kernel/1341305

Cheers,

Will
