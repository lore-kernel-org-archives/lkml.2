Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2FTKBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:01:10 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:16795
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554Ab2FTKBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:01:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI936eI1432Izz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5WUH2-01-3OH-02
X-M-MSG: 
Date: Wed, 20 Jun 2012 12:00:31 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for AMD
 family 15h
Message-ID: <20120620100031.GI1478@erda.amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
 <CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
 <20120620092932.GH1478@erda.amd.com>
 <1340185084.21745.81.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340185084.21745.81.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.12 11:38:04, Peter Zijlstra wrote:
> On Wed, 2012-06-20 at 11:29 +0200, Robert Richter wrote:
> > Second, since nb perfctr are implemented the same way as core
> > counters, the same code would have been used. Thus multiple (two) x86
> > pmus (struct x86_pmu) would reside in parallel in the kernel. 
> 
> Well, no. The I take it the uncore counters are nb wide, thus you need
> special goo to make counter rotation work properly, x86_pmu is unsuited
> for that.

The code for nb and core counters is identical. There would be the
same nmi handler, same code to setup the event, same code to
start/stop cpus. The only difference are per-node msrs, even the msr
offset calculation is the same as for core counters on family 15h. It
would not make sense to duplicate all this code. And, as said, current
design does not fit to use x86_pmus in parallel or to easy reuse x86
functions. Separating nb counters would make the same sense as
implementing a separate pmu for fixed counters.

And wrt counter rotation, this only affects code to assign counters.
You don't need a separate pmu for this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

