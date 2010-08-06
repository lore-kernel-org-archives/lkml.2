Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761169Ab0HFKSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:18:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761160Ab0HFKSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:18:10 -0400
Subject: Re: [PATCH 03/13] writeback: add comment to the dirty limits
 functions
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
        Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20100805162433.105093335@intel.com>
References: <20100805161051.501816677@intel.com>
	 <20100805162433.105093335@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 06 Aug 2010 12:17:26 +0200
Message-ID: <1281089846.1947.411.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 00:10 +0800, Wu Fengguang wrote:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> +/**
> + * bdi_dirty_limit - @bdi's share of dirty throttling threshold
> + *
> + * Allocate high/low dirty limits to fast/slow devices, in order to prevent
> + * - starving fast devices
> + * - piling up dirty pages (that will take long time to sync) on slow devices
> + *
> + * The bdi's share of dirty limit will be adapting to its throughput and
> + * bounded by the bdi->min_ratio and/or bdi->max_ratio parameters, if set.
> + */ 

Another thing solved by the introduction of per-bdi dirty limits (and
now per-bdi flushing) is the whole stacked-bdi writeout deadlock.

Although I'm not sure we want/need to mention that here.
