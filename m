Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2G3CNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 22:13:51 -0400
Received: from ozlabs.org ([203.10.76.45]:40955 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab2G3CNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 22:13:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH V4 3/3] virtio-blk: Add bio-based IO path for virtio-blk
In-Reply-To: <20120729111115.GD8977@redhat.com>
References: <1343442065-15646-1-git-send-email-asias@redhat.com> <1343442065-15646-4-git-send-email-asias@redhat.com> <20120729111115.GD8977@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 30 Jul 2012 11:25:51 +0930
Message-ID: <87a9yim2qg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2012 14:11:15 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Sat, Jul 28, 2012 at 10:21:05AM +0800, Asias He wrote:
> > This patch introduces bio-based IO path for virtio-blk.
> > 
> > Compared to request-based IO path, bio-based IO path uses driver
> > provided ->make_request_fn() method to bypasses the IO scheduler. It
> > handles the bio to device directly without allocating a request in block
> > layer. This reduces the IO path in guest kernel to achieve high IOPS
> > and lower latency. The downside is that guest can not use the IO
> > scheduler to merge and sort requests. However, this is not a big problem
> > if the backend disk in host side uses faster disk device.
> 
> If this optimization depends on the host, then it
> should be reported to the guest using a feature bit,
> as opposed to being guest driven.

I consider this approach a half-way step.  Quick attempts on my laptop
and I couldn't find a case where the bio path was a loss, but in theory
if the host wasn't doing any reordering and it was a slow device, you'd
want the guest to do so.

I'm not sure if current qemu can be configured to do such a thing?

Cheers,
Rusty.
