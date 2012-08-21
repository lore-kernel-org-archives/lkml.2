Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab2HUP2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:28:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45703 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab2HUP2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:28:40 -0400
Date: Tue, 21 Aug 2012 16:28:28 +0100
From: Matthew Garrett <mjg@redhat.com>
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
Message-ID: <20120821152828.GB28241@srcf.ucam.org>
References: <502BA7DC.7060907@linux.intel.com>
 <1345041548.31459.90.camel@twins>
 <502BB5A3.5000403@linux.intel.com>
 <1345043096.31459.106.camel@twins>
 <502BE38D.9030405@linux.intel.com>
 <20120820080606.GA6931@gmail.com>
 <20120820181651.GA737@srcf.ucam.org>
 <20120821094203.GB12385@gmail.com>
 <20120821113951.GA22436@srcf.ucam.org>
 <20120821151910.GA5359@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821151910.GA5359@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:19:10PM +0200, Ingo Molnar wrote:
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > [...] AC/battery is just not an important power management 
> > policy input when compared to various other things.
> 
> Such as?

The scheduler's behaviour is going to have a minimal impact on power 
consumption on laptops. Other things are much more important - backlight 
level, ASPM state, that kind of thing. So why special case the 
scheduler? This is going to be hugely more important on multi-socket 
systems, where your policy is usually going to be dictated by the 
specific workload that you're running at the time. The exception is in 
cases where your rack is overcommitted for power and your rack 
management unit is telling you to reduce power consumption since 
otherwise it's going to have to cut the power to one of the machines in 
the rack in the next few seconds.

> The thing is, when I use Linux on a laptop then AC/battery is 
> *the* main policy input.

And it's already well handled from userspace, as it has to be.

> > Userspace has been doing a perfectly reasonable job of 
> > determining policy here.
> 
> Has it properly switched the scheduler's balancing between 
> power-effient and performance-maximizing strategies when for 
> example a laptop's AC got unplugged/replugged?

No, because sched_mt_powersave usually crippled performance more than it 
saved power and nobody makes multi-socket laptops.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
