Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2LKJSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:18:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43639 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2LKJSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:18:13 -0500
Date: Tue, 11 Dec 2012 10:18:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/49] Automatic NUMA Balancing v10
Message-ID: <20121211091807.GA23600@gmail.com>
References: <1354875832-9700-1-git-send-email-mgorman@suse.de>
 <20121207110113.GB21482@gmail.com>
 <20121209203630.GC1009@suse.de>
 <20121210113945.GA7550@gmail.com>
 <20121210152405.GJ1009@suse.de>
 <20121211010201.GP1009@suse.de>
 <20121211085238.GA21673@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211085238.GA21673@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > This is prototype only but what I was using as a reference 
> > to see could I spot a problem in yours. It has not been even 
> > boot tested but avoids remote->remote copies, contending on 
> > PTL or holding it longer than necessary (should anyway)
> 
> So ... because time is running out and it would be nice to 
> progress with this for v3.8, I'd suggest the following 
> approach:
> 
>  - Please send your current tree to Linus as-is. You already 
>    have my Acked-by/Reviewed-by for its scheduler bits, and my
>    testing found your tree to have no regression to mainline,
>    plus it's a nice win in a number of NUMA-intense workloads.
>    So it's a good, monotonic step forward in terms of NUMA
>    balancing, very close to what the bits I'm working on need as
>    infrastructure.
> 
>  - I'll rebase all my devel bits on top of it. Instead of
>    removing the migration bandwidth I'll simply increase it for
>    testing - this should trigger similarly aggressive behavior.
>    I'll try to touch as little of the mm/ code as possible, to
>    keep things debuggable.

One minor last-minute request/nit before you send it to Linus, 
would you mind doing a:

   CONFIG_BALANCE_NUMA => CONFIG_NUMA_BALANCING

rename please? (I can do it for you if you don't have the time.)

CONFIG_NUMA_BALANCING is really what fits into our existing NUMA 
namespace, CONFIG_NUMA, CONFIG_NUMA_EMU - and, more importantly, 
the ordering of words follows the common generic -> less generic 
ordering we do in the kernel for config names and methods.

So it would fit nicely into existing Kconfig naming schemes:

   CONFIG_TRACING
   CONFIG_FILE_LOCKING
   CONFIG_EVENT_TRACING

etc.

Thanks,

	Ingo
