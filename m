Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2AaLIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:08:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:49771 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab2AaLID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:08:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101482299"
Date: Tue, 31 Jan 2012 18:57:54 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Herbert Poetzl <herbert@13thfloor.at>,
        Eric Dumazet <eric.dumazet@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] fix readahead pipeline break caused by block plug
Message-ID: <20120131105754.GA3867@localhost>
References: <1327996780.21268.42.camel@sli10-conroe>
 <20120131103416.GA1661@localhost>
 <20120131104621.GA27003@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131104621.GA27003@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 05:46:21AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 31, 2012 at 06:34:16PM +0800, Wu Fengguang wrote:
> >  	}
> >  
> > +	blk_start_plug(&plug);
> >  	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
> > +	blk_finish_plug(&plug);
> 
> Please move the plugging into ->direct_IO for both read and write, as
> that is the boundary between generic highlevel code, and low-level block
> code that should know about plugs.

The problem is, there are a dozen of ->direct_IO callback functions.
While there are only two ->direct_IO() callers, one for READ and
another for WRITE, which are much easier to deal with.

Thanks,
Fengguang
