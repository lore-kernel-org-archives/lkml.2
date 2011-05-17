Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab1EQSry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:47:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50753 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab1EQSrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:47:53 -0400
Date: Tue, 17 May 2011 20:47:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4] watchdog: configure nmi watchdog period based on
 watchdog_thresh
Message-ID: <20110517184741.GA29574@elte.hu>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
 <1305588901-8141-4-git-send-email-msb@chromium.org>
 <20110517071642.GF22305@elte.hu>
 <20110517140334.GK31888@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517140334.GK31888@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Tue, May 17, 2011 at 09:16:42AM +0200, Ingo Molnar wrote:
> > Hm, our tolerance for the two thresholds is not just human but technical: hard 
> > lockup warnings should indeed be triggered after just a few seconds, soft 
> > lockups can have false positives under extreme conditions.
> > 
> > So we generally want a higher threshold for soft lockups than for hard lockups.
> > 
> > So how about we couple the thresholds with a factor: we make the soft threshold 
> > twice the amount of time the hard threshold is? Then we could change the 
> > upstream default as well i think: lets change the NMI timeout to 10 seconds 
> > (and thus have the soft threshold at 20 seconds). Is 20 seconds short enough 
> > for most users to not hit reset?
> 
> Making softlockup twice as long as hardlockup seems to make sense.
> Setting the hardlockup to 10 seconds can be ok, but then you get into
> power savings issues.  For example, I have the timers setup to trigger 5
> times a period (I know it probably should be 2 times), so at 10 seconds
> that means the timers are firing every 2 seconds.  That shows up on
> powertop :-(.  Though I was flirting with the idea of trying to slow down
> or stop the timer when the cpu goes into deeper c-states.  But that is a
> different problem.
> 
> > 
> > We might want to change another aspect of the NMI watchdog: right now it tries 
> > to abort the offending task - which is really nasty if there was a spuriously 
> > long irqs-off section somewhere in the kernel. How about we just print a 
> > warning instead?
> 
> I dont understand this.  IIRC NMI watchdog will either printk or panic on
> a hardlockup.  What do you mean by 'aborting' the task?

Oh, simple dementia on my side. We used to attempt a do_exit() in some long 
gone version of that code :-)

Thanks,

	Ingo
