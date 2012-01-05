Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab2AEBe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 20:34:57 -0500
Received: from ozlabs.org ([203.10.76.45]:52487 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2AEBey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 20:34:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Waychison <mikew@google.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH v1 1/2] virtio_net: Pass gfp flags when allocating rx buffers.
In-Reply-To: <20120104225231.18184.96390.stgit@mike2.sea.corp.google.com>
References: <20120104225223.18184.1537.stgit@mike2.sea.corp.google.com> <20120104225231.18184.96390.stgit@mike2.sea.corp.google.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 05 Jan 2012 10:40:02 +1030
Message-ID: <871urfc8md.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jan 2012 14:52:32 -0800, Mike Waychison <mikew@google.com> wrote:
> Currently, the refill path for RX buffers will always allocate the
> buffers as GFP_ATOMIC, even if we are in process context.  This will
> fail to apply memory pressure as the worker thread will not contribute
> to the freeing of memory.
> 
> Fix this by changing add_recvbuf_small to use the gfp variant allocator,
> __netdev_alloc_skb_ip_align().
> 
> Signed-off-by: Mike Waychison <mikew@google.com>

OK, this is a no-brainer.  Thanks!  Dave, can you pick this up?

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
