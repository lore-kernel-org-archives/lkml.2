Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1CITQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:16:16 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:39242 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab1CITQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:16:09 -0500
X-ASG-Debug-ID: 1299698167-01de284cf833cf0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D77D1F2.2030104@fusionio.com>
Date: Wed, 9 Mar 2011 20:16:02 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: block: Fix oops caused by __blkdev_get() calling  disk_unblock_events()
 with invalid @disk
References: <1299662016-7721-1-git-send-email-tj@kernel.org> <4D774641.3070806@kernel.dk> <4D779396.7050905@fusionio.com> <20110309153859.GD27010@htj.dyndns.org> <4D77C664.3080803@fusionio.com> <20110309185909.GA13729@mtj.dyndns.org>
X-ASG-Orig-Subj: Re: block: Fix oops caused by __blkdev_get() calling  disk_unblock_events()
 with invalid @disk
In-Reply-To: <20110309185909.GA13729@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299698167
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57529
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-09 19:59, Tejun Heo wrote:
> On Wed, Mar 09, 2011 at 07:26:44PM +0100, Jens Axboe wrote:
>>>   This is fixed by moving reference putting after open success is
>>>   determined and not clearing @disk to %NULL.  On success, @disk is
>>>   valid because there is another opener holding reference to it.  On
>>>   failure, the references are put after disk_unblock_events() is
>>>   called.
>>
>> Thanks, applied. A bit unfortunate to have a 100% crasher in the tree,
>> though. Will suck for bisects.
> 
> Yeah, that does suck.  I folded in the fix to the offending commit and
> regenerated the tree in case you want to rebase the tree.
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git disk-event-convert-fixed

Thanks, but it's pretty deep in at this point. I'll take a look at it.


-- 
Jens Axboe

