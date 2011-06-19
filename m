Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1FSPft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:35:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39293
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377Ab1FSPfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:35:37 -0400
Date: Sun, 19 Jun 2011 11:35:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110619153536.GB20424@infradead.org>
References: <20110619150108.691351746@intel.com>
 <20110619150510.484877943@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110619150510.484877943@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd rather see this earlier in the series, before the write bandwith
estimation ones, as it's groundwork independ of those changes.

> +		if (wrote) {
> +			if (jiffies - start_time > HZ / 10UL)
> +				break;
> +			if (work->nr_pages <= 0)
> +				break;
> +		}

This code probably wants some comments.

>  static void bdi_flush_io(struct backing_dev_info *bdi)
>  {
> -	struct writeback_control wbc = {
> -		.sync_mode		= WB_SYNC_NONE,
> -		.older_than_this	= NULL,
> -		.range_cyclic		= 1,
> -		.nr_to_write		= 1024,
> -	};
> -
> -	writeback_inodes_wb(&bdi->wb, &wbc);
> +	writeback_inodes_wb(&bdi->wb, 1024);
>  }

At this point you could probably also kill the bdi_flush_io wrapper, and
just call writeback_inodes_wb directly.  A comment on the 1024 pages to
write would be nice, if you remember it from poking the code.  I can't
find any good explanation for it offhand.

