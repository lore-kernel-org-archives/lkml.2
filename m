Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2EHLxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:53:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab2EHLxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:53:07 -0400
Date: Tue, 8 May 2012 14:53:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH untested] virtio: allocate extra memory before the ring (
 was Re: [RFC PATCH] virtio_console: link vq to port with a private) pointer
 in struct virtqueue
Message-ID: <20120508115305.GA16901@redhat.com>
References: <20120508105654.GB15598@redhat.com>
 <7dee31a0-7b89-418c-a69b-436729ba55b0@zmail13.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dee31a0-7b89-418c-a69b-436729ba55b0@zmail13.collab.prod.int.phx2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 07:06:04AM -0400, Paolo Bonzini wrote:
> > And it's not a problem if virtqueue is exactly at start of
> > vring_virtqueue: we just need to allocate a bit more at start, and
> > offset when we free.  Here's how I would do this: first apply patch
> > below that adds the offset parameter, then update all transports, one
> > patch at a time to not use priv pointer, finally you can repurpose
> > priv pointer to let devices use it.
> 
> I like it, though I prefer to have the new arguments as sizeof()
> rather than offsets.

Well it tells us both how much extra memory
to allocate and where in the allocated buffer to put
struct virtqueue.

So size is kind of vague, offset is a more specific name.


> I'll pick up this and test it.

BTW still somewhat unhappy that the specific layout requirements make it a
bit fragile, even though I added BUG_ONs to at least fail in an obvious
way if we break the rules. But I wonder whether Rusty has a better idea.


> > As a bonus we get small incremental patches.
> 
> FWIW, that's possible with the patch I posted too.
> 
> Paolo
