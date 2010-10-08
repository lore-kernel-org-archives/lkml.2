Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0JHHBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:01:11 -0400
Received: from canuck.infradead.org ([134.117.69.58]:44516 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0JHHBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:01:10 -0400
Date: Fri, 8 Oct 2010 03:01:08 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] fs: Convert nr_inodes and nr_unused to per-cpu
 counters
Message-ID: <20101008070108.GA23595@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:16PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The number of inodes allocated does not need to be tied to the
> addition or removal of an inode to/from a list. If we are not tied
> to a list lock, we could update the counters when inodes are
> initialised or destroyed, but to do that we need to convert the
> counters to be per-cpu (i.e. independent of a lock). This means that
> we have the freedom to change the list/locking implementation
> without needing to care about the counters.
> 
> Based on a patch originally from Eric Dumazet.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good except for a spurious whitespace change in inode_init_early.


Reviewed-by: Christoph Hellwig <hch@lst.de>

