Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0GZDMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 23:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab0GZDMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 23:12:37 -0400
Message-ID: <4C4CFCE9.8070303@redhat.com>
Date: Sun, 25 Jul 2010 23:11:37 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 7/8] writeback: sync old inodes first in background writeback
References: <20100723094515.GD5043@localhost> <20100723105719.GE5300@csn.ul.ie> <20100725192955.40D5.A69D9226@jp.fujitsu.com> <20100726030813.GA7668@localhost>
In-Reply-To: <20100726030813.GA7668@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2010 11:08 PM, Wu Fengguang wrote:

> We do need some throttling under memory pressure. However stall time
> more than 1s is not acceptable. A simple congestion_wait() may be
> better, since it waits on _any_ IO completion (which will likely
> release a set of PG_reclaim pages) rather than one specific IO
> completion. This makes much smoother stall time.
> wait_on_page_writeback() shall really be the last resort.
> DEF_PRIORITY/3 means 1/16=6.25%, which is closer.

I agree with the max 1 second stall time, but 6.25% of
memory could be an awful lot of pages to scan on a system
with 1TB of memory :)

Not sure what the best approach is, just pointing out
that DEF_PRIORITY/3 may be too much for large systems...

-- 
All rights reversed
