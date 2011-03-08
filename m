Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1CHMYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:24:08 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:56880 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1CHMYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:24:05 -0500
X-ASG-Debug-ID: 1299587044-01de284cf824850001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D761FE1.20503@fusionio.com>
Date: Tue, 8 Mar 2011 13:24:01 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-6-git-send-email-jaxboe@fusionio.com> <20110304040048.GA32404@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110304040048.GA32404@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299587044
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57406
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-04 05:00, Vivek Goyal wrote:
> On Sat, Jan 22, 2011 at 01:17:24AM +0000, Jens Axboe wrote:
> 
> [..]
>>  mm/page-writeback.c                |    2 +-
>>  mm/readahead.c                     |   12 ---
>>  mm/shmem.c                         |    1 -
>>  mm/swap_state.c                    |    5 +-
>>  mm/swapfile.c                      |   37 --------
>>  mm/vmscan.c                        |    2 +-
>>  118 files changed, 153 insertions(+), 1248 deletions(-)
> 
> block/blk-throttle.c also uses blk_unplug(). We need to get rid of that
> also.

Done.

> [..]
>> @@ -632,8 +630,6 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
>>  		 * don't force unplug of the queue for that case.
>>  		 * Clear unplug_it and fall through.
>>  		 */
> 
> Above comments now seem to be redundant.

Killed.

>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>> index b9e1e15..5ef136c 100644
>> --- a/drivers/md/dm-raid.c
>> +++ b/drivers/md/dm-raid.c
>> @@ -394,7 +394,7 @@ static void raid_unplug(struct dm_target_callbacks *cb)
>>  {
>>  	struct raid_set *rs = container_of(cb, struct raid_set, callbacks);
>>  
>> -	md_raid5_unplug_device(rs->md.private);
>> +	md_raid5_kick_device(rs->md.private);
> 
> With all the unplug logic gone, I think we can get rid of blk_sync_queue()
> call from md. It looks like md was syncing the queue just to make sure
> that unplug_fn is not called again. Now all that logic is gone so it
> should be redundant.
> 
> Also we can probably get rid of some queue_lock taking instances in
> md code. NeilBrown recently put following patch in, which is taking
> queue lock only around plug functions. Now queue plugging gone,
> I guess it should not be required.

Agree on both accounts. I'll leave that out for this version, though.

-- 
Jens Axboe

