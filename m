Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1HKBOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 21:14:46 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57112 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab1HKBOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 21:14:44 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEXgsVW4qk3hwHvd6YzgRsZueAB3ZSh3Rvx3fz9tM7KHPw@mail.gmail.com>
References: <20110811004216.GA24810@july>
	<CANejiEXgsVW4qk3hwHvd6YzgRsZueAB3ZSh3Rvx3fz9tM7KHPw@mail.gmail.com>
Date: Thu, 11 Aug 2011 09:14:43 +0800
X-Google-Sender-Auth: 7kkk0IBWFxb3QSJ6qqwvvse2hQw
Message-ID: <CANejiEUSU_hfex5i5znjAUU9Te2o-fgKuO=uD0UW+a4eaiU4Bw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] Add new elevator ops for request hint
From: Shaohua Li <shli@kernel.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        jh80.chung@samsung.com, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/11 Shaohua Li <shli@kernel.org>:
> 2011/8/11 Kyungmin Park <kmpark@infradead.org>:
>> Hi Jens
>>
>> Now eMMC device requires the upper layer information to improve the data
>> performance and reliability.
>>
>> . Context ID
>> Using the context information, it can sort out the data internally and improve the performance.
>> The main problem is that it's needed to define "What's the context".
>> Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead
>>
>> . Data Tag
>> Using the Data Tag (1-bit information), It writes the data at SLC area when it's hot data. So it can make the chip more reliable.
>> First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.
>>
>> With these characteristics, it's helpful to teach the device. After some consideration. it's needed to pass out these information at request data structure.
>>
>> Sample usage is following in drivers/mmc/card/block.c
>>
>>        struct elevator_queue *e = md->queue.queue->elevator;
>>        struct request_hint hint;
>>        int ret;
>>
>>        if (e->ops->elevator_get_req_hint_fn && req)
>>                ret = e->ops->elevator_get_req_hint_fn(req, &hint);
> please put this to blkdev.h or similar. directly using it here
> is abnormal.
BTW, we can add a (rq->cmd_flags & REQ_ELVPRIV) check here to make
sure the request is at io scheduler.
