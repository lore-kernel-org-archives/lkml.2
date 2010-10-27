Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791Ab0J0KX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:23:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab0J0KXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:23:25 -0400
Date: Wed, 27 Oct 2010 06:23:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Stodden <daniel.stodden@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: linux-next regression: IO errors in with ext4
 and xen-blkfront
Message-ID: <20101027102309.GA1618@infradead.org>
References: <4CBF83A0.8090802@goop.org>
 <4CBF84C9.6050606@goop.org>
 <4CC148E5.2030605@kernel.dk>
 <20101022082916.GA14070@infradead.org>
 <20101025182630.GA6036@dumpdata.com>
 <20101025184756.GA26230@infradead.org>
 <20101025190510.GA6452@dumpdata.com>
 <1288097346.2221.328.camel@ramone>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288097346.2221.328.camel@ramone>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm really not interested in getting into this flamewar again.

If you want to make Xen blockdevices work reliably you need to implement
a cache flush primitive in the driver.  If your cache flush primitive
also enforced ordering that's fine for data integrity, but won't help
your performance.

Note that current the _driver_ does not implement the cache flushes
correctly which is what started this thread and the previous flamewar.
If you can fix it using the existing primitive with just driver changes
that's fine - but according to
http://mail-index.netbsd.org/port-xen/2010/09/24/msg006274.html at least
the NetBSD people didn't think so.

For details on the implementation refer to the
Documentation/block/writeback_cache_control.txt file in the kernel tree,
for reasons why we got rid of barriers with their syncronization
semantics refer to various threads on -fsdevel and lkml during the past
couple of month (search your favour archive for barriers).

