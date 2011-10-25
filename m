Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1JYITp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:19:45 -0400
Received: from brick.kernel.dk ([87.104.106.3]:44788 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab1JYITn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:19:43 -0400
Message-ID: <4EA670F9.8030601@kernel.dk>
Date: Tue, 25 Oct 2011 10:19:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] block: warn if tag is greater than real_max_depth.
References: <1315984992-5158-1-git-send-email-tm@tao.ma> <4EA57E40.2020301@tao.ma>
In-Reply-To: <4EA57E40.2020301@tao.ma>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-24 17:03, Tao Ma wrote:
> Hi Jens,
> 	any option with this patch?
> 
> Thanks
> Tao
> On 09/14/2011 03:23 PM, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> In case tag depth is reduced, it is max_depth not real_max_depth.
>> So we should allow a request with tag >= max_depth, but for a
>> tag >= real_max_depth, there really should be some problem.
>>
>> Cc: Jens Axboe <jaxboe@fusionio.com>
>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>> ---
>>  block/blk-tag.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-tag.c b/block/blk-tag.c
>> index ece65fc..e74d6d1 100644
>> --- a/block/blk-tag.c
>> +++ b/block/blk-tag.c
>> @@ -286,12 +286,14 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
>>  
>>  	BUG_ON(tag == -1);
>>  
>> -	if (unlikely(tag >= bqt->real_max_depth))
>> +	if (unlikely(tag >= bqt->max_depth)) {
>>  		/*
>>  		 * This can happen after tag depth has been reduced.
>> -		 * FIXME: how about a warning or info message here?
>> +		 * But tag shouldn't be larger than real_max_depth.
>>  		 */
>> +		WARN_ON(tag >= bqt->real_max_depth);
>>  		return;
>> +	}
>>  
>>  	list_del_init(&rq->queuelist);
>>  	rq->cmd_flags &= ~REQ_QUEUED;

Looks good, better than what we had. Applied.

-- 
Jens Axboe

