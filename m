Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab2FSCUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:20:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab2FSCUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:20:14 -0400
Message-ID: <4FDFE22E.3030003@redhat.com>
Date: Tue, 19 Jun 2012 10:21:34 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <1340002390-3950-1-git-send-email-asias@redhat.com> <1340002390-3950-4-git-send-email-asias@redhat.com> <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com> <20120618101349.GC23134@redhat.com>
In-Reply-To: <20120618101349.GC23134@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 06:13 PM, Michael S. Tsirkin wrote:
> On Mon, Jun 18, 2012 at 04:03:23PM +0800, Asias He wrote:
>> On 06/18/2012 03:46 PM, Rusty Russell wrote:
>>> On Mon, 18 Jun 2012 14:53:10 +0800, Asias He <asias@redhat.com> wrote:
>>>> This patch introduces bio-based IO path for virtio-blk.
>>>
>>> Why make it optional?
>>
>> request-based IO path is useful for users who do not want to bypass
>> the IO scheduler in guest kernel, e.g. users using spinning disk.
>> For users using fast disk device, e.g. SSD device, they can use
>> bio-based IO path.
>
> OK I guess but then it should be per-device. There could be
> a mix of slow and fast disks :)

Yes, per-device might be useful. There are issues which need solving.
- How do we tell the drive which IO path to use
   - Device add some flag
     - Old qemu/lkvm can not turn this feature on
   - Through /sys filesystem attribute
     - How do we handle the switch from one path to anther.

So, let's add the per-device feature later.

-- 
Asias


