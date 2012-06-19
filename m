Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab2FSGV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab2FSGV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:21:27 -0400
Message-ID: <4FE01A5F.6060201@redhat.com>
Date: Tue, 19 Jun 2012 09:21:19 +0300
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Asias He <asias@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <1340002390-3950-1-git-send-email-asias@redhat.com>  <1340002390-3950-4-git-send-email-asias@redhat.com>  <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com>  <87zk81x7dp.fsf@rustcorp.com.au> <4FDF0DA7.40604@redhat.com> <1340019575.22848.2.camel@lappy> <4FDFE926.7030309@redhat.com>
In-Reply-To: <4FDFE926.7030309@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 05:51 AM, Asias He wrote:
> On 06/18/2012 07:39 PM, Sasha Levin wrote:
>> On Mon, 2012-06-18 at 14:14 +0300, Dor Laor wrote:
>>> On 06/18/2012 01:05 PM, Rusty Russell wrote:
>>>> On Mon, 18 Jun 2012 16:03:23 +0800, Asias He<asias@redhat.com> wrote:
>>>>> On 06/18/2012 03:46 PM, Rusty Russell wrote:
>>>>>> On Mon, 18 Jun 2012 14:53:10 +0800, Asias He<asias@redhat.com> wrote:
>>>>>>> This patch introduces bio-based IO path for virtio-blk.
>>>>>>
>>>>>> Why make it optional?
>>>>>
>>>>> request-based IO path is useful for users who do not want to bypass
>>>>> the
>>>>> IO scheduler in guest kernel, e.g. users using spinning disk. For
>>>>> users
>>>>> using fast disk device, e.g. SSD device, they can use bio-based IO
>>>>> path.
>>>>
>>>> Users using a spinning disk still get IO scheduling in the host though.
>>>> What benefit is there in doing it in the guest as well?
>>>
>>> The io scheduler waits for requests to merge and thus batch IOs
>>> together. It's not important w.r.t spinning disks since the host can do
>>> it but it causes much less vmexits which is the key issue for VMs.
>>
>> Is the amount of exits caused by virtio-blk significant at all with
>> EVENT_IDX?
>
> Yes. EVENT_IDX saves the number of notify and interrupt. Let's take the
> interrupt as an example, The guest fires 200K request to host, the
> number of interrupt is about 6K thanks to EVENT_IDX. The ratio is 200K /
> 6K = 33. The ratio of merging is 40000K / 200K = 20.
>

In this case, why don't you always recommend bio over request based?
