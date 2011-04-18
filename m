Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1DRUBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:01:35 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:33374 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1DRUBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:01:32 -0400
X-ASG-Debug-ID: 1303156891-03d6a55d38d1560001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAC9897.2040606@fusionio.com>
Date: Mon, 18 Apr 2011 22:01:27 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mike Snitzer <snitzer@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: add blk_run_queue_async
References: <20110418092647.GB3837@infradead.org> <BANLkTikOKji3_p+bqMO4zoSnXFunEdue0g@mail.gmail.com> <20110418195929.GA9650@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH] block: add blk_run_queue_async
In-Reply-To: <20110418195929.GA9650@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303156891
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61244
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-18 21:59, Christoph Hellwig wrote:
> On Mon, Apr 18, 2011 at 03:55:04PM -0400, Mike Snitzer wrote:
>>> +{
>>> + ? ? ? if (likely(!blk_queue_stopped(q)))
>>> + ? ? ? ? ? ? ? queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
>>
>> I know Jens already queued this up 'for-linus' but why not use
>> kblockd_schedule_work(q, &q->delay_work)?
> 
> I don't see what that would buy us.  If we'd absolutely want a wrapper
> a blk_delay_queue(q, 0) in Jens' current tree would do it now that is
> has been fixed up to use the kblockd workqueue.

I thought about changing it to use that, but I don't think there's any
point in doing that to be honest.

-- 
Jens Axboe

