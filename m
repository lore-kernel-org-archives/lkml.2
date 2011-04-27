Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1D0WUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:20:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:44969 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1D0WUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:20:04 -0400
Date: Thu, 28 Apr 2011 00:19:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [RFC][PATCH 1/4] clock_rtoffset: new syscall
In-Reply-To: <1303931500.2971.14.camel@work-vm>
Message-ID: <alpine.LFD.2.02.1104280015420.3323@ionos>
References: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>  <1303901023-11568-1-git-send-email-virtuoso@slind.org>  <alpine.LFD.2.02.1104271359580.3323@ionos> <1303931500.2971.14.camel@work-vm>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011, john stultz wrote:
> On Wed, 2011-04-27 at 16:02 +0200, Thomas Gleixner wrote:
> > On Wed, 27 Apr 2011, Alexander Shishkin wrote:
> Overall looks good. I flinched a little bit at adding an internal only
> clockid but trying to avoid that would really make it messy.

Yes. It would. And we really don't want to mess with the POSIX
interfaces. Having this extension and the weird return code for
timerfd seems to be a reasonable limitation.
 
> > +#ifdef __KERNEL__
> > +/* This clock is not exposed to user space */
> > +#define CLOCK_REALTIME_COS		8
> > +#endif
> 
> Would something like INTERNAL_CLOCK_REALTIME_COS be more explicit?

Yes. Good point.

> > +	base = cpu_base->clock_base + HRTIMER_BASE_REALTIME_COS;
> 
> I know its the same thing, but for some reason the above makes me think
> that the clock_base could be non-zero. 
> 
> 	base = &cpu_base->clock_base[HRTIMER_BASE_REALTIME_COS];
> 
> seems more straight forward to me. But its not a huge deal.

I don't care either way :)

Thanks,

	tglx
