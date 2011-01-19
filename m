Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1ASMEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:04:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42233 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab1ASMEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:04:42 -0500
Date: Wed, 19 Jan 2011 13:04:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH] sched: Notify hrtimer users of switches to NOHZ mode
Message-ID: <20110119120412.GA3527@elte.hu>
References: <1295419594-13085-1-git-send-email-sboyd@codeaurora.org>
 <1295437420.28776.4.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295437420.28776.4.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-01-18 at 22:46 -0800, Stephen Boyd wrote:
> > When NOHZ=y and high res timers are disabled (via cmdline or
> > Kconfig) tick_nohz_switch_to_nohz() will notify the user about
> > switching into NOHZ mode. Nothing is printed for the case where
> > HIGH_RES_TIMERS=y. Fix this for the HIGH_RES_TIMERS=y case by
> > duplicating the printk from the low res NOHZ path in the high res
> > NOHZ path.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> > 
> > This confused me since I was thinking 'dmesg | grep -i NOHZ' would
> > tell me if NOHZ was enabled, but if I have hrtimers there is
> > nothing. If we don't do this we should probably remove the original
> > printk.
> 
> I'm not quite sure we want _more_ dmesg chatter, [...]

Well, we used to have bugs in the past where the system locked up after changing the 
main hrtimer mode, so the messages are useful.

This patch completes the messages in that sense and makes them consistent. If we 
want to remove them altogether that would be another patch.

Thanks,

	Ingo
