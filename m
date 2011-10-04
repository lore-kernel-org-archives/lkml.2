Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1JDIU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 04:20:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60635 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367Ab1JDIUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 04:20:24 -0400
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
From: Matt Fleming <matt@console-pimps.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Mosberger-Tang <davidm@egauge.net>
In-Reply-To: <alpine.LFD.2.02.1110032345050.1489@ionos>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <m21uuxirxi.fsf@firstfloor.org>
	 <1317461738.3375.46.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CA+55aFyscb=PcUDrEUhFbH89+W-KYEKrqKHeNN3dqmZD1GF_Hw@mail.gmail.com>
	 <1317656613.3375.78.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20111003163559.GA3957@redhat.com>
	 <1317675520.3375.82.camel@mfleming-mobl1.ger.corp.intel.com>
	 <alpine.LFD.2.02.1110032345050.1489@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 09:20:17 +0100
Message-ID: <1317716417.3375.91.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 00:13 +0200, Thomas Gleixner wrote:
> 
> After staring a bit at your patch I think that you need to tackle that
> from a different angle.
> 
> The main nuisance of sighand->siglock is the exit race protection and
> that's why we need to take it for evrything and some more.

Right.

> In order to distangle the posix-(cpu)-timer and other stuffs
> protection from that single lock, you need to introduce "independent"
> locks which basically do the same dance as lock_task_sighand() does
> and have to be taken in the exit() path in a well defined order before
> manipulating task->sighand.

Yeah, I've been trying to avoid changing the tsk->sighand stuff (you'll
notice that lock_task_sighand() still works as before in this patch
series) because when I've attempted it before it has always resulted in
much more complicated code (and coming from me, that's saying
something!).

> That way you still cover the exit races, but you can break up the
> locking for particular subsystems w/o the need of (much) nesting.

Yeah, that approach seems interesting. I'll have a look at that, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center

