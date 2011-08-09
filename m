Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1HIQUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:20:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:46139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab1HIQT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:19:58 -0400
Subject: Re: [PATCH 3/5] writeback: dirty rate control
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 09 Aug 2011 18:19:32 +0200
In-Reply-To: <1312906591.1083.43.camel@twins>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.878435971@intel.com> <20110809155046.GD6482@redhat.com>
	 <1312906591.1083.43.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312906772.1083.45.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 18:16 +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-09 at 11:50 -0400, Vivek Goyal wrote:
> > 
> > So IIUC, bdi->dirty_ratelimit is the dynmically adjusted desired rate
> > limit (based on postion ratio, dirty_bw and write_bw). But this seems
> > to be overall bdi limit and does not seem to take into account the
> > number of tasks doing IO to that bdi (as your comment suggests). So
> > it probably will track write_bw as opposed to write_bw/N. What am
> > I missing? 
> 
> I think the per task thing comes from him using the pages_dirtied
> argument to balance_dirty_pages() to compute the sleep time. Although
> I'm not quite sure how he keeps fairness in light of the sleep time
> bounding to MAX_PAUSE.

Furthermore, there's of course the issue that current->nr_dirtied is
computed over all BDIs it dirtied pages from, and the sleep time is
computed for the BDI it happened to do the overflowing write on.

Assuming an task (mostly) writes to a single bdi, or equally to all, it
should all work out.


