Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2HIIu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 04:50:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33201 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab2HIIuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 04:50:12 -0400
MIME-Version: 1.0
In-Reply-To: <201208081335333287528@gmail.com>
References: <201208081005308597351@gmail.com>
	<CANejiEXdHaqtXuR47QRimRNcvjxtUn8__7MK5XwW2t658hz=3g@mail.gmail.com>
	<201208081335333287528@gmail.com>
Date: Thu, 9 Aug 2012 16:50:10 +0800
X-Google-Sender-Auth: REvW0PvslTtd3_KdZ1fZg0_en3M
Message-ID: <CANejiEWk-TA_vdEwL2CEW5wgjz-dJAkQTxQ0OuUwto1MsdEQVQ@mail.gmail.com>
Subject: Re: Re: [RFC PATCH] block:Fix some problems about handling plug in blk_queue_bio().
From: Shaohua Li <shli@kernel.org>
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/8 Jianpeng Ma <majianpeng@gmail.com>:
> On 2012-08-08 11:06 Shaohua Li <shli@kernel.org> Wrote:
>>2012/8/8 Jianpeng Ma <majianpeng@gmail.com>:
>>> I think there are three problems about handling plug in blk_queue_bio():
>>> 1:if request_count >= BLK_MAX_REQUEST_COUNT, avoid unnecessary plug->should_sort judge.
>>this makes sense, though not a big deal, nice to fix it.
> Thanks
>>
>>> 2:Only two device can trace plug.
>>I didn't get the point, can you have more details?
>
>>>if (plug) {
>>>              /*
>>>               * If this is the first request added after a plug, fire
>>>               * of a plug trace. If others have been added before, check
>>>               * if we have multiple devices in this plug. If so, make a
>>>               * note to sort the list before dispatch.
>>>               */
>>>              if (list_empty(&plug->list))
>>>                      trace_block_plug(q);
>>>              else {
>>>                      if (!plug->should_sort) {
>>>                              struct request *__rq;
>
>>>                              __rq = list_entry_rq(plug->list.prev);
>>>                              if (__rq->q != q)
>>>                                      plug->should_sort = 1;
>>>                      }
>>>                      if (request_count >= BLK_MAX_REQUEST_COUNT) {
>>>                              blk_flush_plug_list(plug, false);
>>>                              trace_block_plug(q);
> The code only trace two point;
> A:      list_empty(&plug->list)
> B:      request_count >= BLK_MAX_REQUEST_COUNT). it's the same like A which plug->list is empty.
> Suppose:
> 1;reqA-deviceA firstly come, it will call trace_block_plug because the list_empty(plug->list) is true.
> 2:reqB-deviceB comed, attempt_plug_merge will failed because not deviceB-request-queue.But it'll not to call trace_block_plug.
>
> But call blk_flush_plug_list,it will trace_block_unplug all request_queue.

ok, this is true. please send a new patch for the item 1&2 then.
