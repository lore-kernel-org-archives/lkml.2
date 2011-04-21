Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1DUF4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 01:56:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45905 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab1DUF4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 01:56:45 -0400
Date: Thu, 21 Apr 2011 01:56:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 0/6] writeback: moving expire targets for
 background/kupdate works
Message-ID: <20110421055634.GA26187@infradead.org>
References: <20110419030003.108796967@intel.com>
 <20110421043449.GA22423@infradead.org>
 <20110421055031.GA23711@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421055031.GA23711@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 01:50:31PM +0800, Wu Fengguang wrote:
> Hi Christoph,
> 
> On Thu, Apr 21, 2011 at 12:34:50PM +0800, Christoph Hellwig wrote:
> > Hi Wu,
> > 
> > if you're queueing up writeback changes can you look into splitting
> > inode_wb_list_lock as it was done in earlier versions of the inode
> > scalability patches?  Especially if we don't get the I/O less
> > balance_dirty_pages in ASAP it'll at least allows us to scale the
> > busy waiting for the list manipulationes to one CPU per BDI.
> 
> Do you mean to split inode_wb_list_lock into struct bdi_writeback? 
> So as to improve at least the JBOD case now and hopefully benefit the
> 1-bdi case when switching to multiple bdi_writeback per bdi in future?
> 
> I've not touched any locking code before, but it looks like some dumb
> code replacement. Let me try it :)

I can do the patch if you want, it would be useful to carry it in your
series to avoid conflicts, though.

