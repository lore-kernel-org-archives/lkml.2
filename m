Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab0HYHVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:21:02 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:50741 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0HYHU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:20:58 -0400
Date: Wed, 25 Aug 2010 09:20:54 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, balbir@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>,
        ikael Starvik <starvik@axis.com>, dhowells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
Message-ID: <20100825092054.54430c24@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <AANLkTi=FO3fx4F16CUXAzdKYTNoPjZaLfUvsqBJzAPV1@mail.gmail.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	<20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
	<AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
	<20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
	<AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
	<1282636286.2605.2307.camel@laptop>
	<20100824080515.GK4684@balbir.in.ibm.com>
	<1282640953.2605.2428.camel@laptop>
	<20100824113801.GO4684@balbir.in.ibm.com>
	<1282650835.2605.2629.camel@laptop>
	<AANLkTi=QuD7v1PP9PaJt_Dz1N-JKC1e6km1TE_YE6iJk@mail.gmail.com>
	<1282682357.2605.3219.camel@laptop>
	<AANLkTi=FO3fx4F16CUXAzdKYTNoPjZaLfUvsqBJzAPV1@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 19:02:04 -0700
Venkatesh Pallipadi <venki@google.com> wrote:

> On Tue, Aug 24, 2010 at 1:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-08-24 at 12:20 -0700, Venkatesh Pallipadi wrote:
> >> So, why not do the simple things first. Do not disturb any existing
> >> scheduling decisions, account accurate hi and si times system wide,
> >> per task, per cgroup (with as less overhead as possible). Give this
> >> info to users and admin programs and they may make a higher level
> >> sense of this.
> >>
> >> Having looked at both the options, I feel having these export is an
> >> immediate first step.
> >
> > This is where I strongly disagree, providing an interface that cannot
> > possibly be implemented correctly just so you can fudge something (still
> > not sure what from userspace) seems a very bad idea indeed.
> >
> 
> I don't think correctness is a problem. TSC is pretty good for this
> purpose on current hardware. I agree that usability is debatable.
> 
> The use case I mentioned is some management application trying to find
> interference/slowness for a task/task group because some other si
> intensive task or flood ping on that CPU, getting to know that from
> si/hi time for task and what it "expects it to be". Yes this is vague.
> But, I think you agree that problem of si/hi interference on unrelated
> task exists today. And providing this interface was the quick way to
> give some hint to management apps about such problem. But. other
> alternative of making si and hi time as "system time" will help this
> use case as well, as the user will notice lower exec_time in that
> case.
> 
> If you strongly think that the right way is to make both si and hi
> "system time" and that will not cause unfairness and slowdown for some
> unrelated tasks, I can try to cleanup the patch I had for that and
> send it out. I am afraid though, it will cause some regression and we
> will end up back at square one after a month or so. :(

But it is a correctness problem. It is wrong to account the si and hi
time to some random process. To base any kind of decision on wrong data
is asking for trouble. If we can not correctly attribute the si and hi
time to the correct process (which we agree is next to impossible) then
the only thing left to do is to report the time on its own. You can
still pick a random process in your management application and add the
time in user space. As wrong as before but some other application might
want to do smarter things with the data point.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

