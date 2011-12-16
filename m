Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160Ab1LPQIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:08:17 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:22087
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756561Ab1LPQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:08:09 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1dbaL1432N98dKzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWB0TD-01-62I-02
X-M-MSG: 
Date: Fri, 16 Dec 2011 17:07:58 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bebl@mageta.org>
Subject: Re: [PATCH 0/9] rework of extended state handling, LWP support
Message-ID: <20111216160757.GL665@escobedo.osrc.amd.com>
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
 <20111205102223.GA3143@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111205102223.GA3143@elte.hu>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 11:22:23AM +0100, Ingo Molnar wrote:
> 
> * Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> 
> > These patches were built and tested against 3.1. The older RFC 
> > patches that have been lingering in tip/x86/xsave for the last 
> > few months should be removed.
> 
> They have been lingering because of negative review feedback i 
> have given to you about LWP. I'm not convinced about the current 
> form of abstraction that this patch-set offers.
>
> See this past discussion from half a year ago:
> 
>   Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling, LWP support
> 
> We can and should do better than that.

We had an intern, Benjamin Block, working on perf support for LWP until
a few weeks ago. Because of the fundamental problem that it is not
reasonably possible to allocate virtual memory for a process from a
different process' context, the code only supports self-monitoring.

This allows a process to control LWP through the perf syscalls. Instead
of using malloc() and the LLWPCB instruction itself, it can use the perf
syscall to have the perf kernel code do it. It can also use perf to get
at the raw LWP samples instead of just reading them from the LWP buffer.


I'll send you Benjamins code as an RFC patch set, so please take a look
at it and tell me what you think about it. I admit I don't understand
every detail of it yet as I've only recently started to work my way
through it, and I have no prior knowledge about perf. 


Hans


