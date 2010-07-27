Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0G0UVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 16:21:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0G0UVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 16:21:40 -0400
Date: Tue, 27 Jul 2010 16:21:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] bdi: Use parent filesystem BDI for inodes not
 capable of writeback
Message-ID: <20100727202129.GA28641@infradead.org>
References: <1280250301-17603-1-git-send-email-jack@suse.cz>
 <1280250301-17603-2-git-send-email-jack@suse.cz>
 <20100727170903.GA9034@infradead.org>
 <20100727172437.GE6820@quack.suse.cz>
 <20100727172731.GA25727@infradead.org>
 <20100727180131.GG6820@quack.suse.cz>
 <20100727201207.GA16335@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727201207.GA16335@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 04:12:07PM -0400, Christoph Hellwig wrote:
> On Tue, Jul 27, 2010 at 08:01:31PM +0200, Jan Kara wrote:
> > > It shouldn't.  Block device nodes are on the bdev filesystems, and
> >   Ok, so inode->i_sb->s_bdi will actually point to noop_backing_dev_info
> > as set by set_anon_super(). Or am I completely out?
> 
> I think you're right.  This seems rather bad if it's indeed true. I'll
> quickly verify it using Dave's new tracing once I've built a block
> tree kernel.

Indeed it does.  So using ->s_bdi actually is wrong for the block
device node, given that it does set up the bdevfs inode's 
backing_dev_info to the proper one, but can't actually do it for
the per-sb one.
