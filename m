Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1FGXEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:04:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522Ab1FGXEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:04:23 -0400
Date: Tue, 7 Jun 2011 16:03:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@csn.ul.ie>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/15] writeback: introduce
 writeback_control.inodes_cleaned
Message-Id: <20110607160313.86fb31df.akpm@linux-foundation.org>
In-Reply-To: <20110607213853.757201783@intel.com>
References: <20110607213236.634026193@intel.com>
	<20110607213853.757201783@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jun 2011 05:32:39 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> The flusher works on dirty inodes in batches, and may quit prematurely
> if the batch of inodes happen to be metadata-only dirtied: in this case
> wbc->nr_to_write won't be decreased at all, which stands for "no pages
> written" but also mis-interpreted as "no progress".
> 
> So introduce writeback_control.inodes_cleaned to count the inodes get
> cleaned.  A non-zero value means there are some progress on writeback,
> in which case more writeback can be tried.

Yes, that makes sense.  I had a workload which demonstrated/exploited
this nine years ago but I never got around to fixing it, never told
anyone and nobody noticed ;)

> +	long inodes_cleaned;		/* # of inodes cleaned */

nanonit: I'd call this inodes_written, because they may not actually be
clean.
