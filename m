Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3AJJbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:31:51 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:17910 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab3AJJbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:31:49 -0500
X-IronPort-AV: E=Sophos;i="4.84,443,1355094000"; 
   d="scan'208";a="189230568"
Date: Thu, 10 Jan 2013 10:31:46 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Paul Mundt <lethal@linux-sh.org>
cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: clk dereference in arch/sh/kernel/cpufreq.c
In-Reply-To: <20130110085923.GA7785@linux-sh.org>
Message-ID: <alpine.DEB.2.02.1301101031290.2063@localhost6.localdomain6>
References: <alpine.DEB.2.02.1301031038030.1989@hadrien> <20130110085923.GA7785@linux-sh.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013, Paul Mundt wrote:

> On Thu, Jan 03, 2013 at 10:40:20AM +0100, Julia Lawall wrote:
> > There has been a discussion recently about how the result of get_clk
> > should be an opaque handle, not a value that can be dereferenced:
> > 
> > https://lkml.org/lkml/2012/12/20/105
> > 
> > There is such a dereference in arch/sh/kernel/cpufreq.c, in the function
> > sh_cpufreq_cpu_init:
> > 
> > freq_table = cpuclk->nr_freqs ? cpuclk->freq_table : NULL;
> > 
> > It was not obvious to me, however, what API function should be used
> > instead, so I am just reporting the (potential) problem.
> > 
> In this case we would have to add some new API for fetching the frequency
> table associated with the struct clk, which is reasonably
> straightforward. It's not obvious how a private API vs deref of a type we
> have a private definition for is any better or worse, though. This code
> is not aimed at the common struct clk in any event.

OK, maybe it should just be left as is?

julia
