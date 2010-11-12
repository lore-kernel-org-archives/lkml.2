Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab0KLQMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:12:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab0KLQMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:12:16 -0500
Date: Fri, 12 Nov 2010 11:11:44 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101112161144.GP4823@redhat.com>
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
 <4CDD579F.80009@windriver.com>
 <20101112154231.GN4823@redhat.com>
 <4CDD6389.2080206@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDD6389.2080206@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 09:55:53AM -0600, Jason Wessel wrote:
> > To answer your question, I doubt this patch series will change that
> > outcome if it is still broken.
> >
> >   
> 
> It was most definitely broken in 2.6.36->2.6.37-rc1.  Randy Dunlap had
> pointed this out in a separate exchange that was not on LKML.

Can you clarify by what you mean by broken above?  Was 2.6.36 good or bad?

> 
> The symptom you would see looks like:
> 
> ...kernel boot...
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> brd: module loaded
> kgdb: Registered I/O driver kgdbts.
> kgdbts:RUN plant and detach test
> [...HARD HANG STARTS HERE...]
> 
> The kernel is looping at that point waiting for the master kgdb cpu to
> have all the slaves join the debugger but it never happens because the
> perf callback chain which is used by the lockup detector eats the NMI
> IPI event.  After the perf callback is processed perf returns
> NOTIFY_STOP so the notifier which brings the slave CPU into the debugger
> never fires.

Ok.  We have code to handle extra spurious NMIs that is hard to accurately
determine if the NMI was for perf or someone else.  This logic may still
need tweaking.  What cpu are you running on?  AMD/Intel?  If Intel, then
core/core2/nehalem?

I'll try to reproduce it.

Thanks,
Don
