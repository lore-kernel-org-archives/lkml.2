Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3AHDEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:04:33 -0500
Received: from ozlabs.org ([203.10.76.45]:57750 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab3AHDEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:04:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com,
        hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Jens Axboe" <axboe@kernel.dk>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of buffers
In-Reply-To: <50EADB62.1010704@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com> <1355833972-20319-2-git-send-email-pbonzini@redhat.com> <87r4m45g88.fsf@rustcorp.com.au> <50E54DC0.4040609@redhat.com> <87pq1h508k.fsf@rustcorp.com.au> <50EADB62.1010704@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 08 Jan 2013 10:42:13 +1030
Message-ID: <87wqvo3542.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> Il 07/01/2013 01:02, Rusty Russell ha scritto:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>> Il 02/01/2013 06:03, Rusty Russell ha scritto:
>>>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>>>> The virtqueue_add_buf function has two limitations:
>>>>>
>>>>> 1) it requires the caller to provide all the buffers in a single call;
>>>>>
>>>>> 2) it does not support chained scatterlists: the buffers must be
>>>>> provided as an array of struct scatterlist;
>>>>
>>>> Chained scatterlists are a horrible interface, but that doesn't mean we
>>>> shouldn't support them if there's a need.
>>>>
>>>> I think I once even had a patch which passed two chained sgs, rather
>>>> than a combo sg and two length numbers.  It's very old, but I've pasted
>>>> it below.
>>>>
>>>> Duplicating the implementation by having another interface is pretty
>>>> nasty; I think I'd prefer the chained scatterlists, if that's optimal
>>>> for you.
>>>
>>> Unfortunately, that cannot work because not all architectures support
>>> chained scatterlists.
>> 
>> WHAT?  I can't figure out what an arch needs to do to support this?
>
> It needs to use the iterator functions in its DMA driver.

But we don't care for virtio.

>> All archs we care about support them, though, so I think we can ignore
>> this issue for now.
>
> Kind of... In principle all QEMU-supported arches can use virtio, and
> the speedup can be quite useful.  And there is no Kconfig symbol for SG
> chains that I can use to disable virtio-scsi on unsupported arches. :/

Well, we #error if it's not supported.  Then the lazy architectures can
fix it.

Cheers,
Rusty.
