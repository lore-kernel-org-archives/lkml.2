Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab1FVQEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 12:04:46 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:51980 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301Ab1FVQEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:04:44 -0400
X-ASG-Debug-ID: 1308758683-03d6a510a691ca0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E021297.4000505@fusionio.com>
Date: Wed, 22 Jun 2011 18:04:39 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 1/3] sched, block: Move unplug
References: <20110621233444.094372367@chello.nl> <20110621233648.806475812@chello.nl> <4E019353.6030902@fusionio.com> <alpine.LFD.2.02.1106221015320.11814@ionos> <4E01F5D6.1020107@fusionio.com> <alpine.LFD.2.02.1106221628560.11814@ionos> <1308753481.1022.27.camel@twins> <20110622150825.GE17010@redhat.com>
X-ASG-Orig-Subj: Re: [RFC][PATCH 1/3] sched, block: Move unplug
In-Reply-To: <20110622150825.GE17010@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1308758683
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66807
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-22 17:08, Vivek Goyal wrote:
> On Wed, Jun 22, 2011 at 04:38:01PM +0200, Peter Zijlstra wrote:
>> On Wed, 2011-06-22 at 16:30 +0200, Thomas Gleixner wrote:
>>>> It is supposedly a real problem, not just an inkling. It's not about
>>>> recursing indefinitely, the plug is fairly bounded. But the IO dispatch
>>>> path can be pretty deep, and if you hit that deep inside the reclaim or
>>>> file system write path, then you get dangerously close. Dave Chinner
>>>> posted some numbers in the 2.6.39-rc1 time frame showing how close we
>>>> got.
>>>
>>> Fair enough.
>>
>>> Ok. So we move it out and keep the from_scheduler flag so that code
>>> does not go down the IO path from there. 
>>
>> Won't punting the plug to a worker thread wreck all kinds of io
>> accounting due to the wrong task doing the actual io submission?
> 
> I think all the accounting will the done in IO submission path and
> while IO is added to plug. This is just plug flush so should not
> have effect on accounting.

Exactly, this is just the insert operation, so no worries there. The
request are fully "formulated".

-- 
Jens Axboe

