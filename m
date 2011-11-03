Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1KCFIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 01:08:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38038 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1KCFIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 01:08:09 -0400
Date: Thu, 3 Nov 2011 10:13:44 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>, Shuah Khan <shuah.khan@hp.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Russell King <rmk@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] [RFC][PATCH X86_32 1/2]: Call do_notify_resume() with
 interrupts enabled
Message-ID: <20111103044344.GC2335@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111025141812.GA21225@linux.vnet.ibm.com>
 <20111025161426.GC17067@redhat.com>
 <CA+55aFx4g-3yGOgdS-UOGGincbAOgdxwfHCHpd-yVU6-dKwv0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFx4g-3yGOgdS-UOGGincbAOgdxwfHCHpd-yVU6-dKwv0w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110305-5930-0000-0000-000000D89E18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ingo, Thomas, I think this is your call, but it seems valid,
> 
>                  Linus
> 

Hey Ingo, Thomas,

Can you please let me know if you have taken a look at this patch and if
you have any reservations? 

I would also be happy to know your thoughts on the other patch in the
series which makes sure that notify_die is called irrespective of
kprobes.

-- 
Thanks and Regards
Srikar

> On Tue, Oct 25, 2011 at 6:14 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 10/25, Srikar Dronamraju wrote:
> >>
> >> do_notify_resume() gets called with interrupts disabled on x86_32. This
> >> is different from the x86_64 behavior, where interrupts are enabled at
> >> the time.
> >
> > And note that do_notify_resume() paths assume that irqs are enabled.
> > key_replace_session_keyring/get_signal_to_deliver start with _lock_irq.
> >
> > IOW, I vote for this change even if I can't ack it (although it looks
> > "obviously correct" to me). In fact refrigerator() looks buggy without
> > this change. Yes, it enables irqs but only "by accident", via unlock_irq().
> > And we are going to remove this recalc_sigpending() from freezer.
> >
> >
> >> Queries on lkml on this issue hasn't yielded any clear answer. Lets make
> >> x86_32 behave the same as x86_64, unless there is a real reason to
> >> maintain status quo.
> >>
> >> Please refer https://lkml.org/lkml/2011/9/27/130 for more details
> >>
> >> A similar change was suggested in arm
> >>       https://lkml.org/lkml/2011/8/25/231
> >>
> >> My 32-bit machine works fine (tm) with the patch below
> >>

