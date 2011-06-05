Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1FEJmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 05:42:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab1FEJmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 05:42:01 -0400
Date: Sun, 5 Jun 2011 11:41:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
Message-ID: <20110605094151.GD19927@elte.hu>
References: <4DE674EB.1000200@die-jansens.de>
 <1306951751.2497.626.camel@laptop>
 <1306953870.2497.627.camel@laptop>
 <4DE6936F.7090700@die-jansens.de>
 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com>
 <1307092535.2353.2973.camel@twins>
 <4DE8B13D.9020302@die-jansens.de>
 <1307097052.2353.3061.camel@twins>
 <20110605081747.GA17920@elte.hu>
 <4DEB4417.9070003@die-jansens.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEB4417.9070003@die-jansens.de>
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


* Arne Jansen <lists@die-jansens.de> wrote:

> On 05.06.2011 10:17, Ingo Molnar wrote:
> >
> >* Peter Zijlstra<peterz@infradead.org>  wrote:
> >
> >>On Fri, 2011-06-03 at 12:02 +0200, Arne Jansen wrote:
> >>>On 03.06.2011 11:15, Peter Zijlstra wrote:
> >>
> >>>>Anyway, Arne, how long did you wait before power cycling the box? The
> >>>>NMI watchdog should trigger in about a minute or so if it will trigger
> >>>>at all (its enabled in your config).
> >>>
> >>>No, it doesn't trigger,
> >>
> >>Bummer.
> >
> >Is there no output even when the console is configured to do an
> >earlyprintk? That will allow the NMI watchdog to punch through even a
> >printk or scheduler lockup.
> >
> 
> Just to be clear, I have no boot problems whatsoever. And I have no
> problems with the serial console. It's just the regular printk locking
> up when e.g. I load the test module.

Yes.

> > Arne, you can turn this on via one of these:
> >
> >   earlyprintk=vga,keep
> 
> I don't have access to vga as it is a remote machine.
> 
> >   earlyprintk=serial,ttyS0,115200,keep
> 
> I'll try that.

Please don't forget:

> > Could you also please check with the (untested) patch below applied?
> > This will turn off *all* printk done by the NMI watchdog and switches
> > it to do pure early_printk() - which does not use any locking so it

if you get a lockup somewhere within printk then the NMI watchdog 
will lock up.

Also please first check that the NMI watchdog is ticking. (the patch 
will ensure that, there will be periodic prints to the serial log)

Thanks,

	Ingo
