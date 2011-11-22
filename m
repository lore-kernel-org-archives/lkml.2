Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1KVNmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:42:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:21116 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1KVNmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:42:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,552,1315206000"; 
   d="scan'208";a="77957161"
Date: Tue, 22 Nov 2011 21:41:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: fix dirtied pages accounting on
 sub-page writes
Message-ID: <20111122134155.GA23599@localhost>
References: <20111121130342.211953629@intel.com>
 <20111121131215.905222115@intel.com>
 <20111122001127.GG4017@quack.suse.cz>
 <20111122092110.GB12864@localhost>
 <20111122122157.GB8058@quack.suse.cz>
 <1321966662.5148.35.camel@twins>
 <20111122130750.GA19929@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122130750.GA19929@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 09:07:50PM +0800, Wu Fengguang wrote:
> On Tue, Nov 22, 2011 at 08:57:42PM +0800, Peter Zijlstra wrote:
> > On Tue, 2011-11-22 at 13:21 +0100, Jan Kara wrote:
> > > > +             __get_cpu_var(bdp_ratelimits)++;
> > >   I think you need preempt_disable() and preempt_enable() pair around
> > > __get_cpu_var(). Otherwise a process could get rescheduled in the middle of
> > > read-modify-write cycle... 
> > 
> > there's of course the this_cpu_inc(bdp_ratelimits); thing.
> > 
> > On x86 that'll turn into a single insn, on others it will add the
> > required preempt_disable/enable bits.
> 
> It's good to know that. But what if we don't really care which CPU
> data it's increasing, and can accept losing some increases due to the
> resulted race condition?

I just added a comment for it, hope it helps :)

                /*
                 * This is racy, however bdp_ratelimits merely serves as a
                 * gross safeguard. We don't really care the exact CPU it's
                 * charging to and the resulted inaccuracy is acceptable.
                 */
                __get_cpu_var(bdp_ratelimits)++;

Thanks,
Fengguang
