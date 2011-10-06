Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935676Ab1JFF2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 01:28:30 -0400
Received: from ozlabs.org ([203.10.76.45]:60348 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935035Ab1JFF2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 01:28:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] virtio-blk: implement ->make_request
In-Reply-To: <20111005195530.558142038@bombadil.infradead.org>
References: <20111005195403.407628164@bombadil.infradead.org> <20111005195530.558142038@bombadil.infradead.org>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 06 Oct 2011 12:22:14 +1030
Message-ID: <87obxuga41.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Oct 2011 15:54:08 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> Add an alternate I/O path that implements ->make_request for virtio-blk.
> This is required for high IOPs devices which get slowed down to 1/5th of
> the native speed by all the locking, memory allocation and other overhead
> in the request based I/O path.

Ouch.

I'd be tempted to just switch across to this, though I'd be interested
to see if the simple add_buf change I referred to before has some effect
by itself (I doubt it).

Also, though it's overkill I'd use standard list primitives rather than
open-coding a single linked list.

Thanks!
Rusty.
