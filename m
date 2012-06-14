Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2FNKFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:05:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:49395 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab2FNKFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:05:20 -0400
Message-ID: <1339668296.2559.25.camel@twins>
Subject: Re: What is the right practice to get new code upstream( was Fwd:
 [patch] a simple hardware detector for latency as well as throughput ver.
 0.1.0)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
        jcm@jonmasters.org, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        Robert Richter <robert.richter@amd.com>
Date: Thu, 14 Jun 2012 12:04:56 +0200
In-Reply-To: <CAJRGBZw2TctmBxRuA-byaGNCs=1v+M-1PXSm+OuwWApSqu7UjA@mail.gmail.com>
References: <CAJRGBZw2TctmBxRuA-byaGNCs=1v+M-1PXSm+OuwWApSqu7UjA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 20:57 +0800, Luming Yu wrote:
> The Goal is to test out hardware/BIOS caused
> problems in 2 minutes. To me, capable of measuring the intrinsic of
> hardware on which we build our software is always a better idea than
> blindly looking for data from any documents. In current version of the
> tool, we have a basic sampling facility and TSC test ready for x86. I
> plan to add more test into this tool to enrich our tool set in Linux.
> 
> 
There's SMI damage around on much longer periods than 2 minutes.

Also, you can't really do stop_machine for 2 minutes and expect the
system to survive.

Furthermore, I think esp. on more recent chips there's better ways of
doing it.

For Intel there's a IA32_DEBUGCTL.FREEZE_WHILE_SMM_EN [bit 14], if you
program a PMU event that ticks at the same rate as the TSC and enable
the FREEZE_WHILE_SMM stuff, any drift observed between that and the TSC
is time lost to SMM. It also has MSR_SMI_COUNT [MSR 34H] which counts
the number of SMIs.

For AMD there's only event 02Bh, which is SMIs Received. I'm not sure it
has anything like the FREEZE or if the event is modifyable to count the
cycles in SMI.
