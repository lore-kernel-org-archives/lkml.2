Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab1HGGpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 02:45:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:63555 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1HGGpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 02:45:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,332,1309762800"; 
   d="scan'208";a="35914865"
Date: Sun, 7 Aug 2011 14:44:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrea Righi <arighi@develer.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] writeback: IO-less balance_dirty_pages()
Message-ID: <20110807064459.GB3287@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094527.136636891@intel.com>
 <20110806144834.GA29243@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110806144834.GA29243@thinkpad>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +             bw = (u64)base_bw * bw >> BANDWIDTH_CALC_SHIFT;
> > +             pause = (HZ * pages_dirtied + bw / 2) / (bw | 1);
> > +             pause = min(pause, MAX_PAUSE);
> 
> Fix this build warning:
> 
>  mm/page-writeback.c: In function ‘balance_dirty_pages’:
>  mm/page-writeback.c:889:11: warning: comparison of distinct pointer types lacks a cast

Thanks! I'll fix it by changing `pause' to "long", since we'll have
negative pause time anyway when considering think time compensation.

Thanks,
Fengguang
