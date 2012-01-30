Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab2A3Boo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:44:44 -0500
Received: from plane.gmane.org ([80.91.229.3]:45641 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab2A3Boc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:44:32 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Mon, 30 Jan 2012 10:44:19 +0900
Message-ID: <4F25F5F3.6060507@gmail.com>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com> <20120129192447.GB17211@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 121.50.20.41
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
In-Reply-To: <20120129192447.GB17211@htj.dyndns.org>
Cc: dm-devel@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2012-01-30 4:24 AM, Tejun Heo wrote:
> On Sun, Jan 29, 2012 at 06:41:33 PM +0900, Namhyung Kim wrote:
>> The block_bio_complete() TP has been missed so long, so that bio-based
>> drivers haven't been able to trace its IO behavior. Add it.
>>
>> In some rare cases, such as loop_switch, @bio->bi_bdev can be NULL.
>> Thus convert it to TRACE_EVENT_CONDITION() as Steven suggested.
>>
>>  From now on, request-based drivers will also get BLK_TA_COMPLETEs for
>> all bio's in requests. This needs to be handled in userland properly.
>>
>> Also remove external use of the TP in DM and unexport it.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: dm-devel@redhat.com
>
> I like the smiplicity change but do we know how we can filter this out
> from userland?  Also, what's the reason not to do it from blktrace.c?
> What would be the downside of doing that?
>
> Thanks.
>

The userland tool cannot distinguish bounced bio from original one at 
completion TP, but it can expect there will be a duplicated 
BLK_TA_COMPLETE as it sees BLK_TA_BOUNCE for the bio before.

Filtering it out from kernel side seems to hide a real information that 
(paranoid?) user might want to get, and it looks like providing "polcy 
not mechanism" IMHO. That's why I changed my mind finally.

I cannot think of the downside, anyway it's not a big deal, if you think 
it's wrong choice, I'm OK to change it again.


Thanks,
Namhyung

