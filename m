Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab0FDHv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:51:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab0FDHv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:51:27 -0400
Date: Fri, 4 Jun 2010 03:51:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [PATCH 3/6] writeback: Add tracing to write_cache_pages
Message-ID: <20100604075127.GA7317@infradead.org>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com> <1275609328-12514-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275609328-12514-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 09:55:25AM +1000, Dave Chinner wrote:
> Add a trace event to the ->writepage loop in write_cache_pages to give
> visibility into how the ->writepage call is changing variables within the
> writeback control structure. Of most interest is how wbc->nr_to_write changes
> from call to call, especially with filesystems that write multiple pages
> in ->writepage.

Looks good, it might be worth to add another tracepoint for ->writepage
from reclaim context so that we can start investigating the cases where
that happens far too often.

Reviewed-by: Christoph Hellwig <hch@lst.de>
