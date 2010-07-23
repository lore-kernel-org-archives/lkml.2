Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921Ab0GWQ3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:29:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0GWQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:29:20 -0400
Date: Fri, 23 Jul 2010 12:29:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 14/14] writeback: add new tracepoints
Message-ID: <20100723162919.GD29633@infradead.org>
References: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
 <1279897554-1526-15-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279897554-1526-15-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 06:05:54PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> Add 2 new trace points to the periodic write-back wake up case, just like we do
> in the 'bdi_queue_work()' function. Namely, introduce:
> 
> 1. trace_writeback_wakeup(bdi)
> 2. trace_writeback_wakeup_nothread(bdi)
> 
> The first event is triggered every time we wake up a bdi thread to start
> periodic background write-out. The second event is triggered only when the bdi
> thread does not exist and should be created by the forker thread.
> 
> This patch was suggested by Dave Chinner <david@fromorbit.com>

As mentioned before doing the wakeup just for the case where we
really wake up the flusher thead is much better.  It's not 100%
clear for bdi_queue_work as we queue the work in either case, but
I'd prefer to fix that one up as well (not in your series anyway)

