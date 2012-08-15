Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab2HOPFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:05:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:38943 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab2HOPFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:05:09 -0400
Message-ID: <1345043096.31459.106.camel@twins>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        vincent.guittot@linaro.org, svaidy@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Date: Wed, 15 Aug 2012 17:04:56 +0200
In-Reply-To: <502BB5A3.5000403@linux.intel.com>
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>
	  <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins>
	 <502BB5A3.5000403@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 07:43 -0700, Arjan van de Ven wrote:

> > Servers in a datacenter have battery?
> 
> they have AC, and sometimes a battery called "UPS".
> DC is getting much more prevalent in datacenters in general.

AC/DC (/me slams a riff on his air-guitar)... 

> >> seriously, there are possibly many ways to have a power/performance
> >> preference..,. but AC/battery is a very very poor one.
> >>
> > Do expand..
> > 
> 
> The easy cop-out is provide the sysadmin a slider.
> The slightly less easy one is to (and we're taking this approach
> in the new P state code we're working on) say "in the default
> setting, we're going to sacrifice up to 5% performance from peak
> to give you the best power savings within that performance loss budget"
> (with a slider that can give you 0%, 2 1/2%  5% and 10%)
> 
> on Intel PCs and servers, there usually is a bios switch/setting for this
> (there is a setting the bios does to the CPU, and we can read that. Not all bioses
> expose this setting to the end user). We could take clue from what was set there.

This all sounds far too complicated.. we're talking about simple
spreading and packing balancers without deep arch knowledge and knobs,
we couldn't possibly evaluate anything like that.

I was really more thinking of something useful for the laptops out
there, when they pull the power cord it makes sense to try and keep CPUs
asleep until the one that's awake is saturated.


