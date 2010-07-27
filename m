Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0G0Oeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:34:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:64850 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0G0Oet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:34:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,268,1278313200"; 
   d="scan'208";a="304896952"
Date: Tue, 27 Jul 2010 22:34:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 8/8] vmscan: Kick flusher threads to clean pages when
 reclaim is encountering dirty pages
Message-ID: <20100727143423.GA5057@localhost>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
 <1279545090-19169-9-git-send-email-mel@csn.ul.ie>
 <20100726072832.GB13076@localhost>
 <20100726092616.GG5300@csn.ul.ie>
 <20100726112709.GB6284@localhost>
 <20100726125717.GS5300@csn.ul.ie>
 <20100726131008.GE11947@localhost>
 <20100727133513.GZ5300@csn.ul.ie>
 <20100727142412.GA4771@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727142412.GA4771@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you plan to keep wakeup_flusher_threads(), a simpler form may be
> sufficient, eg.
> 
>         laptop_mode ? 0 : (nr_dirty * 16)

This number is not sensitive because the writeback code may well round
it up to some more IO efficient value (currently 4MB). AFAIK the
nr_pages parameters passed by all existing flusher callers are some
rule-of-thumb value, and far from being an exact number.

Thanks,
Fengguang
