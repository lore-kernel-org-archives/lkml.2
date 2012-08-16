Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab2HPHkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:40:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:50129 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2HPHka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:40:30 -0400
Message-ID: <1345102812.31459.114.camel@twins>
Subject: Re: powerpc/perf: hw breakpoints return ENOSPC
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Neuling <mikey@neuling.org>
Cc: K Prasad <prasad@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@kernel.org>
Date: Thu, 16 Aug 2012 09:40:12 +0200
In-Reply-To: <28857.1345091034@neuling.org>
References: <28857.1345091034@neuling.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 14:23 +1000, Michael Neuling wrote:
> 
> On this second syscall, fetch_bp_busy_slots() sets slots.pinned to be 1,
> despite there being no breakpoint on this CPU.  This is because the call
> the task_bp_pinned, checks all CPUs, rather than just the current CPU.
> POWER7 only has one hardware breakpoint per CPU (ie. HBP_NUM=1), so we
> return ENOSPC.

I think this comes from the ptrace legacy, we register a breakpoint on
all cpus because when we migrate a task it cannot fail to migrate the
breakpoint.

Its one of the things I hate most about the hwbp stuff as it relates to
perf.

Frederic knows more...
