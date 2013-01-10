Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3AJJMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:12:09 -0500
Received: from linux-sh.org ([111.68.239.195]:51964 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab3AJJMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:12:05 -0500
X-Greylist: delayed 722 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2013 04:12:05 EST
Date: Thu, 10 Jan 2013 17:59:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: clk dereference in arch/sh/kernel/cpufreq.c
Message-ID: <20130110085923.GA7785@linux-sh.org>
References: <alpine.DEB.2.02.1301031038030.1989@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1301031038030.1989@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 10:40:20AM +0100, Julia Lawall wrote:
> There has been a discussion recently about how the result of get_clk
> should be an opaque handle, not a value that can be dereferenced:
> 
> https://lkml.org/lkml/2012/12/20/105
> 
> There is such a dereference in arch/sh/kernel/cpufreq.c, in the function
> sh_cpufreq_cpu_init:
> 
> freq_table = cpuclk->nr_freqs ? cpuclk->freq_table : NULL;
> 
> It was not obvious to me, however, what API function should be used
> instead, so I am just reporting the (potential) problem.
> 
In this case we would have to add some new API for fetching the frequency
table associated with the struct clk, which is reasonably
straightforward. It's not obvious how a private API vs deref of a type we
have a private definition for is any better or worse, though. This code
is not aimed at the common struct clk in any event.
