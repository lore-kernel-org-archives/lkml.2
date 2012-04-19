Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2DSGVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:21:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab2DSGVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:21:24 -0400
Date: Thu, 19 Apr 2012 11:51:16 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private
 pointer in struct virtqueue
Message-ID: <20120419061958.GA9980@amit.redhat.com>
References: <1334756013-11752-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334756013-11752-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 18 Apr 2012 [15:33:33], Paolo Bonzini wrote:
> For virtio-scsi multiqueue support I would like to have an easy and
> fast way to go from a virtqueue to the internal struct for that
> queue.
> 
> It turns out that virtio-serial has the same need, but it gets
> by with a simple list walk.
> 
> This patch adds a pointer to struct virtqueue that is reserved for
> the virtio device, and uses it in virtio-serial.
> 
> Cc: Amit Shah <amit.shah@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	Untested; what do you think?  Would this patch be acceptable
> 	as is, or only with a more pressing need in virtio-scsi, or never?

Yes, this is useful.  Saves taking a spin lock and walking the list
each time any data is received from the host.

Acked-by: Amit Shah <amit.shah@redhat.com>

Thanks,

		Amit
