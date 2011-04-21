Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1DUFuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 01:50:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:50050 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab1DUFug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 01:50:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,249,1301900400"; 
   d="scan'208";a="631887523"
Date: Thu, 21 Apr 2011 13:50:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
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
Message-ID: <20110421055031.GA23711@localhost>
References: <20110419030003.108796967@intel.com>
 <20110421043449.GA22423@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421043449.GA22423@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, Apr 21, 2011 at 12:34:50PM +0800, Christoph Hellwig wrote:
> Hi Wu,
> 
> if you're queueing up writeback changes can you look into splitting
> inode_wb_list_lock as it was done in earlier versions of the inode
> scalability patches?  Especially if we don't get the I/O less
> balance_dirty_pages in ASAP it'll at least allows us to scale the
> busy waiting for the list manipulationes to one CPU per BDI.

Do you mean to split inode_wb_list_lock into struct bdi_writeback? 
So as to improve at least the JBOD case now and hopefully benefit the
1-bdi case when switching to multiple bdi_writeback per bdi in future?

I've not touched any locking code before, but it looks like some dumb
code replacement. Let me try it :)

Thanks,
Fengguang
