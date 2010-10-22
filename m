Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0JVI3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:29:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0JVI3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:29:33 -0400
Date: Fri, 22 Oct 2010 04:29:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: Re: linux-next regression: IO errors in with ext4 and xen-blkfront
Message-ID: <20101022082916.GA14070@infradead.org>
References: <4CBF83A0.8090802@goop.org>
 <4CBF84C9.6050606@goop.org>
 <4CC148E5.2030605@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC148E5.2030605@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the barriers tree Xen claims to support flushes, but I doesn't.
It never handles REQ_FLUSH requests.  Try commenting out the

	blk_queue_flush(info->rq, info->feature_flush);

call and things should improve.  I still need to hear back from Xen
folks how to actually implement a cache flush - they only implement
a barrier write privilegue which could never implement an empty
cache flush.  Up to current kernels that meant it would implement
barrier writes with content correctly and silently ignore empty barriers
leading to very interesting data integrity bugs.  From 2.6.37 onwards
it simply won't work anymore at all, which is at least consistent
(modulo the bug of actually claiming to support flushes).

