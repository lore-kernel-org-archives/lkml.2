Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1HZOv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:51:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:34653 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1HZOv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:51:56 -0400
Subject: Re: [V3][PATCH 0/6] x86, nmi: new NMI handling routines
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Date: Fri, 26 Aug 2011 16:51:14 +0200
In-Reply-To: <20110826143949.GX2067@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
	 <1314351897.9377.2.camel@twins> <20110826143949.GX2067@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314370274.12445.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 10:39 -0400, Don Zickus wrote:
> On Fri, Aug 26, 2011 at 11:44:57AM +0200, Peter Zijlstra wrote:
> > On Thu, 2011-08-25 at 12:45 -0400, Don Zickus wrote:
> > > I spent some time hacking and came up with this patch.  I tested it on my
> > > core2quad machine trying to enable all the NMI handler I could, mainly
> > > perf and kgdb (and oprofile too when perf was disabled).  Everything seems
> > > to work correctly.  If people are ok with this approach, I'll try and test
> > > this on more machines. 
> > 
> > Right, code looks OK, the only worry that remains is overhead, always
> > running all handlers must cost..
> 
> Yeah nothing is free.  My only counter argument is I removed the case
> statements in the handlers, so it speeds things up a tiny bit.  Also most
> machines only seem to have perf and the arch_backtrace handler registered,
> with modern intel boxes probably registering the ghes handler too.
> 
> There really isn't much there, at least currently.  I would break up the
> handler more if I knew a quicker way to distinguish between something like
> a self-IPI NMI vs. an on-chip NMI like perf.  Then again those NMIs
> probably aren't latched differently unlike the external one sitting in the
> IOAPIC(??).

Yeah, no clue really.. I still need to read up on those hardware specs
(scarce as they are). 

As it stands I think we don't have much choice in this and your proposed
solution is pretty much it, I mean we have a shared edge interrupt and
no sane way to tell who all triggered stuff. 

Short of locking all the hardware dudes in a room and not letting them
out until they fix that is ;-)

Anyway, aside from 6/6 which wants more comments (personally I think I
like you /proc/nmis suggestion best, leaving the single NMI line
in /proc/interrupts) I'm fine with these patches.

Thomas any opinions?
