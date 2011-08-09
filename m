Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1HIQRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:17:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39168 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1HIQQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:16:59 -0400
Subject: Re: [PATCH 3/5] writeback: dirty rate control
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 09 Aug 2011 18:16:30 +0200
In-Reply-To: <20110809155046.GD6482@redhat.com>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.878435971@intel.com> <20110809155046.GD6482@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312906591.1083.43.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 11:50 -0400, Vivek Goyal wrote:
> 
> So IIUC, bdi->dirty_ratelimit is the dynmically adjusted desired rate
> limit (based on postion ratio, dirty_bw and write_bw). But this seems
> to be overall bdi limit and does not seem to take into account the
> number of tasks doing IO to that bdi (as your comment suggests). So
> it probably will track write_bw as opposed to write_bw/N. What am
> I missing? 

I think the per task thing comes from him using the pages_dirtied
argument to balance_dirty_pages() to compute the sleep time. Although
I'm not quite sure how he keeps fairness in light of the sleep time
bounding to MAX_PAUSE.


