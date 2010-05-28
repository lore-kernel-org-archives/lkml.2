Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0E1HpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:45:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49587 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab0E1HpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:45:06 -0400
Date: Fri, 28 May 2010 03:45:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, tytso@mit.edu, jens.axboe@oracle.com
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Message-ID: <20100528074500.GA14151@infradead.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com> <1274784852-30502-2-git-send-email-david@fromorbit.com> <20100527143233.836b2c47.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527143233.836b2c47.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 02:32:33PM -0700, Andrew Morton wrote:
> > +#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
> 
> Could/should be implemented in C.
> 
> > +/*
> > + * We don't actually have pdflush, but this one is exported though /proc...
> > + */
> > +int nr_pdflush_threads;
> 
> So this is always zero now?
> 
> We don't want to keep it forever.  Add a
> printk_once("nr_pdflush_threads is deprecated") when someone reads it,
> remove it in 2014.

These two lines are just moved down a bit by the patch, I think any
cleanups should be left to separate patches.

