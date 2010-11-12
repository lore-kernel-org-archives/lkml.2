Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0KLPmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:42:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378Ab0KLPmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:42:50 -0500
Date: Fri, 12 Nov 2010 10:42:31 -0500
From: Don Zickus <dzickus@redhat.com>
To: jason.wessel@windriver.com
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101112154231.GN4823@redhat.com>
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
 <4CDD579F.80009@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDD579F.80009@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 09:05:03AM -0600, Jason Wessel wrote:
> On 11/12/2010 08:43 AM, Don Zickus wrote:
> > Restructuring the nmi handler to be more readable and simpler.
> >
> > This is just laying the ground work for future improvements in this area.
> >
> > I also left out one of Huang's patch until we figure out how we are going
> > to proceed with a new notifier.
> >
> > Tested 32-bit and 64-bit on AMD and Intel machines.
> >
> > V2:  add a patch to kill DIE_NMI_IPI and add in priorities
> >
> >   
> 
> Had you tested this code with kgdb boot tests at all?
> 
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_KGDB=y
> CONFIG_KGDB_TESTS_ON_BOOT=y
> CONFIG_KGDB_TESTS_BOOT_STRING="V1F100"
> 
> There has been a regression in kgdb due to the use of perf/NMI in the
> lockup detector ever since the new version has been introduced.   The
> perf callbacks in the lockup detector were consuming NMI events not
> related to the call back and causing the kernel debugger not to work at
> all on SMP systems configured with the lockup detector.

Well 2.6.36 should have fixed that.  Perf was blindly eating all NMI
events if it had a user.  With the new lockup detector, that created a
'user' for perf and it happily ate everything.  But we spent a lot of time
trying to fix that for 2.6.36.  If we missed something, we would like to
know.

To answer your question, I doubt this patch series will change that
outcome if it is still broken.

> 
> I was curious to know if this patch series fixed the problem as well as
> to know if you could run the regression test when you make changes
> related to the lockup / NMI path as it affects the kernel debug API.

Absolutely.  I look forward to running tests with consumers of NMI other
than perf. :-)

Thanks for the tip.

Cheers,
Don
