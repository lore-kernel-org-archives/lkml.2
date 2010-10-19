Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab0JSFjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 01:39:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:57752 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab0JSFjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 01:39:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="618074498"
Subject: Re: [patch]x86: spread tlb flush vector between nodes
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <1286959176.24888.6.camel@sli10-conroe.sh.intel.com>
References: <1286955698.13317.5.camel@sli10-conroe.sh.intel.com>
	 <20101013081629.GA1621@basil.fritz.box>
	 <1286959176.24888.6.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 13:39:17 +0800
Message-ID: <1287466757.29515.2.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 16:39 +0800, Shaohua Li wrote:
> On Wed, 2010-10-13 at 16:16 +0800, Andi Kleen wrote:
> > On Wed, Oct 13, 2010 at 03:41:38PM +0800, Shaohua Li wrote:
> > 
> > Hi Shaohua,
> > 
> > > Currently flush tlb vector allocation is based on below equation:
> > > 	sender = smp_processor_id() % 8
> > > This isn't optimal, CPUs from different node can have the same vector, this
> > > causes a lot of lock contention. Instead, we can assign the same vectors to
> > > CPUs from the same node, while different node has different vectors. This has
> > > below advantages:
> > > a. if there is lock contention, the lock contention is between CPUs from one
> > > node. This should be much cheaper than the contention between nodes.
> > > b. completely avoid lock contention between nodes. This especially benefits
> > > kswapd, which is the biggest user of tlb flush, since kswapd sets its affinity
> > > to specific node.
> > 
> > The original scheme with 8 vectors was designed when Linux didn't have
> > per CPU interrupt numbers yet, and interrupts vectors were a scarce resource.
> > 
> > Now that we have per CPU interrupts and there is no immediate danger 
> > of running out I think it's better to use more than 8 vectors for the TLB 
> > flushes.
> > 
> > Perhaps could use 32 vectors or so and give each node on a 8S 
> > system 4 slots and on a 4 node system 8 slots?
> Haven't too much idea. Before we have per CPU interrupts, muti vector
> msi-x isn't widely deployed. Thought we need data if this is really
> required.
looks there are still some overhead with total 8 vectors in a big
machine. I'll try the 32 vectors as you suggested. I'll send separate
patches out to address the 32 vectors issue. Can we merge this patch
first?

Thanks,
Shaohua

