Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0KVOX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:23:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab0KVOXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:23:24 -0500
Date: Mon, 22 Nov 2010 09:22:37 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101122142237.GT18100@redhat.com>
References: <1290086232.2109.1507.camel@laptop>
 <20101118193247.GF18100@redhat.com>
 <4CE583D0.8050407@windriver.com>
 <20101118200807.GC8131@redhat.com>
 <1290112234.2109.1534.camel@laptop>
 <20101119165952.GJ18100@redhat.com>
 <1290191158.2109.1614.camel@laptop>
 <20101119225902.GQ18100@redhat.com>
 <1290208179.2114.13.camel@laptop>
 <4CE708AA.7030405@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE708AA.7030405@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 05:30:50PM -0600, Jason Wessel wrote:
> On 11/19/2010 05:09 PM, Peter Zijlstra wrote:
> > On Fri, 2010-11-19 at 17:59 -0500, Don Zickus wrote:
> >> 
> >> @@ -1371,6 +1385,12 @@ void __init init_hw_perf_events(void)
> >> 
> >>         pmu_check_apic();
> >> 
> >> +       /* sanity check that the hardware exists or is emulated */
> >> +       if (!check_hw_exists()) {
> >> +               pr_cont("no PMU driver, software events only.\n");
> >> +               return;
> >> +       }
> >
> > Maybe report something like this:
> >   "Broken PMU hardware detected, software events only."
> >
> > Because this is really not something that's supposed to happen.
> 
> The kgdb test suite is passing with Don's perf detect logic, so we are
> back to good.  I am in agreement with Peter about the message
> indicating that it is broken hardware.  We don't in any way shape or
> form want leave the illusion this works in the VM.
> 
> # dmesg |grep Per
> <6>Performance Events: no PMU driver, software events only.
> 
> 
> Tested on qemu and kvm, several revisions worth, because it is all
> automated.
> 
> Tested-by: Jason Wessel <jason.wessel@windriver.com>

Awesome.  Thanks for the quick testing Jason.

Cheers,.
Don
