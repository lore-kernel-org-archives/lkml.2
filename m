Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2G3AYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 20:24:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab2G3AYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 20:24:48 -0400
Message-ID: <5015D4C8.9090601@redhat.com>
Date: Mon, 30 Jul 2012 08:26:48 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan.kim@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V3 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <1342168731-11797-1-git-send-email-asias@redhat.com> <1342168731-11797-4-git-send-email-asias@redhat.com> <87d33initv.fsf@rustcorp.com.au> <501350B1.7080908@redhat.com> <20120729125948.GA10041@redhat.com>
In-Reply-To: <20120729125948.GA10041@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2012 08:59 PM, Michael S. Tsirkin wrote:
> On Sat, Jul 28, 2012 at 10:38:41AM +0800, Asias He wrote:
>> On 07/27/2012 08:33 AM, Rusty Russell wrote:
>>> On Fri, 13 Jul 2012 16:38:51 +0800, Asias He <asias@redhat.com> wrote:
>>>> Add 'virtio_blk.use_bio=1' to kernel cmdline or 'modprobe virtio_blk
>>>> use_bio=1' to enable ->make_request_fn() based I/O path.
>>>
>>> This patch conflicts with Paolo's Bonzini's 'virtio-blk: allow toggling
>>> host cache between writeback and writethrough' which is also queued (see
>>> linux-next).
>>
>> Rebased against Paolo's patch in V4.
>>
>>> I'm not sure what the correct behavior for bio & cacheflush is, if any.
>>
>> REQ_FLUSH is not supported in the bio path.
>>
>>> But as to the patch itself: it's a hack.
>>>
>>> 1) Leaving the guest's admin to turn on the switch is a terrible choice.
>>> 2) The block layer should stop merging and sorting when a device is
>>>     fast, not the driver.
>>> 3) I pointed out that slow disks have low IOPS, so why is this
>>>     conditional?  Sure, more guest exits, but it's still a small number
>>>     for a slow device.
>>> 4) The only case where we want merging is on a slow device when the host
>>>     isn't doing it.
>>>
>>> Now, despite this, I'm prepared to commit it.  But in my mind it's a
>>> hack: we should aim for use_bio to be based on a feature bit fed from
>>> the host, and use the module parameter only if we want to override it.
>>
>> OK. A feature bit from host sound like a choice but a switch is also
>> needed on host side.
>
> qemu automatically gives you the ability to control
> any feature bit.

Automatically?

>> And for other OS, e.g. Windows, the bio thing
>> does not apply at all.
>
> Let's try to define when it's a good idea. Is it a hint to guest that
> backend handles small accesses efficiently so ok to disable batching?

Yes. It's also a hint for latency reduction.

>> Anyway, I have to admit that adding a module parameter here is not
>> the best choice. Let's think more.
>>
>> --
>> Asias


-- 
Asias
