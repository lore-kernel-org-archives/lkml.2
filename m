Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2KKSoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 13:44:37 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:36582
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288Ab2KKSog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 13:44:36 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1de0h1202h1d1ah1d2ahzz17326ah8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-WSS-ID: 0MDC6Q4-02-83S-02
X-M-MSG: 
Date: Sun, 11 Nov 2012 12:44:26 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Robert Richter <rric@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf, amd: Enable AMD family 15h northbridge counters
Message-ID: <20121111184426.GA5415@jshin-Toonie>
References: <1352509298-7319-1-git-send-email-jacob.shin@amd.com>
 <20121110115027.GC2777@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121110115027.GC2777@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 12:50:27PM +0100, Robert Richter wrote:
> On 09.11.12 19:01:34, Jacob Shin wrote:
> > The following patchset enables 4 additional performance counters in
> > AMD family 15h processors that counts northbridge events -- such as
> > DRAM accesses.
> > 
> > This patchset is based on previous work done by Robert Richter
> > <rric@kernel.org> :
> > 
> > https://lkml.org/lkml/2012/6/19/324
> 
> The original patch set of this is here (a rebased version):
> 
>  http://git.kernel.org/?p=linux/kernel/git/rric/oprofile.git;a=shortlog;h=refs/heads/perf-nb
> 
> This code was tested in detail.
> 
> > The main differences are:
> > 
> > - The northbridge counters are indexed contiguously right above the
> >   core performance counters.
> > 
> > - MSR address offset calculations are moved to architecture specific
> >   files.
> > 
> > - Interrups are set up to be delivered only to a single core.
> 
> So I rather suggest to make delta patches on top of my patches.

Okay, if we have to, I can rework my patches on top of that, as long 
as the end result looks something like I'm suggesting above. Because
in an upcoming processor family, there is no core performance counter
extensions, but we do have northbridge performance counters. Meaning
the counter address base would be c0010000 and northbridge counters
live in c0010240, being 0x240 apart, we could make counter masks work
but that testng awful alot of 0's for every address offset calculation
.

> 
> Peter's main concerns were that my patch set is not in the
> Intel-uncore style. I started reworking this but was not able to
> finish my work. This concerns still exist.

Right, I considered this too, and still, I agree with you Robert that
it makes more sense to just extend AMD's x86 PMU.

1. Because the hardware interface -- register bit fields, are alost
   identical

2. Because the interrupt delivery mechanism is also identical --
   delivered via same APIC interrupt vector.

I think my proposed patchset on top of current Linus's tree is pretty
minimal, and is isolated to AMD so it should be easier to swallow.

Peter, could you take a look at the patchset and if you still prefer
a intel uncore like implementation?

> 
> Due to the current situation I would rather prefer to create a
> tip:perf/amd-nb branch that includes my patches and then add all
> further necessary steps for mainline acceptance on top of it.

Okay, Peter, let me know if this is a route to go, and I'll generate
my patchset on top of that.

Thanks,

-Jacob

> 
> Thanks,
> 
> -Robert
> 

