Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0CYTdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 15:33:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46601 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0CYTdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 15:33:20 -0400
Date: Thu, 25 Mar 2010 20:33:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/9] oprofile, perf, x86: introduce new functions to reserve perfctrs by index
Message-ID: <20100325193318.GT20695@one.firstfloor.org>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com> <1267716131-17908-4-git-send-email-robert.richter@amd.com> <87eijfczqv.fsf@basil.nowhere.org> <20100325155208.GI1585@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325155208.GI1585@erda.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 04:52:08PM +0100, Robert Richter wrote:
> Andi,
> 
> so far it does not seem this reservation patches will go upstream. So
> we still do not have a solution of how to share the pmu with perf. The

There's the current reservation 
code which has some issues and is butt ugly, but does its job mostly.

The only real problem I have with it is that it doesn't support fixed counters.

That's not very hard to fix (patches posted), but of course requires
some basic cooperation from impartial maintainers. I think extending
it to other registers shouldn't also be that hard.

> current approach is a global pmu lock. I don't think this is a good
> solution and we already see questions on the oprofile mailing list why
> counters are not available to use. This will become much worse if perf
> is using counters permanently in the kernel (e.g. the perf nmi
> watchdog). This will make oprofile unusable.

NMI watchdog is not on by default luckily.

Anyways I don't really understand what the problem with just
allocating counters properly in perf_events like everyone else.
They need to do that anyways to cooperate with firmware or VMs using these
counters.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
