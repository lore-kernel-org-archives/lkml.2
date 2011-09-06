Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1IFRk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:40:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab1IFRkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:40:52 -0400
Date: Tue, 6 Sep 2011 13:40:35 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [V3][PATCH 6/6] x86, nmi: print out NMI stats in /proc/interrupts
Message-ID: <20110906174035.GO6838@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
 <1314290748-23569-7-git-send-email-dzickus@redhat.com>
 <20110906163904.GJ14200@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906163904.GJ14200@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 06:39:04PM +0200, Robert Richter wrote:
> On 25.08.11 12:45:48, Don Zickus wrote:
> > This is a cheap hack to add the stats to the middle of /proc/interrupts.
> > It is more of a conversation starter than anything as I am not sure
> > the right letters and place to put this stuff.
> > 
> > The benefit of these stats is a better breakdown of which list the NMIs
> > get handled in either a normal handler, unknown, or external.  It also
> > list the number of unknown NMIs swallowed to help check for false
> > positives or not.  Another benefit is the ability to actually see which
> > NMI handlers are currently registered in the system.
> > 
> > The output of 'cat /proc/interrupts/ will look like this:
> > 
> > <snip>
> >  58:        275          0        864          0   PCI-MSI-edge      eth0
> > NMI:       4161       4155        158       4194   Non-maskable interrupts
> > SWA:          0          0          0          0   Unknown NMIs swallowed
> >   0:       4161       4155        158       4194   NMI  PMI, arch_bt
> 
> What does the "0" stand for?

Just a place holder meaning NMI0 for the normal NMIs, but as you stated
below, it is more an event counter.  I wanted to use LOC for local but it
was already taken.

> 
> We could easily provide a statistic for each NMI handler, which would
> be more useful.

Of course, but I wasn't sure how to print that without making
/proc/interrupts look messy.  I suggested earlier to Peter that I thought
about a /proc/nmi file that could print that.

> 
> The syntax of the NMI printout is not yet perfect, so before adding it
> as a new interface I would rather wait a bit to discuss this more.
> 
> People also could get confused because the handled count may be
> different to nmi count. This should be documented more clearly, maybe
> as event count instead of nmi count or so.

That is why I put this patch last with a big blurb on top stating this
needs more feedback. :-)  The hack hook into /proc/interrupts probably
isn't reasonable either. 

Cheers,
Don

> 
> -Robert
> 
> > UNK:          0          0          0          0   NMI
> > EXT:          0          0          0          0   NMI
> > LOC:      12653      13304      13974      12926   Local timer interrupts
> > SPU:          0          0          0          0   Spurious interrupts
> > PMI:          6          6          5          6   Performance monitoring interrupts
> > IWI:          0          0          0          0   IRQ work interrupts
> > RES:       1839       1897       1821       1854   Rescheduling interrupts
> > CAL:        524       2714        392        331   Function call interrupts
> > TLB:        217        146        593        576   TLB shootdowns
> > TRM:          0          0          0          0   Thermal event interrupts
> > THR:          0          0          0          0   Threshold APIC interrupts
> > MCE:          0          0          0          0   Machine check exceptions
> > MCP:          1          1          1          1   Machine check polls
> > ERR:          0
> > MIS:          0
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 
