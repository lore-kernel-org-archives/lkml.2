Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0H0Njt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:39:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab0H0Njr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:39:47 -0400
Date: Fri, 27 Aug 2010 09:39:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100827133924.GR4879@redhat.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100826211424.GQ4879@redhat.com>
 <20100827075132.GD22783@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827075132.GD22783@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 09:51:32AM +0200, Robert Richter wrote:
> On 26.08.10 17:14:24, Don Zickus wrote:
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> > index 4539b4b..d16ebd8 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -738,6 +738,7 @@ again:
> >  
> >  	inc_irq_stat(apic_perf_irqs);
> >  	ack = status;
> > +	intel_pmu_ack_status(ack);
> 
> Yes, not immediately ack'ing the status was suspect to me too. Though
> it must then be the same counter that retriggers. Or, it is a cpu
> bug. You could add a debug print of the status register for the case
> the loop is reentered, would be interesting...

It seems to be the same counter.  I wonder if the act of processing it
'intel_save_and_restart' cleared the status bit on the perfselX bit but
not in the global status register.  Thus it triggered again and we
accidentally cleared it when we ack'd later in the code.

Cheers,
Don
