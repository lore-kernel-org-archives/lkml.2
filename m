Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1DSOkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:40:08 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:46653 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab1DSOkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:40:07 -0400
X-ASG-Debug-ID: 1303224004-01de284cf8166670001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAD9EC5.4030400@fusionio.com>
Date: Tue, 19 Apr 2011 16:40:05 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: block: add blk_run_queue_async
References: <20110418092647.GB3837@infradead.org> <BANLkTikOKji3_p+bqMO4zoSnXFunEdue0g@mail.gmail.com> <20110418195929.GA9650@infradead.org> <20110418202053.GA29394@redhat.com> <20110418214818.GA2217@redhat.com>
X-ASG-Orig-Subj: Re: block: add blk_run_queue_async
In-Reply-To: <20110418214818.GA2217@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303224004
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61318
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-18 23:48, Mike Snitzer wrote:
> On Mon, Apr 18 2011 at  4:20pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Mon, Apr 18 2011 at  3:59pm -0400,
>> Christoph Hellwig <hch@infradead.org> wrote:
>>
>>> On Mon, Apr 18, 2011 at 03:55:04PM -0400, Mike Snitzer wrote:
>>>>> +{
>>>>> + ? ? ? if (likely(!blk_queue_stopped(q)))
>>>>> + ? ? ? ? ? ? ? queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
>>>>
>>>> I know Jens already queued this up 'for-linus' but why not use
>>>> kblockd_schedule_work(q, &q->delay_work)?
>>>
>>> I don't see what that would buy us.  If we'd absolutely want a wrapper
>>> a blk_delay_queue(q, 0) in Jens' current tree would do it now that is
>>> has been fixed up to use the kblockd workqueue.
>>
>> Right, I missed 4521cc4 block: blk_delay_queue() should use kblockd
>> workqueue.  So why not use blk_delay_queue()?
>>
>> I agree with Jens that it doesn't much matter but I also cannot see it
>> being a bad thing.. I'd prefer it ;)
>>
>> *shrug*
> 
> Also, FYI, I'm seeing a leftover '@force_kblockd: ...' comment in the
> __blk_run_queue's comment block.

Thanks Mike, I've killed that now.

-- 
Jens Axboe

