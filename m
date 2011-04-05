Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1DEPoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252Ab1DEPoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:44:37 -0400
Date: Tue, 5 Apr 2011 17:43:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>, ben@iagu.net
Subject: Re: [PATCH v2] posix-timers: RCU conversion
Message-ID: <20110405154318.GA20080@redhat.com>
References: <1300726498.2884.493.camel@edumazet-laptop> <4D8784A9.8040303@redhat.com> <1300727545.2884.513.camel@edumazet-laptop> <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com> <1300746429.2837.20.camel@edumazet-laptop> <1300777760.2837.38.camel@edumazet-laptop> <1301849660.2837.211.camel@edumazet-laptop> <1301940501.2319.25.camel@work-vm> <20110405144836.GA17490@redhat.com> <1302016682.3171.19.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302016682.3171.19.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05, Eric Dumazet wrote:
>
> Le mardi 05 avril 2011 à 16:48 +0200, Oleg Nesterov a écrit :
> >
> > Not that I really think it makes sense to change the patch... but we
> > could even use SLAB_DESTROY_BY_RCU, this is more effective. All we
> > need is ctor which sets ->it_signal = NULL and initializes ->it_lock
> > for lock_timer().
> >
>
> I considered this, but this means SLUB cannot merge the
> posix_timers_cache anymore.

OK, I see.

> > The question is, why do we use the global database for the timer ids.
> > All timers live in signal_struct->posix_timers anyway, perhaps we could
> > use a per-process array instead.
> >
>
> This would add some overhead at process creation (to initialize the
> 'array' or whatever tree root).

I am not sure. This initialization should be as simple as
"p->timers_array = NULL".

But,

> It would help some workloads, (create/delete timers from lot of
> different processes/cpus). I am not sure we really need this right now,
> since we waited 2011 before even trying to optimize read side ;)

Yes, agreed.

So, I think the patch is fine.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

