Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0HJDN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 23:13:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40885 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab0HJDNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 23:13:52 -0400
Date: Tue, 10 Aug 2010 12:12:06 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 07/13] writeback: explicit low bound for vm.dirty_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20100806124452.GC4717@localhost>
References: <20100805163401.e9754032.akpm@linux-foundation.org> <20100806124452.GC4717@localhost>
Message-Id: <20100809235652.7113.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: writeback: explicit low bound for vm.dirty_ratio
> From: Wu Fengguang <fengguang.wu@intel.com>
> Date: Thu Jul 15 10:28:57 CST 2010
> 
> Force a user visible low bound of 5% for the vm.dirty_ratio interface.
> 
> This is an interface change. When doing
> 
> 	echo N > /proc/sys/vm/dirty_ratio
> 
> where N < 5, the old behavior is pretend to accept the value, while
> the new behavior is to reject it explicitly with -EINVAL.  This will
> possibly break user space if they checks the return value.

Umm.. I dislike this change. Is there any good reason to refuse explicit 
admin's will? Why 1-4% is so bad? Internal clipping can be changed later
but explicit error behavior is hard to change later.

personally I prefer to
 - accept all value, or
 - clipping value in dirty_ratio_handler 

Both don't have explicit ABI change.

Thanks.



