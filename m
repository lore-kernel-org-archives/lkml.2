Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1HHBfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 21:35:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62866 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab1HHBfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 21:35:18 -0400
Message-ID: <4E3F3D4E.70104@gmail.com>
Date: Mon, 08 Aug 2011 09:35:10 +0800
From: Liu Yuan <namei.unix@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@us.ibm.com>
CC: Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com> <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com> <4E325F98.5090308@gmail.com> <4E32F7F2.4080607@us.ibm.com> <4E363DB9.70801@gmail.com> <1312495132.9603.4.camel@badari-desktop> <4E3BCE4D.7090809@gmail.com> <4E3C302A.3040500@us.ibm.com>
In-Reply-To: <4E3C302A.3040500@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2011 02:02 AM, Badari Pulavarty wrote:
> On 8/5/2011 4:04 AM, Liu Yuan wrote:
>> On 08/05/2011 05:58 AM, Badari Pulavarty wrote:
>>> Hi Liu Yuan,
>>>
>>> I started testing your patches. I applied your kernel patch to 3.0
>>> and applied QEMU to latest git.
>>>
>>> I passed 6 blockdevices from the host to guest (4 vcpu, 4GB RAM).
>>> I ran simple "dd" read tests from the guest on all block devices
>>> (with various blocksizes, iflag=direct).
>>>
>>> Unfortunately, system doesn't stay up. I immediately get into
>>> panic on the host. I didn't get time to debug the problem. Wondering
>>> if you have seen this issue before and/or you have new patchset
>>> to try ?
>>>
>>> Let me know.
>>>
>>> Thanks,
>>> Badari
>>>
>>
>> Okay, it is actually a bug pointed out by MST on the other thread, 
>> that it needs a mutex for completion thread.
>>
>> Now would you please this attachment?This patch only applies to 
>> kernel part, on top of v1 kernel patch.
>>
>> This patch mainly moves completion thread into vhost thread as a 
>> function. As a result, both requests submitting and completion 
>> signalling is in the same thread.
>>
>> Yuan
>
> Unfortunately, "dd" tests (4 out of 6) in the guest hung. I see 
> following messages
>
> virtio_blk virtio2: requests: id 0 is not a head !
> virtio_blk virtio3: requests: id 1 is not a head !
> virtio_blk virtio5: requests: id 1 is not a head !
> virtio_blk virtio1: requests: id 1 is not a head !
>
> I still see host panics. I will collect the host panic and see if its 
> still same or not.
>
> Thanks,
> Badari
>
>
Would you please show me how to reproduce it step by step? I tried dd 
with two block device attached, but didn't get hung nor panic.

Yuan
