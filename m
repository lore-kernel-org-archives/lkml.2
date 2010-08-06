Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518Ab0HFPiC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:38:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43777 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab0HFPh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:37:59 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "fweisbec\@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang\, Ying" <ying.huang@intel.com>
Subject: Re: A question of perf NMI handler
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
	<20100804100116.GH26154@erda.amd.com>
	<20100804140021.GN3353@redhat.com> <1280931093.1923.1194.camel@laptop>
	<20100804145203.GP3353@redhat.com> <1280934161.1923.1294.camel@laptop>
Date: Fri, 06 Aug 2010 17:37:57 +0200
In-Reply-To: <1280934161.1923.1294.camel@laptop> (Peter Zijlstra's message of
	"Wed, 04 Aug 2010 17:02:41 +0200")
Message-ID: <8739urda5m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> Suppose you have 4 counters (AMD, intel-nhm+), when more than 2 overflow
> the first will raise the PMI, if the other 2+ overflow before we disable
> the PMU it will try to raise 2+ more PMIs, but because hardware only has
> a single interrupt pending bit it will at most cause a single extra
> interrupt after we finish servicing the first one.
>
> So then the first interrupt will see 3+ overflows, return 3+, and will
> thus eat 2+ NMIs, only one of which will be the pending interrupt,
> leaving 1+ NMIs from other sources to consume unhandled.
>
> In which case Yinghai will have to press his NMI button 2+ times before
> it registers.
>
> That said, that might be a better situation than always consuming
> unknown NMIs.. 

One alternative would be to stop using NMIs for perf counters in common cases.

If you have PEBS and your events support PEBS then PEBS can give you a
lot of information inside the irq off region. That works for common
events at least.

Also traditionally interrupt off regions are shrinking in Linux,
so is it really still worth all the trouble just to profile inside them.

e.g. one could make nmi profiling an option with default off.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
