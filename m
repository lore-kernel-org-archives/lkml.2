Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0KRTCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:02:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53930 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab0KRTCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:02:19 -0500
Date: Thu, 18 Nov 2010 20:02:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [build failure] Re: BKL: remove extraneous #include <smp_lock.h>
Message-ID: <20101118190205.GB10827@elte.hu>
References: <201011172159.oAHLx1tu001236@hera.kernel.org>
 <20101117140526.d532b373.randy.dunlap@oracle.com>
 <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com>
 <20101118094342.GA10382@elte.hu>
 <AANLkTi=Xoo90jiaQBMxchFkKXt0dgre0tWe-LnVR6aSD@mail.gmail.com>
 <AANLkTikV+KVmwKg4jS2KPG+9EFdd9qD-VUak4qOgFgr4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikV+KVmwKg4jS2KPG+9EFdd9qD-VUak4qOgFgr4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Nov 18, 2010 at 7:57 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > How painful would it be to move lock_depth into thread_struct? I guess
> > we don't have anything that cares about structure offsets in assembly
> > for that thing.  I should just try.
> 
> Gaah, the only generic field there is the restart_block, so we'd have
> to hide it there, or then add it to each architecture. So scratch
> that.
> 
> I guess this is the simplest approach.
> 
>                          Linus

>  include/linux/hardirq.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 714da7e..32f9fd6 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -94,6 +94,7 @@
>  #define in_nmi()	(preempt_count() & NMI_MASK)
>  
>  #if defined(CONFIG_PREEMPT) && defined(CONFIG_BKL)
> +# include <linux/sched.h>
>  # define PREEMPT_INATOMIC_BASE (current->lock_depth >= 0)
>  #else
>  # define PREEMPT_INATOMIC_BASE 0

Hey, i will quote this patch in the future, when you flame me about some ugly 
compatibility hack ;-)

I guess it will all go away with CONFIG_BKL so we dont really care so deeply. I'll 
test it.

Thanks,

	Ingo
