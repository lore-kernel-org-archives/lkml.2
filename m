Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0HXMG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:06:26 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:55692 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0HXMGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:06:23 -0400
Date: Tue, 24 Aug 2010 14:06:19 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, Venkatesh Pallipadi <venki@google.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
Message-ID: <20100824140619.35850ae9@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1282650835.2605.2629.camel@laptop>
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
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 13:53:55 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2010-08-24 at 17:08 +0530, Balbir Singh wrote:
> > 
> > The point is for containers it is more likely to give the right answer
> > and so on. Yes, the results are not 100% accurate. 
> 
> Consider one group heavily dirtying pages, it stuffs the IO queues full
> and gets blocked on IO completion. Since the CPU is then free to
> schedule something else we start running things from another group,
> those IO completions will come in while we run other group and get
> accounted to other group -- FAIL.
> 
> s/group/task/ etc..
> 
> That just really doesn't work, accounting async work, esp stuff that is
> not under software control it very tricky indeed.
> 
> So what are you wanting to do, and why. Do you really need accounting
> madness?

Well, I have sent a patch back in 2006 that stops adding the hardirq /
softirq time to the currently running process. See
http://lkml.org/lkml/2006/8/24/139
It did not get very far, so that answer to the question if we need
accounting madness seems to be yes ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

