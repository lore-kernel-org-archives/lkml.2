Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1CJTcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:32:15 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:47408 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab1CJTcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:32:14 -0500
X-ASG-Debug-ID: 1299785532-01de284cf83f230001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D792735.8000604@fusionio.com>
Date: Thu, 10 Mar 2011 20:32:05 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-5-git-send-email-jaxboe@fusionio.com> <20110310165452.GE29464@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 04/10] block: initial patch for on-stack per-task plugging
In-Reply-To: <20110310165452.GE29464@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299785532
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57610
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-10 17:54, Vivek Goyal wrote:
> On Sat, Jan 22, 2011 at 01:17:23AM +0000, Jens Axboe wrote:
> 
> [..]
>> -/*
>> - * Only disabling plugging for non-rotational devices if it does tagging
>> - * as well, otherwise we do need the proper merging
>> - */
>> -static inline bool queue_should_plug(struct request_queue *q)
>> -{
>> -	return !(blk_queue_nonrot(q) && blk_queue_tagged(q));
>> -}
>> -
> 
> Jens,
> 
> While discussing stack plug with Mike Snitzer, this occurred to us that in
> new code we seem to be plugging even if underlying device is SSD with NCQ.
> Should we continue to maintain the old behavior of not plugging for NCQ SSD?

The main reason plugging was turned off for SSD's previously was because
it ended up hammering on the queue lock a lot. So it was turned off to
speed them up.

The new plugging scheme is faster than hitting the queue directly, so
now it would be a good idea to do the plugging in fact. Plus even for
high performance SSD's, things like merging are still a good idea.

So yes, it's on now and on purpose.

-- 
Jens Axboe

