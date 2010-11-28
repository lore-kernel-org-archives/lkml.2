Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0K1XBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 18:01:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0K1XBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 18:01:48 -0500
Date: Mon, 29 Nov 2010 00:01:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] kthread: NUMA aware kthread_create_on_cpu()
Message-ID: <20101128230146.GB12300@basil.fritz.box>
References: <1290972833.29196.90.camel@edumazet-laptop>
 <20101128224024.GA12300@basil.fritz.box>
 <1290984712.29196.100.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290984712.29196.100.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 11:51:51PM +0100, Eric Dumazet wrote:
> > Also this messes up the policy of the caller process. You really
> > need to save/restore it.
> 
> Well, caller process duty is to create kthreads in a loop.

In this case any other allocations it may do are still on those
nodes.

> > Problem is that this ends up in architecture specific code
> > for the stack, so may be a larger patch.
> 
> I suggest arches that need slab to allocate kthread stacks do the
> appropriate changes, because I am not able to make them myself.
> 
> On x86, we use page allocator only, so NUMA mempolicy is used.

task_struct is always allocated from slab.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
