Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0HAKvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 06:51:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43214 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab0HAKvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 06:51:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] vmscan: synchronous lumpy reclaim don't call congestion_wait()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Andy Whitcroft <apw@shadowen.org>, Rik van Riel <riel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
In-Reply-To: <20100801104232.GA17573@localhost>
References: <20100801180751.4B0E.A69D9226@jp.fujitsu.com> <20100801104232.GA17573@localhost>
Message-Id: <20100801194520.4B14.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  1 Aug 2010 19:51:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If the system 512MB memory, DEF_PRIORITY mean 128kB scan and It takes 4096
> > shrink_page_list() calls to scan 128kB (i.e. 128kB/32=4096) memory.
> 
> Err you must forgot the page size.

page size? DEF_PRIORITY is 12.

512MB >> DEF_PRIORITY
 = 512MB / 4096
 = 128kB

128kB scan mean 4096 times shrink_list(). because one shrink_list() scan
SWAP_CLUSTER_MAX (i.e. 32).

> 
> 128kB means 128kB/4kB=32 pages which fit exactly into one
> SWAP_CLUSTER_MAX batch. The shrink_page_list() call times
> has nothing to do DEF_PRIORITY.

Umm.. I haven't catch this mention.

