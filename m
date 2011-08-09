Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1HITQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab1HITQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:16:51 -0400
Date: Tue, 9 Aug 2011 15:16:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] writeback: IO-less balance_dirty_pages()
Message-ID: <20110809191622.GH6482@redhat.com>
References: <20110806084447.388624428@intel.com>
 <20110806094527.136636891@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806094527.136636891@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 04:44:52PM +0800, Wu Fengguang wrote:

[..]
> -/*
> - * task_dirty_limit - scale down dirty throttling threshold for one task
> - *
> - * task specific dirty limit:
> - *
> - *   dirty -= (dirty/8) * p_{t}
> - *
> - * To protect light/slow dirtying tasks from heavier/fast ones, we start
> - * throttling individual tasks before reaching the bdi dirty limit.
> - * Relatively low thresholds will be allocated to heavy dirtiers. So when
> - * dirty pages grow large, heavy dirtiers will be throttled first, which will
> - * effectively curb the growth of dirty pages. Light dirtiers with high enough
> - * dirty threshold may never get throttled.
> - */

Hi Fengguang,

So we have got rid of the notion of per task dirty limit based on their
fraction? What replaces it.

I can't see any code which is replacing it. If yes, I am wondering how
do you get fairness among tasks which share this bdi.

Also wondering what did this patch series to do make sure that tasks
share bdi more fairly and get write_bw/N bandwidth.

Thanks
Vivek
