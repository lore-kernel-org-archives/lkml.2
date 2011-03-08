Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1CHJlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:41:20 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:47127 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab1CHJlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:41:15 -0500
X-ASG-Debug-ID: 1299577273-03d6a54f6323bd0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D75F9B5.1050704@fusionio.com>
Date: Tue, 8 Mar 2011 10:41:09 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>	 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>	 <20110303221353.GA10366@redhat.com>	 <AANLkTi=MfDzf+-eLbysoP-ZiXX6cV_tVxYE14Vr8FSak@mail.gmail.com>	 <20110304214359.GA18442@redhat.com> <4D715E8A.5070006@fusionio.com>	 <20110304222702.GB18921@redhat.com>  <4D72A302.6060008@fusionio.com>	 <1299493427.2308.11.camel@twins>  <4D753556.3020800@fusionio.com>	 <1299530500.2308.417.camel@twins>  <4D754411.5010508@fusionio.com> <1299577122.2308.1201.camel@twins>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <1299577122.2308.1201.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299577273
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57395
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-08 10:38, Peter Zijlstra wrote:
> On Mon, 2011-03-07 at 21:46 +0100, Jens Axboe wrote:
>>
>> Great, that'll work for me! Your patch should work as-is, then. Thanks
>> Peter.
> 
> Well I think it would be good to write it like:
> 
>   if (prev->state != TASK_RUNNING && blkneeds_flush(prev)) {
>     raw_spin_unlock(&rq->lock);
>     blk_flush_plug(prev);
>     raw_spin_lock(&rq->lock);
>   }
> 
> To avoid flipping that lock when we don't have to.

Yes good point, in any case the need to flush will be an unlikely event.
So saving the lock/unlock dance for when we really need it is a good
optimization.

-- 
Jens Axboe

