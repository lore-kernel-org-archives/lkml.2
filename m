Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab0LXM3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 07:29:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42566 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0LXM3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 07:29:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sAyBECmwYYanmSUK+NzwIGY6+FW8btZF2L8WqLG7Px5OGy5r5qVk4p1M45BqvO8YNc
         dhx2I1Dtp0Zfviq8xm3I7+MBm4dV77wa9oSX3Jz+odTh4QO4gPocD11rGDhvwBiz0yVI
         tytSi5YOWtMp6ln95prJ7yoXValb+5oxLPFXA=
Date: Fri, 24 Dec 2010 13:29:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 01/15] nohz_task: New mask for cpus having nohz task
Message-ID: <20101224122903.GA1879@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-2-git-send-email-fweisbec@gmail.com>
 <4D145339.1080205@cn.fujitsu.com>
 <1293178796.3182.2.camel@Palantir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293178796.3182.2.camel@Palantir>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 09:19:56AM +0100, Dario Faggioli wrote:
> On Fri, 2010-12-24 at 16:00 +0800, Lai Jiangshan wrote: 
> > On 12/20/2010 11:24 PM, Frederic Weisbecker wrote:
> > >  
> > > +config NO_HZ_TASK
> > > +       bool "Tickless task"
> > > +       depends on HAVE_NO_HZ_TASK && NO_HZ && SMP && HIGH_RES_TIMERS
> > > +       help
> > > +         When a task runs alone on a CPU and switches into this mode,
> > > +         the timer interrupt will only trigger when it is strictly
> > > +         needed.
> > 
> > Why it depends on SMP?
> > 
> I guess that's because you need at least a ticking CPU for timekeeping
> and stuff... Right?
> 
> Regards,
> Dario


Exactly.

In the next version I'll probably drop that requirement. On UP a single task
must still be able to be in nohz mode when it is in userspace, as timekeeping
doesn't matter there until we reenter the kernel.

Dunno, I'll see what I can do.
