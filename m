Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1HAWSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 18:18:35 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:40884
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631Ab1HAWS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 18:18:28 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz146fK1432N98dK4015Lzz1202hzz8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP9SJE-01-DVM-02
X-M-MSG: 
Date: Tue, 2 Aug 2011 00:16:25 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] oprofile, x86: Convert memory allocation to static
 array
Message-ID: <20110801221625.GF11795@erda.amd.com>
References: <4E35A14E.90702@gmail.com>
 <20110801070742.GA11795@erda.amd.com>
 <4E36C18B.7050502@gmail.com>
 <20110801213142.GE11795@erda.amd.com>
 <20110801214130.GF27083@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110801214130.GF27083@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.08.11 17:41:30, Andi Kleen wrote:
> On Mon, Aug 01, 2011 at 11:31:42PM +0200, Robert Richter wrote:
> > On 01.08.11 11:08:59, Maarten Lankhorst wrote:
> > > On -rt, allocators don't work from atomic context any more,
> > > and the maximum size of the array is known at compile time.
> > > 
> > > Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> > 
> > Applied to oprofile/core. Thanks, Maarten.
> 
> And what happens when the CPU reports more than 32 counters?
> You have a silent buffer overflow then.

>From the layout of IA32_PERF_GLOBAL_CTRL MSR it seems to be limited to
32. Anyway, if there might be cpus out soon with more than 32 counters
we can either extend the array to 256 or limit the counters used to 32.

> Besides I bet there are other cases like this all over the tree.
> 
> And the whole thing is tasteless. 
> 
> Nacked-by: Andi Kleen <ak@linux.intel.com>

This dynamic allocation is causing trouble from the beginning. Using a
static array removes a lot of NULL pointer checks:

 arch/x86/oprofile/op_model_ppro.c |   24 +-----------------------

The previous implementation silently dropped counters during setup on
failure. Also we have had many bugs caused by this dynamic allocation
(I counted 3 fixes). This all isn't it worth and you did not yet
explain the concerns you have (besides the potentially buffer overflow
which is fixable and probably of academic nature).

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

