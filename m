Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1GDHhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:37:55 -0400
Received: from ozlabs.org ([203.10.76.45]:54261 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab1GDHhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:37:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, dave@linux.vnet.ibm.com,
        Amit Shah <amit.shah@redhat.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] virtio_balloon: Notify guest only after deflating the balloon
In-Reply-To: <20110703121137.GA15826@redhat.com>
References: <1309576016-22800-1-git-send-email-levinsasha928@gmail.com> <20110703082748.GD13183@redhat.com> <1309686419.2250.8.camel@sasha> <20110703103051.GA15537@redhat.com> <1309690349.2250.21.camel@sasha> <20110703121137.GA15826@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 04 Jul 2011 17:07:12 +0930
Message-ID: <87boxasdhz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jul 2011 15:11:37 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Sun, Jul 03, 2011 at 01:52:29PM +0300, Sasha Levin wrote:
> > This just leads me to believe that we should either not notify the host,
> > or not wait_for_completion() when telling the host.
> 
> Interesting. The spec says
> 
> (a) The driver constructs an array of addresses of memory pages it has
> previously given to the balloon, as described above. This descriptor
> is added to the deflateq.
> (b) If the VIRTIO_BALLOON_F_MUST_TELL_HOST feature is set,
> the guest may not use these requested pages until that descriptor in
> the deflateq has been used by the device.
> (c) Otherwise, the guest may begin to re-use pages previously given to
> the balloon before the device has acknowledged their withdrawl.
>  21 In this case, deflation advice is merely a courtesy
> 
> This does not discuss the following issue: what happens
> if the device never uses the descriptor in the deflateq
> and VIRTIO_BALLOON_F_MUST_TELL_HOST is not set?
> 
> Rusty, any comments?

The device still *has* a queue.  It should process it!

The feature should be called VIRTIO_BALLOON_F_ASK_HOST_BEFORE_REUSE.

If we didn't want the information at *all*, we would have made the queue
not exist in that case...

Thanks,
Rusty.
