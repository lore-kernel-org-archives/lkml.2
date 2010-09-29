Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab0I2X5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 19:57:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32773 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0I2X5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 19:57:18 -0400
Date: Wed, 29 Sep 2010 19:57:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/17] fs: Inode cache scalability
Message-ID: <20100929235716.GA18423@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:18:32PM +1000, Dave Chinner wrote:
> I've only ported the patches so far, without changing anything
> significant other than the comit descriptions. One thing that has
> stood out as I've done this is that the ordering of the patches is
> not ideal, and some things (like the inode counters) are modified
> multiple times through the patch set.  I'm quite happy to
> reorder/rework the series to fix these problems if that is desired.

There's two obvious ordering issues: first the inode counters that you
mentioned.  I think this is esialy fixed by simply dropping both batches
messing with it - we should have the new locks protecting it in places once
inode_lock is dropped.  The other one is the clean up inode reference
counting patch, which sounds like it should be earlier in the series so
that we have the helpers in place before touching all places that
opencode an inode reference count increment.

Thanks forpicking up the work on this while Nick is travelling and some
more comments on the individual patches will follow.

