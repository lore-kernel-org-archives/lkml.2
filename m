Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1ILOXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:23:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58582 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab1ILOXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:23:09 -0400
Date: Mon, 12 Sep 2011 16:23:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
Message-ID: <20110912142305.GN7761@one.firstfloor.org>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com> <1315836358.26517.43.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315836358.26517.43.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 04:05:58PM +0200, Peter Zijlstra wrote:
> Subject: llist: Remove cpu_relax() usage in cmpxchg loops
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Sep 12 15:50:49 CEST 2011
> 
> Initial benchmarks show they're a net loss (2 socket wsm):
> 

May still save power. however:

>  		entry = cmpxchg(&head->first, old_entry, new);
>  		if (entry == old_entry)
>  			break;
> -		cpu_relax();

You need at least a barrier() then, otherwise the compiler could
change the memory order in the loop.

-Andi
