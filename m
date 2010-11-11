Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab0KKAqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:46:55 -0500
Received: from ozlabs.org ([203.10.76.45]:59326 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757318Ab0KKAqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:46:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6.37-rc1, OOM] virtblk: OOM in do_virtblk_request()
Date: Thu, 11 Nov 2010 11:16:48 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic-pae; KDE/4.5.1; i686; ; )
Cc: Dave Chinner <david@fromorbit.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org
References: <20101105013003.GE13830@dastard> <20101110133151.GB2101@infradead.org>
In-Reply-To: <20101110133151.GB2101@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011111116.48263.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010 12:01:51 am Christoph Hellwig wrote:
> Rusty, Michael,
> 
> any comments?  I think Dave's observation is correct, and the lack of
> a mempool for allocations in the virtio stack is a no-go for virtio_blk.

Interesting.  virtio will try to fall back to using direct ring entries
if it can, but if course if your request is too large it can never do that.

So, we could add a memory pool, or restrict the request size in virtio_blk.

Any other thoughts?
Rusty.
