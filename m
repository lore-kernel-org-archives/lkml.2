Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1JTW0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 18:26:18 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56803 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782Ab1JTW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 18:26:17 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Oct 2011 18:26:16 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAFudoE55LCxn/2dsb2JhbABCqRmBBoFuAQEFOhwjEAgDGC4UJQMhE719Eoc2YQSlaw
Date: Fri, 21 Oct 2011 09:21:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
Message-ID: <20111020222109.GB14993@dastard>
References: <4E9E0B71.9020708@am.sony.com>
 <20111019073547.GR21648@n2100.arm.linux.org.uk>
 <4E9F5F1B.1020106@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9F5F1B.1020106@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 04:36:59PM -0700, Tim Bird wrote:
> On 10/19/2011 12:35 AM, Russell King - ARM Linux wrote:
> > On Tue, Oct 18, 2011 at 04:27:45PM -0700, Tim Bird wrote:
> >> I'm about to submit a set of patches (really pretty small)
> >> to add 4K stack support to ARM (defaulted to 'N').
> >>
> >> This has been kicking around in my Sony tree for a few years,
> >> and it's about time to mainline it.  The first patch is
> >> the actual 4KSTACKS patch.  See subsequent patches
> >> for tools to help with stack reduction to avoid the problems
> >> that apparently led to the removal of this feature on x86.
> > 
> > This isn't a good idea - if the feature has been abandoned on x86,
> > people aren't going to be soo concerned about the stack usage of
> > each function.  They're going to accept that there's more stack
> > space available, and we'll see code paths that start expecting that.
> 
> Well, the difference in size is not an order of magnitude.  Current
> stacks are only twice as big as what this feature optionally allows.
> So people really shouldn't go crazy with their stack usage.
> 
> Granted we're already seeing a bit of stack bloat, but IMHO this should
> be nipped in the bud.  If the stack grows a lot more, it will likely
> need to shift to 16K, which would REALLY be costly on machines
> with lots of threads and low memory.

FWIW, I was seriously considering bringing up 16k stacks on x86-64
as a topic for the kernel summit. We've been getting reports of the
8k stack being blown on different filesystems for the past year or
so on relatively trivial storage configs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
