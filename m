Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab1D1WKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 18:10:50 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:47111 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1D1WKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 18:10:49 -0400
Date: Thu, 28 Apr 2011 18:10:13 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
In-Reply-To: <20110427064342.GE17079@elte.hu>
Message-ID: <alpine.DEB.2.00.1104281801350.25779@cl320.eecs.utk.edu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org> <1303407662-15564-2-git-send-email-acme@infradead.org> <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu> <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <1303809958.20212.219.camel@twins> <alpine.DEB.2.00.1104261617320.32482@cl320.eecs.utk.edu> <20110427064342.GE17079@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011, Ingo Molnar wrote:

> 
> Erm, that assumes you already know that magic incantation. Most of the users 
> who want to do measurements and profiling do not know that. So there's little 
> difference between:
> 
>  - someone shows them the 0x53cf28 magic code
>  - someone shows them the L2_IFETCH:BOTH_CORES magic symbol
> 
> So you while hexa values have like 10% utility, the stupid, vendor-specific 
> event names you are pushing here have like 15% utility.
> 
> In perf we are aiming for 100% utility, where if someone knows something about 
> CPUs and can type 'cycles', 'instructions' or 'branches', will get the obvious 
> result.
> 
> This is not a difficult usability concept really.

yes, and this functionality belongs in the perf tool itself (or some other 
user tool, like libpfm4, or PAPI).  Not in the kernel.

How much larger are you willing to make the kernel to hold your 
generalized events?  PAPI has at least 128 that people have found useful 
enough to add over the years.  There are probably more.

I notice the kernel doesn't have any FP or SSE/Vector counts yet.  Or 
uops.  Or hw-interrupt counts.  Fused multiply-add?  
How about GPU counters (PAPI is starting to support these)?  Network 
counters?  Infiniband?

You're being lazy and pushing "perf" functionality into the kernel.  It 
belongs in userspace.  

It's not the kernel's job to make things easy for users.  Its job is to 
make things possible, and get out of the way.

It's already bad enough that your generalized events can change from 
kernel version to kernel version without warning.  By being in the kernel, 
aren't they a stable ABI that can't be changed?

Vince
