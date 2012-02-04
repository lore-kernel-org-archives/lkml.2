Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2BDSBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 13:01:07 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52641 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914Ab2BDSBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 13:01:05 -0500
Date: Sat, 4 Feb 2012 18:00:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
Message-ID: <20120204180016.GB30910@arm.com>
References: <alpine.LFD.2.02.1202022016480.2759@xanadu.home>
 <1328234629-32735-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328234629-32735-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 02:03:49AM +0000, Stephen Boyd wrote:
> armv7's flush_cache_all() flushes caches via set/way. To
> determine the cache attributes (line size, number of sets,
> etc.) the assembly first writes the CSSELR register to select a
> cache level and then reads the CCSIDR register. The CSSELR register
> is banked per-cpu and is used to determine which cache level CCSIDR
> reads. If the task is migrated between when the CSSELR is written and
> the CCSIDR is read the CCSIDR value may be for an unexpected cache
> level (for example L1 instead of L2) and incorrect cache flushing
> could occur.
> 
> Disable interrupts across the write and read so that the correct
> cache attributes are read and used for the cache flushing
> routine. We disable interrupts instead of disabling preemption
> because the critical section is only 3 instructions and we want
> to call v7_dcache_flush_all from __v7_setup which doesn't have a
> full kernel stack with a struct thread_info.
> 
> This fixes a problem we see in scm_call() when flush_cache_all()
> is called from preemptible context and sometimes the L2 cache is
> not properly flushed out.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Nicolas Pitre <nico@fluxnic.net>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin
