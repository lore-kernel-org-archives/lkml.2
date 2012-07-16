Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2GPL60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 07:58:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59124 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2GPL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 07:58:23 -0400
MIME-Version: 1.0
In-Reply-To: <1342107302-28116-1-git-send-email-asias@redhat.com>
References: <1342107302-28116-1-git-send-email-asias@redhat.com>
Date: Mon, 16 Jul 2012 12:58:21 +0100
Message-ID: <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add vhost-blk support
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 4:35 PM, Asias He <asias@redhat.com> wrote:
> This patchset adds vhost-blk support. vhost-blk is a in kernel virito-blk
> device accelerator. Compared to userspace virtio-blk implementation, vhost-blk
> gives about 5% to 15% performance improvement.

Why is it 5-15% faster?  vhost-blk and the userspace virtio-blk you
benchmarked should be doing basically the same thing:

1. An eventfd file descriptor is signalled when the vring has new
requests available from the guest.
2. A thread wakes up and processes the virtqueue.
3. Linux AIO is used to issue host I/O.
4. An interrupt is injected into the guest.

Does the vhost-blk implementation do anything fundamentally different
from userspace?  Where is the overhead that userspace virtio-blk has?

I'm asking because it would be beneficial to fix the overhead
(especially it that could speed up all userspace applications) instead
of adding a special-purpose kernel module to work around the overhead.

Stefan
