Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2GRJqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab2GRJqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:46:13 -0400
Message-ID: <500685DA.2090402@redhat.com>
Date: Wed, 18 Jul 2012 12:46:02 +0300
From: Ronen Hod <rhod@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Asias He <asias@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add vhost-blk support
References: <1342107302-28116-1-git-send-email-asias@redhat.com> <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com> <50052276.2080906@redhat.com> <500527BA.9000001@redhat.com> <50052E7E.6020100@redhat.com>
In-Reply-To: <50052E7E.6020100@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 12:21 PM, Asias He wrote:
> On 07/17/2012 04:52 PM, Paolo Bonzini wrote:
>> Il 17/07/2012 10:29, Asias He ha scritto:
>>> So, vhost-blk at least saves ~6 syscalls for us in each request.
>>
>> Are they really 6?  If I/O is coalesced by a factor of 3, for example
>> (i.e. each exit processes 3 requests), it's really 2 syscalls per request.
>
> Well. I am counting the number of syscalls in one notify and response process. Sure the IO can be coalesced.

Note that Asias is using very fast "disks" (FusionIO & Ramdisk).
- This might affect the level of coalescing both ways, depending on the scenario and algorithm.
- This also means that the 5%-15% gain will probably be lower in real life.
Ronen.

>
>> Also, is there anything we can improve? Perhaps we can modify epoll and
>> ask it to clear the eventfd for us (would save 2 reads)?  Or
>> io_getevents (would save 1)?
>>
>>> I guess you mean qemu here. Yes, in theory, qemu's block layer can be
>>> improved to achieve similar performance as vhost-blk or kvm tool's
>>> userspace virito-blk has. But I think it makes no sense to prevent one
>>> solution becase there is another in theory solution called: we can do
>>> similar in qemu.
>>
>> It depends.  Like vhost-scsi, vhost-blk has the problem of a crippled
>> feature set: no support for block device formats, non-raw protocols,
>> etc.  This makes it different from vhost-net.
>
> Data-plane qemu also has this cripppled feature set problem, no? Does user always choose to use block devices format like qcow2? What if they prefer raw image or raw block device?
>
>>
>> So it begs the question, is it going to be used in production, or just a
>> useful reference tool?
>
> This should be decided by user, I can not speak for them. What is wrong with adding one option for user which they can decide?
>


