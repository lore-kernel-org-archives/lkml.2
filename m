Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2GCO2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:28:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab2GCO2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:28:22 -0400
Message-ID: <4FF3017C.4020605@redhat.com>
Date: Tue, 03 Jul 2012 17:28:12 +0300
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ronen Hod <rhod@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <1340002390-3950-1-git-send-email-asias@redhat.com> <1340002390-3950-4-git-send-email-asias@redhat.com> <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com> <87zk81x7dp.fsf@rustcorp.com.au> <4FDF0DA7.40604@redhat.com> <4FF3001C.9020706@redhat.com>
In-Reply-To: <4FF3001C.9020706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 05:22 PM, Ronen Hod wrote:
> On 06/18/2012 02:14 PM, Dor Laor wrote:
>> On 06/18/2012 01:05 PM, Rusty Russell wrote:
>>> On Mon, 18 Jun 2012 16:03:23 +0800, Asias He<asias@redhat.com>  wrote:
>>>> On 06/18/2012 03:46 PM, Rusty Russell wrote:
>>>>> On Mon, 18 Jun 2012 14:53:10 +0800, Asias He<asias@redhat.com>  wrote:
>>>>>> This patch introduces bio-based IO path for virtio-blk.
>>>>>
>>>>> Why make it optional?
>>>>
>>>> request-based IO path is useful for users who do not want to bypass the
>>>> IO scheduler in guest kernel, e.g. users using spinning disk. For users
>>>> using fast disk device, e.g. SSD device, they can use bio-based IO
>>>> path.
>>>
>>> Users using a spinning disk still get IO scheduling in the host though.
>>> What benefit is there in doing it in the guest as well?
>>
>> The io scheduler waits for requests to merge and thus batch IOs
>> together. It's not important w.r.t spinning disks since the host can
>> do it but it causes much less vmexits which is the key issue for VMs.
>
> Does it make sense to use the guest's I/O scheduler at all?

That's the reason we have a noop io scheduler.

> - It is not aware of the physical (spinning) disk layout.
> - It is not aware of all the host's disk pending requests.
> It does have a good side-effect - batching of requests.
>
> Ronen.
>
>>
>>>
>>> Cheers,
>>> Rusty.
>>> _______________________________________________
>>> Virtualization mailing list
>>> Virtualization@lists.linux-foundation.org
>>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


