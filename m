Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab2I1KQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:16:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52333 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab2I1KQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:16:12 -0400
X-IronPort-AV: E=Sophos;i="4.80,501,1344182400"; 
   d="scan'208";a="5934543"
Message-ID: <50657973.8090401@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 18:18:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>
Subject: Re: [PATCH 05/12] workqueue: don't wake up other workers in rescuer
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com> <1348680043-5077-6-git-send-email-laijs@cn.fujitsu.com> <20120926183429.GF12544@google.com>
In-Reply-To: <20120926183429.GF12544@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 18:16:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 18:16:21,
	Serialize complete at 2012/09/28 18:16:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 02:34 AM, Tejun Heo wrote:
> (cc'ing Ray Jui)
> 
> On Thu, Sep 27, 2012 at 01:20:36AM +0800, Lai Jiangshan wrote:
>> rescuer is NOT_RUNNING, so there is no sense when it wakes up other workers,
>> if there are available normal workers, they are already woken up when needed.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>>  kernel/workqueue.c |    8 --------
>>  1 files changed, 0 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index c718b94..6c339bf 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -2438,14 +2438,6 @@ repeat:
>>  
>>  		process_scheduled_works(rescuer);
>>  
>> -		/*
>> -		 * Leave this gcwq.  If keep_working() is %true, notify a
>> -		 * regular worker; otherwise, we end up with 0 concurrency
>> -		 * and stalling the execution.
>> -		 */
>> -		if (keep_working(pool))
>> -			wake_up_worker(pool);
>> -
> 
> This was added by 7576958a9d5a4a6 ("workqueue: wake up a worker when a
> rescuer is leaving a gcwq") to fix a bug reported by Ray Jui.
> 
>   http://thread.gmane.org/gmane.linux.kernel/1098131
> 
> I'm fairly sure it was a valid bug report.  I don't think the
> depletion comes from concurrency management.  It's just the lack of
> chaining which could lead to stall.  What am I missing here?
> 

"http://thread.gmane.org/gmane.linux.kernel/1098131" does not find out the root cause.
I find out the root cause with hard searching from the code, I will describe it later.

Thanks,
Lai

