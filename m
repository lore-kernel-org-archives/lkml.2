Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2GGH1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 03:27:44 -0400
Received: from ozlabs.org ([203.10.76.45]:35066 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab2GGH1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 03:27:42 -0400
Message-ID: <1341646064.30371.27.camel@concordia>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
From: Michael Ellerman <michael@ellerman.id.au>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        Robert Richter <robert.richter@amd.com>
Date: Sat, 07 Jul 2012 17:27:44 +1000
In-Reply-To: <CABPqkBS=eXZXXf6HKtw=LgaKMW9Pe2tfMiuD+FGw5CWkPY-SuA@mail.gmail.com>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
	 <1341300987.11663.15.camel@concordia> <1341306905.23484.53.camel@twins>
	 <1341389237.22063.7.camel@concordia> <1341393205.23484.111.camel@twins>
	 <CABPqkBS=eXZXXf6HKtw=LgaKMW9Pe2tfMiuD+FGw5CWkPY-SuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 17:57 +0200, Stephane Eranian wrote:
> On Wed, Jul 4, 2012 at 11:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > I think Stephane is currently trying to revive that, although he hasn't
> > posted yet. Please have a look if that captures the possible PPC states
> > as well. Stephane could you share your current stuff so Michael can have
> > a look?

> I am currently on vacation and with limited internet access.

No stress, I am currently busy doing other things :)

> But yes, the PEBS-LL patchset I have been working on
> does abstract PEBS-LL and offers an abstracted data source
> field. It uses:
> PERF_SAMPLE_IP: for instr address
> PERF_SAMPLE_ADDR: for the data address
> 
> It introduces:
> PERF_SAMPLE_LATENCY: to capture the access latency
> PERF_SAMPLE_DSRC: to encode the data source.
> 
> That latter value is a structured bitmask which covers:
> - type of access (load, store, prefetch, instr)
> - mem level: hit or miss in L1, LFB, L2, L3, LOC_RAM, REM_RAM, uncached, IO
> - snoop access: hit, miss, none
> - TLB access: hit or miss in L1, L2, HW walker, OS fault
> 
> Hopefully those are generic enough to cover all possible cases across
> architectures. PPC would be a good test case.
> Note that multiple bits per category may be set in case the HW cannot
> disambiguate like this is the case on with PEBS-LL sometimes.

OK that sounds promising. And I like that it's a bitmask.

>From a preliminary look I think the list you have above will cover most
of the information we can report. And we should have some bits left over
for extensibility.

cheers




