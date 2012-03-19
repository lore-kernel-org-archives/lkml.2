Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab2CSWY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:24:26 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2118 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab2CSWYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:24:24 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
From: "Michael J. Wang" <mjwang@broadcom.com>
To: "Yong Zhang" <yong.zhang0@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
        "Michael J. Wang" <mjwang@broadcom.com>
Subject: RE: minor improvement to pick_next_highest_task_rt ?
Thread-Topic: minor improvement to pick_next_highest_task_rt ?
Thread-Index: Ac0DE0zjnFkg0eOFSReAvHFGlHQgYACwV8UAABKEdmA=
Date: Mon, 19 Mar 2012 22:23:47 +0000
Message-ID: <2EF88150C0EF2C43A218742ED384C1BC0FC83D56@IRVEXCHMB08.corp.ad.broadcom.com>
References: <2EF88150C0EF2C43A218742ED384C1BC0FC83935@IRVEXCHMB08.corp.ad.broadcom.com>
 <20120319063204.GA1361@zhy>
In-Reply-To: <20120319063204.GA1361@zhy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {E95E4E74-14DF-4C43-A58B-B111F0C7B76D}
x-cr-hashedpuzzle: AWNz BSRU C6nv Dwd3 MAJg OuxV X7iM aE9O fMEq kIbB
 ol38 pLKf 1Xoe 100L 386C
 97X2;5;YQAuAHAALgB6AGkAagBsAHMAdAByAGEAQABjAGgAZQBsAGwAbwAuAG4AbAA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGkAbgBnAG8AQABlAGwAdABlAC4AaAB1ADsAcgBvAHMAdABlAGQAdABAAGcAbwBvAGQAbQBpAHMALgBvAHIAZwA7AHkAbwBuAGcALgB6AGgAYQBuAGcAMABAAGcAbQBhAGkAbAAuAGMAbwBtAA==;Sosha1_v1;7;{E95E4E74-14DF-4C43-A58B-B111F0C7B76D};bQBqAHcAYQBuAGcAQABiAHIAbwBhAGQAYwBvAG0ALgBjAG8AbQA=;Mon,
 19 Mar 2012 22:23:35
 GMT;UgBFADoAIABtAGkAbgBvAHIAIABpAG0AcAByAG8AdgBlAG0AZQBuAHQAIAB0AG8AIABwAGkAYwBrAF8AbgBlAHgAdABfAGgAaQBnAGgAZQBzAHQAXwB0AGEAcwBrAF8AcgB0ACAAPwA=
x-originating-ip: [10.12.161.125]
MIME-Version: 1.0
X-WSS-ID: 63796BD24GW6715811-02-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2JMOXVK030530

Thanks Yong.  I will resend the patch according to Documentation/SubmittingPatches right after this.

Michael


-----Original Message-----
From: Yong Zhang [mailto:yong.zhang0@gmail.com] 
Sent: Sunday, March 18, 2012 11:32 PM
To: Michael J. Wang
Cc: linux-kernel@vger.kernel.org; Peter Zijlstra; Steven Rostedt; Ingo Molnar
Subject: Re: minor improvement to pick_next_highest_task_rt ?

Cc'ing more people.

And comments below.

On Fri, Mar 16, 2012 at 01:22:56AM +0000, Michael J. Wang wrote:
> Hi RT Scheduler experts,
> 
> I was studying pick_next_highest_task_rt() and was wondering if this is a valid improvement:
> 
> --- rt.c-3.3-rc7	2012-03-15 17:53:27.774190199 -0700
> +++ rt.c	2012-03-15 17:53:44.541979403 -0700
> @@ -1403,7 +1403,7 @@
>  next_idx:
>  		if (idx >= MAX_RT_PRIO)
>  			continue;
> -		if (next && next->prio < idx)
> +		if (next && next->prio <= idx)
>  			continue;
>  		list_for_each_entry(rt_se, array->queue + idx, run_list) {
>  			struct task_struct *p;
> 
> 
> My reasoning is: if next is not NULL, then we have found a candidate task, and its priority is next->prio.  Now we are looking for an even higher priority task in the other rt_rq's.  idx is the highest priority in the current candidate rt_rq.  In the current 3.3-rc7 code, if idx is equal to next->prio, we would start scanning the tasks in that rt_rq and replace the current candidate task with a task from that rt_rq.  But the new task would only have a priority that is equal to our previous candidate task, so we have not advanced our goal of finding a higher prio task.  So shouldn't we just skip that rt_rq if next->prio is less than *or equal to* idx ?

Yeah, I think this make sense.

But you should remake your patch according to
Documentation/SubmittingPatches.

Thanks,
Yong

> 
> I know this is just a minor improvement and probably results in no measurable performance gain.  But it just seems more correct this way.  (Or if it is not correct, maybe I'll learn something :-)
> 
> I do not subscribe to the LKML (but I have read the FAQ), so I would appreciate it if you can cc me on your responses.
> 
> Thanks,
> Michael
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
