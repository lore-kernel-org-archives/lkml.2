Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab0HAKoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 06:44:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:53249 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab0HAKop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 06:44:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,297,1278313200"; 
   d="scan'208";a="643682786"
Date: Sun, 1 Aug 2010 18:42:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: [PATCH] vmscan: synchronous lumpy reclaim don't call
 congestion_wait()
Message-ID: <20100801104232.GA17573@localhost>
References: <20100801085134.GA15577@localhost>
 <20100801180751.4B0E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801180751.4B0E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the system 512MB memory, DEF_PRIORITY mean 128kB scan and It takes 4096
> shrink_page_list() calls to scan 128kB (i.e. 128kB/32=4096) memory.

Err you must forgot the page size.

128kB means 128kB/4kB=32 pages which fit exactly into one
SWAP_CLUSTER_MAX batch. The shrink_page_list() call times
has nothing to do DEF_PRIORITY.

Thanks,
Fengguang
