Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2EHLGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:06:09 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:57487 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2EHLGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:06:08 -0400
Date: Tue, 08 May 2012 07:06:04 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH untested] virtio: allocate extra memory before the ring ( was Re: [RFC PATCH] virtio_console: link vq to port with a private) pointer in struct virtqueue
Message-ID: <7dee31a0-7b89-418c-a69b-436729ba55b0@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20120508105654.GB15598@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.36.112.23]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And it's not a problem if virtqueue is exactly at start of
> vring_virtqueue: we just need to allocate a bit more at start, and
> offset when we free.  Here's how I would do this: first apply patch
> below that adds the offset parameter, then update all transports, one
> patch at a time to not use priv pointer, finally you can repurpose
> priv pointer to let devices use it.

I like it, though I prefer to have the new arguments as sizeof()
rather than offsets.

I'll pick up this and test it.

> As a bonus we get small incremental patches.

FWIW, that's possible with the patch I posted too.

Paolo
