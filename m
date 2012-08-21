Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2HUSee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:34:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35561 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2HUSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:34:31 -0400
Date: Tue, 21 Aug 2012 19:34:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120821183414.GA436@srcf.ucam.org>
References: <502BE38D.9030405@linux.intel.com>
 <20120820080606.GA6931@gmail.com>
 <20120820181651.GA737@srcf.ucam.org>
 <20120821094203.GB12385@gmail.com>
 <20120821113951.GA22436@srcf.ucam.org>
 <20120821151910.GA5359@gmail.com>
 <20120821152828.GB28241@srcf.ucam.org>
 <20120821155908.GA5499@gmail.com>
 <20120821161324.GA29665@srcf.ucam.org>
 <20120821182346.GA7325@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821182346.GA7325@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 08:23:46PM +0200, Ingo Molnar wrote:
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > The scheduler is unaware of whether I care about a process 
> > finishing quickly or whether I care about it consuming less 
> > power.
> 
> You are posing them as if the two were mutually exclusive, while 
> in reality they are not necessarily exclusive: it's quite 
> possible that the highest (non-turbo) CPU frequency happens to 
> be the most energy efficient one for a CPU with a particular 
> workload ...

You just put in a proviso that makes them mutually exclusive. If I want 
it done fast, I want it done in the highest turbo CPU frequency. If I 
don't want it done fast, I want it done in the most efficient CPU 
frequency. They're probably not the same thing.

> You also missed the bit of my mail where I suggested that such 
> user preferences and tolerances can be communicated to the 
> scheduler via a policy toggle - which the scheduler would take 
> into account.

Yes. And that toggle should be the thing that defines the policy under 
all circumstances.

> > Ok so what you're actually telling me here is that you don't 
> > understand anything about power management and where our 
> > problems are.
> 
> Huh? In practice we suck today in terms of energy efficiency. 
> That covers both scheduling and other areas.
> 
> Saying this out aloud does not tell anything about my 
> understanding of power management...
> 
> So please outline a technical point.

Our power consumption is worse than under other operating systems is 
almost entirely because only one of our three GPU drivers implements any 
kind of useful power management. The power saving functionality that we 
expose to userspace is already used when it's safe to do so. So blaming 
our userspace policy management for our higher power consumption means 
that you can't possibly understand where the problems actually are, 
which indicates that you probably shouldn't be trying to tell me about 
optimal approaches to power management.

> You mean the code is in drivers? Or the problem is in drivers? 

The problem is in the drivers.

> > sched_mt_powersave was inherently going to have a huge impact 
> > on performance, and with modern chips that would result in the 
> > platform consuming more power. It was a feature that was 
> > useful for a small number of generations of desktop CPUs - I 
> > don't think it would ever skew the power/performance ratio in 
> > a useful direction on mobile hardware. But feel free to blame 
> > userspace for hardware design.
> 
> FYI, sched_mt_powersave is *GONE* in recent kernels, because it 
> basically never worked. This thread is about designing and 
> implementing something that actually works.

Yes. You asked me whether userspace ever used the knobs that the kernel 
exposed. I said no, because the only knob relevant for laptops would 
never improve energy efficiency on laptops. It is therefore impossible 
to use this as an example of userspace policy management not doing the 
right thing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
