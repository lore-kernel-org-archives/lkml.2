Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2AaMaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:30:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:60629 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab2AaMaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:30:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101502311"
Date: Tue, 31 Jan 2012 20:20:39 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Herbert Poetzl <herbert@13thfloor.at>,
        Eric Dumazet <eric.dumazet@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] fix readahead pipeline break caused by block plug
Message-ID: <20120131122039.GA12706@localhost>
References: <1327996780.21268.42.camel@sli10-conroe>
 <20120131103416.GA1661@localhost>
 <20120131104621.GA27003@infradead.org>
 <20120131105754.GA3867@localhost>
 <20120131113452.GA3235@infradead.org>
 <20120131114256.GA8796@localhost>
 <20120131115716.GA19829@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131115716.GA19829@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 06:57:16AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 31, 2012 at 07:42:56PM +0800, Wu Fengguang wrote:
> > > So what?  Better do a bit more work now and keep the damn thing
> > > maintainable.
> > 
> > What if we add a wrapper function for doing
> > 
> >         blk_start_plug(&plug);
> >         ->direct_IO()
> >         blk_finish_plug(&plug);
> 
> No.  Just put it into __blockdev_direct_IO - a quick 2 minute audit of
> the kernel source shows that is in fact the only ->direct_IO instance
> which ever submits block I/O anyway.

Right, so nice point!

Thanks,
Fengguang
