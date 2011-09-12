Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab1ILOYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:24:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:51069 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671Ab1ILOYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:24:13 -0400
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 12 Sep 2011 16:23:53 +0200
In-Reply-To: <20110912142305.GN7761@one.firstfloor.org>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
	 <1315836358.26517.43.camel@twins>
	 <20110912142305.GN7761@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315837433.26517.45.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 16:23 +0200, Andi Kleen wrote:
> On Mon, Sep 12, 2011 at 04:05:58PM +0200, Peter Zijlstra wrote:
> > Subject: llist: Remove cpu_relax() usage in cmpxchg loops
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Mon Sep 12 15:50:49 CEST 2011
> > 
> > Initial benchmarks show they're a net loss (2 socket wsm):
> > 
> 
> May still save power. however:
> 
> >  		entry = cmpxchg(&head->first, old_entry, new);
> >  		if (entry == old_entry)
> >  			break;
> > -		cpu_relax();
> 
> You need at least a barrier() then, otherwise the compiler could
> change the memory order in the loop.

the cmpxchg is a full memory barrier and compiler barrier.
