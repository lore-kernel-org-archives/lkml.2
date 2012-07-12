Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162473Ab2GLW5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:57:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162095Ab2GLWnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:41 -0400
Date: Fri, 13 Jul 2012 00:43:34 +0200
From: Jiri Bohac <jbohac@suse.cz>
To: John Stultz <johnstul@us.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 0/6] Fix for leapsecond caused hrtimer/futex issue
 (updated)
Message-ID: <20120712224334.GA32620@midget.suse.cz>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
 <4FFCB287.80701@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFCB287.80701@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 03:53:59PM -0700, John Stultz wrote:
> On 07/10/2012 03:43 PM, John Stultz wrote:
> >Over the weekend, Thomas got a chance to review the leap second fix
> >in more detail and had a few additional changes he wanted to make
> >to improve performance as well as style.
> >
> >So this iteration includes his modifications.
> >
> >Once merged, I'll be working to get the backports finished as quickly
> >as I can and sent to -stable.

looking at the proposed 2.6.32.y stable patch at:
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commitdiff;h=18d208632bf17aed56c581b882868b2be44be71e;hp=6d224606bb8eec78027522d6dd5abfea8108c41a
Is this the final version you are about to send to -stable?

In 2.6.32 timekeeping_leap_insert() is not called from the timer
interrupt, but from the leap_timer hrtimer.

I think the new clock_was_set_timer will thus not be called by
irq_exit() because TIMER_SOFTIRQ has not been raised. Unless
TIMER_SOFTIRQ is raised, clock_was_set() will not be called until
the next periodic timer interrupt, correct?

Wouldn't the original schedule_work() approach work better for
2.6.32?

Or do you plan backporting the most recent version to 2.6.32?

Thanks,

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

