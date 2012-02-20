Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2BTWcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 17:32:13 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:59386 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab2BTWcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 17:32:12 -0500
Date: Tue, 21 Feb 2012 00:32:09 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Tejun Heo <tj@kernel.org>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>, sam@ravnborg.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <20120220170603.GC7836@mtj.dyndns.org>
Message-ID: <alpine.SOC.1.00.1202210030530.11350@math.ut.ee>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee> <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131119040.1488@math.ut.ee> <20120213214623.GJ11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202162151030.16208@math.ut.ee>
 <alpine.SOC.1.00.1202201109260.467@math.ut.ee> <20120220170603.GC7836@mtj.dyndns.org>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Feb 20, 2012 at 11:11:05AM +0200, Meelis Roos wrote:
> > Finished bisecting on the other machine too (Sun Fire V100 where strlen 
> > crashes):
> > 
> > 7bd0b0f0da3b1ec11cbcc798eb0ef747a1184077 is the first bad commit
> > commit 7bd0b0f0da3b1ec11cbcc798eb0ef747a1184077
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Thu Dec 8 10:22:09 2011 -0800
> > 
> >     memblock: Reimplement memblock allocation using reverse free area iterator
> >     
> >     Now that all early memory information is in memblock when enabled, we
> >     can implement reverse free area iterator and use it to implement NUMA
> >     aware allocator which is then wrapped for simpler variants instead of
> >     the confusing and inefficient mending of information in separate NUMA
> >     aware allocator.
> >     
> >     Implement for_each_free_mem_range_reverse(), use it to reimplement
> >     memblock_find_in_range_node() which in turn is used by all allocators.
> >     
> >     The visible allocator interface is inconsistent and can probably use
> >     some cleanup too.
> >     
> >     Signed-off-by: Tejun Heo <tj@kernel.org>
> >     Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >     Cc: Yinghai Lu <yinghai@kernel.org>
> 
> Hmmm.... So, different bisection results from two machines?  That's a
> bit weird.  I *think* this bisection result makes more sense.  Can you
> please verify the bisection result on e2500 once more?

You were right. The first machine now bisects down to the same commit - 
I was confused by "0 revisions to test" and did not run the last step 
whe first bisecting.

-- 
Meelis Roos (mroos@linux.ee)
