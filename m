Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab2IDOM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:12:59 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:58390 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757065Ab2IDOM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:12:58 -0400
Message-ID: <50460C61.6050705@tao.ma>
Date: Tue, 04 Sep 2012 22:12:49 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2] block/throttle: Add IO throttled information in blkio.throttle.
References: <1346390109-3169-1-git-send-email-tm@tao.ma> <20120904133528.GB13768@redhat.com>
In-Reply-To: <20120904133528.GB13768@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 111.193.15.194 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 09:35 PM, Vivek Goyal wrote:
> On Fri, Aug 31, 2012 at 01:15:09PM +0800, Tao Ma wrote:
> 
> [..]
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index 1588c2d..9317d71 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -46,6 +46,8 @@ struct tg_stats_cpu {
>>  	struct blkg_rwstat		service_bytes;
>>  	/* total IOs serviced, post merge */
>>  	struct blkg_rwstat		serviced;
>> +	/* total IOs queued, not submitted to the underlying device. */
>> +	struct blkg_rwstat		io_queued;
>>  };
> 
> Couple of questions.
> 
> - blkg_rwstat is "unsigned" and io_queued can go negative too (Because
>   throttled bio can very well be dispatched from other cpu from a worker
>   thread). So is it a good idea to represent a negative number with 
>   unsingned type?
> 
> - As this stat is per cpu, a reader might very well see negative (or a
>   huge unsigned value) as number of io_queued. Not sure if that is acceptable.
>   How would user space come to know whether it is a valid value or not. I
>   thought per cpu stats are good for continuously increasing values but
>   not necessarily for values which can increase as well as decrease.
You are right. So I should just use throtl_grp->nr_queued to display the
total numbers of ios being throttled and I guess a rcu_read_lock should
be enough for me to access that data.

Thanks for the review.

Thanks
Tao
