Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab2ALAYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 19:24:45 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57414 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2ALAYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 19:24:44 -0500
X-AuditID: 9c93016f-b7c72ae000007401-d9-4f0e283333e7
Message-ID: <4F0E282B.8060607@lge.com>
Date: Thu, 12 Jan 2012 09:24:11 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>, axboe@kernel.dk, mingo@redhat.com,
        fweisbec@gmail.com, teravest@google.com, slavapestov@google.com,
        ctalbott@google.com, dhsharp@google.com, linux-kernel@vger.kernel.org,
        winget@google.com, namhyung@gmail.com
Subject: Re: [PATCH 2/9] block: block_bio_complete tracepoint was missing
References: <1326220106-5765-1-git-send-email-tj@kernel.org> <1326220106-5765-3-git-send-email-tj@kernel.org> <1326302732.7642.57.camel@gandalf.stny.rr.com> <20120111173036.GG26832@google.com>
In-Reply-To: <20120111173036.GG26832@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-12 2:30 AM, Tejun Heo wrote:
> Hello,
>
> On Wed, Jan 11, 2012 at 12:25:32PM -0500, Steven Rostedt wrote:
>> On Tue, 2012-01-10 at 10:28 -0800, Tejun Heo wrote:
>>> block_bio_complete tracepoint was defined but not invoked anywhere.
>>> Fix it.
>>>
>>> -tj: This will generate duplicate BLK_TA_COMPLETEs.  Namhyung is
>>>       working on proper solution.
>>>
>>> DO_NOT_APPLY
>>> Cc: Namhyung Kim<namhyung@gmail.com>
>>> ---
>>>   fs/bio.c |    3 +++
>>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/bio.c b/fs/bio.c
>>> index b1fe82c..96548da 100644
>>> --- a/fs/bio.c
>>> +++ b/fs/bio.c
>>> @@ -1447,6 +1447,9 @@ void bio_endio(struct bio *bio, int error)
>>>   	else if (!test_bit(BIO_UPTODATE,&bio->bi_flags))
>>>   		error = -EIO;
>>>
>>> +	if (bio->bi_bdev)
>>> +		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
>>> +					 bio, error);
>>
>> I thought I commented before about using TRACE_EVENT_CONDITIONAL() here.
>> To remove that open coded branch.
>
> Yeah but this particular patch is dead now so it's a bit pointless.
> ioblame:ioblame_io uses it FWIW.  Namhyung, can you please consider
> using TRACE_EVENT_CONDITION() for you patches if applicable?
>
> Thanks.
>

Sure, I'll apply it.

Thanks,
Namhyung Kim
