Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2FSChv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:37:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab2FSChu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:37:50 -0400
Message-ID: <4FDFE651.20207@redhat.com>
Date: Tue, 19 Jun 2012 10:39:13 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <1340002390-3950-1-git-send-email-asias@redhat.com> <1340002390-3950-4-git-send-email-asias@redhat.com> <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com> <87zk81x7dp.fsf@rustcorp.com.au>
In-Reply-To: <87zk81x7dp.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 06:05 PM, Rusty Russell wrote:
> On Mon, 18 Jun 2012 16:03:23 +0800, Asias He <asias@redhat.com> wrote:
>> On 06/18/2012 03:46 PM, Rusty Russell wrote:
>>> On Mon, 18 Jun 2012 14:53:10 +0800, Asias He <asias@redhat.com> wrote:
>>>> This patch introduces bio-based IO path for virtio-blk.
>>>
>>> Why make it optional?
>>
>> request-based IO path is useful for users who do not want to bypass the
>> IO scheduler in guest kernel, e.g. users using spinning disk. For users
>> using fast disk device, e.g. SSD device, they can use bio-based IO path.
>
> Users using a spinning disk still get IO scheduling in the host though.
> What benefit is there in doing it in the guest as well?

Merging in guest kernel's IO scheduling can reduce the number of 
requests guest fires to host side. For instance, with the same workload 
in guest side, the number of request drops to ~200K from ~4000K with 
guest kernel's merging in qemu.

>
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Asias


