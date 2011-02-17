Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab1BQRSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:18:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34669 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821Ab1BQRS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:18:29 -0500
Date: Thu, 17 Feb 2011 18:18:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jolsa@redhat.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tracing: Add unstable sched clock note to the
 warning
Message-ID: <20110217171823.GB17058@elte.hu>
References: <1296649698-6003-1-git-send-email-jolsa@redhat.com>
 <tip-5e38ca8f3ea423442eaafe1b7e206084aa38120a@git.kernel.org>
 <1297957180.23343.915.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297957180.23343.915.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2011-02-17 at 15:00 +0000, tip-bot for Jiri Olsa wrote:
> > Commit-ID:  5e38ca8f3ea423442eaafe1b7e206084aa38120a
> > Gitweb:     http://git.kernel.org/tip/5e38ca8f3ea423442eaafe1b7e206084aa38120a
> > Author:     Jiri Olsa <jolsa@redhat.com>
> > AuthorDate: Wed, 2 Feb 2011 13:28:18 +0100
> > Committer:  Steven Rostedt <rostedt@goodmis.org>
> > CommitDate: Tue, 8 Feb 2011 11:57:22 -0500
> > 
> > tracing: Add unstable sched clock note to the warning
> > 
> > The warning "Delta way too big" warning might appear on a system with
> > unstable shed clock right after the system is resumed and tracing
> > was enabled during the suspend.
> > 
> > Since it's not realy bug, and the unstable sched clock is working
> > fast and reliable otherwise, Steven suggested to keep using the
> > sched clock in any case and just to make note in the warning itself.
> > 
> 
> 
> Peter Zijlstra just informed me on IRC that the commit:
> 
> cd7240c0b900eb6d690ccee088a6c9b46dae815a
> x86, tsc, sched: Recompute cyc2ns_offset's during resume from sleep
> states
> 
> Prevents the clock from going backwards triggering the warn on. If this
> is the case, I think we can revert this patch.
> 
> I'll wait on the original reporters of the bug to find out. If the clock
> does not go backwards when the above commit is applied, then this patch
> is not needed.
> 
> If this is the case, do you want me to rebase without it, or should we
> just revert it?

A revert would be nicer (with an explanation in it), as i've already pushed out the 
perc/core tree.

If you do the revert today against the current perf/core tip (bee96907383e) then i 
can pull it in a fast-forward way and we'd minimalize the window.

Thanks,

	Ingo
