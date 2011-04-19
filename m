Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab1DSSVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 14:21:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56508 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1DSSVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 14:21:49 -0400
Date: Tue, 19 Apr 2011 20:21:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] perf, x86: Use ALTERNATIVE() to check for X86_FEATURE_PERFCTR_CORE
Message-ID: <20110419182148.GS16484@one.firstfloor.org>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com> <1302913676-14352-4-git-send-email-robert.richter@amd.com> <m27har9vnq.fsf@firstfloor.org> <20110419103927.GV31407@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419103927.GV31407@erda.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 12:39:27PM +0200, Robert Richter wrote:
> On 18.04.11 16:00:57, Andi Kleen wrote:
> > Robert Richter <robert.richter@amd.com> writes:
> > 
> > > Using ALTERNATIVE() when checking for X86_FEATURE_PERFCTR_CORE avoids
> > > an extra pointer chase and data cache hit.
> > 
> > Is that really a performance critical path?
> > 
> > Seems more like unnecessary obfuscation to me.
> 
> We hotest path is in perf_pmu_disable(), which happens at least with
> every task switch when calling the event scheduler.

Yes but that's already a slow path isn't it? It better is, because
the MSR accesses alone are incredibly expensive. I guess your test
and jump isn't even on the radar after that ...

-Andi
