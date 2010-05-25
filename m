Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab0EYBja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:39:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55538 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758038Ab0EYBj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:39:29 -0400
Message-ID: <4BFB29DB.10507@cn.fujitsu.com>
Date: Tue, 25 May 2010 09:37:31 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] io-controller: Add new interfaces to trace	backlogged
 group status
References: <4BF64712.1070500@cn.fujitsu.com> <20100521131751.GA15302@redhat.com> <4BF9D265.70008@cn.fujitsu.com> <20100524212207.GC28685@redhat.com>
In-Reply-To: <20100524212207.GC28685@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, May 24, 2010 at 09:12:05AM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> On Fri, May 21, 2010 at 04:40:50PM +0800, Gui Jianfeng wrote:
>>>> Hi,
>>>>
>>>> This series implements three new interfaces to keep track of tranferred bytes,
>>>> elapsing time and io rate since group getting backlogged. If the group dequeues
>>>> from service tree, these three interfaces will reset and shows zero.
>>> Hi Gui,
>>>
>>> Can you give some details regarding how this functionality is useful? Why
>>> would somebody be interested in only in stats of till group was
>>> backlogged and not in total stats?
>>>
>>> Groups can come and go so fast and these stats will reset so many times
>>> that I am not able to visualize how these stats will be useful.
>> Hi Vivek,
>>
>> Currently, we assign weight to a group, but user still doesn't know how fast the
>> group runs. With io rate interface, users can check the rate of a group at any
>> moment, or to determine whether the weight assigned to a group is enough.
>> bytes and time interface is just for debug purpose.
> 
> Gui,
> 
> I still don't understand that why blkio.sectors or blkio.io_service_bytes
> or blkio.io_serviced interfaces are not good enough to determine at what
> rate a group is doing IO.
> 
> I think we can very well write something in userspace like "iostat" to 
> display the per group rate. Utility can read the any of the above files
> say at the interfval of 1s, calculate the diff between the values and
> display that as group effective rate.

Hi Vivek,

blkio.io_active_rate reflects the rate since group get backlogged, so the rate is a smooth 
value. This value represents the actual rate a group runs. IMO, io rate calculated from
user space is not accurate in following two scenarios:

1 Userspace app chooses the interval of 1s, if 0.5s is backlogged and 0.5s is not, the 
  rate calculated in this interval doesn't make sense.

2 Consider there're several groups are waiting for service, but most part of the interval
  is just fall into the period that the group is under-service. such rate calculated by user
  app isn't acurate, rate burst might occur.

Further more, once max weight control is available, we can make use of such interface to realize
how well this group works.

Thanks,
Gui


> 
> Thanks
> Vivek
> 
> 
