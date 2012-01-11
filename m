Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab2AKOUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 09:20:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42935 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab2AKOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 09:20:20 -0500
Date: Wed, 11 Jan 2012 15:20:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [BUG] kernel freezes with latest tree
Message-ID: <20120111142011.GA7991@somewhere.redhat.com>
References: <1326171798.6638.4.camel@edumazet-laptop>
 <1326183371.6638.6.camel@edumazet-laptop>
 <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
 <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
 <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
 <1326234230.2614.15.camel@edumazet-laptop>
 <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 03:44:38PM -0800, Linus Torvalds wrote:
> On Tue, Jan 10, 2012 at 2:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > Maybe a recent change in NMI handling, or perf events ?
> 
> Unlikely. And it shouldn't show up in the merge commit anyway, those
> things should be pretty independent.
> 
> > No idea why the bisection (I redid it carefully : same result) points to the above commit.
> 
> Ok, so the bisect is almost certainly correct. But just to be anal and
> really careful, can you independently check both parents of the merge,
> and then re-check the merge itself, and verify that the two parent
> commits never hang, and that the merged state hangs.
> 
> Just to take any bisection issues out of the picture, and just verify
> those three commits by hand.
> 
> But in the meantime, we should assume that it's the merge that is the problem.
> 
> I added Frederic to the cc, because he did the
> tick_nohz_idle_enter_norcu(), so maybe he can tell if there is
> something in that merge that looks suspicious (Frederic - see the
> history of the thread on lkml. I thought maybe it was the lack of
> irq-disable around set_cpu_sd_state_idle(), but Eric already tested
> that). And Suresh because he worked on the whole nohz/nr_busy_cpus.
> Maybe you guys see some obvious semantic clash..

As the thread evolved I guess we found the issue or at least we
got more clues.

But just in case, I double checked the merge but nothing looked
suspicious to me.

Thanks.

> 
> Anybody? Any ideas? Clearly there can be a merge problem that doesn't
> actually show as a real data conflict, just some semantic conflict,
> but I don't see what such issues would be brouht in by the scheduler
> merge anyway.
> 
>                        Linus
