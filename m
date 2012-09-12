Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2ILGdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:33:31 -0400
Received: from ozlabs.org ([203.10.76.45]:39514 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab2ILGd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:33:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
In-Reply-To: <20120910221111.GA21854@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com> <20120903143018.GA5353@redhat.com> <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com> <20120903202737.GD6181@redhat.com> <CAJK669ZvnnG6fGOog-Z47B7xqyn9hcx5dAD7S--+2PSgE+hrLA@mail.gmail.com> <20120904135022.GI9805@redhat.com> <CAJK669Z1UYakBWartChfoeKL_eU5=GFZMGhH8R_Q-difVm0ygQ@mail.gmail.com> <20120904185541.GB3602@redhat.com> <87k3w7j49i.fsf@rustcorp.com.au> <20120906052735.GB17656@redhat.com> <20120910221111.GA21854@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 12 Sep 2012 15:54:40 +0930
Message-ID: <877grzdahj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
>> virtio: don't crash when device is buggy
>> 
>> Because of a sanity check in virtio_dev_remove, a buggy device can crash
>> kernel.  And in case of rproc it's userspace so it's not a good idea.
>> We are unloading a driver so how bad can it be?
>> Be less aggressive in handling this error: if it's a driver bug,
>> warning once should be enough.
>> 
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> Rusty?

Thanks, applied.

I really want to implement CONFIG_VIRTIO_DEVEL_DEBUG which would
incorporate the checks in virtio_ring.c as well as this.  Then I could
also reshuffle descriptors (eg. split them) to find buggy devices like
qemu which assume the first descriptor is the struct virtio_net_hdr...

Cheers,
Rusty,
