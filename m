Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2LISS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 13:18:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35895 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab2LISS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 13:18:57 -0500
Message-ID: <50C4D60D.4090201@kernel.dk>
Date: Sun, 09 Dec 2012 19:18:53 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: xtu4 <xiaobing.tu@intel.com>
CC: linux-kernel@vger.kernel.org, di.zhang@intel.com
Subject: Re: [PATCH] Allow 0ms deadline latency
References: <50C4B5D7.4030808@intel.com> <50C4B62C.7050404@intel.com>
In-Reply-To: <50C4B62C.7050404@intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-09 17:02, xtu4 wrote:
> On 12/10/2012 12:01 AM, xtu4 wrote:
>> Subject: [PATCH] Allow 0ms deadline latency, increase the read speed
>>
>> Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
>> ---
>> block/deadline-iosched.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
>> index c644137..e502d6b 100644
>> --- a/block/deadline-iosched.c
>> +++ b/block/deadline-iosched.c
>> @@ -230,7 +230,7 @@ static inline int deadline_check_fifo(struct 
>> deadline_data *dd, int ddir)
>>        /*
>>         * rq is expired!
>>         */
>> -       if (time_after(jiffies, rq_fifo_time(rq)))
>> +       if (time_after_eq(jiffies, rq_fifo_time(rq)))
>>                return 1;
>>
>>         return 0;

Looks fine, it allows FIFO behaviour for deadline as well. I have
applied it.

-- 
Jens Axboe

