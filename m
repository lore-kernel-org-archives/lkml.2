Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab0K2JFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:05:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34250 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0K2JFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:05:21 -0500
Date: Mon, 29 Nov 2010 10:05:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] kthread: NUMA aware kthread_create_on_cpu()
Message-ID: <20101129090510.GA15763@basil.fritz.box>
References: <1290972833.29196.90.camel@edumazet-laptop>
 <20101128224024.GA12300@basil.fritz.box>
 <1290984712.29196.100.camel@edumazet-laptop>
 <20101128230146.GB12300@basil.fritz.box>
 <1290987424.29196.128.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290987424.29196.128.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 12:37:04AM +0100, Eric Dumazet wrote:
> Le lundi 29 novembre 2010 à 00:01 +0100, Andi Kleen a écrit :
> > On Sun, Nov 28, 2010 at 11:51:51PM +0100, Eric Dumazet wrote:
> > > > Also this messes up the policy of the caller process. You really
> > > > need to save/restore it.
> > > 
> > > Well, caller process duty is to create kthreads in a loop.
> > 
> > In this case any other allocations it may do
> >  are still on those
> > nodes.
> 
> As I said, it does only create_kthread() calls, and no "other
> allocations".

Code changes. Your current setup seems fragile (also
the static variable)

> > > > for the stack, so may be a larger patch.
> > > 
> > > I suggest arches that need slab to allocate kthread stacks do the
> > > appropriate changes, because I am not able to make them myself.
> > > 
> > > On x86, we use page allocator only, so NUMA mempolicy is used.
> > 
> > task_struct is always allocated from slab.
> 
> Hmm, I meant stack (the thing that might be trashed a lot in ksoftirqd),
> so it is included in struct thread_info

task_struct is quite hot too. Also your original mail said
task struct i believe.

> And got correct stacks. Are you sure we must use PREFERRED ?

Yes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
