Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab2K0Vjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:39:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:25242 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab2K0Vjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:39:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,174,1355126400"; 
   d="scan'208";a="223260400"
Date: Tue, 27 Nov 2012 16:39:43 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Laine Walker-Avina <lwalkera@ieee.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, lwalkera@micron.com
Subject: Re: Alignment Issue with Direct IO to NVMe Drive
Message-ID: <20121127213943.GB5100@linux.intel.com>
References: <CAMi7pMamJK079wQs+5Kaz=zdYGAPS+BFg2xCRKJMqPFMrQvQPQ@mail.gmail.com>
 <50B4AD8A.7020208@kernel.dk>
 <20121127170509.GA5100@linux.intel.com>
 <CAMi7pMb7Ln02hLfa_i-7ucWZBDGzQLUOoQTeFp70=yGix_gojA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMi7pMb7Ln02hLfa_i-7ucWZBDGzQLUOoQTeFp70=yGix_gojA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 09:47:48AM -0800, Laine Walker-Avina wrote:
> On Tue, Nov 27, 2012 at 9:05 AM, Matthew Wilcox <willy@linux.intel.com> wrote:
> > Laine, when this occurs, what is the alignment of 'offset' in the sg
> > entry you're looking at?  If userspace is passing in an unaligned address,
> > I don't think there's anything we do to try to align it.
> 
> I thought this was the case as well, but it appears to be aligned
> looking at the request in the user space program (fio using libaio in
> this case) before the IO is submitted.

OK, so we have an aligned virtual address being translated into an
unaligned DMA address.  I have a suspicion ... are you using the swiotlb,
or are you using a real IOMMU?  Grep dmesg for 'IOMMU' if you're not sure.
