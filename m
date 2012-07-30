Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2G3Nvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:51:43 -0400
Received: from verein.lst.de ([213.95.11.211]:49782 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305Ab2G3NvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:51:16 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2012 09:51:16 EDT
Date: Mon, 30 Jul 2012 15:42:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH V4 3/3] virtio-blk: Add bio-based IO path for virtio-blk
Message-ID: <20120730134247.GA6041@lst.de>
References: <1343442065-15646-1-git-send-email-asias@redhat.com> <1343442065-15646-4-git-send-email-asias@redhat.com> <20120729111115.GD8977@redhat.com> <87a9yim2qg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9yim2qg.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 11:25:51AM +0930, Rusty Russell wrote:
> I consider this approach a half-way step.  Quick attempts on my laptop
> and I couldn't find a case where the bio path was a loss, but in theory
> if the host wasn't doing any reordering and it was a slow device, you'd
> want the guest to do so.
> 
> I'm not sure if current qemu can be configured to do such a thing?


The host kernel will do the I/O scheduling for you unless you explicitly
disable it.  And we should be able to assume an administrator will only
disable it when they have a reason for it - if not they'll get worse
performance for non-virtualized workloads as well.

