Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2H2LVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 07:21:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab2H2LVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 07:21:39 -0400
Date: Wed, 29 Aug 2012 14:07:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
Message-ID: <20120829110748.GB5970@redhat.com>
References: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com>
 <1346159043-16446-2-git-send-email-levinsasha928@gmail.com>
 <20120828132032.GB2039@redhat.com>
 <503CC904.3050207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503CC904.3050207@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 03:35:00PM +0200, Sasha Levin wrote:
> On 08/28/2012 03:20 PM, Michael S. Tsirkin wrote:
> > On Tue, Aug 28, 2012 at 03:04:03PM +0200, Sasha Levin wrote:
> >> Currently if VIRTIO_RING_F_INDIRECT_DESC is enabled we will
> >> use indirect descriptors and allocate them using a simple
> >> kmalloc().
> >>
> >> This patch adds a cache which will allow indirect buffers under
> >> a configurable size to be allocated from that cache instead.
> >>
> >> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > 
> > I imagine this helps performance? Any numbers?
> 
> I ran benchmarks on the original RFC, I've re-tested it now and got similar
> numbers to the original ones (virtio-net using vhost-net, thresh=16):
> 
> Before:
> 	Recv   Send    Send
> 	Socket Socket  Message  Elapsed
> 	Size   Size    Size     Time     Throughput
> 	bytes  bytes   bytes    secs.    10^6bits/sec
> 
> 	 87380  16384  16384    10.00    4512.12
> 
> After:
> 	Recv   Send    Send
> 	Socket Socket  Message  Elapsed
> 	Size   Size    Size     Time     Throughput
> 	bytes  bytes   bytes    secs.    10^6bits/sec
> 
> 	 87380  16384  16384    10.00    5399.18
> 
> 
> Thanks,
> Sasha

This is with both patches 1 + 2?
Sorry could you please also test what happens if you apply
- just patch 1
- just patch 2

Thanks!
