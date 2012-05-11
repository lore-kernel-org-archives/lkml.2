Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2EKPHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:07:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab2EKPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:07:52 -0400
Date: Fri, 11 May 2012 16:07:47 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, michaelc@cs.wisc.edu,
        emunson@mgebm.net
Subject: Re: [PATCH 10/17] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
Message-ID: <20120511150747.GU11435@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
 <1336657510-24378-11-git-send-email-mgorman@suse.de>
 <20120511.005740.210437168371869566.davem@davemloft.net>
 <20120511143218.GS11435@suse.de>
 <1336747350.1017.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1336747350.1017.22.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 04:42:30PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-05-11 at 15:32 +0100, Mel Gorman wrote:
> > > > +extern atomic_t memalloc_socks;
> > > > +static inline int sk_memalloc_socks(void)
> > > > +{
> > > > +   return atomic_read(&memalloc_socks);
> > > > +}
> > > 
> > > Please change this to be a static branch.
> > > 
> > 
> > Will do. I renamed memalloc_socks to sk_memalloc_socks, made it a int as
> > atomics are unnecessary and I check it directly in a branch instead of a
> > static inline. It should be relatively easy for the branch predictor. 
> 
> David means you to use include/linux/jump_label.h.
> 

Ah, that makes a whole lot more sense. Thanks for the clarification.

-- 
Mel Gorman
SUSE Labs
