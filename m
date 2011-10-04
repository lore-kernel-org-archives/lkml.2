Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab1JDTxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:53:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910Ab1JDTxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:53:07 -0400
Date: Tue, 4 Oct 2011 15:52:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] IO-less dirty throttling v12
Message-ID: <20111004195206.GG28306@redhat.com>
References: <20111003134228.090592370@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003134228.090592370@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:42:28PM +0800, Wu Fengguang wrote:
> Hi,
> 
> This is the minimal IO-less balance_dirty_pages() changes that are expected to
> be regression free (well, except for NFS).
> 
>         git://github.com/fengguang/linux.git dirty-throttling-v12
> 
> Tests results will be posted in a separate email.

Looks like we are solving two problems.

- IO less balance_dirty_pages()
- Throttling based on ratelimit instead of based on number of dirty pages.

The second piece is the one which has complicated calculations for
calculating the global/bdi rates and logic for stablizing the rates etc.

IIUC, second piece is primarily needed for better latencies for writers.

Will it make sense to break down this work in two patch series. First
push IO less balance dirty pages and then all the complicated pieces
of ratelimits.

ratelimit allowed you to come up with sleep time for the process. Without
that I think you shall have to fall back to what Jan Kar had done, 
calculation based on number of pages.

Thanks
Vivek
