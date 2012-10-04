Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab2JDDwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 23:52:51 -0400
Received: from ozlabs.org ([203.10.76.45]:45117 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab2JDDwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 23:52:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <anthony@codemonkey.ws>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] virtio-net: inline header support
In-Reply-To: <87mx033u74.fsf@codemonkey.ws>
References: <cover.1348824232.git.mst@redhat.com> <87vces2gxq.fsf@rustcorp.com.au> <87mx033u74.fsf@codemonkey.ws>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 04 Oct 2012 13:04:56 +0930
Message-ID: <87391u3o67.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori <anthony@codemonkey.ws> writes:
> Rusty Russell <rusty@rustcorp.com.au> writes:
>
>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>>
>>> Thinking about Sasha's patches, we can reduce ring usage
>>> for virtio net small packets dramatically if we put
>>> virtio net header inline with the data.
>>> This can be done for free in case guest net stack allocated
>>> extra head room for the packet, and I don't see
>>> why would this have any downsides.
>>
>> I've been wanting to do this for the longest time... but...
>>
>>> Even though with my recent patches qemu
>>> no longer requires header to be the first s/g element,
>>> we need a new feature bit to detect this.
>>> A trivial qemu patch will be sent separately.
>>
>> There's a reason I haven't done this.  I really, really dislike "my
>> implemention isn't broken" feature bits.  We could have an infinite
>> number of them, for each bug in each device.
>
> This is a bug in the specification.
>
> The QEMU implementation pre-dates the specification.  All of the actual
> implementations of virtio relied on the semantics of s/g elements and
> still do.

lguest fix is pending in my queue.  lkvm and qemu are broken; lkvm isn't
ever going to be merged, so I'm not sure what its status is?  But I'm
determined to fix qemu, and hence my torture patch to make sure this
doesn't creep in again.

> What's in the specification really doesn't matter when it doesn't agree
> with all of the existing implementations.
>
> Users use implementations, not specifications.  The specification really
> ought to be changed here.

I'm sorely tempted, except that we're losing a real optimization because
of this :(

The specification has long contained the footnote:

        The current qemu device implementations mistakenly insist that
        the first descriptor cover the header in these cases exactly, so
        a cautious driver should arrange it so.

I'd like to tie this caveat to the PCI capability change, so this note
will move to the appendix with the old PCI layout.

Cheers,
Rusty.
