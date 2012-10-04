Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab2JDBYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:24:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61945 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab2JDBYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:24:51 -0400
From: Anthony Liguori <anthony@codemonkey.ws>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] virtio-net: inline header support
In-Reply-To: <87vces2gxq.fsf@rustcorp.com.au>
References: <cover.1348824232.git.mst@redhat.com> <87vces2gxq.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.13.2+93~ged93d79 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 03 Oct 2012 20:24:47 -0500
Message-ID: <87mx033u74.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> "Michael S. Tsirkin" <mst@redhat.com> writes:
>
>> Thinking about Sasha's patches, we can reduce ring usage
>> for virtio net small packets dramatically if we put
>> virtio net header inline with the data.
>> This can be done for free in case guest net stack allocated
>> extra head room for the packet, and I don't see
>> why would this have any downsides.
>
> I've been wanting to do this for the longest time... but...
>
>> Even though with my recent patches qemu
>> no longer requires header to be the first s/g element,
>> we need a new feature bit to detect this.
>> A trivial qemu patch will be sent separately.
>
> There's a reason I haven't done this.  I really, really dislike "my
> implemention isn't broken" feature bits.  We could have an infinite
> number of them, for each bug in each device.

This is a bug in the specification.

The QEMU implementation pre-dates the specification.  All of the actual
implementations of virtio relied on the semantics of s/g elements and
still do.

What's in the specification really doesn't matter when it doesn't agree
with all of the existing implementations.

Users use implementations, not specifications.  The specification really
ought to be changed here.

Regards,

Anthony Liguori
