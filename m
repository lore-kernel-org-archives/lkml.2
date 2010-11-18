Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab0KRTEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:04:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:19496 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab0KRTEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:04:47 -0500
Date: Thu, 18 Nov 2010 11:04:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [build failure] Re: BKL: remove extraneous #include
 <smp_lock.h>
Message-Id: <20101118110409.f9c8d7d2.randy.dunlap@oracle.com>
In-Reply-To: <20101118190205.GB10827@elte.hu>
References: <201011172159.oAHLx1tu001236@hera.kernel.org>
	<20101117140526.d532b373.randy.dunlap@oracle.com>
	<AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com>
	<20101118094342.GA10382@elte.hu>
	<AANLkTi=Xoo90jiaQBMxchFkKXt0dgre0tWe-LnVR6aSD@mail.gmail.com>
	<AANLkTikV+KVmwKg4jS2KPG+9EFdd9qD-VUak4qOgFgr4@mail.gmail.com>
	<20101118190205.GB10827@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 20:02:05 +0100 Ingo Molnar wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, Nov 18, 2010 at 7:57 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > How painful would it be to move lock_depth into thread_struct? I guess
> > > we don't have anything that cares about structure offsets in assembly
> > > for that thing.  I should just try.
> > 
> > Gaah, the only generic field there is the restart_block, so we'd have
> > to hide it there, or then add it to each architecture. So scratch
> > that.
> > 
> > I guess this is the simplest approach.
> > 
> >                          Linus
> 
> >  include/linux/hardirq.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> > index 714da7e..32f9fd6 100644
> > --- a/include/linux/hardirq.h
> > +++ b/include/linux/hardirq.h
> > @@ -94,6 +94,7 @@
> >  #define in_nmi()	(preempt_count() & NMI_MASK)
> >  
> >  #if defined(CONFIG_PREEMPT) && defined(CONFIG_BKL)
> > +# include <linux/sched.h>
> >  # define PREEMPT_INATOMIC_BASE (current->lock_depth >= 0)
> >  #else
> >  # define PREEMPT_INATOMIC_BASE 0
> 
> Hey, i will quote this patch in the future, when you flame me about some ugly 
> compatibility hack ;-)
> 
> I guess it will all go away with CONFIG_BKL so we dont really care so deeply. I'll 
> test it.


Ingo, I built it with your posted config file.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
