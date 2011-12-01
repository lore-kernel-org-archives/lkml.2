Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1LAUgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:36:37 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:6816 "EHLO
	VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751718Ab1LAUgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:36:36 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz146fK1432N98dKzz1202hzz8275bhz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVJL8U-01-IQX-02
X-M-MSG: 
Date: Thu, 1 Dec 2011 21:36:05 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <suresh.b.siddha@intel.com>, <eranian@google.com>, <brgerst@gmail.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] rework of extended state handling, LWP support
Message-ID: <20111201203605.GB411@escobedo.osrc.amd.com>
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
 <m2ipm2lioy.fsf@firstfloor.org>
 <20111130173745.GT878@escobedo.osrc.amd.com>
 <20111130215200.GS24062@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111130215200.GS24062@one.firstfloor.org>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 10:52:00PM +0100, Andi Kleen wrote:
> On Wed, Nov 30, 2011 at 06:37:46PM +0100, Hans Rosenfeld wrote:
> > On Tue, Nov 29, 2011 at 01:31:09PM -0800, Andi Kleen wrote:
> > > Hans Rosenfeld <hans.rosenfeld@amd.com> writes:
> > > >
> > > > The lazy allocation of the xstate area has been removed. The support for
> > > > extended states that cannot be saved/restored lazily, like AMD's LWP,
> > > > need this. Since optimized library functions using SSE etc. are widely
> > > > used today, most processes would have an xstate area anyway, making the
> > > > memory overhead negligible.
> > > 
> > > Do you have any data on that?  It sounds dubious for specialized
> > > workloads.
> > 
> > What kind of specialized workload do you mean?
> 
> Anything that doesn't do large memcpys/memsets: glibc only uses SSE
> when you pass large buffers. And then doesn't use the FPU. And possibly
> has lots of processes.
> 
> Some older glibc did an unconditional FPU initialization at start,
> but I believe that's long gone.

Well, I can't comment on which glibc version does what exactly. But on
the 64bit systems that I observed, _all_ processes had an xstate area
allocated. That was not the case on 32bit, but I'd suspect that the
32bit distributions just aren't optimized for modern hardware.

So I assume, if you have 10000s of processes on a legacy 32bit system
that never do any FPU stuff or SSE optimizations, you might indeed waste
a couple of megabytes. I don't think thats very realistic, but that's
just my opinion.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

