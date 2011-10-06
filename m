Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433Ab1JFNxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:53:12 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:43279
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1JFNxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:53:11 -0400
Date: Thu, 6 Oct 2011 15:53:09 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] virtio-blk: implement ->make_request
Message-ID: <20111006135309.GA27941@kernel.dk>
References: <20111005195403.407628164@bombadil.infradead.org>
 <20111005195530.558142038@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005195530.558142038@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05 2011, Christoph Hellwig wrote:
> Add an alternate I/O path that implements ->make_request for virtio-blk.
> This is required for high IOPs devices which get slowed down to 1/5th of
> the native speed by all the locking, memory allocation and other overhead
> in the request based I/O path.

We definitely have some performance fruit hanging rather low in that
path, but a factor 5 performance difference sounds insanely excessive. I
haven't looked at virtio_blk in detail, but I've done 500K+ IOPS on
request based drivers before (yes, on real hardware). So it could be
that virtio_blk is just doing things rather suboptimally in some places,
and that it would be possible to claim most of that speedup there too.

-- 
Jens Axboe

