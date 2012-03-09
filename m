Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2CILlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 06:41:22 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:38795
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354Ab2CILlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 06:41:21 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zz1432N98dK148cMzz1202hzz8275bh5eeeKz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0M8GQ-01-1KV-02
X-M-MSG: 
Date: Fri, 9 Mar 2012 12:41:12 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20120309114112.GR16322@erda.amd.com>
References: <20111223111958.GE16765@erda.amd.com>
 <20111223135340.GB21382@elte.hu>
 <1324649698.24803.55.camel@twins>
 <20111223144040.GB2297@elte.hu>
 <20111223161701.GF16765@erda.amd.com>
 <20111223163930.GA5983@elte.hu>
 <20111223165030.GG16765@erda.amd.com>
 <20111230095521.GA12077@elte.hu>
 <20120202112133.GR16322@erda.amd.com>
 <20120308121924.GA19674@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120308121924.GA19674@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On 08.03.12 13:19:24, Ingo Molnar wrote:
> I've applied the following 4 kernel patches to perf/x86-ibs:
> 
>  db98c5faf8cb: perf/x86: Implement 64-bit counter support for IBS
>  4db2e8e6500d: perf/x86: Implement IBS pmu control ops
>  b7074f1fbd61: perf/x86: Implement IBS interrupt handler
>  510419435c69: perf/x86: Implement IBS event configuration
> 
> and pushed it out.
> 
> We can apply any tooling changes to this branch as well.
> 
> I suspect being able to skid-less profile on AMD CPUs, using 
> IBS, would be a useful feature to users. What would be required 
> for that to work?

thanks for putting this into tip. This helps a lot.

I am just looking into skid-less sampling. The effort of attaching the
rip taken from the IBS sample for events 0x76/0xc1 should be feasable.

In between I started the implementation of ibs pseudo events as
described here:

 Appendix F Guide to Instruction-Based Sampling
 http://support.amd.com/us/Processor_TechDocs/47414_15h_sw_opt_guide.pdf

This includes kernel side filtering and ibs support for the perf tool.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

