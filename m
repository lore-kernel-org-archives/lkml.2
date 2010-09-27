Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab0I0NXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:23:12 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:50725 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab0I0NXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:23:10 -0400
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100926181127.GA26985@redhat.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
	 <1285250541.1837.95.camel@holzheu-laptop>
	 <20100923171025.GA26623@redhat.com>
	 <1285330688.2179.305.camel@holzheu-laptop>
	 <20100926181127.GA26985@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 27 Sep 2010 15:23:04 +0200
Message-ID: <1285593784.2116.97.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Sun, 2010-09-26 at 20:11 +0200, Oleg Nesterov wrote:
> > I think one place was "khelper" (kmod.c). It is created with
> > kernel_thread() and it exits without having accounted the times with
> > sys_wait() to the parent's ctimes
> 
> No. Well yes, it is not accounted, but this is not because it is
> kthread.
> 
> To simplify the discussion, lets talk about utime/cutime only,
> and lets forget about the multithreading.
> 
> It is very simple, currently linux accounts the exiting task's
> utime and adds its to ->cutime _only_ if parent does do_wait().
> If parent ignores SIGCHLD, the child reaps itself and it is not
> accounted.
> 
> I do not know why it was done this way, but I'm afraid we can't
> change this historical behaviour.

Ok thanks, I didn't know this. So time can disappear, if the parent
ignores SIGCHLD.

I am a bit disappointed, because I thought by looking at all tasks of a
system it should be possible to evaluate all consumed CPU time from now
to the time where the system has been booted. That would have been a
nice thing.

> > Ok, the problem is that I did not consider exiting threads that are no
> > thread group leaders. When they exit the ctime of the parent is not
> > updated. Instead the time is accumulated in the signal struct.
> 
> I think I am a bit confused, but see above. With or without threads
> the whole process can exit without accounting.

Sorry that I couldn't explain my thoughts clear enough, believe me, I
tried my best :-)

Michael



