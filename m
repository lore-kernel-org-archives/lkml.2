Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2FNOPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:15:22 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34950 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756040Ab2FNOPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:15:18 -0400
MIME-Version: 1.0
In-Reply-To: <1339668296.2559.25.camel@twins>
References: <CAJRGBZw2TctmBxRuA-byaGNCs=1v+M-1PXSm+OuwWApSqu7UjA@mail.gmail.com>
	<1339668296.2559.25.camel@twins>
Date: Thu, 14 Jun 2012 22:15:16 +0800
Message-ID: <CAJRGBZx2QAfZeTmfc-LodECqsea7Be0jzz+7Y=X85wmYB3RgWg@mail.gmail.com>
Subject: Re: What is the right practice to get new code upstream( was Fwd:
 [patch] a simple hardware detector for latency as well as throughput ver. 0.1.0)
From: Luming Yu <luming.yu@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
        jcm@jonmasters.org, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 6:04 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-06-12 at 20:57 +0800, Luming Yu wrote:
>> The Goal is to test out hardware/BIOS caused
>> problems in 2 minutes. To me, capable of measuring the intrinsic of
>> hardware on which we build our software is always a better idea than
>> blindly looking for data from any documents. In current version of the
>> tool, we have a basic sampling facility and TSC test ready for x86. I
>> plan to add more test into this tool to enrich our tool set in Linux.
>>
>>
> There's SMI damage around on much longer periods than 2 minutes.

Right, it's a problem that if we run the tool when SMI is not triggered.
My rough idea  is to come up with some ideas to scan the system. Not entirely
sure but  2 minutes could be sufficient to finish such scan on a normal
laptop. The question is how we scan? We may need to adjust the 2 minutes
goal accordingly based on the method of scan and the size of machine to scan.

>
> Also, you can't really do stop_machine for 2 minutes and expect the
> system to survive.

By design, the test thread suppose to, by default, for tsc
measurement, spend sample_width/sample_window of cpu cycles in
stop_machine context on sampling. The left cpu cycles yields to other
threads in msleep_interruptible.  The default sample_width is 500us,
the default sample_window is 1ms.

>
> Furthermore, I think esp. on more recent chips there's better ways of
> doing it.

Right , the reference to PMU counts will make the tool more useful.

>
> For Intel there's a IA32_DEBUGCTL.FREEZE_WHILE_SMM_EN [bit 14], if you
> program a PMU event that ticks at the same rate as the TSC and enable
> the FREEZE_WHILE_SMM stuff, any drift observed between that and the TSC
> is time lost to SMM. It also has MSR_SMI_COUNT [MSR 34H] which counts
> the number of SMIs.
>
> For AMD there's only event 02Bh, which is SMIs Received. I'm not sure it
> has anything like the FREEZE or if the event is modifyable to count the
> cycles in SMI.

It's in to-do-list for version 0.2 of the tool.

Thanks!!!
