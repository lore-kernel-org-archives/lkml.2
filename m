Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab2EHGN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 02:13:28 -0400
Received: from ozlabs.org ([203.10.76.45]:38439 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab2EHGN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 02:13:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@kernel.dk>, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] lglock: remove online variants of lock
In-Reply-To: <20120508045044.GJ22082@ZenIV.linux.org.uk>
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228112422.GC11324@alboin.amr.corp.intel.com> <87ipijzfwn.fsf@rustcorp.com.au> <20120420112149.GH25458@amd.local0.net> <87sjfcfynb.fsf@rustcorp.com.au> <20120507054616.GG22082@ZenIV.linux.org.uk> <87txzrcoge.fsf@rustcorp.com.au> <20120508045044.GJ22082@ZenIV.linux.org.uk>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 08 May 2012 15:42:37 +0930
Message-ID: <87txzrb3qi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012 05:50:44 +0100, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Tue, May 08, 2012 at 01:29:45PM +0930, Rusty Russell wrote:
> > Optimizing the slow paths adds a lot of complexity.  If you need to
> > grab every lock often, you have other problems.
> 
> Applied, but I'm not too happy about the situation with vfsmount_lock ;-/
> On kernels built for a lot of possible CPUs the loss of ..._online()
> versions will get painful.

My original motivation was to get rid of that cpumask_t (and replace it
with a cpumask_var_t).  A simple enough patch, but I couldn't bring
myself to leave that complex logic in place without clear justification.

> OTOH, we can always put the map + single
> spinlock + single notifier into lglock.c and reproduce the old logics.
> I'll do a patch along those lines and put it on a separate branch;
> then we'll be able to test and compare.

I'll be interested in the results: virtual systems are classic for
wanting large # of CPUs which aren't actually online, so we might
actually care.

I'd also like to get rid of the cpu_possible_map altogether, and just
have NR_CPUS/nr_cpu_ids, since last I checked no arch really wants
sparse numbers.

Cheers,
Rusty.
