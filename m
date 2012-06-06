Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2FFOle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:41:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:29430 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab2FFOld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:41:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="148899307"
Date: Wed, 6 Jun 2012 07:41:32 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 5/5] perf, x86: Prefer RDPMC over RDMSR for reading
 counters
Message-ID: <20120606144132.GJ28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
 <1338944211-28275-5-git-send-email-andi@firstfloor.org>
 <1338979579.2749.95.camel@twins>
 <20120606141644.GF28225@tassilo.jf.intel.com>
 <1338992472.2749.116.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338992472.2749.116.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 04:21:12PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-06 at 07:16 -0700, Andi Kleen wrote:
> > On Wed, Jun 06, 2012 at 12:46:19PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > 
> > > > RDPMC is much faster than RDMSR for reading performance counters,
> > > > since it's not serializing.  Use it if possible in the perf handler.
> > > > 
> > > > Only tested on Sandy Bridge, so I only enabled it there so far.
> > > 
> > > That's just stupid.. I took Vince's patch from a while back.
> > 
> > What do you mean? It's significantly faster to read the counters this
> > way, because it avoids serialization and other overhead. 
> 
> What I'm saying is you only enabling it for snb and being too lazy to
> test anything else. Nor do I think its worth the conditional, all chips
> we have PMU support for have rdpmc instructions.

The reason I avoided it on everyone is that some old chips (NetBurst'ish 
I think) only were able to read the low 32bits through RDPMC.

If you prefer I can enable it on all the P6 cores?  I cannot test them
all however.

> 
> > Vince's patch only enabled it for user space I believe, This is for lowering
> > the kernel PMI handler overhead.
> 
> No, his patch did the kernel thing. Furthermore he actually tested it on
> a bunch of machines.

Ok. I wasn't aware of that. But it's not merged, what happened to ti?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
