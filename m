Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2EaK5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:57:39 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:58147 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2EaK5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:57:37 -0400
X-ASG-Debug-ID: 1338461856-0421b516ea37660001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FC74E6A.3030606@fusionio.com>
Date: Thu, 31 May 2012 12:56:42 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block: avoid infinite loop in get_task_io_context()
References: <4FC6189B.9080909@fusionio.com>  <1338402812.2760.413.camel@edumazet-glaptop>  <4FC66D3D.6080509@fusionio.com>  <1338404902.2760.451.camel@edumazet-glaptop>  <1338410107.2760.544.camel@edumazet-glaptop>  <1338460706.2760.1330.camel@edumazet-glaptop>  <4FC74C59.2030100@fusionio.com> <1338461516.2760.1333.camel@edumazet-glaptop>
X-ASG-Orig-Subj: Re: [PATCH] block: avoid infinite loop in get_task_io_context()
In-Reply-To: <1338461516.2760.1333.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1338461856
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.98526
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 12:51 PM, Eric Dumazet wrote:
> On Thu, 2012-05-31 at 12:47 +0200, Jens Axboe wrote:
>>  BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]
>>
>> Eric, do you have a task trace to go with this lockup, where task !=
>> current?
>>
>> In any case, it is a legit bug fix. I have applied it.
>>
> 
> Unfortunately I couldn't get netconsole working at this stage...
> 
> syscall was sys_ioprio_set()

That's good enough, then it all makes sense. I guess we could be
checking PF_EXITING earlier, but I think the patch is fine as-is.

-- 
Jens Axboe

