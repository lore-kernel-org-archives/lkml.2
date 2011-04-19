Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1DSKjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:39:37 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.186]:49622
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299Ab1DSKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:39:35 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2cK1432N98dKzz1202hzz8275bhz32i668h839h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJWAXT-01-3J4-02
X-M-MSG: 
Date: Tue, 19 Apr 2011 12:39:27 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] perf, x86: Use ALTERNATIVE() to check for
 X86_FEATURE_PERFCTR_CORE
Message-ID: <20110419103927.GV31407@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-4-git-send-email-robert.richter@amd.com>
 <m27har9vnq.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <m27har9vnq.fsf@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.04.11 16:00:57, Andi Kleen wrote:
> Robert Richter <robert.richter@amd.com> writes:
> 
> > Using ALTERNATIVE() when checking for X86_FEATURE_PERFCTR_CORE avoids
> > an extra pointer chase and data cache hit.
> 
> Is that really a performance critical path?
> 
> Seems more like unnecessary obfuscation to me.

We hotest path is in perf_pmu_disable(), which happens at least with
every task switch when calling the event scheduler.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

