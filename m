Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab0HJSLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:11:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:34689 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757755Ab0HJSLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:11:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,349,1278313200"; 
   d="scan'208";a="646255157"
Date: Wed, 11 Aug 2010 02:06:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 07/13] writeback: explicit low bound for vm.dirty_ratio
Message-ID: <20100810180625.GA4887@localhost>
References: <20100805163401.e9754032.akpm@linux-foundation.org>
 <20100806124452.GC4717@localhost>
 <20100809235652.7113.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809235652.7113.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 11:12:06AM +0800, KOSAKI Motohiro wrote:
> > Subject: writeback: explicit low bound for vm.dirty_ratio
> > From: Wu Fengguang <fengguang.wu@intel.com>
> > Date: Thu Jul 15 10:28:57 CST 2010
> > 
> > Force a user visible low bound of 5% for the vm.dirty_ratio interface.
> > 
> > This is an interface change. When doing
> > 
> > 	echo N > /proc/sys/vm/dirty_ratio
> > 
> > where N < 5, the old behavior is pretend to accept the value, while
> > the new behavior is to reject it explicitly with -EINVAL.  This will
> > possibly break user space if they checks the return value.
> 
> Umm.. I dislike this change. Is there any good reason to refuse explicit 
> admin's will? Why 1-4% is so bad? Internal clipping can be changed later
> but explicit error behavior is hard to change later.
> 
> personally I prefer to
>  - accept all value, or
>  - clipping value in dirty_ratio_handler 
> 
> Both don't have explicit ABI change.

Good point. Sorry for being ignorance. Neil is right that there is no
reason to impose some low bound. So the first option looks good.

Thanks,
Fengguang
