Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1BAWFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:05:07 -0500
Received: from www.tglx.de ([62.245.132.106]:40034 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1BAWFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:05:06 -0500
Date: Tue, 1 Feb 2011 23:04:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 28/28] posix clocks: Introduce dynamic clocks
In-Reply-To: <1296596987.3336.83.camel@work-vm>
Message-ID: <alpine.LFD.2.00.1102012301090.31804@localhost6.localdomain6>
References: <20110201134320.688829863@linutronix.de>  <20110201134420.164172635@linutronix.de> <1296596987.3336.83.camel@work-vm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011, john stultz wrote:

> On Tue, 2011-02-01 at 13:52 +0000, Thomas Gleixner wrote:
> > plain text document attachment
> > (posix-clocks-introduce-dynamic-clocks.patch)
> > From: Richard Cochran <richardcochran@gmail.com>
> > 
> > This patch adds support for adding and removing posix clocks. The
> > clock lifetime cycle is patterned after usb devices. Each clock is
> > represented by a standard character device. In addition, the driver
> > may optionally implement custom character device operations.
> > 
> > The posix clock and timer system calls listed below now work with
> > dynamic posix clocks, as well as the traditional static clocks.
> > The following system calls are affected:
> > 
> >    - clock_adjtime (brand new syscall)
> >    - clock_gettime
> >    - clock_getres
> >    - clock_settime
> >    - timer_create
> >    - timer_delete
> >    - timer_gettime
> >    - timer_settime
> > 
> > [ tglx: Adapted to the posix-timer cleanup. Moved clock_posix_dynamic
> >   	to posix-clock.c and made all referenced functions static ]
> 
> I sort of worry about the naming collision with the term posix-clock, as
> this is just one type of posix clock (I suspect most folks think of a
> posix clock as the clockid passed to the existing posix api).

Well that's kernel internal and not the posix-timer syscalls.
 
> Could we maybe use posix-dynclock or posix-fdclock or something? I know
> its already been changed from clkdev, so sorry for being finicky here
> and not catching this earlier.

I'm fine with the name as is and it's well documented.

Thanks,

	tglx
