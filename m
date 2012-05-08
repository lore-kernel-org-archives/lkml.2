Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab2EHEEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:04:38 -0400
Received: from ozlabs.org ([203.10.76.45]:34973 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab2EHEEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:04:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private pointer in struct virtqueue
In-Reply-To: <1334756013-11752-1-git-send-email-pbonzini@redhat.com>
References: <1334756013-11752-1-git-send-email-pbonzini@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 08 May 2012 11:41:55 +0930
Message-ID: <87397be80k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012 15:33:33 +0200, Paolo Bonzini <pbonzini@redhat.com> wrote:
> For virtio-scsi multiqueue support I would like to have an easy and
> fast way to go from a virtqueue to the internal struct for that
> queue.
> 
> It turns out that virtio-serial has the same need, but it gets
> by with a simple list walk.
> 
> This patch adds a pointer to struct virtqueue that is reserved for
> the virtio device, and uses it in virtio-serial.

I ike the concept, but share Michael's concern with naming confusion.

How bad would be it to get rid of the current ->priv and use
container_of() instead?  ie. have virtio_pci, virtio_mmio, lguest_bus
and s390's kvm_virtio embed the struct virtqueue?

Thanks,
Rusty.
