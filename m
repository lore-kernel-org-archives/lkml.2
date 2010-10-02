Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0JBQCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:02:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:41066 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab0JBQCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:02:20 -0400
Date: Sat, 2 Oct 2010 12:02:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] fs: Convert nr_inodes to a per-cpu counter
Message-ID: <20101002160210.GA30697@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-17-git-send-email-david@fromorbit.com>
 <20100929215322.ff635d3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929215322.ff635d3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:53:22PM -0700, Andrew Morton wrote:
> > +extern int get_nr_inodes(void);
> > +extern int get_nr_inodes_unused(void);
> 
> These are pretty cruddy names.  Unfotunately we don't really have a vfs
> or "inode" subsystem name to prefix them with.

We don't really need to export these anyway.  We have two callers for
each of them, and both are in the form of:


	/* approximate dirty inodes */
	nr_dirty_inodes = get_nr_inodes() - get_nr_inodes_unused();
	if (nr_dirty_inodes < 0)
		nr_dirty_inodes = 0;
	
which means we should just have a properly documented
get_nr_dirty_inodes() helper, the rest can stay private to inode.c

