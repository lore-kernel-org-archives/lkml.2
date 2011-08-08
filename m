Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1HHXdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:33:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:4261 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab1HHXc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:32:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,340,1309762800"; 
   d="scan'208";a="36464216"
Date: Tue, 9 Aug 2011 07:32:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] writeback: per task dirty rate limit
Message-ID: <20110808233254.GA15932@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094527.002914580@intel.com>
 <1312811234.10488.34.camel@twins>
 <20110808142123.GB22080@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110808142123.GB22080@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- linux-next.orig/kernel/fork.c	2011-08-08 22:11:59.000000000 +0800
> +++ linux-next/kernel/fork.c	2011-08-08 22:18:05.000000000 +0800
> @@ -1301,6 +1301,9 @@ static struct task_struct *copy_process(
>  	p->pdeath_signal = 0;
>  	p->exit_state = 0;
>  
> +	p->nr_dirtied = 0;
> +	p->nr_dirtied_pause = 8;

Hmm, it looks better to allow a new task to dirty 128KB without being
throttled, if the system is not in dirty exceeded state. So changed
the last line to this:

+	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);

Thanks,
Fengguang
