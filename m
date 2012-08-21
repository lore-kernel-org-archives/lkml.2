Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab2HUQNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:13:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47913 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2HUQNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:13:39 -0400
Date: Tue, 21 Aug 2012 17:13:24 +0100
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
Message-ID: <20120821161324.GA29665@srcf.ucam.org>
References: <502BB5A3.5000403@linux.intel.com>
 <1345043096.31459.106.camel@twins>
 <502BE38D.9030405@linux.intel.com>
 <20120820080606.GA6931@gmail.com>
 <20120820181651.GA737@srcf.ucam.org>
 <20120821094203.GB12385@gmail.com>
 <20120821113951.GA22436@srcf.ucam.org>
 <20120821151910.GA5359@gmail.com>
 <20120821152828.GB28241@srcf.ucam.org>
 <20120821155908.GA5499@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821155908.GA5499@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:59:08PM +0200, Ingo Molnar wrote:
> * Matthew Garrett <mjg@redhat.com> wrote:
> > The scheduler's behaviour is going to have a minimal impact on 
> > power consumption on laptops. Other things are much more 
> > important - backlight level, ASPM state, that kind of thing. 
> > So why special case the scheduler? [...]
> 
> I'm not special casing the scheduler - but we are talking about 
> scheduler policies here, so *if* it makes sense to handle this 
> dynamically then obviously the scheduler wants to use system 
> state information when/if the kernel can get it.
> 
> Your argument is as if you said that the shape of a car's side 
> view mirrors is not important to its top speed, because the 
> overall shape of the chassis and engine power are much more 
> important.
> 
> But we are desiging side view mirrors here, so we might as well 
> do a good job there.

If the kernel is going to make power choices automatically then it 
should do it everywhere, not piecemeal.

> > [...] This is going to be hugely more important on 
> > multi-socket systems, where your policy is usually going to be 
> > dictated by the specific workload that you're running at the 
> > time. [...]
> 
> If only we had some kernel subsystem that is intimiately familar 
> with the workloads running on the system and could act 
> accordingly and with low latency.
> 
> We could name that subsystem it in some intuitive fashion: it 
> switches and schedules workloads, so how about calling it the 
> 'scheduler'?

The scheduler is unaware of whether I care about a process finishing 
quickly or whether I care about it consuming less power.

> > [...] The exception is in cases where your rack is 
> > overcommitted for power and your rack management unit is 
> > telling you to reduce power consumption since otherwise it's 
> > going to have to cut the power to one of the machines in the 
> > rack in the next few seconds.
> 
> ( That must be some ACPI middleware driven crap, right? Not 
>   really the Linux kernel's problem. )

It's as much the Linux kernel's problem as AC/battery decisions are - 
ie, it's not.

> > > The thing is, when I use Linux on a laptop then AC/battery 
> > > is *the* main policy input.
> > 
> > And it's already well handled from userspace, as it has to be.
> 
> Not according to the developers switching away from Linux 
> desktop distros in droves, because MacOSX or Win7 has 30%+ 
> better battery efficiency.

Ok so what you're actually telling me here is that you don't understand 
anything about power management and where our problems are.

> The scheduler might be a small part of the picture, but it's 
> certainly a part of it.

It's in the drivers, which is where it has been since we went tickless. 

> > No, because sched_mt_powersave usually crippled performance 
> > more than it saved power and nobody makes multi-socket 
> > laptops.
> 
> That's a user-space policy management fail right there: why 
> wasn't this fixed? If the default policy is in the kernel we can 
> at least fix it in one place for the most common cases. If it's 
> spread out amongst multiple projects then progress only happens 
> at glacial speed ...

sched_mt_powersave was inherently going to have a huge impact on 
performance, and with modern chips that would result in the platform 
consuming more power. It was a feature that was useful for a small 
number of generations of desktop CPUs - I don't think it would ever skew 
the power/performance ratio in a useful direction on mobile hardware. 
But feel free to blame userspace for hardware design.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
