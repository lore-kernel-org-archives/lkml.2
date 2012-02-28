Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293Ab2B1LYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:24:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:34171 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965250Ab2B1LYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:24:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112130824"
Date: Tue, 28 Feb 2012 03:24:22 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
Message-ID: <20120228112422.GC11324@alboin.amr.corp.intel.com>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227155338.7b5110cd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 03:53:38PM -0800, Andrew Morton wrote:
> On Tue, 28 Feb 2012 09:52:30 +1030
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Use a cpumask_var_t instead of cpumask_t.  We're doing plenty of
> > allocations here anyway, so it's not really an issue, and it sets a
> > good example.
> > 
> > (cpumask_t is obsolescent, as are the cpus_* functions).
> 
> Congratulations to yourself and Andi:

Well the only way to avoid that problem is to merge it ASAP.

The patch -- like most code movement patches -- is totally unsuitable for 
keeping around for months in trees.

Usually I found the best way to do merges with code movement patches
is to edit the patches itself if possible.

Maybe some day we'll get patch like tools that can deal with this stuff
better.

Rusty: you should probably have cocci rules for this stuff, not manual
patches.

-Andi
