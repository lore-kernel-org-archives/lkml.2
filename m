Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab0KROdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:33:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757894Ab0KROdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:33:00 -0500
Date: Thu, 18 Nov 2010 09:32:32 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, gorcunov@gmail.com
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118143232.GC18100@redhat.com>
References: <20101112154231.GN4823@redhat.com>
 <4CDD6389.2080206@windriver.com>
 <20101112161144.GP4823@redhat.com>
 <4CDD6CAD.30303@windriver.com>
 <20101112172755.GR4823@redhat.com>
 <20101116184325.GB4823@redhat.com>
 <4CE2E3C3.6060800@windriver.com>
 <20101118080516.GJ32621@elte.hu>
 <4CE52048.5080802@windriver.com>
 <1290086232.2109.1507.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290086232.2109.1507.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:17:12PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-18 at 06:47 -0600, Jason Wessel wrote:
> > More specifically
> > when another subsystem injects an NMI event the perf NMI code returns
> > NOTIFY_STOP. 
> 
> Not unconditionally, right? We only do so when the previous NMI was from
> the PMU and nobody claimed this one (NOTIFY_STOP from DIE_NMIUNKNOWN).
> 
> Or are you hitting the other one, where !handled but pmu_nmi.handled >
> 1 ?

On my Nehalem box, the kgdb tests work fine, no issues there.  On my P4
box, the p4 handler really thinks the NMIs are from the perf counter and
returns handled==1 and starves the kgdb tests.

I haven't gotten around to checking Jason's kvm setup to determine which
handler his setup is calling.

Jason, could you snip part of your dmesg log that shows the output with
"Performance Events:" (or just send me the whole thing :-) ).

Cheers,
Don

